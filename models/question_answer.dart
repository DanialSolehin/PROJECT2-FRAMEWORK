class QuestionAnswer {
  String id;
  String question;
  String answer;

  QuestionAnswer({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      id: json['id'] ??
          '', 
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  void updateQuestion(String newQuestion) {
    question = newQuestion;
  }

  void updateAnswer(String newAnswer) {
    answer = newAnswer;
  }
}

class Question {
  final String id;
  String answers;

  Question({required this.id, required this.answers});

  void updateAnswer(String newAnswer) {
    answers = newAnswer;
  }
}
