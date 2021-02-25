part of 'onboarding_bloc.dart';

abstract class OnboardingState {
  const OnboardingState();
}

class OnboardingStateInitial extends OnboardingState {}

class OnboardingStateLoading extends OnboardingState {}

abstract class OnboardingStateLoaded extends OnboardingState {
  final Map<int, bool> flags;
  final int currentStep;

  const OnboardingStateLoaded({
    this.flags,
    this.currentStep,
  });

  OnboardingStateLoaded copyWith({
    Map<int, bool> flags,
    int currentStep,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingStateLoaded &&
        mapEquals(other.flags, flags) &&
        other.currentStep == currentStep;
  }

  @override
  int get hashCode => flags.hashCode ^ currentStep.hashCode;
}

class OnboardingStateStepInProgress extends OnboardingStateLoaded {
  const OnboardingStateStepInProgress({
    Map<int, bool> flags,
    int currentStep,
  }) : super(
          currentStep: currentStep,
          flags: flags,
        );

  OnboardingStateStepInProgress copyWith({
    Map<int, bool> flags,
    int currentStep,
  }) {
    return OnboardingStateStepInProgress(
      flags: flags ?? this.flags,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class OnboardingStateAllStepsShown extends OnboardingStateLoaded {
  const OnboardingStateAllStepsShown({
    Map<int, bool> flags,
    int currentStep,
  }) : super(
          currentStep: currentStep,
          flags: flags,
        );

  OnboardingStateAllStepsShown copyWith({
    Map<int, bool> flags,
    int currentStep,
  }) {
    return OnboardingStateAllStepsShown(
      flags: flags ?? this.flags,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class OnboardingStateAwaitingStep extends OnboardingStateLoaded {
  const OnboardingStateAwaitingStep({
    Map<int, bool> flags,
    int currentStep,
  }) : super(
          currentStep: currentStep,
          flags: flags,
        );

  OnboardingStateAwaitingStep copyWith({
    Map<int, bool> flags,
    int currentStep,
  }) {
    return OnboardingStateAwaitingStep(
      flags: flags ?? this.flags,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
