import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

import { UserDataService } from '../../user-data.service';

@Component({
  selector: 'app-dci',
  templateUrl: './dci.component.html',
  styleUrls: ['./dci.component.css']
})
export class DciComponent implements OnInit {

  public username: string[];

  constructor(
    public userDataService: UserDataService, 
    private route: Router, 
    private router: ActivatedRoute) {

    this.router.parent.params.subscribe(params => {
      this.username = params["username"];
    });
  }

  ngOnInit() {
  }

  goToDashboard() {
      // TODO: Add user here
      this.route.navigate(["../dashboard/"]);
  }

}
