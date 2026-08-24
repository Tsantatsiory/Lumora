import 'package:flutter/material.dart';
import '../models/lesson_models.dart';
import '../theme.dart';
import '../widgets/activities/flashcard_view.dart';
import '../widgets/activities/multiple_choice_view.dart';
import '../widgets/activities/fill_blank_view.dart';
import '../widgets/activities/true_false_view.dart';
import '../widgets/activities/order_sequence_view.dart';

class LessonSessionScreen extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onFinished;

  const LessonSessionScreen({
    super.key,
    required this.lesson,
    required this.onFinished,
  });

  @override
  State<LessonSessionScreen> createState() => _LessonSessionScreenState();
}

class _LessonSessionScreenState extends State<LessonSessionScreen> {
  int currentActivityIndex = 0;
  int correctCount = 0;
  bool isCompleted = false;

  // State for current exercise
  bool hasSubmitted = false;
  bool? isAnswerCorrect;
  String currentFeedbackExplanation = '';

  // Intermediary inputs
  int? mcqSelectedIndex;
  String? fillBlankSelectedWord;
  bool? trueFalseSelected;
  List<String> orderSequenceList = [];

  Activity get currentActivity => widget.lesson.activities[currentActivityIndex];
  int get totalActivities => widget.lesson.activities.length;
  double get progress => (currentActivityIndex + (hasSubmitted ? 1 : 0)) / totalActivities;

  void _resetCurrentInputs() {
    hasSubmitted = false;
    isAnswerCorrect = null;
    currentFeedbackExplanation = '';
    mcqSelectedIndex = null;
    fillBlankSelectedWord = null;
    trueFalseSelected = null;
    if (currentActivityIndex < widget.lesson.activities.length &&
        widget.lesson.activities[currentActivityIndex].type == ActivityType.orderSequence) {
      final act = widget.lesson.activities[currentActivityIndex] as OrderSequenceActivity;
      orderSequenceList = List<String>.from(act.correctSequence);
    } else {
      orderSequenceList = [];
    }
  }

  bool _isInputValid() {
    switch (currentActivity.type) {
      case ActivityType.flashcard:
        return true;
      case ActivityType.multipleChoice:
        return mcqSelectedIndex != null;
      case ActivityType.fillInBlank:
        return fillBlankSelectedWord != null;
      case ActivityType.trueFalse:
        return trueFalseSelected != null;
      case ActivityType.orderSequence:
        return true;
    }
  }

  void _checkAnswer() {
    if (hasSubmitted) return;

    bool correct = false;
    String explanation = '';

    switch (currentActivity.type) {
      case ActivityType.flashcard:
        correct = true;
        final act = currentActivity as FlashcardActivity;
        explanation = act.note ?? 'Excellente mémorisation !';
        break;

      case ActivityType.multipleChoice:
        final act = currentActivity as MultipleChoiceActivity;
        correct = mcqSelectedIndex == act.correctIndex;
        explanation = act.explanation;
        break;

      case ActivityType.fillInBlank:
        final act = currentActivity as FillInBlankActivity;
        correct = fillBlankSelectedWord?.trim().toLowerCase() == act.correctWord.trim().toLowerCase();
        explanation = act.explanation;
        break;

      case ActivityType.trueFalse:
        final act = currentActivity as TrueFalseActivity;
        correct = trueFalseSelected == act.isTrue;
        explanation = act.explanation;
        break;

      case ActivityType.orderSequence:
        final act = currentActivity as OrderSequenceActivity;
        final seq = orderSequenceList.isNotEmpty ? orderSequenceList : act.correctSequence;
        correct = seq.join('__') == act.correctSequence.join('__');
        explanation = act.explanation;
        break;
    }

    setState(() {
      hasSubmitted = true;
      isAnswerCorrect = correct;
      currentFeedbackExplanation = explanation;
      if (correct) {
        correctCount++;
      }
    });
  }

  void _nextActivity() {
    if (currentActivityIndex + 1 < totalActivities) {
      setState(() {
        currentActivityIndex++;
        _resetCurrentInputs();
      });
    } else {
      setState(() {
        isCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return _buildCompletionView();
    }

    final canCheck = _isInputValid();

    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Exit button & Progress Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _confirmExit(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: AppBorders.neo(width: 1.8),
                        boxShadow: AppShadows.neo(offset: 1.8),
                      ),
                      child: const Icon(Icons.close_rounded, size: 20, color: AppColors.text),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.neoBorder, width: 1.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 300),
                          alignment: Alignment.centerLeft,
                          widthFactor: progress.clamp(0.05, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.lime,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: AppBorders.neo(width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded, size: 14, color: AppColors.amber),
                        Text(
                          '+${widget.lesson.xpReward}',
                          style: body(11, weight: FontWeight.w900, color: AppColors.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Activity Content with Illustration Banner (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Illustration Image Header for this activity/lesson
                    if (currentActivity.illustrationImage != null || widget.lesson.coverImage != null) ...[
                      _buildIllustrationHeader(
                        currentActivity.illustrationImage ?? widget.lesson.coverImage!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Exercise Content
                    _buildCurrentActivityWidget(),
                  ],
                ),
              ),
            ),

            // Bottom Feedback / Validation Bar
            _buildBottomActionBar(canCheck),
          ],
        ),
      ),
    );
  }

  /// Illustration Banner Container
  Widget _buildIllustrationHeader(String imagePath) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: 2.2),
        boxShadow: AppShadows.neo(offset: 3.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card - 2.2),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.bannerBg,
            alignment: Alignment.center,
            child: const Icon(Icons.menu_book_rounded, size: 48, color: AppColors.surface),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentActivityWidget() {
    switch (currentActivity.type) {
      case ActivityType.flashcard:
        return FlashcardView(
          key: ValueKey(currentActivity.id),
          activity: currentActivity as FlashcardActivity,
        );

      case ActivityType.multipleChoice:
        return MultipleChoiceView(
          key: ValueKey(currentActivity.id),
          activity: currentActivity as MultipleChoiceActivity,
          selectedIndex: mcqSelectedIndex,
          hasSubmitted: hasSubmitted,
          onSelect: (index) => setState(() => mcqSelectedIndex = index),
        );

      case ActivityType.fillInBlank:
        return FillBlankView(
          key: ValueKey(currentActivity.id),
          activity: currentActivity as FillInBlankActivity,
          selectedWord: fillBlankSelectedWord,
          hasSubmitted: hasSubmitted,
          onSelectWord: (word) => setState(() => fillBlankSelectedWord = word),
          onClearWord: () => setState(() => fillBlankSelectedWord = null),
        );

      case ActivityType.trueFalse:
        return TrueFalseView(
          key: ValueKey(currentActivity.id),
          activity: currentActivity as TrueFalseActivity,
          selectedAnswer: trueFalseSelected,
          hasSubmitted: hasSubmitted,
          onSelect: (answer) => setState(() => trueFalseSelected = answer),
        );

      case ActivityType.orderSequence:
        return OrderSequenceView(
          key: ValueKey(currentActivity.id),
          activity: currentActivity as OrderSequenceActivity,
          hasSubmitted: hasSubmitted,
          onSequenceChanged: (seq) => orderSequenceList = seq,
        );
    }
  }

  Widget _buildBottomActionBar(bool canCheck) {
    if (hasSubmitted) {
      final isSuccess = isAnswerCorrect ?? true;

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: isSuccess ? AppColors.chipBg : const Color(0xFFFFE8E5),
          border: const Border(
            top: BorderSide(color: AppColors.neoBorder, width: 2.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSuccess ? AppColors.lime : AppColors.text,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_rounded : Icons.close_rounded,
                    color: AppColors.surface,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isSuccess ? 'Excellent !' : 'À revoir :',
                  style: heading(16, weight: FontWeight.w900, color: AppColors.text),
                ),
              ],
            ),
            if (currentFeedbackExplanation.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                currentFeedbackExplanation,
                style: body(12, color: AppColors.text, height: 1.4, weight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 14),
            InkWell(
              onTap: _nextActivity,
              borderRadius: BorderRadius.circular(AppRadius.button),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSuccess ? AppColors.lime : AppColors.text,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: AppBorders.neo(width: 2.2),
                  boxShadow: AppShadows.neo(offset: 3.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentActivityIndex + 1 < totalActivities ? 'Continuer' : 'Terminer la session',
                      style: body(14, weight: FontWeight.w900, color: AppColors.surface),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, color: AppColors.surface, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Normal State before Submit
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.neoBorder, width: 2.5),
        ),
      ),
      child: InkWell(
        onTap: canCheck ? _checkAnswer : null,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: canCheck ? AppColors.lime : AppColors.bg,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: AppBorders.neo(width: 2.0),
            boxShadow: canCheck ? AppShadows.neo(offset: 3.0) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentActivity.type == ActivityType.flashcard ? 'J\'ai compris ▶' : 'Vérifier',
                style: body(
                  14,
                  weight: FontWeight.w900,
                  color: canCheck ? AppColors.surface : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Completion Victory View
  Widget _buildCompletionView() {
    final accuracy = totalActivities > 0 ? (correctCount / totalActivities * 100).round() : 100;

    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Icon Badge Victory
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.bannerBg,
                  shape: BoxShape.circle,
                  border: AppBorders.neo(width: 3.0),
                  boxShadow: AppShadows.neo(offset: 4.0),
                ),
                alignment: Alignment.center,
                child: const Text('🎉', style: TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 24),
              Text(
                'Session Complétée !',
                style: heading(26, weight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.lesson.title,
                style: body(14, color: AppColors.muted, weight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Summary Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryBox(
                      title: 'Gain d\'XP',
                      value: '+${widget.lesson.xpReward}',
                      icon: Icons.bolt_rounded,
                      iconColor: AppColors.amber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryBox(
                      title: 'Précision',
                      value: '$accuracy%',
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: AppColors.lime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryBox(
                      title: 'Série',
                      value: '35 jours',
                      icon: Icons.local_fire_department_rounded,
                      iconColor: AppColors.amber,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Continue Button
              InkWell(
                onTap: widget.onFinished,
                borderRadius: BorderRadius.circular(AppRadius.button),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    border: AppBorders.neo(width: 2.2),
                    boxShadow: AppShadows.neo(offset: 3.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Retour aux Leçons',
                        style: body(14.5, weight: FontWeight.w900, color: AppColors.surface),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.surface, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBox({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: 2.0),
        boxShadow: AppShadows.neo(offset: 2.5),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 6),
          Text(value, style: heading(15, weight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(
            title,
            style: body(10, color: AppColors.muted, weight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.neoBorder, width: 2.5),
        ),
        title: Text('Quitter la session ?', style: heading(18, weight: FontWeight.w900)),
        content: Text(
          'Votre progression dans cette session ne sera pas sauvegardée.',
          style: body(13, color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Rester', style: body(13, weight: FontWeight.w800, color: AppColors.text)),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(ctx);
              widget.onFinished();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bannerBg,
                borderRadius: BorderRadius.circular(8),
                border: AppBorders.neo(width: 1.8),
              ),
              child: Text(
                'Quitter',
                style: body(13, weight: FontWeight.w900, color: AppColors.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
