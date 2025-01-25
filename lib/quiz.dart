class Option {
  final int id;
  final String description;
  final bool isCorrect;

  Option({required this.id, required this.description, required this.isCorrect});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as int,
      description: json['description'] as String,
      isCorrect: json['is_correct'] as bool, // Assuming `is_correct` is a boolean
// Assuming 'true'/'false' as strings
    );
  }
}

class Question {
  final int id;
  final String description;
  final List<Option> options;
  final String readingMaterial;
  final PracticeMaterial practiceMaterial;
  final String detailedSolution;

  Question({
    required this.id,
    required this.description,
    required this.options,
    required this.readingMaterial,
    required this.practiceMaterial,
    required this.detailedSolution,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Option> options = (json['options'] as List)
        .map((optionJson) => Option.fromJson(optionJson))
        .toList();

    String readingMaterial = json['reading_material']['content'] ?? '';
    PracticeMaterial practiceMaterial = PracticeMaterial.fromJson(json['reading_material']['practice_material']);
    String detailedSolution = json['detailed_solution'] as String;

    return Question(
      id: json['id'] as int,
      description: json['description'] as String,
      options: options,
      readingMaterial: readingMaterial,
      practiceMaterial: practiceMaterial,
      detailedSolution: detailedSolution,
    );
  }
}

class PracticeMaterial {
  final List<String> content;
  final List<String> keywords;

  PracticeMaterial({required this.content, required this.keywords});

  factory PracticeMaterial.fromJson(Map<String, dynamic> json) {
    return PracticeMaterial(
      content: List<String>.from(json['content'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
    );
  }
}