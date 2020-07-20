import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { Err403Component } from './err403/err403.component';

const routes: Routes = [
  {
    path: 'error/403',
    component: Err403Component
  }
]

@NgModule({
  imports: [
    CommonModule, RouterModule.forChild(routes),
  ],
  declarations: [Err403Component],
  exports: [
    RouterModule
  ]
})
export class ErrModule { }
