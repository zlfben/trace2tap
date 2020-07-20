import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';

import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material';
import { MatTabsModule } from '@angular/material/tabs';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatSelectModule } from '@angular/material/select';
import { MatStepperModule } from '@angular/material/stepper';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatRadioModule } from '@angular/material/radio';

import { UmibaseComponent } from './umibase/umibase.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { LoginComponent } from './login/login.component';
import { UciComponent } from './uci/uci.component';
import { AdminComponent } from './admin/admin.component';

const routes: Routes = [
  {
    path: '',
    component: UmibaseComponent,
    children: [
        {
            path: 'dashboard',
            component: DashboardComponent
        },
        {
            path: 'user/create',
            component: UciComponent
        },
        {
            path: '',
            component: LoginComponent
        },
        {
            path: 'admin',
            component: AdminComponent
        }
    ]
  }
]

@NgModule({
  imports: [
    RouterModule.forChild(routes),
    CommonModule, MatIconModule, MatButtonModule, MatProgressSpinnerModule,
    MatCardModule, MatFormFieldModule, MatInputModule, MatRadioModule,
    MatTabsModule, MatSlideToggleModule, MatSidenavModule,
    MatListModule, MatSelectModule, MatStepperModule, ReactiveFormsModule
  ],
  declarations: [
      UmibaseComponent, DashboardComponent, LoginComponent, UciComponent, AdminComponent
  ],
  exports: [
    RouterModule
  ]
})
export class UmiModule { }
