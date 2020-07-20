import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

export interface RuleUIRepresentation {
  words: string[]; // e.g. IF, AND, THEN
  icons: string[]; // the string name of the icons
  descriptions: string[]; // the descriptions for each of the icons
}

export interface DialogData {
  rules: RuleUIRepresentation[];
}

@Component({
  selector: 'app-currentrule',
  templateUrl: './currentrule.component.html',
  styleUrls: ['./currentrule.component.css']
})
export class CurrentruleComponent implements OnInit {
  public RULES: RuleUIRepresentation[];

  constructor(private _dialogRef: MatDialogRef<CurrentruleComponent>, 
    @Inject(MAT_DIALOG_DATA) public data: DialogData) { }

  ngOnInit() {
    this.RULES = this.data.rules;
  }

}
