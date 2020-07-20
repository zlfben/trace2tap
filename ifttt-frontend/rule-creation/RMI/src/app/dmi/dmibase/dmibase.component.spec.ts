import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DmibaseComponent } from './dmibase.component';

describe('DmibaseComponent', () => {
  let component: DmibaseComponent;
  let fixture: ComponentFixture<DmibaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DmibaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DmibaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
