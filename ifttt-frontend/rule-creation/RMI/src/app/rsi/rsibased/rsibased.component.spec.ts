import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RsibasedComponent } from './rsibased.component';

describe('RsibasedComponent', () => {
  let component: RsibasedComponent;
  let fixture: ComponentFixture<RsibasedComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RsibasedComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RsibasedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
