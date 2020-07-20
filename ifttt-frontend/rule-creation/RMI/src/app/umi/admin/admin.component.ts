import { Component, OnInit } from '@angular/core';
import { UserDataService, Location } from '../../user-data.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.css']
})
export class AdminComponent implements OnInit {

  public locations: Location[] = [];
  public sideNavOpened: boolean;
  public currentLocation: number = 0;
  public locationFetched: boolean = false;
  constructor(
    public userDataService: UserDataService, 
    private route: Router,) { }

  ngOnInit() {
    this.userDataService.getLocations("admin").subscribe(data => {
      this.locations = data["locations"];
      this.locationFetched = true;
    });
  }

  changeLoc(loc_i: number) {
    this.currentLocation = loc_i;
  }

  logout() {
    this.userDataService.logout().subscribe(data => {
        this.userDataService.username = null;
        this.userDataService.isLoggedIn = false;
        this.userDataService.current_loc = -1;
        this.route.navigate(["/"]);
    });
  }
  
  gotoRevert() {
    this.userDataService.current_loc = this.locations[this.currentLocation].id;
    this.route.navigate(["/admin/revert/"]);
  }

  gotoDebug() {
    this.userDataService.current_loc = this.locations[this.currentLocation].id;
    this.route.navigate(["/admin/debug/"]);
  }

  gotoManual() {
    this.userDataService.current_loc = this.locations[this.currentLocation].id;
    this.route.navigate(["/admin/manual/"]);
  }
}
