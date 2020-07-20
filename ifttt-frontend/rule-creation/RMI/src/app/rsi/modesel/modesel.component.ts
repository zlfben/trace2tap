import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MatBottomSheet, MatBottomSheetRef } from '@angular/material/bottom-sheet';
import { MatDialog, MatDialogRef } from '@angular/material';
import { UserDataService } from '../../user-data.service';

@Component({
  selector: 'app-modesel',
  templateUrl: './modesel.component.html',
  styleUrls: ['./modesel.component.css']
})
export class ModeselComponent implements OnInit {

  constructor(
    private _dialogRef: MatDialogRef<ModeselComponent>,
    private route: Router,
    public userDataService: UserDataService
    ) { }

  ngOnInit() {
  }

  learnFP() {
    this._dialogRef.close();
    this.route.navigate(["/debug"]);
  }

  learnFN() {
    this._dialogRef.close();
    this.route.navigate(["/synthesize"]);
  }

}
