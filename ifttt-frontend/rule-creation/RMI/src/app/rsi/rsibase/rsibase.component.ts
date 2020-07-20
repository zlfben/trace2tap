import {
  OnInit, 
  Component,
  ViewChild,
  ViewContainerRef,
  ComponentFactoryResolver,
  ComponentRef,
  ComponentFactory
} from '@angular/core';

import { Router } from '@angular/router';
import { MatDialog } from '@angular/material';
import { UserDataService, Device, Location, Command, Rule } from '../../user-data.service';
import { CurrentruleComponent } from '../currentrule/currentrule.component';
import { ModeselComponent } from '../modesel/modesel.component';
import { VisComponent } from '../vis/vis.component';

export interface SynthesizePatchMeta {
  mask: boolean[];
  score: number;
  rule: Rule;
  TP: number;
  FP: number;
  R: number;
}

export interface RuleUIRepresentation {
  words: string[]; // e.g. IF, AND, THEN
  icons: string[]; // the string name of the icons
  descriptions: string[]; // the descriptions for each of the icons
}

@Component({
  selector: 'app-rsibase',
  templateUrl: './rsibase.component.html',
  styleUrls: ['./rsibase.component.css']
})
export class RsibaseComponent implements OnInit {

  private patchCluster: SynthesizePatchMeta[][];
  public clusterNum: number;
  private currentDevice: Device;
  private currentCommand: Command;
  private unparsedRules: Rule[];
  public RULES: RuleUIRepresentation[];
  public SAVEDRULES: RuleUIRepresentation[];
  public showSpinner: boolean = true;
  public currentCluster: number = 0;
  private origUnparsedRules: Rule[] = [];
  private savedUnparsedRules: Rule[] = [];
  private parentMask: boolean[] = [];
  private nEpisodes: number;
  private token: string;
  public finished: boolean;
  private showAlternatives: boolean = false;
  private traceLogsPositive: any[];
  private traceLogsNegative: any[];
  private devList: string[];
  private capList: string[];
  private tapLogsShownPositive: any[];
  private tapLogsShownNegative: any[];
  private tapSensorList: any[];
  private targetId: number;
  public logFetched: boolean = false;
  private ruleSavedFlags: any[];

  @ViewChild('viscontainer', { read: ViewContainerRef }) entry: ViewContainerRef;
  constructor(public userDataService: UserDataService, private route: Router,
    private resolver: ComponentFactoryResolver, private dialog: MatDialog) { }

  createVis() {
    this.entry.clear();
    const factory = this.resolver.resolveComponentFactory(VisComponent);
    const componentRef = this.entry.createComponent(factory);
    componentRef.instance.traceLogsPositive = this.traceLogsPositive;
    componentRef.instance.maskListPositive = new Array(this.traceLogsPositive.length).fill(false);
    for (let log_id of this.tapLogsShownPositive[this.currentCluster]) {
      componentRef.instance.maskListPositive[log_id] = true;
    }
    componentRef.instance.traceLogsNegative = this.traceLogsNegative;
    componentRef.instance.maskListNegative = new Array(this.traceLogsNegative.length).fill(false);
    for (let log_id of this.tapLogsShownNegative[this.currentCluster]) {
      componentRef.instance.maskListNegative[log_id] = true;
    }
    // componentRef.instance.maskList = this.tapLogsShown[this.currentCluster];
    componentRef.instance.currentCluster = this.currentCluster;
    componentRef.instance.mode = false;
    componentRef.instance.devList = this.devList;
    componentRef.instance.capList = this.capList;
    componentRef.instance.tapLogsShownPositive = this.tapLogsShownPositive;
    componentRef.instance.tapLogsShownNegative = this.tapLogsShownNegative;
    componentRef.instance.targetId = this.targetId;
    componentRef.instance.tapSensorList = this.tapSensorList;
    componentRef.instance.currentCommandText = this.getCurrentCommandText();
    let PNRCount = [];
    for (let patch of this.patchCluster) {
      PNRCount.push([patch[0].TP, patch[0].FP, patch[0].R]);
    }
    componentRef.instance.PNRCount = PNRCount;
  }

  ngOnInit() {
    this.finished = false;
    this.currentDevice = this.userDataService.currentDevice;
    this.currentCommand = this.userDataService.currentCommand;

    this.userDataService.getRuleSuggestion(this.currentDevice, this.currentCommand).subscribe(data => {
      this.patchCluster = data["rules"];
      this.origUnparsedRules = [...data["orig_rules"]];
      this.savedUnparsedRules = [...data["orig_rules"]];
      this.token = data["token"];
      if (!this.patchCluster.length) {
        this.finished = true;
        this.showSpinner = false;
      } else {
        this.nEpisodes = data["n_episodes"]
        this.parentMask = new Array<boolean>(this.nEpisodes);
        this.parentMask = this.parentMask.fill(true);
        this.clusterNum = this.patchCluster.length;
        this.ruleSavedFlags = [];
        for (let cl in this.patchCluster) {
          let flags = this.patchCluster[cl].map(x=>false);
          this.ruleSavedFlags.push(flags);
        }
        this.currentCluster = 0;
        this.unparsedRules = this.patchCluster[this.currentCluster].map(x => x.rule);
        if (data["userid"]) {
          this.userDataService.user_id = data["userid"];
        }
        if (this.unparsedRules) {
          var i: number;
          this.parseRules();
        }
        if (this.savedUnparsedRules) {
          this.updateSavedRules();
        }
        this.showSpinner = false;
      }
      this.fetchLog();
    });
  }

  public getCurrentCommandText() {
    return this.userDataService.getTextFromParVal(this.currentDevice, 
                                                  this.currentCommand.capability, 
                                                  [this.currentCommand.parameter], 
                                                  [{"value": this.currentCommand.value,
                                                    "comparator": "="}]);
  }

  //parse rules into displayable form for list
  private parseRules() {
    const rules = this.unparsedRules;
    this.RULES = rules.map((rule => {
      const words = [];
      const descriptions = [];
      const icons = [];

      // add the if clause stuff
      let rule_ifClause = this.userDataService.updateClausesTimezone(rule.ifClause, true);
      for (let i = 0; i < rule_ifClause.length; i++) {
        let clause = rule_ifClause[i];
        clause = this.userDataService.getTextForClause(clause);
        words.push(i == 0 ? "If" : (i > 1 ? "and" : "while"));
        if (clause.channel) {
          icons.push(clause.channel.icon);
        } else {
          icons.push("");
        }
        const description = clause.text;
        descriptions.push(description);
      }

      // add the then clause
      words.push("then");
      rule.thenClause[0] = this.userDataService.getTextForClause(rule.thenClause[0]);
      const description = rule.thenClause[0].text;
      descriptions.push(description);
      if (rule.thenClause[0].channel) {
        icons.push(rule.thenClause[0].channel.icon);
      } else {
        icons.push("");
      }

      // add the priority clause (not currently a feature but Abhi wrote it)
      if (rule.priority) {
        words.push('PRIORITY');
        const priority_description = `${rule.priority}`;
        icons.push('timer');
        descriptions.push(priority_description);
      }

      const ruleRep: RuleUIRepresentation = {
        words: words,
        icons: icons,
        descriptions: descriptions
      };
      return ruleRep;
    }));
  }

  gotoPrev() {
    this.currentCluster = this.currentCluster == 0 ? this.currentCluster : this.currentCluster-1;
    this.unparsedRules = this.patchCluster[this.currentCluster].map(x => x.rule);
    if (this.unparsedRules) {
      this.parseRules();
    }
    this.createVis();
  }

  gotoNext() {
    this.currentCluster = this.currentCluster+1<this.clusterNum ? this.currentCluster+1 : this.currentCluster;
    this.unparsedRules = this.patchCluster[this.currentCluster].map(x => x.rule);
    if (this.unparsedRules) {
      this.parseRules();
    }
    this.createVis();
  }

  saveRuleFlag(cluster: number, i: number) {
    this.ruleSavedFlags[cluster][i] = !this.ruleSavedFlags[cluster][i];
    this.pushUnparsedRules();
    this.updateSavedRules();
  }

  saveRule(i: number) {
    let mask = Array<boolean>(0);
    for (let j = 0; j < this.nEpisodes; j++) {
      let digit = !this.patchCluster[this.currentCluster][i].mask[j] && this.parentMask[j];
      mask.push(digit);
    }
    this.savedUnparsedRules.push(this.unparsedRules[i]);
    this.currentCluster = 0;
    this.showSpinner = true;
    this.userDataService.getFollowUpRuleSuggestion(this.token, mask).subscribe(data => {
      this.patchCluster = data["rules"];
      if (!this.patchCluster.length) {
        this.finished = true;
        this.showSpinner = false;
      } else {
        this.clusterNum = this.patchCluster.length;
        this.currentCluster = 0;
        this.unparsedRules = this.patchCluster[this.currentCluster].map(x => x.rule);
        if (data["userid"]) {
          this.userDataService.user_id = data["userid"];
        }
        if (this.unparsedRules) {
          var i: number;
          this.parseRules();
        }
        this.showSpinner = false;
      }
      this.updateSavedRules();
      this.parentMask = mask;
      this.fetchLog();
    });
  }

  goToDashboard() {
    this.route.navigate(["/synthesize/dashboard"]);
  }

  pushUnparsedRules() {
    this.savedUnparsedRules = [...this.origUnparsedRules];
    for (let i in this.patchCluster) {
      for (let j in this.patchCluster[i]) {
        if (this.ruleSavedFlags[i][j]) {
          this.savedUnparsedRules.push(this.patchCluster[i][j].rule);
        }
      }
    }
    for (let i in this.savedUnparsedRules) {
      for (let j in this.savedUnparsedRules[i].ifClause) {
        this.savedUnparsedRules[i].ifClause[j] = this.userDataService.getTextForClause(this.savedUnparsedRules[i].ifClause[j]);
        this.savedUnparsedRules[i].ifClause[j].id = +j;
      }
    }
  }

  finishAdding() {
    this.pushUnparsedRules();
    this.userDataService.addRules(this.savedUnparsedRules);
  }

  fetchLog() {
    this.logFetched = false;
    let self = this;
    this.userDataService.fetchLog(this.token).subscribe(data => {
      self.traceLogsPositive = data["log_positive_list"];
      self.traceLogsNegative = data["log_negative_list"];
      self.devList = data["dev_list"];
      self.capList = data["cap_list"];
      self.tapLogsShownPositive = data["tap_clips_shown_positive"];
      self.tapLogsShownNegative = data["tap_clips_shown_negative"];
      self.targetId = data["target_id"];
      self.tapSensorList = data["rule_sensor_list"];
      self.createVis();
      self.logFetched = true;
    });
  }

  updateSavedRules() {
    const rules = this.savedUnparsedRules;
    this.SAVEDRULES = rules.map((rule => {
      const words = [];
      const descriptions = [];
      const icons = [];

      // add the if clause stuff
      for (let i = 0; i < rule.ifClause.length; i++) {
        let clause = rule.ifClause[i];
        words.push(i == 0 ? "If" : (i > 1 ? "and" : "while"));
        if (clause.channel) {
          icons.push(clause.channel.icon);
        } else {
          icons.push("");
        }
        const description = clause.text;
        descriptions.push(description);
      }

      // add the then clause
      words.push("then");
      const description = rule.thenClause[0].text;
      descriptions.push(description);
      if (rule.thenClause[0].channel) {
        icons.push(rule.thenClause[0].channel.icon);
      } else {
        icons.push("");
      }
      

      // add the priority clause (not currently a feature but Abhi wrote it)
      if (rule.priority) {
        words.push('PRIORITY');
        const priority_description = `${rule.priority}`;
        icons.push('timer');
        descriptions.push(priority_description);
      }

      const ruleRep: RuleUIRepresentation = {
        words: words,
        icons: icons,
        descriptions: descriptions
      };
      return ruleRep;
    }));
  }

  showOrHideAlt() {
    this.showAlternatives = !this.showAlternatives;
    if (!this.showAlternatives) {
      this.createVis();
    }
  }

  openDialog() {
    const dialogRef = this.dialog.open(CurrentruleComponent, {
      data: {rules: this.SAVEDRULES}
    });
  }

  getStat(i: number) {
    let tp = "This rule would automate " + String(this.patchCluster[this.currentCluster][i].TP) + " times when you actually applied the action. ";
    let fp = "It would also be triggered at " + String(this.patchCluster[this.currentCluster][i].FP) + " times when you didn't.";
    return tp + fp;
  }
}
