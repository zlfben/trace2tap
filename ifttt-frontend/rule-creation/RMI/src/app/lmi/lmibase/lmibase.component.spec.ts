import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LmibaseComponent } from './lmibase.component';

describe('LmibaseComponent', () => {
  let component: LmibaseComponent;
  let fixture: ComponentFixture<LmibaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LmibaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LmibaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
