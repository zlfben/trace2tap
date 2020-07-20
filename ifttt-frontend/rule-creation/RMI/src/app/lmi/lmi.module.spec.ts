import { LmiModule } from './lmi.module';

describe('LmiModule', () => {
  let lmiModule: LmiModule;

  beforeEach(() => {
    lmiModule = new LmiModule();
  });

  it('should create an instance', () => {
    expect(lmiModule).toBeTruthy();
  });
});
