import { ErrModule } from './err.module';

describe('ErrModule', () => {
  let errModule: ErrModule;

  beforeEach(() => {
    errModule = new ErrModule();
  });

  it('should create an instance', () => {
    expect(errModule).toBeTruthy();
  });
});
