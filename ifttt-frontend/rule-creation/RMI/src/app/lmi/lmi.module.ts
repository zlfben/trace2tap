import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material';
import { MatButtonModule } from '@angular/material/button';

import { LmibaseComponent } from './lmibase/lmibase.component';
import { LmciComponent } from './lmci/lmci.component';
import { LmliComponent } from './lmli/lmli.component';

const routes: Routes = [
    {
        path: 'location',
        component: LmibaseComponent,
        children: [
            {
                path: 'create',
                component: LmciComponent
            },
            {
                path: '',
                component: LmliComponent
            }
        ]
    }
]

@NgModule({
    imports: [
        RouterModule.forChild(routes), CommonModule, MatFormFieldModule,
        MatInputModule, MatButtonModule
    ],
    declarations: [
        LmibaseComponent, LmciComponent, LmliComponent
    ],
    exports: [
        RouterModule
    ]
})
export class LmiModule { }
