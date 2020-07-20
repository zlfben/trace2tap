from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
from django.core.cache import caches

from autotapta.input.IoTCore import inputTraceFromList, updateTraceFromList
from autotapta.analyze.Analyze import filterFlipping
from autotapta.model.Trace import enhanceTraceWithTiming
from autotapta.analyze.Rank import calcScoreEnhanced, analyzeTimeOrder
from backend import models as m
from autotap.util import generate_dict_from_state_log, initialize_trace_for_location, get_trace_for_location, generate_clip
from autotap.translator import generate_all_device_templates, generate_boolean_map, translate_clause_into_autotap_tap
from backend.rulecount import generate_cap_time_list_from_tap

import json
import math
from datetime import datetime
import pytz


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('command', type=str, help='list: list all interview entries; show: show the rules')
        parser.add_argument('-i', '--index', type=int, help='The index of the entry to be shown')
        parser.add_argument('-c', '--cluster', type=int, help='The index of the cluster')
        parser.add_argument('-r', '--rule', type=int, help='The index of the rule within the cluster')
    
    def list_entries(self):
        records = list(m.Record.objects.filter(typ='syn_first').order_by('timestamp'))
        for index in range(len(records)):
            record = records[index]
            print('%d (id %d):\t%s, %s' % (index, record.id, record.timestamp, record.location.name if record.location else 'Unknown location'))

    def print_rule(self, rule):
        first = True
        for if_clause in rule['ifClause']:
            if first:
                print('IF ' + if_clause['text'], end=', ')
                first = False
            else:
                print('WHILE ' + if_clause['text'], end=', ')
        for then_clause in rule['thenClause']:
            print('THEN ' + then_clause['text'])
        
    def analyze_entry(self, entry, cluster, rule_id):
        records = list(m.Record.objects.filter(typ='syn_first').order_by('timestamp'))
        record = records[entry]

        try:
            request = json.loads(record.request)
        except json.decoder.JSONDecodeError:
            request = {}
        
        try:
            response = json.loads(record.response)
        except json.decoder.JSONDecodeError:
            response = {}
        
        rule_meta = response['rules'][cluster-1][rule_id-1]
        rule = rule_meta['rule']
        self.print_rule(rule)

        # step 1 get the t race
        location = record.location
        trace = get_trace_for_location(location)
        earliest_time = datetime.min.replace(tzinfo=None)
        record_time = record.timestamp.replace(tzinfo=None)
        trace = generate_clip(trace, earliest_time, record_time)

        tap = translate_clause_into_autotap_tap(rule, False)
        target_action = tap.action

        orig_tap_time_list = []
        orig_tap_time_list += generate_cap_time_list_from_tap(tap)
        trace = filterFlipping(trace, target_action)
        new_trace = enhanceTraceWithTiming(trace, orig_tap_time_list, '*')

        # step 2 analyze calling autotap
        pre_n, post_n = analyzeTimeOrder(new_trace, target_action, tap, 
                                            pre_time_span=settings.PRE_TIME, 
                                            post_time_span=settings.POST_TIME)

        print(pre_n, post_n)

    def show_entry(self, entry):
        records = list(m.Record.objects.filter(typ='syn_first').order_by('timestamp'))
        record = records[entry]

        try:
            request = json.loads(record.request)
        except json.decoder.JSONDecodeError:
            request = {}
        
        try:
            response = json.loads(record.response)
        except json.decoder.JSONDecodeError:
            response = {}

        # get all ranks
        rule_tups = []
        for index in range(len(response['rules'])):
            rule_list = response['rules'][index]
            for rule_index in range(len(rule_list)):
                rule_meta = rule_list[rule_index]
                score = rule_meta['score']
                complexity = len(rule_meta['rule']['ifClause']) - 1
                TP = rule_meta['TP']
                FP = rule_meta['FP']
                precision = TP*1.0/(TP+FP) if TP+FP != 0 else 0
                # score -= -0.05139802595 * complexity if complexity is not None else 0
                # score = precision
                score = rule_meta['score']
                # score = rule_meta['TP'] * 1.0 / (rule_meta['TP'] + rule_meta['FP']) * (1 + math.log(rule_meta['TP'])) / (len(rule_meta['rule']['ifClause']))
                # print(rule_meta)
                rule_tups.append(((index, rule_index), score))
        rule_tups = sorted(rule_tups, key=lambda t: t[1], reverse=True)
        rank_dict = {}
        for rank in range(len(rule_tups)):
            rule_tup = rule_tups[rank]
            rank_dict[rule_tup[0]] = rank + 1
        
        condition_n_dict = {}
        n_rules = 0

        for index in range(len(response['rules'])):
            
            rule_list = response['rules'][index]
            n_rules += len(rule_list)

            ranks_cluster_tup = [(ii, rank_dict[(index, ii)]) for ii in range(len(rule_list))]
            ranks_cluster_tup = sorted(ranks_cluster_tup, key=lambda x: x[1])
            ranks_cluster_dict = {ranks_cluster_tup[jj][0]: jj+1 for jj in range(len(ranks_cluster_tup))}
            print('========= Cluster %d =========' % (index + 1))
            for rule_index in range(len(rule_list)):
                rule_meta = rule_list[rule_index]
                rule = rule_meta['rule']
                rank_within_cluster = ranks_cluster_dict[rule_index]
                precision = rule_meta['TP'] / rule_meta['R']
                print('%d: Rank: %d (precision: %f, cond: %d, within cluster: %d)\t' % (rule_index+1, rank_dict[(index, rule_index)], precision, len(rule['ifClause'])-1, rank_within_cluster), end='')
                self.print_rule(rule)
                
                if len(rule['ifClause'])-1 not in condition_n_dict:
                    condition_n_dict[len(rule['ifClause'])-1] = 0
                condition_n_dict[len(rule['ifClause'])-1] += 1

        print('----------- Stats -----------')
        print('condition_n_dict:', condition_n_dict)
        print('total number of rules:', n_rules)

    def handle(self, *args, **options):
        """
        This is used to add the location field in all existing state logs
        """
        command = options['command']

        if command == 'list':
            self.list_entries()
        elif command == 'show':
            try:
                entry = options['index']
                self.show_entry(entry)
            except IndexError:
                raise Exception('Need to have index for the show command')
        elif command == 'analyze':
            try:
                entry = options['index']
                cluster = options['cluster']
                rule_id = options['rule']
                self.analyze_entry(entry, cluster, rule_id)
            except IndexError:
                raise Exception('Need to have entry, cluster, rule id for the analyze command')
        else:
            raise Exception('unknown command %s' % command)
            



