import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'onboarding/onboarding_bloc.dart';

class OnboardingStepWrapper extends StatelessWidget {
  final int step;
  final Widget child;
  final VoidCallback onStepFinished;
  const OnboardingStepWrapper({
    Key key,
    @required this.step,
    @required this.child,
    this.onStepFinished,
  }) : super(key: key);

  void _onContinue(BuildContext context) {
    BlocProvider.of<OnboardingBloc>(context).add(
      OnboardingEventStepShown(step),
    );
    if (onStepFinished != null) {
      onStepFinished();
    }
  }

  void _onClose(BuildContext context) {
    BlocProvider.of<OnboardingBloc>(context).add(
      OnboardingEventClose(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      // listener: (context, state) {
      //   print(state);
      //   if (state is OnboardingStateAwaitingStep && state.currentStep == step)
      //     BlocProvider.of<OnboardingBloc>(context).add(
      //       OnboardingEventOpenStep(step),
      //     );
      // },
      // buildWhen: (oldState, newState) {
      // return false;
      // print(
      //   'state changed: ${oldState.runtimeType} -> ${newState.runtimeType}',
      // );
      // return (oldState is OnboardingStateAwaitingStep &&
      //         oldState.currentStep == step) ||
      //     (oldState is OnboardingStateStepInProgress &&
      //         oldState.currentStep == step);
      // },
      builder: (BuildContext context, OnboardingState state) {
        print('step $step blocBuilder rebuild');
        print('update bloc state: ${state.runtimeType}');
        bool showPortal =
            state is OnboardingStateStepInProgress && state.currentStep == step;
        print('show Portal: $showPortal');
        if (state is OnboardingStateInitial) {
          print('launching load event');
          BlocProvider.of<OnboardingBloc>(context).add(OnboardingEventLoad());
        } else if (state is OnboardingStateAwaitingStep &&
            state.currentStep == step) {
          BlocProvider.of<OnboardingBloc>(context).add(
            OnboardingEventOpenStep(step),
          );
        }

        return PortalEntry(
          portal: Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.circle,
              ),
              child: Row(
                children: [
                  FlatButton(
                    color: Color(0xFF0000FF),
                    child: Text('skip'),
                    onPressed: () => _onClose(context),
                  ),
                  OutlineButton(
                    color: Color(0xFF00FFFF),
                    child: Text('continue'),
                    onPressed: () => _onContinue(context),
                  )
                ],
              )),
          portalAnchor: Alignment.center,
          visible: showPortal,
          childAnchor: Alignment.center,
          child: child,
        );
      },
    );
  }
}
