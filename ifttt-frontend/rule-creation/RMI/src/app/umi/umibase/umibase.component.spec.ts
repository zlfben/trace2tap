import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UmibaseComponent } from './umibase.component';

describe('UmibaseComponent', () => {
  let component: UmibaseComponent;
  let fixture: ComponentFixture<UmibaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UmibaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UmibaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
