import { Component, OnInit, ViewChild, ViewContainerRef, ComponentFactoryResolver, ComponentRef } from '@angular/core';
import { UserDataService, Device, Location, Command, Rule } from '../../user-data.service';
import { Router } from '@angular/router';
import { VisbaseComponent } from '../../rsi/vis/visbase/visbase.component';

@Component({
  selector: 'app-revertbase',
  templateUrl: './revertbase.component.html',
  styleUrls: ['./revertbase.component.css']
})
export class RevertbaseComponent implements OnInit {

  private currentDevice: Device;
  private currentCommand: Command;
  public logList: any[];
  private devList: string[];
  private capList: string[];
  private targetId: number;
  public logFetched: boolean = false;

  @ViewChild('vis', { read: ViewContainerRef }) entry: ViewContainerRef;
  private compRef: ComponentRef<VisbaseComponent>;

  constructor(private userDataService: UserDataService, 
    private route: Router, private resolver: ComponentFactoryResolver) { }

  ngOnInit() {
    this.currentDevice = this.userDataService.currentDevice;
    this.currentCommand = this.userDataService.currentCommand;

    let self = this;

    this.userDataService.getRevert(this.currentDevice, this.currentCommand).subscribe(data => {
      self.logList = data["log_list"];
      self.devList = data["dev_list"];
      self.capList = data["cap_list"];
      self.targetId = data["target_id"];
      this.compRef = this.createVis();
    });
  }

  createVis() {
    this.entry.clear();
    const factory = this.resolver.resolveComponentFactory(VisbaseComponent);
    const componentRef = this.entry.createComponent(factory);

    componentRef.instance.traceLogs = this.logList;
    componentRef.instance.maskList = this.logList.map(x=>{return true;});
    componentRef.instance.currentCluster = 0;
    componentRef.instance.mode = 2;
    componentRef.instance.devList = this.devList;
    componentRef.instance.capList = this.capList;
    componentRef.instance.targetId = this.targetId;
    componentRef.instance.tapSensorList = [[]];
    componentRef.instance.needComp = true;

    componentRef.instance.display = true;

    return componentRef;
  }

  goToDashboard() {
    this.route.navigate(["/admin/revert/"]);
  }
}
