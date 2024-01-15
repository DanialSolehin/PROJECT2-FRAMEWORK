import 'package:exploresphere/admin/admin_home_page.dart';
import 'package:exploresphere/admin/qna_admin.dart';
import 'package:exploresphere/models/logout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exploresphere/models/place.dart';
import 'package:exploresphere/models/question_answer.dart';

class FeedbackModel {
  final String placeName;
  final double rating;

  FeedbackModel({required this.placeName, required this.rating});
}

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<FeedbackModel> feedbackData = [];
  List<QuestionAnswer> quesList = [];

  void loadFeedbackData() async {
    final url = Uri.https(firebaseUrl,
        'feedback.json'); // Replace with your feedback data endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        List<FeedbackModel> dummy = [];

        for (final entry in responseData.entries) {
          dummy.add(FeedbackModel(
            placeName: entry.value['placeName'],
            rating: entry.value['rating'].toDouble(),
          ));
        }

        setState(() {
          feedbackData = dummy;
        });

        print(
            '#Debug feedback_screen.dart => feedbackData length: ${feedbackData.length}');
      } else {
        print('#Debug feedback_screen.dart => Failed to get the data');
      }
    } catch (error) {
      print('#Debug feedback_screen.dart => error = $error');
    }
  }

  void _deleteFeedback(int index) async {
    final url = Uri.https(firebaseUrl,
        'feedback.json'); // Replace with your feedback data endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> myData = json.decode(response.body);

        // Get the key of the feedback entry to delete
        String keyToDelete = '';
        myData.forEach((key, value) {
          if (value['placeName'] == feedbackData[index].placeName &&
              value['rating'] == feedbackData[index].rating) {
            keyToDelete = key;
          }
        });

        // Check if a matching entry was found
        if (keyToDelete.isNotEmpty) {
          // Delete the entry from the database
          final deleteResponse = await http.delete(
            Uri.https(firebaseUrl,
                'feedback/$keyToDelete.json'), // Replace with your feedback entry endpoint
          );

          if (deleteResponse.statusCode == 200) {
            // If the deletion is successful, update the UI
            setState(() {
              feedbackData.removeAt(index);
            });
            print('Feedback deleted successfully');
          } else {
            print('Failed to delete feedback');
          }
        } else {
          print('No matching entry found to delete');
        }
      } else {
        print('Failed to get data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    loadFeedbackData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Add the logic to refresh feedback data here
              loadFeedbackData();
            },
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
                      onAnswerSubmitted: (int index, String answer) {},
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
            opacity: 0.4,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Feedback History',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: feedbackData.length,
                  itemBuilder: (context, index) {
                    final placeName = feedbackData[index].placeName;
                    final rating = feedbackData[index].rating;

                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _deleteFeedback(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            'Place: $placeName',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Rating: $rating',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
