import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'vis-status',
  templateUrl: './status.component.html',
  styleUrls: ['./status.component.css']
})
export class StatusComponent implements OnInit {
  @Input() value: any;
  @Input() mode: number;  // 0: new 1: fix 2:revert
  @Input() currentCluster: number;
  constructor() { }

  ngOnInit() {
  }

  // getOrigTypeValue(v) {
  //   if(['on', 'open', 'On', 'Open'].includes(v)) {
  //     return ['triangle-on', ''];
  //   } else if(['off', 'closed', 'Off', 'Closed'].includes(v)) {
  //     return ['triangle-off', ''];
  //   } else if(['motion', 'no motion', 'active', 'inactive', 'Motion', 'No Motion'].includes(v)) {
  //     return ['coral_dot', ''];
  //   } else if(['triggered'].includes(v)) {
  //     return ['blue_dot', ''];
  //   } else if(['solid_line_green'].includes(v)) {
  //     return ['solid_line_green', ''];
  //   } else if(['solid_line_coral'].includes(v)) {
  //     return ['solid_line_coral', ''];
  //   } else {
  //     return ['plain', v];
  //   }
  // }

  getValueType(value) {
    let total_height = 35;

    // remove fixed items' height from total height
    let num_line = 0;
    for (let typ_val of value) {
      let typ = typ_val[0];
      if (['motion', 'blue_dot'].includes(typ)) {
        total_height -= 8;
      } else if (['plain', 'on', 'off'].includes(typ)) {
        total_height -= 14;
      } else if (['solid_line_coral', 'line', 'solid_line_green'].includes(typ)) {
        num_line += 1;
      }
    }
    let line_height = total_height > 0? total_height / num_line: 0;

    let result = [];
    for (let index in value) {
      let typ = value[index][0];
      let val = value[index][1];
      let height = '0px';
      if (['solid_line_coral', 'line', 'solid_line_green'].includes(typ)) {
        height = String(line_height) + 'px';
      } else if (['motion', 'blue_dot'].includes(typ)) {
        height = String(8) + 'px';
      } else if (['plain', 'on', 'off', 'newtap', 'orig', 'origv', 'del'].includes(typ)) {
        height = String(14) + 'px';
      }
      result.push([typ, val, height])
    }
    return result;

  }


}
