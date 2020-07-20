import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LmliComponent } from './lmli.component';

describe('LmliComponent', () => {
  let component: LmliComponent;
  let fixture: ComponentFixture<LmliComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LmliComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LmliComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
