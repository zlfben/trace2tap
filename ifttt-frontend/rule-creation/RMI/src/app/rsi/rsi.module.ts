import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CommonModule } from '@angular/common';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatSliderModule } from '@angular/material/slider';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card'
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatBottomSheetModule } from '@angular/material/bottom-sheet';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FormsModule } from '@angular/forms';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatTreeModule } from '@angular/material/tree';
import { MatDialogModule } from '@angular/material/dialog';
import { MatExpansionModule } from '@angular/material/expansion';


import { DashboardComponent } from './dashboard/dashboard.component';
import { RsibaseComponent } from './rsibase/rsibase.component';
import { VisComponent } from './vis/vis.component';
import { ModeselComponent } from './modesel/modesel.component';
import { RsibasedComponent } from './rsibased/rsibased.component';
import { StatusComponent } from './vis/status/status.component';
import { CurrentruleComponent } from './currentrule/currentrule.component';
import { LegendComponent } from './vis/legend/legend.component';
import { VisbaseComponent } from './vis/visbase/visbase.component';

const routes: Routes = [
  {
    path: 'synthesize',
    component: RsibaseComponent
  },
  {
    path: 'synthesize/dashboard',
    component: DashboardComponent
  },
  {
    path: 'synthesize/visualization',
    component: VisComponent
  },
  {
    path: 'debug',
    component: RsibasedComponent
  }
]

@NgModule({
  declarations: [DashboardComponent, RsibaseComponent, VisComponent, ModeselComponent, RsibasedComponent, StatusComponent, CurrentruleComponent, LegendComponent, VisbaseComponent],
  imports: [
    RouterModule.forChild(routes),
    CommonModule, FormsModule,
    MatSelectModule, MatSliderModule, MatButtonModule, MatIconModule, MatTreeModule,
    BrowserAnimationsModule, MatFormFieldModule, MatCardModule, MatSidenavModule,
    MatListModule, MatProgressSpinnerModule, MatBottomSheetModule, MatTooltipModule,
    MatDialogModule, MatExpansionModule
  ],
  entryComponents: [
    ModeselComponent,
    CurrentruleComponent,
    LegendComponent,
    VisbaseComponent
  ],
})
export class RsiModule { }
