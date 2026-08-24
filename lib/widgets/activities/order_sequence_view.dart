import 'package:flutter/material.dart';
import '../../models/lesson_models.dart';
import '../../theme.dart';

class OrderSequenceView extends StatefulWidget {
  final OrderSequenceActivity activity;
  final bool hasSubmitted;
  final ValueChanged<List<String>> onSequenceChanged;

  const OrderSequenceView({
    super.key,
    required this.activity,
    required this.hasSubmitted,
    required this.onSequenceChanged,
  });

  @override
  State<OrderSequenceView> createState() => _OrderSequenceViewState();
}

class _OrderSequenceViewState extends State<OrderSequenceView> {
  late List<String> currentItems;

  @override
  void initState() {
    super.initState();
    // Shuffled version for the user to reorder
    currentItems = List<String>.from(widget.activity.correctSequence)..shuffle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onSequenceChanged(currentItems);
      }
    });
  }

  void _moveUp(int index) {
    if (widget.hasSubmitted || index <= 0) return;
    setState(() {
      final item = currentItems.removeAt(index);
      currentItems.insert(index - 1, item);
    });
    widget.onSequenceChanged(currentItems);
  }

  void _moveDown(int index) {
    if (widget.hasSubmitted || index >= currentItems.length - 1) return;
    setState(() {
      final item = currentItems.removeAt(index);
      currentItems.insert(index + 1, item);
    });
    widget.onSequenceChanged(currentItems);
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (widget.hasSubmitted) return;
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = currentItems.removeAt(oldIndex);
      currentItems.insert(newIndex, item);
    });
    widget.onSequenceChanged(currentItems);
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
          widget.activity.instruction,
          style: heading(19, weight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          'Organisez les étapes dans le bon ordre (glissez ou utilisez les flèches) :',
          style: body(12, color: AppColors.muted, weight: FontWeight.w600),
        ),
        const SizedBox(height: 18),

        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorder: _onReorder,
          itemCount: currentItems.length,
          itemBuilder: (context, i) {
            final item = currentItems[i];
            final isItemCorrect = i < widget.activity.correctSequence.length &&
                item == widget.activity.correctSequence[i];

            Color bgColor = AppColors.surface;
            if (widget.hasSubmitted) {
              bgColor = isItemCorrect ? AppColors.lime : const Color(0xFFFFDCD8);
            }

            return Container(
              key: ValueKey(item),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: AppBorders.neo(width: 2.0),
                boxShadow: AppShadows.neo(offset: 2.5),
              ),
              child: Row(
                children: [
                  // Rank number badge
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (widget.hasSubmitted && isItemCorrect)
                          ? AppColors.surface
                          : AppColors.bg,
                      shape: BoxShape.circle,
                      border: AppBorders.neo(width: 1.5),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: heading(12, weight: FontWeight.w900, color: AppColors.text),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text content
                  Expanded(
                    child: Text(
                      item,
                      style: body(
                        12.5,
                        weight: FontWeight.w700,
                        color: (widget.hasSubmitted && isItemCorrect)
                            ? AppColors.surface
                            : AppColors.text,
                      ),
                    ),
                  ),

                  // Controls: Up/Down buttons + Drag Handle
                  if (!widget.hasSubmitted) ...[
                    const SizedBox(width: 6),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: i > 0 ? () => _moveUp(i) : null,
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 20,
                            color: i > 0 ? AppColors.text : AppColors.muted.withValues(alpha: 0.3),
                          ),
                        ),
                        InkWell(
                          onTap: i < currentItems.length - 1 ? () => _moveDown(i) : null,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: i < currentItems.length - 1
                                ? AppColors.text
                                : AppColors.muted.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    ReorderableDragStartListener(
                      index: i,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.drag_indicator_rounded, color: AppColors.muted, size: 22),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
