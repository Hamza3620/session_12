import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FadeTransitionHook extends Hook<Animation<double>> {
  final AnimationController animationController;
  const FadeTransitionHook(this.animationController);
  @override
  HookState<Animation<double>, FadeTransitionHook> createState() =>
      _FadeTransitionHookState();
}

class _FadeTransitionHookState
    extends HookState<Animation<double>, FadeTransitionHook> {
  final _fadeTransition = useAnimationController(duration: const Duration());

  @override
  void initHook() {
    super.initHook();
    hook.animationController.addListener(() {
      if (hook.animationController.isCompleted) {
        _fadeTransition.forward();
      }
    });
  }

  @override
  Animation<double> build(BuildContext context) {
    return _fadeTransition;
  }

  @override
  void dispose() {
    _fadeTransition.dispose();
    super.dispose();
  }
}

Animation<double> useFadeTransition(AnimationController animationController) {
  return use(FadeTransitionHook(animationController));
}
