import { UmiModule } from './umi.module';

describe('UmiModule', () => {
  let umiModule: UmiModule;

  beforeEach(() => {
    umiModule = new UmiModule();
  });

  it('should create an instance', () => {
    expect(umiModule).toBeTruthy();
  });
});
