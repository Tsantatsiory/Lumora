import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/lesson_models.dart';
import '../../theme.dart';

class FlashcardView extends StatefulWidget {
  final FlashcardActivity activity;

  const FlashcardView({super.key, required this.activity});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> with SingleTickerProviderStateMixin {
  bool isFlipped = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => isFlipped = !isFlipped);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.activity.contextVerse != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              borderRadius: BorderRadius.circular(6),
              border: AppBorders.neo(width: 1.2),
            ),
            child: Text(
              widget.activity.contextVerse!,
              style: body(11, weight: FontWeight.w900, color: AppColors.lime),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Mémorisation & Réflexion',
          style: heading(20, weight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          'Touchez la carte pour révéler l\'enseignement biblique :',
          style: body(12, color: AppColors.muted, weight: FontWeight.w600),
        ),
        const SizedBox(height: 24),

        // Flip Card Animée
        Center(
          child: GestureDetector(
            onTap: _flip,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final angle = _animation.value * pi;
                final isUnder = angle > pi / 2;

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0015)
                    ..rotateY(angle),
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 220),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: isUnder ? AppColors.bannerBg : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: AppBorders.neo(width: 2.5),
                      boxShadow: AppShadows.neo(offset: 4.0),
                    ),
                    child: Transform(
                      transform: isUnder ? (Matrix4.identity()..rotateY(pi)) : Matrix4.identity(),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isUnder ? AppColors.surface : AppColors.chipBg,
                                  borderRadius: BorderRadius.circular(6),
                                  border: AppBorders.neo(width: 1.2),
                                ),
                                child: Text(
                                  isUnder ? 'EXPLICATION' : 'VERSET CLÉ',
                                  style: body(9, weight: FontWeight.w900, color: AppColors.text),
                                ),
                              ),
                              Icon(
                                isUnder ? Icons.auto_awesome_rounded : Icons.touch_app_rounded,
                                size: 20,
                                color: AppColors.text,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isUnder ? widget.activity.backText : widget.activity.frontText,
                            style: heading(
                              isUnder ? 15 : 18,
                              weight: FontWeight.w900,
                              color: isUnder ? AppColors.surface : AppColors.text,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.flip_rounded, size: 14, color: isUnder ? AppColors.surface : AppColors.muted),
                              const SizedBox(width: 4),
                              Text(
                                'Appuyez pour retourner',
                                style: body(
                                  10.5,
                                  weight: FontWeight.w700,
                                  color: isUnder ? AppColors.surface : AppColors.muted,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
