import { Component, OnInit, ComponentFactoryResolver } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog } from '@angular/material';
import { UserDataService, Device, Location, Command, Rule } from '../../user-data.service';
import { CurrentruleComponent } from '../../rsi/currentrule/currentrule.component';


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
  selector: 'app-debug',
  templateUrl: './debug.component.html',
  styleUrls: ['./debug.component.css']
})
export class DebugComponent implements OnInit {
    // private patchCluster: SynthesizePatchMeta[][];
  // public clusterNum: number;
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
  public empty: boolean = false;
  private traceLogsPositive: any[];  // for visualization
  private traceLogsNegative: any[];  // for visualization
  public logFetched: boolean = false;  // flag to show visualization
  private devList: string[];
  private capList: string[];
  private targetId: number;
  private tapSensorList: any[];
  private ruleMaskPositive: any[];
  private ruleMaskNegative: any[];


  public respList: any[];
  public currentCase: number = 0;
  public currentCaseStr: string = "0";
  private loc_id: number;

  constructor(public userDataService: UserDataService, private route: Router, 
              private resolver: ComponentFactoryResolver, private dialog: MatDialog) { }

  ngOnInit() {
    this.loc_id = this.userDataService.current_loc;
    let self = this;

    this.finished = false;
    this.showSpinner = true;

    this.userDataService.getDebugPages(this.loc_id).subscribe(data => {
      self.respList = data["resp_list"];
      if (!self.respList.length) {
        self.empty = true;
        self.showSpinner = false;
      } else {
        self.currentCase = 0;
        self.currentCaseStr = "0";
  
        self.unparsedOrigRules = self.respList[self.currentCase]['orig_rules'];
        self.savedUnparsedRules = self.respList[self.currentCase]["orig_rules"];
        self.patches = self.respList[self.currentCase]['patches'];
        self.patchMasks = self.respList[self.currentCase]['rule_masks'];
        self.token = self.respList[self.currentCase]['token'];
  
        self.patchNum = self.patches.length;
        if (!self.patchNum) {
          self.finished = true;
        } else {
          self.finished = false;
        }
        self.showSpinner = false;
        if (self.patches.length) {
          self.parsePatch(self.currentPatch);
        }
        if (self.savedUnparsedRules) {
          self.updateSavedRules();
        }
      }
    });
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
  }

  gotoNext() {
    this.currentPatch = this.currentPatch+1<this.patches.length ? this.currentPatch+1 : this.currentPatch;
    this.parsePatch(this.currentPatch);
  }

  goToDashboard() {
    this.route.navigate(["/admin/"]);
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

  changeCase() {
    this.currentCase = +this.currentCaseStr;

    this.unparsedOrigRules = this.respList[this.currentCase]['orig_rules'];
    this.savedUnparsedRules = this.respList[this.currentCase]["orig_rules"];
    this.patches = this.respList[this.currentCase]['patches'];
    this.patchMasks = this.respList[this.currentCase]['rule_masks'];
    this.token = this.respList[this.currentCase]['token'];

    this.patchNum = this.patches.length;
    if (!this.patchNum) {
      this.finished = true;
    } else {
      this.finished = false;
    }
    this.showSpinner = false;
    if (this.patches.length) {
      this.parsePatch(this.currentPatch);
    }
    if (this.savedUnparsedRules) {
      this.updateSavedRules();

    }
  }
}
