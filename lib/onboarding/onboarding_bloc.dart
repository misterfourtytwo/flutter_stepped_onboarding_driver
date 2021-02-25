import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:onboarding_test_app/onboarding_data_dao.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

const int onboardingStepsCnt = 6;

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingStateInitial());

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    print(event);
    print(state);
    if (event is OnboardingEventLoad) {
      yield* _handleLoad(this.state, event);
    } else if (event is OnboardingEventOpenStep) {
      yield* _handleOpenStep(this.state, event);
    } else if (event is OnboardingEventStepShown) {
      yield* _handleStepShown(this.state, event);
    } else if (event is OnboardingEventClose) {
      yield* _handleClose(this.state, event);
    } else {
      print('got unknown event ${event.runtimeType}');
    }
  }

  Stream<OnboardingState> _handleLoad(
    OnboardingState state,
    OnboardingEventLoad event,
  ) async* {
    if (state is OnboardingStateInitial) {
      yield OnboardingStateLoading();

      final Map<int, bool> flags = OnboardingDataDao().getFlagsMap();
      int currentStep = onboardingStepsCnt;
      for (int i = onboardingStepsCnt - 1; i >= 0; i--) {
        if (flags.containsKey(i) && flags[i] == true) continue;
        flags[i] = false;
        currentStep = i;
      }

      // if (this.state is OnboardingStateLoading) {
      if (currentStep != onboardingStepsCnt) {
        yield OnboardingStateAwaitingStep(
          flags: flags,
          currentStep: currentStep,
        );
      } else {
        yield OnboardingStateAllStepsShown(
          flags: flags,
          currentStep: onboardingStepsCnt,
        );
        // }
      }
    }
  }

  Stream<OnboardingState> _handleOpenStep(
    OnboardingState state,
    OnboardingEventOpenStep event,
  ) async* {
    if (state is OnboardingStateAwaitingStep) {
      // if (state.currentStep == event.step) {
      yield OnboardingStateStepInProgress(
        flags: state.flags,
        currentStep: state.currentStep,
      );
      // }
    }
  }

  Stream<OnboardingState> _handleStepShown(
    OnboardingState state,
    OnboardingEventStepShown event,
  ) async* {
    if (state is OnboardingStateStepInProgress) {
      await OnboardingDataDao().setStep(step: state.currentStep);
      if (state.currentStep == event.step) {
        {
          if (event.step + 1 < onboardingStepsCnt) {
            yield OnboardingStateAwaitingStep(
              flags: OnboardingDataDao().getFlagsMap(),
              currentStep: event.step + 1,
            );
          } else {
            yield OnboardingStateAllStepsShown(
              flags: OnboardingDataDao().getFlagsMap(),
              currentStep: onboardingStepsCnt,
            );
          }
        }
      }
    }
  }

  Stream<OnboardingState> _handleClose(
    OnboardingState state,
    OnboardingEvent event,
  ) async* {
    final Map<int, bool> flags = <int, bool>{
      for (int i = 0; i < onboardingStepsCnt; i++) i: true,
    };
    OnboardingDataDao().setFlagsMap(flags);
    yield OnboardingStateAllStepsShown(
        currentStep: onboardingStepsCnt, flags: flags);
  }
}
