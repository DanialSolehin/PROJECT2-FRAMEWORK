import 'package:exploresphere/customer/customer_profile.dart';
import 'package:exploresphere/models/logout.dart';
import 'package:exploresphere/models/user.dart';
import 'package:flutter/material.dart';
import 'package:exploresphere/customer/home_page.dart';
import 'package:exploresphere/models/question_answer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exploresphere/models/place.dart';


class QnaCustomerPage extends StatefulWidget {
  final User user;

  const QnaCustomerPage({super.key, required this.user});
  @override
  _QnaCustomerPageState createState() => _QnaCustomerPageState();
}

class _QnaCustomerPageState extends State<QnaCustomerPage> {
  bool isAppBarOpen = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<QuestionAnswer> quesList = [];

  final TextEditingController questionController = TextEditingController();
  bool showAnswer = false;
  String selectedAnswer = '';

  bool isEditing = false;
  int editingIndex = -1;

  @override
  void initState() {
    super.initState();
    loadData();
    loadAnswer();
  }

  void loadData() async {
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

        setState(() {
          quesList = dummy;
          isEditing = false;
          editingIndex = -1;
        });
      } else {
        print('Failed to get answer');
      }
    } catch (error) {
      print('Error loading answer: $error');
    }
  }

  void loadAnswer() async {
    final url = Uri.https(firebaseUrl, 'answers.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> myData = json.decode(response.body);

        myData.entries.forEach((e) {
          String questionId = e.value['questionId'];

          // Find the corresponding question by ID
          QuestionAnswer question =
              quesList.firstWhere((q) => q.id == questionId);

          // Update the answer for the found question
          question.answer = e.value['answer'] ?? '';
        });
      } else {
        print('Failed to get answers');
      }
    } catch (error) {
      print('Error loading answers: $error');
    }
  }

  //   void loadAnswer() async {
  //   final url = Uri.https(firebaseUrl, 'answers.json');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       Map<String, dynamic> myData = json.decode(response.body);
  //       myData.entries.map((e) {
  //        QuestionAnswer question = quesList.firstWhere((q) => q.id == e.value['questionId']);
  //         question.answer = e.value['answer'] ?? '';
  //       });
  //     } else {
  //       print('Failed to get answer');
  //     }
  //   } catch (error) {
  //     print('Error loading answer: $error');
  //   }
  // }

  void addQuestion() async {
    final url = Uri.https(firebaseUrl, 'ques.json');
    final response = await http.post(
      url,
      body: json.encode({
        'question': questionController.text,
        'answer': '', // You can set an initial answer or leave it empty
      }),
    );

    if (response.statusCode == 200) {
      loadData();
      loadAnswer(); // Refresh the question list after adding a new question
    } else {
      print('Failed to add question: ${response.reasonPhrase}');
    }

    setState(() {
      questionController.clear();
    });
  }

  void editQuestion(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      questionController.text = quesList[index].question;
    });
  }

  void updateQuestion() async {
    final url = Uri.https(firebaseUrl, 'ques.json');
    await http.put(
      url,
      body: json.encode({
        'question': questionController.text,
      }),
    );

    setState(() {
      quesList[editingIndex].updateQuestion(questionController.text);
      isEditing = false;
      editingIndex = -1;
      questionController.clear();
    });
  }

  void deleteQuestion(String question, int index) async {
    final url = Uri.https(firebaseUrl, 'ques.json');
    await http.delete(url);

    setState(() {
      quesList.removeAt(index);
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Q&A Page'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(user: widget.user,)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user,)),
                ); // Close drawer
                // Add navigation code to Profile page
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Q&A'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QnaCustomerPage(user: widget.user,)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                logout(context);
              },
            ),
            // Add more list items as needed
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildQuestionInput(),
                SizedBox(height: 20),
                Expanded(child: _buildQUESTList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: questionController,
              decoration: InputDecoration(
                hintText: 'Enter your question',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: isEditing ? updateQuestion : addQuestion,
            child: Text(isEditing ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildQUESTList() {
    return ListView.builder(
      itemCount: quesList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  quesList[index].question,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => editQuestion(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteQuestion(quesList[index].toString(), index),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    if (selectedAnswer == quesList[index].answer &&
                        showAnswer) {
                      showAnswer = false;
                      selectedAnswer = '';
                    } else {
                      showAnswer = true;
                      selectedAnswer = quesList[index].answer;
                    }
                  });
                },
                onLongPress: () => editQuestion(index),
              ),
              Visibility(
                visible: showAnswer && selectedAnswer == quesList[index].answer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    quesList[index].answer,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//    Widget _buildQUESTList() {
//   return ListView.builder(
//     itemCount: quesList.length,
//     itemBuilder: (context, index) {
//       return Card(
//         margin: EdgeInsets.symmetric(vertical: 8.0),
//         child: ListTile(
//           title: Text(
//             quesList[index].question,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Visibility(
//             visible: showAnswer && selectedAnswer == quesList[index].answer,
//             child: Text(quesList[index].answer),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () => editQuestion(index),
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: () => deleteQuestion(index),
//               ),
//             ],
//           ),
//           onTap: () {
//             setState(() {
//               if (selectedAnswer == quesList[index].answer && showAnswer) {
//                 showAnswer = false;
//                 selectedAnswer = '';
//               } else {
//                 showAnswer = true;
//                 selectedAnswer = quesList[index].answer;
//               }
//             });
//           },
//           onLongPress: () => editQuestion(index),
//         ),
//       );
//     },
//   );
// }
}
