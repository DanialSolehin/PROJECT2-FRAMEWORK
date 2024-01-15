import 'package:exploresphere/models/question_answer.dart';
import 'package:exploresphere/models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QnaDataProvider {
  List<QuestionAnswer> quesList = [];

  Future<void> loadQuesData() async {
    final url = Uri.https(firebaseUrl, 'ques.json');

    try {
      final response = await http.get(url);
      List<QuestionAnswer> dummy = [];
      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> myData = json.decode(response.body);
        myData.entries.map((e) {
          dummy.add(QuestionAnswer(
            id: e.key,
            question: e.value['question'],
            answer: e.value['answer'] ?? '',
          ));
        }).toList();

        quesList = dummy;
      } else {
        print('Failed to get questions');
      }
    } catch (error) {
      print('Error loading questions: $error');
    }
  }

  Future<void> loadAnswerData() async {
    final url = Uri.https(firebaseUrl, 'answers.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> myData = json.decode(response.body);
        myData.entries.forEach((e) {
          // Assuming each answer has a corresponding question ID
          QuestionAnswer question =
              quesList.firstWhere((q) => q.id == e.value['questionId']);
          question.answer = e.value['answers'] ?? '';
        });
      } else {
        print('Failed to get answers');
      }
    } catch (error) {
      print('Error loading answers: $error');
    }
  }

  // Add methods for adding, updating, and deleting questions and answers
}
