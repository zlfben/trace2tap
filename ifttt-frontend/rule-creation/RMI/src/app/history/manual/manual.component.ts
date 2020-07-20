import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { UserDataService, Device, Location, Command, Rule } from '../../user-data.service';


export interface RuleUIRepresentation {
  words: string[]; // e.g. IF, AND, THEN
  icons: string[]; // the string name of the icons
  descriptions: string[]; // the descriptions for each of the icons
}

@Component({
  selector: 'app-manual',
  templateUrl: './manual.component.html',
  styleUrls: ['./manual.component.css']
})
export class ManualComponent implements OnInit {

  private loc_id: number;
  public rulePatches: any[];
  private unparsedRules: any[];
  public currentPatchId: number = 0;
  public RULES: RuleUIRepresentation[];
  public finish: boolean = false;

  constructor(private userDataService: UserDataService, private route: Router) { }

  ngOnInit() {
    this.loc_id = this.userDataService.current_loc;
    let self = this;
    this.userDataService.getManualChanges(this.loc_id).subscribe(data => {
      self.rulePatches = data['resp_list'];
      self.parseRulesToId(this.currentPatchId);
      self.finish = true;
    });
  }

  private parseRulesToId(to_id: number) {
    // parse rules to the previous status of patch[to_id]
    let target_id = to_id - 1;

    if (target_id == -1) {
      this.unparsedRules = [];
    } else {
      this.unparsedRules = this.rulePatches[target_id]['rules'];
    }
    this.parseRules();
  }
  
  private parseRules() {
    //parse rules into displayable form for list
    const rules = this.unparsedRules;
    this.RULES = rules.map((rule => {
      const words = [];
      const descriptions = [];
      const icons = [];

      // add the if clause stuff
      for (let i = 0; i < rule.ifClause.length; i++) {
        let clause = rule.ifClause[i];
        words.push(i == 0 ? "If" : (i > 1 ? "and" : "while"));
        icons.push(clause.channel.icon);
        clause.text = this.userDataService.updateTextForTiming(clause.text);
        // convert UTC time to local time if clock is used
        if (clause.text.startsWith('(Clock)')) {
          let strLocalTime = this.userDataService.UTCTime2LocalTime(clause.text.substr(-5, 5));
          clause.text = clause.text.replace(/\d{2}:\d{2}/, strLocalTime);
        }
        const description = clause.text;
        descriptions.push(description);
      }

      // add the then clause
      words.push("then");
      const description = rule.thenClause[0].text;
      descriptions.push(description);
      icons.push(rule.thenClause[0].channel.icon);

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

  goToDashboard() {
    this.route.navigate(["/admin"]);
  }

  gotoPrev() {
    this.currentPatchId = this.currentPatchId == 0 ? 0 : this.currentPatchId - 1;
    this.parseRulesToId(this.currentPatchId);
  }

  gotoNext() {
    this.currentPatchId = this.currentPatchId == this.rulePatches.length ? this.rulePatches.length : this.currentPatchId + 1;
    this.parseRulesToId(this.currentPatchId);
  }
}
