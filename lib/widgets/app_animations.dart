import 'package:flutter/material.dart';

/// Premium, dependency-free motion used throughout Kisan Queue.
///
/// Page entrances are intentionally smooth rather than flashy:
/// fade + upward slide + subtle scale over ~1 second.
/// Taps use a quick scale response so actions feel tactile without
/// delaying the actual callback.
class AnimatedPage extends StatefulWidget {
  const AnimatedPage({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 950),
  });

  final Widget child;
  final Duration duration;

  @override
  State<AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    _scale = Tween<double>(
      begin: 0.975,
      end: 1,
    ).animate(curve);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.035),
      end: Offset.zero,
    ).animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}

/// A tactile press animation for custom cards/tiles.
/// The callback runs immediately on release; the animation never makes
/// navigation feel slow.
class AnimatedTap extends StatefulWidget {
  const AnimatedTap({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  State<AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted) {
      setState(() => _pressed = value);
    }
  }

  void _release() {
    _setPressed(false);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _release(),
        child: AnimatedScale(
          scale: _pressed ? 0.965 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            opacity: _pressed ? 0.88 : 1,
            duration: const Duration(milliseconds: 180),
            child: ClipRRect(
              borderRadius:
                  widget.borderRadius ?? BorderRadius.zero,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Route transition for full-screen navigation.
/// Gives every push/pop a consistent premium motion language.
class PremiumPageRoute<T> extends PageRouteBuilder<T> {
  PremiumPageRoute({
    required WidgetBuilder builder,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.035),
                  end: Offset.zero,
                ).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.985,
                    end: 1,
                  ).animate(curved),
                  child: child,
                ),
              ),
            );
          },
        );
}
