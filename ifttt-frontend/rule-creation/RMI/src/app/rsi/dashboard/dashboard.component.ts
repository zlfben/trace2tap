import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog } from '@angular/material';
import { MatBottomSheet } from '@angular/material/bottom-sheet';
import { ModeselComponent } from '../modesel/modesel.component';
import { UserDataService, Device, Location, Command, Capability, Parameter } from '../../user-data.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  public username: string;
  public devices: Device[];
  public locations: Location[];
  public showSpinner: boolean = true;
  public sideNavOpened: boolean = false;

  constructor(
    public userDataService: UserDataService,
    private route: Router,
    private router: ActivatedRoute,
    private dialog: MatDialog) { 
    
  }

  ngOnInit() {
    this.userDataService.getUsername().subscribe(data => {
      this.username = data["username"];
      this.userDataService.getLocations(this.username).subscribe(data => {
          this.locations = data["locations"];
          if(this.locations.length > 0) {
              this.userDataService.current_loc = this.locations[0]["id"]
              this.locations.forEach( (loc) => {
                  this.userDataService.getDevices(loc["id"]).subscribe(
                      data => {
                          loc.devices = data["devs"];
                          this.devices = loc.devices;
                          this.showSpinner = false;
                      },
                      err => {
                          if(err.status == 403) {
                              this.route.navigate(["/error/403"]);
                          }
                      });
              });
          }
      });
    });
    this.sideNavOpened = false;
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

  getCommandFromCapability(device: Device, capability: Capability) {
    return device.commands.filter(x => x.capability.id == capability.id);
  }

  getDefaultTextForCapability(capability: Capability, parameter: Parameter) {
    return this.userDataService.getDefaultTextForCapability(capability, parameter);
  }

  changeLoc(loc: Location) {
    this.devices = loc.devices;
  }

  logout() {
    this.userDataService.logout().subscribe(data => {
      this.userDataService.username = null;
      this.userDataService.isLoggedIn = false;
      this.userDataService.current_loc = -1;
      this.route.navigate(["/"]);
    });
  }

  openDialog(device: Device, command: Command) {
    this.userDataService.currentDevice = device;
    this.userDataService.currentCommand = command;
    this.dialog.open(ModeselComponent);
  }

  goToRsiBase(device: Device, command: Command) {
    this.userDataService.currentDevice = device;
    this.userDataService.currentCommand = command;
    this.route.navigate(["/synthesize"]);
  }

  goToDashboard() {
    this.route.navigate(["/rules"]);
  }

  gotoCreate() {
    delete this.userDataService.currentlyStagedRule;
    localStorage['currentlyStagedRuleIndex'] = -1;
    this.route.navigate(["/create"]);
  }
}
