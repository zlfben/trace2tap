import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { RouterModule, Routes} from '@angular/router';
import { MatInputModule } from '@angular/material';
import { MatSliderModule } from '@angular/material/slider';
import { ColorPickerModule } from 'ngx-color-picker';

import { RmiModule } from './rmi/rmi.module';
import { RciModule } from './rci/rci.module';
import { UmiModule } from './umi/umi.module';
import { DmiModule } from './dmi/dmi.module';
import { ErrModule } from './err/err.module';
import { LmiModule } from './lmi/lmi.module';
import { RsiModule } from './rsi/rsi.module';
import { HistoryModule } from './history/history.module';

import { SharedModule } from './shared.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppComponent } from './app.component';

import { HttpClientModule, HttpClientXsrfModule, HTTP_INTERCEPTORS } from '@angular/common/http';

import { XsrfInterceptor } from './xsrf.interceptor';
import { LOCALE_ID } from '@angular/core';

import { VisComponent } from './rsi/vis/vis.component';

const routes: Routes = [
  {
    path: '',
    component: AppComponent,
  },
]

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule, RmiModule, RciModule, UmiModule, DmiModule,
    ErrModule, LmiModule, RsiModule, HistoryModule, 
    SharedModule, BrowserAnimationsModule,
    RouterModule.forRoot(routes, {enableTracing: false}),
    MatInputModule, MatSliderModule,
    HttpClientModule,
    HttpClientXsrfModule.withOptions({
      cookieName: 'csrftoken',
      headerName: 'X-CSRFToken'
    }), ColorPickerModule,
  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: XsrfInterceptor, multi: true },
    { provide: LOCALE_ID, useValue: 'en-US' }
  ],
  bootstrap: [AppComponent],
  entryComponents: [VisComponent]
})
export class AppModule { }
