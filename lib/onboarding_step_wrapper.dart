import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'onboarding/onboarding_bloc.dart';

const onboardingConfigs = [
  OnboardingConfig(align: CrossAxisAlignment.start, pickFaceBottom: true),
  OnboardingConfig(align: CrossAxisAlignment.end, pickFaceBottom: true),
  OnboardingConfig(align: CrossAxisAlignment.start, pickFaceBottom: true),
  OnboardingConfig(align: CrossAxisAlignment.end, pickFaceBottom: true),
  OnboardingConfig(align: CrossAxisAlignment.end, pickFaceBottom: true),
  OnboardingConfig(align: CrossAxisAlignment.end, pickFaceBottom: false),
];

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
          portalAnchor: Alignment.center,
          visible: showPortal,
          childAnchor: Alignment.center,
          child: child,
          portal: PortalBuilder(
            child: child,
            step: step,
            onContinue: () => _onContinue(context),
            onClose: () => _onClose(context),
          ),
        );
      },
    );
  }
}

class PortalBuilder extends StatefulWidget {
  final Widget child;
  final int step;
  final VoidCallback onContinue;
  final VoidCallback onClose;
  const PortalBuilder({
    Key key,
    @required this.child,
    @required this.step,
    this.onClose,
    this.onContinue,
  }) : super(key: key);

  @override
  _PortalBuilderState createState() => _PortalBuilderState();
}

class _PortalBuilderState extends State<PortalBuilder> {
  Alignment getPortalAnchor(OnboardingConfig config) {
    switch (config.align) {
      case CrossAxisAlignment.start:
        return config.pickFaceBottom ? Alignment.bottomLeft : Alignment.topLeft;
      case CrossAxisAlignment.end:
        return config.pickFaceBottom
            ? Alignment.bottomRight
            : Alignment.topRight;
      default:
        return config.pickFaceBottom
            ? Alignment.bottomCenter
            : Alignment.topCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: PortalEntry(
        portal: MyHintWidget(
          config: onboardingConfigs[widget.step],
          onContinue: widget.onContinue,
          onClose: widget.onClose,
        ),
        portalAnchor: getPortalAnchor(onboardingConfigs[widget.step]),
        childAnchor: Alignment.topLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.yellow,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class MyHintWidget extends StatelessWidget {
  final OnboardingConfig config;
  final VoidCallback onContinue;
  final VoidCallback onClose;
  const MyHintWidget({
    Key key,
    this.config,
    this.onContinue,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(config);
    return Container(
      color: Colors.pink.withOpacity(.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: config.align,
        children: [
          if (!config.pickFaceBottom) TopPick(),
          Text(config.message),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlatButton(
                onPressed: onClose,
                child: Text('Пропустить'),
              ),
              FlatButton(
                onPressed: onContinue,
                child: Text('Далее'),
              )
            ],
          ),
          if (config.pickFaceBottom) BottomPick(),
        ],
      ),
    );
  }
}

class TopPick extends StatelessWidget {
  const TopPick({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 20,
      width: 20,
    );
  }
}

class BottomPick extends StatelessWidget {
  const BottomPick({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: Colors.red,
      height: 20,
      width: 20,
    );
  }
}

class OnboardingConfig {
  final CrossAxisAlignment align;
  final bool pickFaceBottom;
  final String message;
  const OnboardingConfig({
    @required this.align,
    @required this.pickFaceBottom,
    this.message = 'abacaba?',
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OnboardingConfig &&
        o.align == align &&
        o.pickFaceBottom == pickFaceBottom &&
        o.message == message;
  }

  @override
  int get hashCode =>
      align.hashCode ^ pickFaceBottom.hashCode ^ message.hashCode;

  @override
  String toString() =>
      'OnboardingConfig(align: $align, pickFaceBottom: $pickFaceBottom, message: $message)';
}
