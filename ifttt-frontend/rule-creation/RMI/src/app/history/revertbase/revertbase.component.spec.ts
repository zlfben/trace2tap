import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RevertbaseComponent } from './revertbase.component';

describe('RevertbaseComponent', () => {
  let component: RevertbaseComponent;
  let fixture: ComponentFixture<RevertbaseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RevertbaseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RevertbaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
