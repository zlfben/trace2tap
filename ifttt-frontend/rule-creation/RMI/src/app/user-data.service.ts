import { Injectable, Inject, LOCALE_ID } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient, HttpHeaders, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { environment } from '../environments/environment';
import { delay } from 'rxjs/operators'; 
import { of } from 'rxjs';
import { formatDate } from '@angular/common';

export interface Task {
  description: String;
  rules: Object[];
}

export interface Rule {
  ifClause: Clause[];
  thenClause: Clause[];
  priority?: number;
  temporality: string;
  id?: number;
}

export interface Sp1 {
  thisState: Clause[];
  thatState: Clause[];
  compatibility: boolean;
}

export interface Sp2 {
  stateClause: Clause[];
  compatibility: boolean;
  comparator?: String;
  time?: Time;
  alsoClauses?: Clause[];
}

export interface Sp3 {
  triggerClause: Clause[];
  compatibility: boolean;
  timeComparator?: string;
  otherClauses?: Clause[];
  afterTime?: Time;
}

export interface Time {
  seconds: number;
  minutes: number;
  hours: number;
}

export interface Clause {
  channel: Channel;
  device: Device;
  capability: Capability;
  parameters?: Parameter[];
  parameterVals?: any[];
  text: string;
  id?: number;
}

export interface Channel {
  id: number;
  name: string;
  icon: string;
}

export interface Capability {
  id: number;
  name: string;
  label: string;
}

export interface Parameter {
  id: number;
  name: string;
  type: string;
  values: any[];
}

export interface Command {
  capability: Capability;
  parameter: Parameter;
  value: string;
  count: number;
  covered: number;
  reverted: number;
}

export interface Device {
  id: number;
  name: string;
  label: string;
  icon: string;
  commands: Command[];
  mainState: boolean;
  mainStateLabel: string;
  subscribed: boolean;
}



export interface Location {
  id: number;
  name: string;
  devices: Device[];
}

export interface STInstalledApp {
  st_id: string;
  name: string;
  location_id: string;
  refresh_token: string;
}

export interface STApp {
  name: string;
  description: string;
  client_id: string;
  client_secret: string;
}

@Injectable()
export class UserDataService {

  // user variables
  private taskList: Task[];
  private currentTaskIndex: number = 0;
  public hashed_id: string;
  public user_id: number;
  public task_id: number;
  public username: string;
  public mode: string;
  public isLoggedIn: boolean = false;
  public current_loc: number = -1;
  // rule variables
  public currentlyStagedRuleIndex: number = 0;
  public currentlyStagedRule: Rule | null = null;
  public currentObjectType: string = "trigger";

  // temporality variables
  public isCurrentObjectEvent: boolean = false;
  public currentObjectIndex: number = -1;
  public temporality: string = "event-state";

  //sp variables
  public currentlyStagedSp1: Sp1 | null = null;
  public currentlyStagedSp2: Sp2 | null = null;
  public currentlyStagedSp3: Sp3 | null = null;
  public currentlyStagedSpIndex: number = 0;
  public currentSpType: number;
  public currentSpClauseType: string;
  public compatibilityPhrase: string = '';
  public comparator: string = '';
  public hasAfterTime: boolean;
  public whileOrAfter: boolean = true;
  public hideSp2Time: boolean = false;
  public hideSp2Also: boolean = false;

  // clause variables
  public channels: Channel[];
  public selectedChannel: Channel;
  public selectedDevice: Device;
  public selectedCapability: Capability;
  public parameters: Parameter[];
  public currentClause: Clause;

  // meta clause variables
  public currentHistoryObjectIndex: number;
  public historyClause: Clause;
  public historyClauseParameterIndex: number;
  public isCurrentHistoryEvent: string = '';
  public currentHistoryObjectType: string = '';

  // editing variables
  public editing: boolean;
  public editingRuleID: number;
  public stopLoadingEdit: boolean;
  public editingSpID: number;

  // for rule synthesizing based on traces
  public currentCommand: Command;
  public currentDevice: Device;

  private apiUrl: string = environment.apiUrl;

  constructor(private router: Router, private route: ActivatedRoute,
              private http: HttpClient, @Inject(LOCALE_ID) public locale: string) {
    this.getUserTasks().then((tasks: Task[]) => {
      this.taskList = tasks;
    });
    this.editing == false;
  }

  // unused
  public shouldShowPriority(): boolean {
    const shouldShow = this.temporality === "state-state";
    if (shouldShow && !this.currentlyStagedRule.priority) {
      this.currentlyStagedRule['priority'] = 1;
    }
    return shouldShow;
  }

  // unused
  public getDescriptionFromClause(clause: Clause) {
    return this.currentClause.text;
  }

  // unused
  private getUserTasks(): Promise<Task[]> {
    return new Promise((resolve, reject) => {
      resolve([
        {
          description: `Your dog, Fido, likes to play outside in the rain, but he then tracks mud into 
            the house. Therefore, if Fido happens to be outside in the rain, call him inside.`,
          rules: []
        }
      ]);
    });
  }

  // unused
  public getCurrentTask(): Task {
    return this.taskList[this.currentTaskIndex];
  }

  // unused
  public getTotalNumberTasks(): number {
    return this.taskList.length;
  }

  // unused
  public getCurrentTaskNumber(): string {
    // return this.currentTaskIndex + 1;
    return "hello"; // thanks abhi
  }

  // unused
  public isRuleCurrentlyStaged(): boolean {
    return !!this.currentlyStagedRule;
  }

  // stages empty rule if no rule
  public stageRule(): void {
    if (!this.currentlyStagedRule) {
      this.currentlyStagedRule = {
        ifClause: [],
        thenClause: [],
        temporality: this.temporality,
      };
    }
  }

  // adds current clause to either "if" or "then" clauses or current rule
  public addClauseToRule() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    delete this.parameters;
    if (this.currentObjectType == "trigger") {
      if (this.currentObjectIndex == -1) {
        clause.id = this.currentlyStagedRule.ifClause.length;
        this.currentlyStagedRule.ifClause.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedRule.ifClause[this.currentObjectIndex] = clause;
      }
    }
    else {
      clause.id = 0;
      this.currentlyStagedRule.thenClause[0] = clause;
    }
  }

  // benches current clause to "this.historyClause" so the clause to fulfill
  // the meta parameter can be chosen for rules
  public selectHistoryClause(historyClauseParameterIndex: number, currentParameterVals: any[], temporality: string) {
    this.historyClauseParameterIndex = historyClauseParameterIndex;
    this.historyClause = this.currentClause;
    this.historyClause.parameterVals = currentParameterVals;
    this.currentHistoryObjectIndex = this.currentObjectIndex;
    delete this.currentClause;
    var is_event = (temporality == 'event' ? -1 : 1);
    this.gotoDeviceSelector('trigger', is_event);
  }

  // benches current clause to "this.historyClause" so the clause to fulfill
  // the meta parameter can be chosen for sps
  public selectSpHistoryClause(sptype: number, historyClauseParameterIndex: number, currentParameterVals: any[], temporality: string) {
    this.historyClauseParameterIndex = historyClauseParameterIndex;
    this.historyClause = this.currentClause;
    this.historyClause.parameterVals = currentParameterVals;
    delete this.currentClause;
    this.currentHistoryObjectIndex = this.currentObjectIndex;
    var trigger = (temporality == 'event' ? 'trigger' :'not-trigger');
    this.gotoSpChannelSelector(trigger, this.currentSpClauseType, 0);
  }

  // takes historyClause off the bench and adds the current clause as
  // its meta parameter
  public addClauseToHistoryChannelClause() {
    this.historyClause.parameterVals[this.historyClauseParameterIndex] = {"value":this.getTextForClause(this.currentClause), "comparator":"="}
    this.currentClause = this.historyClause;
    delete this.historyClause;
    this.isCurrentObjectEvent = this.isCurrentHistoryEvent == 'event' ? true : false;
    this.isCurrentHistoryEvent = '';
    this.currentObjectIndex = this.currentHistoryObjectIndex;
    delete this.currentHistoryObjectIndex;
    this.selectedDevice = this.currentClause.device;
    this.selectedCapability = this.currentClause.capability;
  }

  // reloads parameter configuration page now that we've selected the
  // meta parameter for rules
  public reloadForHistoryClause() {
    this.router.navigate(['../create'], {skipLocationChange: true}).then(()=>
    this.router.navigate(['../create/configureParameters', 
                        this.currentClause.channel ? this.currentClause.channel.id : 'undefined', 
                        this.currentClause.device.id, 
                        this.currentClause.capability.id]));
  }

  // reloads parameter configuration page now that we've selected the
  // meta parameter for sps
  public reloadForSpHistoryClause() {
    this.router.navigate(['../createSp'], {skipLocationChange: true}).then(()=>
    this.router.navigate(['../createSp/configureParameters', 
                        this.currentClause.channel.id, 
                        this.currentClause.device.id, 
                        this.currentClause.capability.id]));
  }

  public reloadForRuleClear() {
    delete this.currentlyStagedRule;
    this.stopLoadingEdit = true;
    this.router.navigate(["/rules"], {skipLocationChange: true}).then(()=>
    this.router.navigate(['../create']));
  }

  public  reloadForSp1Clear() {
    delete this.currentlyStagedSp1;
    this.stopLoadingEdit = true;
    this.router.navigate(['../createSp'], {skipLocationChange: true}).then(()=>
    this.router.navigate(['../createSp/sp1']));
  }

  public  reloadForSp2Clear() {
    delete this.currentlyStagedSp2
    this.stopLoadingEdit = true;
    this.router.navigate(['../createSp'], {skipLocationChange: true}).then(()=>
    this.router.navigate(['../createSp/sp2']));
  }

  public  reloadForSp3Clear() {
    this.whileOrAfter = true;
    delete this.currentlyStagedSp3;
    this.stopLoadingEdit = true;
    this.router.navigate(['../createSp'], {skipLocationChange: true}).then(()=>
    this.router.navigate(['../createSp/sp3']));
  }

  // uses a ruleid to get a full rule from the backend for editing
  public getFullRule(ruleid: number) {
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    let body = {"ruleid":ruleid, "loc_id": this.current_loc};
    this.http.post(this.apiUrl + "user/rules/get/", body, option)
              .subscribe(
                data => { 
                  // update time from utc to local if clock - time is used
                  data["rule"].ifClause = this.updateClausesTimezone(data["rule"].ifClause, true);
                  this.currentlyStagedRule = data["rule"]; 
                }
              );
  }

  // sends current rule to backend for saving
  public finishRule() {
    var mode = (this.editing ? "edit" : "create");
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    var ruleid = (this.editing ? this.editingRuleID : 0)
    var loc_id = this.current_loc
    let body = {}
    
    // convert local time to UTC time if clock - time is used
    this.currentlyStagedRule.ifClause = this.updateClausesTimezone(this.currentlyStagedRule.ifClause, false);
    
    if(this.task_id){
      body = {"rule": this.currentlyStagedRule, "user_id": this.user_id, "task_id": this.task_id, "mode": mode, "rule_id":ruleid};
    } else {
      body = {"rule": this.currentlyStagedRule, "mode": mode, "rule_id":ruleid, "loc_id": loc_id};
    }
    this.editing = false;
    this.compatibilityPhrase = '';
    
    // @TODO: should find a better way to decide which url should be used
    if(!this.isLoggedIn) {
      this.http.post(this.apiUrl + "user/rules/new/", body, option)
      .subscribe(
         data => {this.currentlyStagedRule = null;
         this.router.navigate(['icse19/' + this.hashed_id + "/" + this.task_id + "/rules"]);}
      );
    } else {
      this.http.post(this.apiUrl + "user/rules/new/", body, option).subscribe(data => {
        this.currentlyStagedRule = null;
        this.router.navigate(["../rules"]);
      })
    }
  }

  // send a list of rules to add to the backend, used for adding suggested rules
  public addRules(rule_list: Rule[]) {
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    var loc_id = this.current_loc
    let body = {}

    // shouldn't convert time zone. the page uses utc
    // for (let i in rule_list) {
    //   rule_list[i].ifClause = this.updateClausesTimezone(rule_list[i].ifClause, false);
    //   // console.log(rule_list[i].ifClause);
    // }
    // should update text
    for (let rule of rule_list) {
      for (let clause of rule.ifClause) {
        clause = this.getTextForClause(clause);
      }
      for (let clause of rule.thenClause) {
        clause = this.getTextForClause(clause);
      }
    }

    body = {"rules": rule_list, "loc_id": loc_id};
    this.http.post(this.apiUrl + "user/rules/newbatch/", body, option).subscribe(data => {
      this.currentlyStagedRule = null;
      this.router.navigate(["/rules"]);
    })
  }

  public changeRules(device: Device, command: Command, rule_list: Rule[]) {
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    var loc_id = this.current_loc
    let body = {}
    for (let i in rule_list) {
      rule_list[i].ifClause = this.updateClausesTimezone(rule_list[i].ifClause, false);
    }
    body = {"device": device, "command": command, "rules": rule_list, "loc_id": loc_id};
    this.http.post(this.apiUrl + "user/rules/changebatch/", body, option).subscribe(data => {
      this.currentlyStagedRule = null;
      this.router.navigate(["/rules"]);
    });
  }

  // deletes rule at ruleid
  public deleteRule(ruleid: number) {
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    let body = {"ruleid": ruleid, "locid": this.current_loc}
    return this.http.post(this.apiUrl + "user/rules/delete/", body, option)
  }

  // checks if staged rule is valid to be saved
  public stagedRuleIsValid(): boolean {
    return (this.currentlyStagedRule && this.currentlyStagedRule.ifClause.length > 0 
            && this.currentlyStagedRule.thenClause.length > 0);
  }

  // navigates to rule creation
  public gotoCreate() {
    this.router.navigate(["../create/"]);
  }

  //navigates to sp creation
  public gotoCreateSp(sptype: number) {
    if (sptype == 1) {
      this.router.navigate(["../createSp/sp1"]);
    }
    else if (sptype == 2) {
      this.router.navigate(["../createSp/sp2"]);
    }
    else if (sptype == 3) {
      this.router.navigate(["../createSp/sp3"]);
    }
    else {this.router.navigate(["../createSp/"]);}
  }

  // navigates to channel selector for rules
  public gotoChannelSelector(objectType: string, index: number): void {
    if (objectType == 'trigger' || objectType == 'action') this.currentObjectType = objectType;
    if (objectType == 'triggerAdd') {this.currentObjectType = 'trigger';}
    this.currentObjectIndex = index;
    if (objectType == "trigger" && index <= 0) {
      this.isCurrentObjectEvent = true;
    } else {
      this.isCurrentObjectEvent = false;
    }
    this.router.navigate(["../create/selectChannel"], {relativeTo: this.route});
  }

  // navigates to channel selector for sps
  public gotoSpChannelSelector(objectType: string, spClauseType: string, index: number): void {
    this.currentObjectType = objectType;
    this.currentSpClauseType = spClauseType;
    this.currentObjectIndex = index;
    if (spClauseType == 'trigger' || spClauseType == 'otherEvent') {this.isCurrentObjectEvent = true} 
    else {this.isCurrentObjectEvent = false}
    this.router.navigate(["../createSp/selectChannel"], {relativeTo: this.route});
  }

  // navigates to device selector for rules
  public gotoDeviceSelector(objectType: string, index: number): void {
    if (objectType == 'trigger' || objectType == 'action') this.currentObjectType = objectType;
    if (objectType == 'triggerAdd') {this.currentObjectType = 'trigger';}
    this.currentObjectIndex = index;
    if (objectType == "trigger" && index <= 0) {
      this.isCurrentObjectEvent = true;
    } else {
      this.isCurrentObjectEvent = false;
    }
    this.router.navigate(['../create/selectDevice'], {relativeTo: this.route})
  }

  // navigates to device selector for sps
  public gotoSpDeviceSelector(channel: Channel): void {
    this.selectedChannel = channel;
    this.router.navigate(['../createSp/selectDevice', String(channel.id)])
  }

  //navigates to capability selector for rules
  public gotoCapabilitySelector(selectedDevice: Device, deviceID: number): void {
    this.selectedDevice = selectedDevice;
    this.router.navigate(['../create/selectCapability', String(deviceID)]);
  }

  // navigates to capability selector for sps
  public gotoSpCapabilitySelector(selectedDevice: Device, channelID: number, deviceID: number): void {
    this.selectedDevice = selectedDevice;
    this.router.navigate(['../createSp/selectCapability', String(channelID), String(deviceID)]);
  }

  // navigates to parameter configuration for rules
  public gotoParameterConfiguration(selectedCapability: Capability, channelID: number, deviceID: number, capabilityID: number) {
    this.selectedCapability = selectedCapability;
    this.currentClause = {"channel":this.selectedChannel, "device":this.selectedDevice, "capability":this.selectedCapability, "text":this.selectedCapability.label}
    var parameters;
    this.getParametersForCapability(true, true, deviceID, capabilityID).subscribe(
      data => { 
        parameters = data["params"];
        if (parameters.length > 0) {
          this.router.navigate(['../create/configureParameters', String(channelID), String(deviceID), String(capabilityID)]);
        }
        else {
          this.addClauseToRule()
          this.gotoCreate();}
      });
  }

  // navigates to parameter configuration for sps
  public gotoSpParameterConfiguration(selectedCapability: Capability, channelID: number, deviceID: number, capabilityID: number) {
    this.selectedCapability = selectedCapability;
    this.currentClause = {"channel":this.selectedChannel, "device":this.selectedDevice, "capability":this.selectedCapability, "text":this.selectedCapability.label}
    var parameters;
    this.getParametersForCapability(true, true, deviceID, capabilityID).subscribe(
      data => { 
        parameters = data["params"];
        if (parameters.length > 0) {
          this.router.navigate(['../createSp/configureParameters', String(channelID), String(deviceID), String(capabilityID)]);
        }
        else {
          if (this.currentlyStagedSp1){
            this.addClauseToSp1()
            this.gotoCreateSp(1);
          }
          else if (this.currentlyStagedSp2){
            this.addClauseToSp2()
            this.gotoCreateSp(2);
          }
          else {
            this.addClauseToSp3()
            this.gotoCreateSp(3);
          }
        }
      }
    );
  }

  // get csrf cookie from the backend
  public getCsrfCookie(): any {
    let option = {withCredentials: true};
    return this.http.get(this.apiUrl + "user/get_cookie/", option);
  }

  // gets a user's rules from the backend using their user_id, as well as 
  // will get their numerical user id based on their string 
  // hashed_id URL parameter if a user_id field isn't provided in this call.
  public getRules(): any {
      return this.http.get(this.apiUrl + "user/loc/" + this.current_loc +"/rules/");
  }

  public getICSERules(hashed_id: string): any {
    let body = {"userid": this.user_id, "taskid": this.task_id, "code":hashed_id};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/rules/", body, option);
  }

  // gets all channels from the backend
  public getChannels(is_Trigger: boolean, is_Event: boolean,): any {
    let body = {};
    if(this.user_id) {
      body = {"user_id": this.user_id, "is_trigger": is_Trigger};
    } else {
      body = {"user_id": "", "is_trigger": is_Trigger};
    }
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/chans/", body, option);
  }

  // gets all devices related to selected channel
  public getDevicesForChannel(is_Trigger: boolean, is_Event: boolean, channel_id: number): any {
    let body = {};
    if(this.user_id) {
      body = {"user_id": "", "is_trigger": is_Trigger, "channelid": channel_id};
    } else {
      body = {"userid": this.user_id, "is_trigger": is_Trigger, "channelid": channel_id};
    }
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/chans/devs/", body, option);
  }

  // gets all devices in a given location
  public getDevicesInLocation(is_Trigger: boolean, is_Event: boolean): any {
    let body = {};
    body = {"is_trigger": is_Trigger, "loc_id": this.current_loc};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/loc/devs/", body, option);
  }

  // gets all capabilities related to selected device
  public getCapabilitiesForDevice(is_Trigger: boolean, is_Event: boolean, device_id: number): any {
    let body = {"deviceid": device_id, 
                "is_trigger": is_Trigger,
                "is_event": is_Event
              };
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/loc/devs/caps/", body, option);
  }

  // gets all parameters for selected capability
  public getParametersForCapability(is_Trigger: boolean, is_Event: boolean, device_id: number, capability_id: number): any {
    let body = {"capid": capability_id};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/chans/devs/caps/params/", body, option);
  }

  public getTextFromParVal(device: Device, capability: Capability, parameters: Parameter[], parameterVals: any[], hideDev: boolean=false): string {
    var label = capability.label;
    if (hideDev) {
      label = label.replace("{DEVICE}'s", "");
      label = label.replace("({DEVICE})", "");
      label = label.replace("{DEVICE}", "");
    } else {
      label = label.replace("{DEVICE}", (device.label ? device.label : device.name));
    }
    var parameter: any;
    for (parameter in parameters) {
      if (parameters[parameter].type == "range" || parameters[parameter].type == "input") {
        label = label.replace("{" + parameters[parameter].name + "}", parameterVals[parameter].value);
        const rangeComparators = ["=","!=",">","<"];
        var i: number;
        for (i = 0; i < rangeComparators.length; i++) {
          if (parameterVals[parameter].comparator == rangeComparators[i]) {
            var re = new RegExp("{" + parameters[parameter].name + "\/" + rangeComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1");  
          }
          else {
            var re  = new RegExp("{" + parameters[parameter].name + "\/" + rangeComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else if (parameters[parameter].type == "set") {
        label = label.replace("{" + parameters[parameter].name + "}", parameterVals[parameter].value);
        const setComparators = ["=", "!="];
        var i: number;
        for (i = 0; i < setComparators.length; i++) {
          if (parameterVals[parameter].comparator == setComparators[i]) {
            var re = new RegExp("{" + parameters[parameter].name + "\/" + setComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1")  
          }
          else {
            var re  = new RegExp("{" + parameters[parameter].name + "\/" + setComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else if (parameters[parameter].type == "duration") {
        var description = '';
        const sptime = parameterVals[parameter].value;
        if (sptime.hours > 0) {description += (sptime.hours + (sptime.hours==1?" hour":" hours"));}
        if (sptime.minutes > 0) {description += (sptime.minutes + (sptime.minutes==1?" minute":" minutes"));}
        if (sptime.seconds > 0) {description += (sptime.seconds + (sptime.seconds==1?" second":" seconds"));}
        label = label.replace("{" + parameters[parameter].name + "}", description);
        const durationComparators = [">", "<", "="];
        var i: number;
        for (i = 0; i < durationComparators.length; i++) {
          if (parameterVals[parameter].comparator == durationComparators[i]) {
            var re = new RegExp("{" + parameters[parameter].name + "\/" + durationComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1")  
          }
          else {
            var re  = new RegExp("{" + parameters[parameter].name + "\/" + durationComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else if (parameters[parameter].type == "meta") {
        // console.log(parameterVals[parameter].value);
        let clause = this.getTextForClause(parameterVals[parameter].value);
        label = label.replace("{$trigger$}", clause.text)
      }
      else if (parameters[parameter].type == "color") {
        label = label.replace("{" + parameters[parameter].name + "}", parameterVals[parameter].value);
        const colorComparators = ["=", "!="];
        var i: number;
        for (i = 0; i < colorComparators.length; i++) {
          if (parameterVals[parameter].comparator == colorComparators[i]) {
            var re = new RegExp("{" + parameters[parameter].name + "\/" + colorComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1")  
          }
          else {
            var re  = new RegExp("{" + parameters[parameter].name + "\/" + colorComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else if (parameters[parameter].type != "bin") {
        label = label.replace("{" + parameters[parameter].name + "}", parameterVals[parameter].value);
        // this is overkill but apparently it's needed in some cases
        const setComparators = ["=","!=",">","<"];
        var i: number;
        for (i = 0; i < setComparators.length; i++) {
          if (parameterVals[parameter].comparator == setComparators[i]) {
            var re = new RegExp("{" + parameters[parameter].name + "\/" + setComparators[i] + "\\|(.*?)}", "g");
            label = label.replace(re, "$1")  
          }
          else {
            var re  = new RegExp("{" + parameters[parameter].name + "\/" + setComparators[i] + "\\|.*?}", "g");
            label = label.replace(re, "");
          }
        }
      }
      else {
        label = label.replace("{" + parameters[parameter].name + "}", parameterVals[parameter].value);
        // if binary value is true
        if (parameterVals[parameter].value == parameters[parameter].values[0]) {
          // get rid of false text
          var re = new RegExp("{" + parameters[parameter].name + "\/F\\|.*?}", "g");
          label = label.replace(re, "");
          // leave true text but get rid of its capsule
          var re = new RegExp("{" + parameters[parameter].name + "\/T\\|(.*?)}", "g");
          label = label.replace(re, "$1")  
        }
        else if (parameterVals[parameter].value == parameters[parameter].values[1]) {
          // get rid of true text
          var re = new RegExp("{" + parameters[parameter].name + "\/T\\|.*?}", "g");
          label = label.replace(re, "");
          // leave false text but get rid of its capsule
          var re = new RegExp("{" + parameters[parameter].name + "\/F\\|(.*?)}", "g");
          label = label.replace(re, "$1") 
        } else {
          // get rid of true text
          var re = new RegExp("{" + parameters[parameter].name + "\/T\\|.*?}", "g");
          label = label.replace(re, "");
          // get rid of false text
          var re = new RegExp("{" + parameters[parameter].name + "\/F\\|.*?}", "g");
          label = label.replace(re, "");
        }
      }
    }
    return label;
  }
  
  // wherever a full clause shows up (in /rules, /sp, /create, or /createSp)
  // this function uses regular expressions on its label to put the
  // add its selected values
  public getTextForClause(clause: Clause): Clause {
    clause.text = this.getTextFromParVal(clause.device, clause.capability, clause.parameters, clause.parameterVals);
    clause.text = this.updateTextForTiming(clause.text);
    return clause;
  }

  public updateTextForTiming(text: string): string {
    let re_time = new RegExp('^(Exactly )?(.*) ago, "(.*)" became true and has been the case.$');
    let match_time = re_time.exec(text);
    if (match_time) {
      let time = match_time[2];
      let statement = match_time[3];
      let re_temp_1_p = '^(.*) detects (.*)$';  // (1) has been detecting (2)
      let re_temp_1_n = '^(.*) does not detect (.*)$';  // (1) has not detected (2)
      let re_temp_2_p = '^(.*) is (.*)$';  // (1) has been (2)
      let re_temp_2_n = '^(.*) is not (.*)$'; // (1) has not been (2)
      let reg_tups = [[re_temp_1_p, ' has been detecting '],
                      [re_temp_1_n, ' has not detected '],
                      [re_temp_2_p, ' has been '],
                      [re_temp_2_n, ' has not been ']];
      for (let tup of reg_tups) {
        let reg = new RegExp(tup[0]);
        if (reg.test(statement)) {
          let match = reg.exec(statement);
          return match[1] + tup[1] + match[2] + ' for ' + time;
        }
      }
    }
    return text;
  }

  public getTextForCommand(device: Device, command: Command): string {
    return this.getTextFromParVal(device, command.capability, [command.parameter], [{"value": command.value, "comparator": "="}], true);
  }

  public getDefaultTextForCapability(capability: Capability, parameter: Parameter) {
    let device: Device = {
      id: 0, name: "", label: "", icon: "", 
      commands: [], mainState: null, 
      mainStateLabel: null, subscribed: false
    };
    let parameters = [parameter];
    let parameterVals = [{value: "..."}];
    return this.getTextFromParVal(device, capability, parameters, parameterVals, true);
  }

  // SAFETY PROPERTY STUFF BELOW

  // gets a user's sps from the backend using their user_id, as well as 
  // will get their numerical user id based on their string 
  // hashed_id URL parameter if a user_id field isn't provided in this call.
  public getSps(hashed_id: string): any {
    let body = {"userid": this.user_id, "taskid":this.task_id, "code": hashed_id};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/sps/", body, option);
  }

  // checks if currently staged sp is valid to be saved
  public stagedSpIsValid(sptype: number): boolean {
    if (sptype == 1) {
      return (this.currentlyStagedSp1 && this.currentlyStagedSp1.thisState.length > 0 
              && this.currentlyStagedSp1.thatState.length > 0 && this.compatibilityPhrase != '');
    }
    if (sptype == 2) {
      var bool = (this.currentlyStagedSp2 && this.currentlyStagedSp2.stateClause.length > 0 &&
                  this.compatibilityPhrase != '');
      return bool;
    }
    if (sptype == 3) {
      var bool = (this.currentlyStagedSp3 && this.currentlyStagedSp3.triggerClause.length > 0 
              && this.currentlyStagedSp3.compatibility == false);
      if (this.currentlyStagedSp3 && this.compatibilityPhrase != '' && this.currentlyStagedSp3.triggerClause.length > 0 &&
          (this.currentlyStagedSp3.otherClauses.length > 0 || 
          this.currentlyStagedSp3.afterTime)) {
        bool = true;
      }
      if (this.currentlyStagedSp3.afterTime && this.currentlyStagedSp3.otherClauses.length == 0) {
        bool = false
      }
      return bool;
    }
  }

  // stages an empty sp1 if there isn't one
  public stageSp1(): void {
    if (!this.currentlyStagedSp1) {
      this.currentlyStagedSp1 = {
        thisState: [],
        thatState: [],
        compatibility: true,
      };
    }
  }

  // stages an empty sp2 if there isn't one
  public stageSp2(): void {
    if (!this.currentlyStagedSp2) {
      this.currentlyStagedSp2 = {
        stateClause: [],
        alsoClauses: [],
        compatibility: true,
        comparator: '>',
        time: null,
      };
    }
  }

  // stages an empty sp3 if there isn't one
  public stageSp3(): void {
    if (!this.currentlyStagedSp3) {
      this.currentlyStagedSp3 = {
        triggerClause: [],
        otherClauses: [],
        compatibility: true,
        timeComparator: '<',
      };
    }
  }
  
  // adds current clause to currently staged sp1
  public addClauseToSp1() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    if (this.currentSpClauseType == "this") {
      clause.id = 0;
      this.currentlyStagedSp1.thisState[0] = clause;
    }
    else {
      if (this.currentObjectIndex == -1) {
        clause.id = 0;
        this.currentlyStagedSp1.thatState.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedSp1.thatState[this.currentObjectIndex] = clause;
      }
    }
  }

  // adds current clause to currently staged sp2
  public addClauseToSp2() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    if (this.currentSpClauseType == "state") {
      clause.id = 0;
      this.currentlyStagedSp2.stateClause[0] = clause;
    }
    else {
      if (this.currentObjectIndex == -1) {
        clause.id = 0;
        this.currentlyStagedSp2.alsoClauses.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedSp2.alsoClauses[this.currentObjectIndex] = clause;
      }
    }
  }

  // adds current clause to currently staged sp3
  public addClauseToSp3() {
    const clause = this.getTextForClause(this.currentClause);
    delete this.currentClause;
    if (this.currentSpClauseType == "trigger") {
      clause.id = 0;
      this.currentlyStagedSp3.triggerClause[0] = clause;
    }
    else {
      if (this.currentObjectIndex == -1) {
        clause.id = 0;
        this.currentlyStagedSp3.otherClauses.push(clause);
      }
      else {
        clause.id = this.currentObjectIndex;
        this.currentlyStagedSp3.otherClauses[this.currentObjectIndex] = clause;
      }
    }
  }

  // saves currently staged sp to the backend
  public finishSp(sptype: number) {
    var mode = (this.editing ? "edit" : "create");
    var spid = (this.editing ? this.editingSpID : 0)
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    this.editing == false;
    if (sptype == 1) {
      let body = {"sp": this.currentlyStagedSp1, "userid": this.user_id, "taskid": this.task_id, "mode": mode, "spid":spid};
      this.http.post(this.apiUrl + "user/sp1/new/", body, option)
             .subscribe(
                data => {this.currentlyStagedSp1 = null;
                this.router.navigate(['icse19/' + this.hashed_id + "/" + this.task_id + "/sp"]);}
             );
    }
    else if (sptype == 2) {
      let body = {"sp": this.currentlyStagedSp2, "userid": this.user_id, "taskid": this.task_id, "mode": mode, "spid":spid};
      this.http.post(this.apiUrl + "user/sp2/new/", body, option)
             .subscribe(
                data => {this.currentlyStagedSp2 = null;
                this.router.navigate(['icse19/' + this.hashed_id + "/" + this.task_id + "/sp"]);}
             );
    }
    else {
      let body = {"sp": this.currentlyStagedSp3, "userid": this.user_id, "taskid": this.task_id, "mode": mode, "spid":spid};
      this.http.post(this.apiUrl + "user/sp3/new/", body, option)
             .subscribe(
                data => {this.currentlyStagedSp3 = null;
                this.router.navigate(['icse19/' + this.hashed_id + "/" + this.task_id + "/sp"]);}
             );
    }
  }

  // gets a full sp from the backend from its id for editing
  public getFullSp(spid: number, sptype: number) {
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    let body = {"userid": this.user_id, "spid":spid};
    if (sptype == 1) {
    this.http.post(this.apiUrl + "user/sp1/get/", body, option)
              .subscribe(
                data => {this.currentlyStagedSp1 = data["sp"];
                this.compatibilityPhrase = (data["sp"].compatibility ? 'always' : 'never');}
              );
    } else if (sptype == 2) {
      this.http.post(this.apiUrl + "user/sp2/get/", body, option)
                .subscribe(
                  data => {this.currentlyStagedSp2 = data["sp"];
                  this.compatibilityPhrase = (data["sp"].compatibility ? 'always' : 'never');
                  if (!this.currentlyStagedSp2.comparator) {
                    this.currentlyStagedSp2.comparator = '';
                  }
                  if (!this.currentlyStagedSp2.time) {
                    this.hideSp2Time = true;
                  } else {this.hideSp2Time = false;}
                  if (this.currentlyStagedSp2.alsoClauses.length == 0) {
                    this.hideSp2Also = true;
                  } else {this.hideSp2Also = false;}
                  });
    } else {
      this.http.post(this.apiUrl + "user/sp3/get/", body, option)
                .subscribe(
                  data => {this.currentlyStagedSp3 = data["sp"];
                  this.compatibilityPhrase = (data["sp"].compatibility ? 'always' : 'never');
                  this.hasAfterTime = (data["sp"].timeAfter ? true : false);
                  this.currentlyStagedSp3.timeComparator = '>';
                  }
                );
    }
  }

  // deletes sp by its id
  public deleteSp(spid: number) {
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    let body = {"userid": this.user_id, "taskid":this.task_id, "spid": spid}
    return this.http.post(this.apiUrl + "user/sps/delete/", body, option)
  }

  // DEVICE RELATED STUFF BELOW

  public getDevices(locId: number, plain_revert: boolean=false): any {
    let body = {"locid": locId, "plain_revert": plain_revert};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "user/devices/", body, option);
  }

  // LOCATION RELATED STUFF BELOW

  public getLocations(username: string) {
    return this.http.get(this.apiUrl + "user/locations/");
  }

  // Analyze trace
  public getRuleSuggestion(device: Device, command: Command) {
    let body = {"device": device, "command": command, "first_time": true};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "autotap/suggestadd/", body, option);
  }

  // Analyze trace
  public getFollowUpRuleSuggestion(token: string, mask: Boolean[]) {
    let body = {"token": token, "mask": mask, "first_time": false};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "autotap/suggestadd/", body, option);
  }

  // Debug rules from trace
  public getRuleDebugSuggestion(device: Device, command: Command) {
    let body = {"device": device, "command": command, "first_time": true};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "autotap/suggestdebug/", body, option);
  }
  
  // Follow up debug
  public getFollowUpRuleDebugSuggestion(token: string, rules: Rule[]) {
    let body = {"token": token, "rules": rules, "first_time": false};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "autotap/suggestdebug/", body, option);
  }

  // Get log for visualization
  public fetchLog(token: string) {
    let body = {"token": token};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "autotap/getepisode/", body, option);
  }

  // Get log for visualization (debug)
  public fetchLogDebug(token: string) {
    let body = {"token": token};
    let option = {headers: new HttpHeaders().set('Content-Type', 'application/json')};
    return this.http.post(this.apiUrl + "autotap/getepisodedebug/", body, option);
  }

  // USER RELATED STUFF BELOW

  public login(username: string, password: string) {
    // IoTCore-login
    const body = "username=" + username + "&password=" + password;
    return this.http.post(
      this.apiUrl + 'user/login/', 
      body, 
      {
        headers: new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded'),
        observe: 'response'
      });
  }

  public register(username: string, password: string) {
    // IoTCore-login
    const body = "username=" + username + "&password=" + password;
    return this.http.post(
      this.apiUrl + 'user/register/', 
      body, 
      {
        headers: new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded'),
        observe: 'response'
      });
  }

  public logout() {
    return this.http.get(this.apiUrl + 'user/logout/');
  }

  public getUsername() {
    /*  Return:
        200:  {"userid": "", "username": ""}
        401:  {"msg": "Please login."}
        500:  {"msg": repr(err)}
    */
    return this.http.get(this.apiUrl + 'user/get_name/');
  }

  public checkUsername(username: string) {
    let body = "username=" + username;
    return this.http.post(
      this.apiUrl + 'user/check_name/',
      body,
      {
        headers: new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded'),
        observe: 'response'
      }).pipe(
        delay(400)
      );
  }

  // SMARTTHINGS RELATED STUFF

  public registerApp(stapp: STApp) {
    let body = {
      "client_id": stapp.client_id,
      "client_secret": stapp.client_secret,
      "name": stapp.name,
      "description": stapp.description
    };
    return this.http.post(
      this.apiUrl + 'st/installed_apps/register/', 
      body, 
      {
        headers: new HttpHeaders().set('Content-Type', 'application/json'),
        observe: 'response'
      }
    );
  }

  public changeDevState(dev: Device) {
    let body = {
      "locid": this.current_loc,
      "devid": dev.id,
      "capability": "switch",
      "command": dev.mainStateLabel.toLowerCase(),
      "values": {}
    }
    return this.http.post(
      this.apiUrl + 'st/installed_apps/command/',
      body,
      {
        headers: new HttpHeaders().set('Content-Type', 'application/json'),
        observe: 'response'
      }
    );
  }

  public localTime2UTCTime(localTime: string) {
    let strDateTime = formatDate(new Date(), 'yyyy-MM-dd', this.locale) + 'T' + localTime + ':00';
    let scheduledUTCTime = new Date(strDateTime).toISOString();
    return formatDate(scheduledUTCTime, 'HH:mm', this.locale, '+0000');
  }

  public UTCTime2LocalTime(UTCTime: string) {
    let strUTCTime = formatDate(new Date(), 'yyyy-MM-dd', this.locale) + 'T' + UTCTime + ':00+00:00';
    return formatDate(new Date(strUTCTime), 'HH:mm', this.locale);
  }

  private deepCopyClause(clause) {
    let new_clause = {...clause};
    new_clause.parameters = clause.parameters.map(x => {return {...x}});
    new_clause.parameterVals = clause.parameterVals.map(x => {return {...x}});
    return new_clause;
  }

  public updateClausesTimezone(clauses: Clause[], utc2local: boolean) {
    let new_clauses = clauses.map(this.deepCopyClause);
    var i: any;
    for (i in new_clauses) {
      let clause = new_clauses[i];
      if (clause.device.name == "Clock" && clause.capability.name == "Clock") {
        let j: any;
        for (j in clause.parameters) {
          if (clause.parameters[j].type == "time") {
            if (utc2local) {
              clause.parameterVals[j].value = this.UTCTime2LocalTime(clause.parameterVals[j].value);
            } else {
              clause.parameterVals[j].value = this.localTime2UTCTime(clause.parameterVals[j].value);
            }
            new_clauses[i] = this.getTextForClause(clause);
          }
        }
      }
    }
    return new_clauses;
  }

  public getRevertForLoc(loc_id: number) {
    let url = this.apiUrl + 'autotap/revert/loc/';
    let body = {'loc_id': loc_id};
    return this.http.post(url, body, {
      headers: new HttpHeaders().set('Content-Type', 'application/json'),
      observe: 'response'
    });
  }

  public getRevert(device: Device, command: Command) {
    let url = this.apiUrl + 'autotap/revert/action/';
    let body = {'command': command, 'device': device};
    return this.http.post(url, body, {
      headers: new HttpHeaders().set('Content-Type', 'application/json')
    });
  }

  public getManualChanges(loc_id: number) {
    let url = this.apiUrl + 'autotap/manual/';
    let body = {'loc_id': loc_id};
    return this.http.post(url, body, {
      headers: new HttpHeaders().set('Content-Type', 'application/json')
    });
  }

  public getDebugPages(loc_id: number) {
    let url = this.apiUrl + 'autotap/debugpage/';
    let body = {'loc_id': loc_id};
    return this.http.post(url, body, {
      headers: new HttpHeaders().set('Content-Type', 'application/json')
    });
  }
}
