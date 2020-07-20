import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material';
import { MatButtonModule } from '@angular/material/button';

import { DmibaseComponent } from './dmibase/dmibase.component';
import { DciComponent } from './dci/dci.component';

const routes: Routes = [
    {
        path: 'devices',
        component: DmibaseComponent,
        children: [
            {
                path: 'create',
                component: DciComponent
            }
        ]
    }
];

@NgModule({
  imports: [
    CommonModule, RouterModule.forChild(routes),
    MatFormFieldModule, MatInputModule, MatButtonModule
  ],
  declarations: [DmibaseComponent, DciComponent],
  exports: [
    RouterModule
  ]
})
export class DmiModule { }
