import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormBuilder, FormControl, Validators, AbstractControl, FormGroup, FormGroupDirective, NgForm } from '@angular/forms';

import { UserDataService, STInstalledApp, STApp } from '../../user-data.service';

@Component({
    selector: 'app-uci',
    templateUrl: './uci.component.html',
    styleUrls: ['./uci.component.css']
})
export class UciComponent implements OnInit {

    private st_token_pattern = '^[a-f0-9]{8}\-[a-f0-9]{4}\-[a-f0-9]{4}\-[a-f0-9]{4}\-[a-f0-9]{12}$';

    public st_installed_apps: STInstalledApp[];
    public preAppCreationForm = this.fb.group({
        "appCreated": [false, [Validators.required]]
    });
    public stSetupForm = this.fb.group({
        "clientId": ['', [Validators.required, Validators.pattern(this.st_token_pattern)]],
        "clientSecret": ['', [Validators.required, Validators.pattern(this.st_token_pattern)]]
    });
    public appProfileForm = this.fb.group({
        "appName": ['', [Validators.pattern('[a-zA-Z0-9 \\-_]*'), Validators.maxLength(128)]],
        "appDscr": ['']
    });
    public appRegResult = "";
    public appRegResultDscr = "";
    public appRegSuccess = false;

    public username: string;

    constructor(
        public userDataService: UserDataService,
        private route: Router, 
        private fb: FormBuilder
    ) { }

    ngOnInit() {
        this.userDataService.getCsrfCookie().subscribe();
        this.appRegResult = "Done";
        this.appRegResultDscr = "Loading...";
        this.username = this.userDataService.username;
    }

    stappRegister() {
        let stappName = this.preAppCreationForm.value.appCreated ? "" : this.appProfileForm.value.appName;
        let stappDscr = this.preAppCreationForm.value.appCreated ? "" : this.appProfileForm.value.appDscr;
        const stapp: STApp = {
            "client_id": this.stSetupForm.value.clientId,
            "client_secret": this.stSetupForm.value.clientSecret,
            "name": stappName,
            "description": stappDscr
        }
        this.userDataService.registerApp(stapp).subscribe(
            res => {
                this.appRegResultDscr = "Great! Your SmartThings App is now created in our database!";
                this.appRegSuccess = true;
            }, 
            err => {
                this.appRegResult = "Failed";
                this.appRegResultDscr = "Sorry. Your app is not successfully registered. Please try again.";
                console.log(err.error.msg);
            });
    }

    goToDashboard() {
        this.route.navigate(["/dashboard/"]);
    }

    getLocationsAndDevices() {
        this.userDataService.getUsername().subscribe(data => {
            let username = data["username"];
            this.userDataService.getLocations(username).subscribe(data => {
                let locations = data["locations"];
                if(locations.length > 0) {
                    this.userDataService.getDevices(locations[0]["id"]).subscribe(
                        data => {},
                        err => {
                            console.log(err.error.msg);
                        });
                }
            });
        });
    }

}
