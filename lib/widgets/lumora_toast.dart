import 'package:flutter/material.dart';
import '../theme.dart';

/// Shows a small floating toast near the bottom of the screen,
/// matching the `.toast-message` element in the original design.
void showLumoraToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return _ToastWidget(
        message: message,
        onDone: () => entry.remove(),
      );
    },
  );

  overlay.insert(entry);
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDone;
  const _ToastWidget({required this.message, required this.onDone});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _offset = Tween<Offset>(begin: const Offset(0, .3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 100,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _offset,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface, // Changé: blanc
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.lime.withValues(alpha: 0.25)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withValues(alpha: 0.1), // Ombre legere de la palette
                    blurRadius: 35,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                widget.message,
                style: body(12.5, color: AppColors.text),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}