enum ActivityType {
  flashcard,
  multipleChoice,
  fillInBlank,
  trueFalse,
  orderSequence,
}

abstract class Activity {
  final String id;
  final ActivityType type;
  final String title;
  final String? contextVerse;
  final String? illustrationImage;

  const Activity({
    required this.id,
    required this.type,
    required this.title,
    this.contextVerse,
    this.illustrationImage,
  });

  Map<String, dynamic> toJson();
}

/// 1. Flashcard / Mémorisation
class FlashcardActivity extends Activity {
  final String frontText;
  final String backText;
  final String? note;

  const FlashcardActivity({
    required super.id,
    required super.title,
    super.contextVerse,
    super.illustrationImage,
    required this.frontText,
    required this.backText,
    this.note,
  }) : super(type: ActivityType.flashcard);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'flashcard',
        'title': title,
        'contextVerse': contextVerse,
        'illustrationImage': illustrationImage,
        'frontText': frontText,
        'backText': backText,
        'note': note,
      };

  factory FlashcardActivity.fromJson(Map<String, dynamic> json) {
    return FlashcardActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      contextVerse: json['contextVerse'] as String?,
      illustrationImage: json['illustrationImage'] as String?,
      frontText: json['frontText'] as String,
      backText: json['backText'] as String,
      note: json['note'] as String?,
    );
  }
}

/// 2. QCM / Multiple Choice
class MultipleChoiceActivity extends Activity {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const MultipleChoiceActivity({
    required super.id,
    required super.title,
    super.contextVerse,
    super.illustrationImage,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  }) : super(type: ActivityType.multipleChoice);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'multipleChoice',
        'title': title,
        'contextVerse': contextVerse,
        'illustrationImage': illustrationImage,
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
      };

  factory MultipleChoiceActivity.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      contextVerse: json['contextVerse'] as String?,
      illustrationImage: json['illustrationImage'] as String?,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }
}

/// 3. Phrase à trous / Fill in the Blank
class FillInBlankActivity extends Activity {
  final String prompt;
  final String fullText;
  final String correctWord;
  final List<String> wordBank;
  final String explanation;

  const FillInBlankActivity({
    required super.id,
    required super.title,
    super.contextVerse,
    super.illustrationImage,
    required this.prompt,
    required this.fullText,
    required this.correctWord,
    required this.wordBank,
    required this.explanation,
  }) : super(type: ActivityType.fillInBlank);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'fillInBlank',
        'title': title,
        'contextVerse': contextVerse,
        'illustrationImage': illustrationImage,
        'prompt': prompt,
        'fullText': fullText,
        'correctWord': correctWord,
        'wordBank': wordBank,
        'explanation': explanation,
      };

  factory FillInBlankActivity.fromJson(Map<String, dynamic> json) {
    return FillInBlankActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      contextVerse: json['contextVerse'] as String?,
      illustrationImage: json['illustrationImage'] as String?,
      prompt: json['prompt'] as String,
      fullText: json['fullText'] as String,
      correctWord: json['correctWord'] as String,
      wordBank: List<String>.from(json['wordBank'] as List),
      explanation: json['explanation'] as String,
    );
  }
}

/// 4. Vrai ou Faux / True or False
class TrueFalseActivity extends Activity {
  final String statement;
  final bool isTrue;
  final String explanation;

  const TrueFalseActivity({
    required super.id,
    required super.title,
    super.contextVerse,
    super.illustrationImage,
    required this.statement,
    required this.isTrue,
    required this.explanation,
  }) : super(type: ActivityType.trueFalse);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'trueFalse',
        'title': title,
        'contextVerse': contextVerse,
        'illustrationImage': illustrationImage,
        'statement': statement,
        'isTrue': isTrue,
        'explanation': explanation,
      };

  factory TrueFalseActivity.fromJson(Map<String, dynamic> json) {
    return TrueFalseActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      contextVerse: json['contextVerse'] as String?,
      illustrationImage: json['illustrationImage'] as String?,
      statement: json['statement'] as String,
      isTrue: json['isTrue'] as bool,
      explanation: json['explanation'] as String,
    );
  }
}

/// 5. Remettre dans l'ordre / Order Sequence
class OrderSequenceActivity extends Activity {
  final String instruction;
  final List<String> correctSequence;
  final String explanation;

  const OrderSequenceActivity({
    required super.id,
    required super.title,
    super.contextVerse,
    super.illustrationImage,
    required this.instruction,
    required this.correctSequence,
    required this.explanation,
  }) : super(type: ActivityType.orderSequence);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'orderSequence',
        'title': title,
        'contextVerse': contextVerse,
        'illustrationImage': illustrationImage,
        'instruction': instruction,
        'correctSequence': correctSequence,
        'explanation': explanation,
      };

  factory OrderSequenceActivity.fromJson(Map<String, dynamic> json) {
    return OrderSequenceActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      contextVerse: json['contextVerse'] as String?,
      illustrationImage: json['illustrationImage'] as String?,
      instruction: json['instruction'] as String,
      correctSequence: List<String>.from(json['correctSequence'] as List),
      explanation: json['explanation'] as String,
    );
  }
}

/// Modèle global d'une Leçon
class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String moduleTitle;
  final int xpReward;
  final int estimatedMinutes;
  final String? coverImage;
  final List<Activity> activities;

  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.moduleTitle,
    required this.xpReward,
    required this.estimatedMinutes,
    this.coverImage,
    required this.activities,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'category': category,
        'moduleTitle': moduleTitle,
        'xpReward': xpReward,
        'estimatedMinutes': estimatedMinutes,
        'coverImage': coverImage,
        'activities': activities.map((a) => a.toJson()).toList(),
      };

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final actsList = json['activities'] as List;
    final activities = actsList.map<Activity>((a) {
      final map = a as Map<String, dynamic>;
      final type = map['type'] as String;
      switch (type) {
        case 'flashcard':
          return FlashcardActivity.fromJson(map);
        case 'multipleChoice':
          return MultipleChoiceActivity.fromJson(map);
        case 'fillInBlank':
          return FillInBlankActivity.fromJson(map);
        case 'trueFalse':
          return TrueFalseActivity.fromJson(map);
        case 'orderSequence':
          return OrderSequenceActivity.fromJson(map);
        default:
          throw Exception('Type d\'activité inconnu : $type');
      }
    }).toList();

    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      category: json['category'] as String,
      moduleTitle: json['moduleTitle'] as String,
      xpReward: json['xpReward'] as int,
      estimatedMinutes: json['estimatedMinutes'] as int,
      coverImage: json['coverImage'] as String?,
      activities: activities,
    );
  }
}
