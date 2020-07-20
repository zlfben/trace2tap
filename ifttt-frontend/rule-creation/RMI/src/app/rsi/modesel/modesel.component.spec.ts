import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ModeselComponent } from './modesel.component';

describe('ModeselComponent', () => {
  let component: ModeselComponent;
  let fixture: ComponentFixture<ModeselComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ModeselComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ModeselComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
