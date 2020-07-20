import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

import { UserDataService, Device, Location } from '../../user-data.service';

@Component({
    selector: 'app-dashboard',
    templateUrl: './dashboard.component.html',
    styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

    public username: string;
    public devices: Device[];
    public locations: Location[];
    public sideNavOpened: boolean;
    public showSpinner: boolean = true;

    constructor(
        public userDataService: UserDataService,
        private route: Router,
        private router: ActivatedRoute
    ) {
        //get the csrf cookie
        // this.userDataService.getCsrfCookie().subscribe(data => {

        // });
    }

    ngOnInit() {
        // this.devices = [
        //   {"id": 1, "name": "Hue Light 1", "label": "Hue Light 1", "icon": "lightbulb_outline", "mainState": true, "mainStateLabel": "On", "subscribed": true},
        // ];
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

    refreshLocations() {}

    changeDevState(dev: Device) {
        dev.mainState = !dev.mainState;
        dev.mainStateLabel = dev.mainState ? "On" : "Off";
        this.userDataService.changeDevState(dev).subscribe(
            data => {}, 
            err => {
                dev.mainState = !dev.mainState;
                dev.mainStateLabel = dev.mainState ? "On" : "Off";
            }
        );
    }

    goToLocationCreate() {
        this.route.navigate(["../location/create"]);
    }

    goToRuleManagement() {
        this.route.navigate(["../rules"]);
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
}
