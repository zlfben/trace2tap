import { Component, OnInit, Input } from '@angular/core';
import { UserDataService, Location, Command, Device, Capability, Parameter } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-revert',
  templateUrl: './revert.component.html',
  styleUrls: ['./revert.component.css']
})
export class RevertComponent implements OnInit {
  public devices: Device[];
  public showSpinner: boolean = true;

  constructor(
    public userDataService: UserDataService,
    private route: Router) { }

  ngOnInit() {
    this.userDataService.getUsername().subscribe(u_data => {

      this.userDataService.getDevices(this.userDataService.current_loc, true).subscribe(data => {
        this.devices = data['devs'];
        this.showSpinner = false;
      });
    });
  }

  getDeviceCommandCapabilities(device: Device) {
    let capList = [];
    for (let command of device.commands) {
      if (!capList.map(cap => cap[0].id).includes(command.capability.id)) {
        capList.push([command.capability, command.parameter]);
      }
    }
    return capList;
  }

  getDefaultTextForCapability(capability: Capability, parameter: Parameter) {
    return this.userDataService.getDefaultTextForCapability(capability, parameter);
  }

  goToDashboard() {
    this.route.navigate(["/admin"]);
  }

  goToRevertBase(dev: Device, command: Command) {
    this.userDataService.currentDevice = dev;
    this.userDataService.currentCommand = command;
    this.route.navigate(["admin/revertbase/"]);
  }

  getCommandFromCapability(device: Device, capability: Capability) {
    return device.commands.filter(x => x.capability.id == capability.id);
  }
}
