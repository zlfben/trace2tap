import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-lmci',
  templateUrl: './lmci.component.html',
  styleUrls: ['./lmci.component.css']
})
export class LmciComponent implements OnInit {

  constructor(private route: Router) { }

  ngOnInit() {
  }

  goToDashboard() {
    // TODO: Add user here
    this.route.navigate(["../dashboard/"]);
  }

}
