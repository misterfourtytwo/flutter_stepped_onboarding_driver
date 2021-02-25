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
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingStateInitial) {
          BlocProvider.of<OnboardingBloc>(context).add(OnboardingEventLoad());
        } else if (state is OnboardingStateAwaitingStep &&
            state.currentStep == step) {
          BlocProvider.of<OnboardingBloc>(context)
              .add(OnboardingEventOpenStep(step));
        }
      },
      buildWhen: (oldState, newState) {
        return oldState is OnboardingStateLoaded &&
            oldState.currentStep == step;
      },
      builder: (BuildContext context, OnboardingState state) {
        bool showPortal =
            state is OnboardingStateStepInProgress && state.currentStep == step;
        print('step $step blocBuilder rebuild');
        print('update bloc state: ${state.runtimeType}');
        print('show Portal: $showPortal');

        return PortalEntry(
          portalAnchor: Alignment.bottomCenter,
          visible: showPortal,
          childAnchor: Alignment.topCenter,
          child: child,
          portal: Builder(
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Positioned.fill(
                    //     child: Container(
                    //   color: Colors.red,
                    // )),
                    //
                    Align(
                      child: Container(
                        height: 240,
                        width: 240,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                color: Colors.blue[200],
                                child: Text('skip'),
                                onPressed: () => _onClose(context),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: FlatButton(
                                color: Colors.green[200],
                                child: Text('continue'),
                                onPressed: () => _onContinue(context),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
