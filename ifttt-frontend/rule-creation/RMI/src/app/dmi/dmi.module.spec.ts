import { DmiModule } from './dmi.module';

describe('DmiModule', () => {
  let dmiModule: DmiModule;

  beforeEach(() => {
    dmiModule = new DmiModule();
  });

  it('should create an instance', () => {
    expect(dmiModule).toBeTruthy();
  });
});
