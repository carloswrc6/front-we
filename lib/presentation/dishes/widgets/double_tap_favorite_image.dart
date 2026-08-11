import 'package:flutter/material.dart';

class FavoriteDoubleTapImage extends StatefulWidget {
  final Widget child;
  final VoidCallback onDoubleTap;

  const FavoriteDoubleTapImage({
    super.key,
    required this.child,
    required this.onDoubleTap,
  });

  @override
  State<FavoriteDoubleTapImage> createState() => _FavoriteDoubleTapImageState();
}

class _FavoriteDoubleTapImageState extends State<FavoriteDoubleTapImage>
    with TickerProviderStateMixin {
  Offset _tapPosition = Offset.zero;
  bool _showHeart = false;
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _rise;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _showHeart = false);
        }
      });
    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 65,
      ),
    ]).animate(_controller);
    _opacity = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_controller);
    _rise = Tween(begin: 0.0, end: -24.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _tapPosition = details.localPosition;
  }

  void _handleDoubleTap() {
    widget.onDoubleTap();
    setState(() => _showHeart = true);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (_showHeart)
            Positioned(
              left: _tapPosition.dx - 40,
              top: _tapPosition.dy - 40,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0, _rise.value),
                      child: Opacity(
                        opacity: _opacity.value,
                        child: Transform.scale(
                          scale: _scale.value,
                          child: const Icon(
                            Icons.favorite,
                            size: 80,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 24, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
