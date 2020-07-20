import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { VisbaseComponent } from './visbase.component';

describe('VisbaseComponent', () => {
  let component: VisbaseComponent;
  let fixture: ComponentFixture<VisbaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ VisbaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(VisbaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
