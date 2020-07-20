import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CommonModule } from '@angular/common';
import { RevertComponent } from './revert/revert.component';
import { DebugComponent } from './debug/debug.component';
import { ManualComponent } from './manual/manual.component';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatCardModule } from '@angular/material/card';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSliderModule } from '@angular/material/slider';
import { MatSelectModule } from '@angular/material/select';
import { RevertbaseComponent } from './revertbase/revertbase.component';


const routes: Routes = [
  {
    path: 'admin/revert',
    component: RevertComponent
  },
  {
    path: 'admin/debug',
    component: DebugComponent
  },
  {
    path: 'admin/manual',
    component: ManualComponent
  },
  {
    path: 'admin/revertbase',
    component: RevertbaseComponent
  }
]

@NgModule({
  imports: [
    RouterModule.forChild(routes),
    CommonModule, MatProgressSpinnerModule, MatCardModule, 
    MatListModule, MatButtonModule, MatIconModule, MatSliderModule, MatSelectModule
  ],
  declarations: [RevertComponent, DebugComponent, ManualComponent, RevertbaseComponent],
  exports: [
    RouterModule
  ]
})
export class HistoryModule { }
