import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CurrentruleComponent } from './currentrule.component';

describe('CurrentruleComponent', () => {
  let component: CurrentruleComponent;
  let fixture: ComponentFixture<CurrentruleComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CurrentruleComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CurrentruleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
