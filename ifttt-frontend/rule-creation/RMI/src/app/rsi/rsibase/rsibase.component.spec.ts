import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RsibaseComponent } from './rsibase.component';

describe('RsibaseComponent', () => {
  let component: RsibaseComponent;
  let fixture: ComponentFixture<RsibaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RsibaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RsibaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
