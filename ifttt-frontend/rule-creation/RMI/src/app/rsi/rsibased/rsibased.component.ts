import { Component, OnInit, ViewContainerRef, ViewChild, ComponentFactoryResolver } from '@angular/core';
import { MatDialog } from '@angular/material';
import { Router } from '@angular/router';
import { UserDataService, Device, Location, Command, Rule } from '../../user-data.service';
import { VisComponent } from '../vis/vis.component';
import { CurrentruleComponent } from '../currentrule/currentrule.component';

export interface ModifyRuleMeta {
  id: number;
  rule: Rule;
}

export interface DeleteRuleMeta {
  id: number;
}

export interface PatchMeta {
  id: number;
  rule?: Rule;
  typ: string;
  score: number;
  TP: number;
  FP: number;
}

export interface RuleUIRepresentation {
  words: string[]; // e.g. IF, AND, THEN
  status: number; // 0: orig, x>0: add condition at position x, -1: deleted
  icons: string[]; // the string name of the icons
  descriptions: string[]; // the descriptions for each of the icons
}

@Component({
  selector: 'app-rsibased',
  templateUrl: './rsibased.component.html',
  styleUrls: ['./rsibased.component.css']
})
export class RsibasedComponent implements OnInit {

  // private patchCluster: SynthesizePatchMeta[][];
  // public clusterNum: number;
  private currentDevice: Device;
  private currentCommand: Command;
  // private unparsedRules: Rule[];
  private unparsedRules: Rule[];
  private unparsedOrigRules: Rule[];
  private modifyPatches: ModifyRuleMeta[];
  private deletePatches: DeleteRuleMeta[];
  private patches: PatchMeta[];
  private currentPatch: number = 0;
  private patchMasks: boolean[][];
  private patchNum: number = 0;

  public RULES: RuleUIRepresentation[];
  public SAVEDRULES: RuleUIRepresentation[];
  public showSpinner: boolean = true;
  // public currentCluster: number = 0;
  private savedUnparsedRules: Rule[] = [];
  private parentMask: boolean[] = [];
  // private nEpisodes: number;
  private token: string;
  public finished: boolean = false;
  private traceLogsPositive: any[];  // for visualization
  private traceLogsNegative: any[];  // for visualization
  public logFetched: boolean = false;  // flag to show visualization
  private devList: string[];
  private capList: string[];
  private targetId: number;
  private tapSensorList: any[];
  private ruleMaskPositive: any[];
  private ruleMaskNegative: any[];

  @ViewChild('viscontainer', { read: ViewContainerRef }) entry: ViewContainerRef;
  constructor(public userDataService: UserDataService, private route: Router, 
              private resolver: ComponentFactoryResolver, private dialog: MatDialog) { }

  ngOnInit() {
    this.finished = false;
    this.showSpinner = true;
    this.currentDevice = this.userDataService.currentDevice;
    this.currentCommand = this.userDataService.currentCommand;

    this.userDataService.getRuleDebugSuggestion(this.currentDevice, this.currentCommand).subscribe(data => {
      this.unparsedOrigRules = data['orig_rules'];
      this.savedUnparsedRules = data["orig_rules"];
      this.modifyPatches = data['modify'];
      this.deletePatches = data['delete'];
      this.patches = data['patches'];
      // this.patchMasks = [...data['modify_rule_masks'], ...data['delete_rule_masks']];
      this.patchMasks = data['rule_masks'];
      this.token = data['token'];
      this.patchNum = this.patches.length;
      if (!this.patchNum) {
        this.finished = true;
        this.showSpinner = false;
      }
      this.showSpinner = false;
      if (this.patches.length) {
        this.parsePatch(this.currentPatch);
      }
      if (this.savedUnparsedRules) {
        this.updateSavedRules();
      }
      this.fetchLog();
    });
  }

  createVis() {
    this.entry.clear();
    const factory = this.resolver.resolveComponentFactory(VisComponent);
    const componentRef = this.entry.createComponent(factory);
    // TODO: handle positive and negative
    componentRef.instance.traceLogsPositive = this.traceLogsPositive;
    componentRef.instance.maskListPositive = this.ruleMaskPositive[this.currentPatch];  // TODO: handle masks
    componentRef.instance.traceLogsNegative = this.traceLogsNegative;
    componentRef.instance.maskListNegative = this.ruleMaskNegative[this.currentPatch];
    componentRef.instance.currentCluster = this.currentPatch;
    componentRef.instance.mode = true;
    componentRef.instance.devList = this.devList;
    componentRef.instance.capList = this.capList;
    componentRef.instance.tapLogsShownPositive = [];
    componentRef.instance.tapLogsShownNegative = [];
    componentRef.instance.targetId = this.targetId;
    componentRef.instance.tapSensorList = this.tapSensorList;
    componentRef.instance.currentCommandText = this.getCurrentCommandText();
    
    // TODO: calc TP and FPs
    let PNRCount = [];
    for (let patch of this.patches) {
      PNRCount.push([patch.TP, patch.FP, this.traceLogsPositive.length]);
    }
    componentRef.instance.PNRCount = PNRCount;
  }

  fetchLog() {
    this.logFetched = false;
    let self = this;
    this.userDataService.fetchLogDebug(this.token).subscribe(data => {
      self.traceLogsPositive = data["log_list_positive"];
      self.traceLogsNegative = data["log_list_negative"];
      self.ruleMaskPositive = data["rule_mask_positive"];
      self.ruleMaskNegative = data["rule_mask_negative"];
      self.devList = data["dev_list"];
      self.capList = data["cap_list"];
      self.targetId = data["target_id"];
      self.tapSensorList = data["rule_sensor_list"];
      self.createVis();
      self.logFetched = true;
    });
  }

  public getCurrentCommandText() {
    return this.userDataService.getTextFromParVal(this.currentDevice, 
                                                  this.currentCommand.capability, 
                                                  [this.currentCommand.parameter], 
                                                  [{"value": this.currentCommand.value,
                                                    "comparator": "="}]);
  }

  private parsePatch(index: number) {
    this.unparsedRules = [];
    let patchMeta = this.patches[index];
    if (patchMeta.typ == 'modify') {
      this.unparsedRules = [];
      for (let rule of this.unparsedOrigRules) {
        if (rule.id == patchMeta.id) {
          this.unparsedRules.push(patchMeta.rule);
        } else {
          this.unparsedRules.push(rule);
        }
      }
    } else {
      this.unparsedRules = this.unparsedOrigRules;
    }
    this.parseRules();
    // if (index >= this.modifyPatches.length) {
    //   // should be delete
    //   index = index - this.modifyPatches.length;
    //   let delMeta = this.deletePatches[index];
    //   this.unparsedRules = this.unparsedOrigRules;
    //   this.parseRules();
    // } else {
    //   // should be modify
    //   let modifyMeta = this.modifyPatches[index];
    //   for (let rule of this.unparsedOrigRules) {
    //     if (rule.id == modifyMeta.id) {
    //       this.unparsedRules.push(modifyMeta.rule);
    //     } else {
    //       this.unparsedRules.push(rule);
    //     }
    //   }
    //   this.parseRules();
    // }
  }

  //parse rules into displayable form for list
  private parseRules() {
    const rules = this.unparsedRules;
    this.RULES = rules.map((rule => {
      const words = [];
      const descriptions = [];
      const icons = [];

      // add the if clause stuff
      rule.ifClause = this.userDataService.updateClausesTimezone(rule.ifClause, true);
      for (let i = 0; i < rule.ifClause.length; i++) {
        let clause = rule.ifClause[i];
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

      let status = 0;
      if (this.patches[this.currentPatch].typ == 'delete') {
        // should be delete
        let delMeta = this.patches[this.currentPatch];
        if (delMeta.id == rule.id) {
          status = -1;
        }
      } else {
        // shoule be modify
        let modifyMeta = this.patches[this.currentPatch];
        if (modifyMeta.id == rule.id) {
          status = words.length-2;
        }
      }

      const ruleRep: RuleUIRepresentation = {
        words: words,
        icons: icons,
        descriptions: descriptions,
        status: status
      };
      return ruleRep;
    }));
  }

  gotoPrev() {
    this.currentPatch = this.currentPatch == 0 ? this.currentPatch : this.currentPatch-1;
    this.parsePatch(this.currentPatch);
    this.createVis();
  }

  gotoNext() {
    this.currentPatch = this.currentPatch+1<this.patches.length ? this.currentPatch+1 : this.currentPatch;
    this.parsePatch(this.currentPatch);
    this.createVis();
  }

  goToDashboard() {
    this.route.navigate(["/synthesize/dashboard"]);
  }

  finishDebugging() {
    for (let i in this.savedUnparsedRules) {
      for (let j in this.savedUnparsedRules[i].ifClause) {
        this.savedUnparsedRules[i].ifClause[j].id = +j;
      }
    }
    this.userDataService.changeRules(this.currentDevice, this.currentCommand, this.savedUnparsedRules);
  }

  showTrace() {
    // each entry in trace log should be a valid html element string
    // @TODO: need some buttons to navigate the logs here
    // document.getElementById('vis').innerHTML += this.traceLogs[0];
  }

  applyPatch() {
    this.currentPatch = 0;
    this.showSpinner = true;
    this.savedUnparsedRules = this.unparsedRules;
    this.unparsedOrigRules = this.unparsedRules;
    this.userDataService.getFollowUpRuleDebugSuggestion(this.token, this.unparsedRules).subscribe(data => {
      this.patches = data['patches'];
      // this.modifyPatches = data['modify'];
      // this.deletePatches = data['delete'];
      this.patchMasks = data['rule_masks'];
      this.patchNum = this.patches.length;
      if (!this.patchNum) {
        this.finished = true;
      }
      this.showSpinner = false;
      if (this.patches.length) {
        this.parsePatch(this.currentPatch);
      }
      if (this.savedUnparsedRules) {
        this.updateSavedRules();
      }
      this.fetchLog();
    });
  }

  updateSavedRules() {
    const rules = this.savedUnparsedRules;
    this.SAVEDRULES = rules.map((rule => {
      const words = [];
      const descriptions = [];
      const icons = [];

      // add the if clause stuff
      rule.ifClause = this.userDataService.updateClausesTimezone(rule.ifClause, true);
      for (let i = 0; i < rule.ifClause.length; i++) {
        let clause = rule.ifClause[i];
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
        descriptions: descriptions,
        status: 0
      };
      return ruleRep;
    }));
  }

  openDialog() {
    const dialogRef = this.dialog.open(CurrentruleComponent, {
      data: {rules: this.SAVEDRULES}
    });
  }

}
