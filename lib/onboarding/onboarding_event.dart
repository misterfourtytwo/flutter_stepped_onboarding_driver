part of 'onboarding_bloc.dart';

abstract class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingEventLoad extends OnboardingEvent {
  const OnboardingEventLoad();
}

class OnboardingEventClose extends OnboardingEvent {
  const OnboardingEventClose();
}

class OnboardingEventOpenStep extends OnboardingEvent {
  final int step;

  const OnboardingEventOpenStep(this.step);
}

class OnboardingEventStepShown extends OnboardingEvent {
  final int step;

  const OnboardingEventStepShown(this.step);
}

class OnboardingEventReset extends OnboardingEvent {
  const OnboardingEventReset();
}
