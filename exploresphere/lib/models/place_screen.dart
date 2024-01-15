import 'dart:io';

import 'package:exploresphere/customer/customer_profile.dart';
import 'package:exploresphere/customer/home_page.dart';
import 'package:exploresphere/models/user.dart';
import 'package:flutter/material.dart';
import 'package:exploresphere/models/place.dart';
import 'package:exploresphere/data/star_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceScreen extends StatefulWidget {
  final User user;
  final String placeId;
  final String placeName;
  final String description;
  String imagePath; 

  final String special;
  final List<String> mostVisitedPlaces;
  final String funFact;

  PlaceScreen({
    required this.user,
    required this.placeId,
    required this.placeName,
    required this.description,
    required this.imagePath,
    required this.special,
    required this.mostVisitedPlaces,
    required this.funFact,
  });

  @override
  _PlaceScreenState createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  bool _isLit = false;
  double _feedbackRating = 0;

  Future<void> _saveFeedbackToDatabase() async {
    final feedbackData = FeedbackData(
      placeName: widget.placeName, 
      rating: _feedbackRating,
    );

    final url = Uri.https(firebaseUrl, 'feedback.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(feedbackData.toMap()),
      );

      if (response.statusCode == 200) {
        print('Feedback saved successfully');
      } else {
        print('Failed to save feedback: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to save feedback: $error');
    }
  }

  void _setFeedback(double rating) {
    setState(() {
      _feedbackRating = rating;

      print('Feedback given: $_feedbackRating');
    });
  }

  void _toggleLight() {
    setState(() {
      _isLit = !_isLit;
      if (_isLit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.funFact),
            duration: Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(user: widget.user,)), 
                ); 
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.file(
                  File(widget.imagePath),
                  
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.lightbulb,
                      color: _isLit ? Colors.yellow : Colors.grey,
                      size: 40.0,
                    ),
                    onPressed: () {
                      _toggleLight();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'What\'s Special:',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.special,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.mostVisitedPlaces
                    .map(
                      (place) => Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  place,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Give Feedback:',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Material(
                          elevation: _feedbackRating >= index + 1 ? 5.0 : 0.0,
                          shape: CircleBorder(),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () {
                              _setFeedback(index + 1.toDouble());
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.star,
                                color: _feedbackRating >= index + 1
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        _saveFeedbackToDatabase(); 
                        Navigator.pop(context); 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(user: widget.user,)),
                        ); 
                      },
                      child: Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
