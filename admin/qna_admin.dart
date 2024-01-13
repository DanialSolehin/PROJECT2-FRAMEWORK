import 'package:exploresphere/admin/admin_home_page.dart';
import 'package:exploresphere/admin/feedback_admin_page.dart';
import 'package:exploresphere/models/logout.dart';
import 'package:flutter/material.dart';
import 'package:exploresphere/models/question_answer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exploresphere/models/place.dart';

class AdminQnaPage extends StatefulWidget {
  final List<QuestionAnswer> questList;
  final Function(int, String) onAnswerSubmitted;

  AdminQnaPage({required this.questList, required this.onAnswerSubmitted});

  @override
  _AdminQnaPageState createState() => _AdminQnaPageState();
}

class _AdminQnaPageState extends State<AdminQnaPage> {
  final TextEditingController answerController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAppBarOpen = false;
  List<QuestionAnswer> quesList = [];

  bool isEditing = false;
  int editingIndex = -1; // Add this line

  void addAnswer(int index) async {
    final url = Uri.https(firebaseUrl, 'answers.json');
    final response = await http.post(
      url,
      body: json.encode({
        'questionId': quesList[index].id,
        'answer': answerController.text,
      }),
    );

    if (response.statusCode == 200) {
      loadData();
      loadAnswer(); // Refresh the question list after adding a new answer
    } else {
      print('Failed to add answer: ${response.reasonPhrase}');
    }

    setState(() {
      answerController.clear();
    });
  }

  // void editAnswer(int index) {
  //   setState(() {
  //     isEditing = true;
  //     editingIndex = index;
  //     answerController.text = quesList[index].answer ?? '';
  //   });
  // }

  // void updateAnswer() async {
  //   final url = Uri.https(firebaseUrl, 'answers/${quesList[editingIndex].id}.json');
  //   await http.put(
  //     url,
  //     body: json.encode({
  //       'answer': answerController.text,
  //     }),
  //   );

  //   setState(() {
  //     quesList[editingIndex].updateAnswer(answerController.text);
  //     isEditing = false;
  //     editingIndex = -1;
  //     answerController.clear();
  //   });
  // }

  // void deleteAnswer(int index) async {
  //   final url = Uri.https(firebaseUrl, 'answers/${quesList[index].id}.json');
  //   await http.delete(url);

  //   setState(() {
  //     quesList[index].answer = '';
  //   });
  // }

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
            answer: e.value['answers'] ?? '',
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
        myData.entries.map((e) {
          QuestionAnswer question =
              quesList.firstWhere((q) => q.id == e.value['questionId']);
          question.answer = e.value['answer'] ?? '';
        });
      } else {
        print('Failed to get answer');
      }
    } catch (error) {
      print('Error loading answer: $error');
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData();
    loadAnswer();
  }

  Widget _buildAnswerList(
      List<QuestionAnswer> quesList, List<QuestionAnswer> answerList) {
    return ListView.builder(
      itemCount: quesList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              quesList[index].question,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: isEditing && editingIndex == index
                ? Form(
                    child: TextFormField(
                      controller: answerController,
                      decoration: InputDecoration(labelText: 'Enter Answer'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an answer';
                        }
                        return null;
                      },
                    ),
                  )
                : Text(
                    answerList[index].answer ?? 'Admin has not answered yet'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addOrUpdateAnswer(index),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editAnswer(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteAnswer(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Qna Admin'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // loadData();
              loadAnswer();
              toggleEditing();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AdminHomePage()), // Navigate to HomePage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('QnA'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminQnaPage(
                      questList: quesList,
                      onAnswerSubmitted: (int index, String answers) {},
                    ),
                  ), // Navigate to HomePage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('FeedBack'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: quesList.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    quesList[index].question,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: isEditing && editingIndex == index
                      ? Form(
                          child: TextFormField(
                            controller: answerController,
                            decoration:
                                InputDecoration(labelText: 'Enter Answer'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an answer';
                              }
                              return null;
                            },
                          ),
                        )
                      : Text(quesList[index].answer ??
                          'Admin has not answered yet'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _addOrUpdateAnswer(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editAnswer(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteAnswer(index),
                      ),
                    ],
                  ),
                ),
              );
              // return Card(
              //   margin: EdgeInsets.symmetric(vertical: 8.0),
              //   child: ListTile(
              //     title: Text(
              //       quesList[index].question,
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //     subtitle: Text(
              //       quesList[index].answer ?? 'Admin has not answered yet',
              //     ),
              //     trailing: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         IconButton(
              //           icon: Icon(Icons.add),
              //           onPressed: () => _addOrUpdateAnswer(index),
              //         ),
              //         IconButton(
              //           icon: Icon(Icons.edit),
              //           onPressed: () => _editAnswer(index),
              //         ),
              //         IconButton(
              //           icon: Icon(Icons.delete),
              //           onPressed: () => _deleteAnswer(index),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isEditing ? () => _addOrUpdateAnswer : null,
        child: Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _editAnswer(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      answerController.text = quesList[index].answer ?? '';
    });
  }

  Future<void> _addOrUpdateAnswer(int index) async {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        await _updateAnswer(index);
      } else {
        await _addAnswer(index);
      }

      setState(() {
        isEditing = false;
        editingIndex = -1;
        answerController.clear();
      });
    }
  }

  Future<void> _addAnswer(int index) async {
    final url = Uri.https(firebaseUrl, 'answers.json');
    final response = await http.post(
      url,
      body: json.encode({
        'questionId': quesList[index].id,
        'answers': answerController.text,
      }),
    );

    if (response.statusCode == 200) {
      loadData();
      loadAnswer();
    } else {
      print('Failed to add answer: ${response.reasonPhrase}');
    }
  }

  Future<void> _updateAnswer(int index) async {
    final url = Uri.https(firebaseUrl, 'answers/${quesList[index].id}.json');
    await http.put(
      url,
      body: json.encode({
        'answers': answerController.text,
      }),
    );

    setState(() {
      quesList[index].updateAnswer(answerController.text);
    });
  }

  void _deleteAnswer(int index) async {
    final url = Uri.https(firebaseUrl, 'answers/${quesList[index].id}.json');
    await http.delete(url);

    setState(() {
      quesList[index].answer = '';
    });
  }
}
