import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LmciComponent } from './lmci.component';

describe('LmciComponent', () => {
  let component: LmciComponent;
  let fixture: ComponentFixture<LmciComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LmciComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LmciComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
