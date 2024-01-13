import 'package:exploresphere/models/place.dart';
import 'package:exploresphere/customer/customer_profile.dart';
import 'package:exploresphere/customer/qna_customer.dart';
import 'package:exploresphere/models/logout.dart';
import 'package:exploresphere/models/user.dart';
import 'package:flutter/material.dart';
import 'package:exploresphere/models/place_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppBar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  User? user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isAppBarOpen = false;

  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final url = Uri.https(firebaseUrl, 'place.json');

    try {
      final response = await http.get(url);
      List<Place> dummy = [];
      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> myData = json.decode(response.body);
        await Future.wait(myData.entries.map((e) async {
          List<dynamic> mostVisitedPlacesNew = e.value['mostVisitedPlaces'];
          List<String> convertedList =
              mostVisitedPlacesNew.map((place) => place.toString()).toList();
          print('#Debug admin_home_page.dart => key ${e.key}');

          // Download the image from the URL
          final imageResponse = await http.get(Uri.parse(e.value['imagePath']));
          final imagePath = await saveImage(imageResponse.bodyBytes);

          dummy.add(Place(
            placeId: e.key,
            placeName: e.value['placeName'],
            description: e.value['description'],
            imagePath: imagePath,
            special: e.value['special'],
            mostVisitedPlaces: convertedList,
            funFact: e.value['funFact'],
          ));
        }).toList());

        setState(() {
          places = dummy;
        });
        print('#Debug admin_home_page.dart => places length ${places.length}');
      } else {
        print('#Debug admin_home_page.dart => Failed to get the data');
      }
    } catch (error) {
      print('#Debug admin_home_page.dart => error = $error');
    }
  }

  Future<String> saveImage(List<int> imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    await File(imagePath).writeAsBytes(imageBytes);
    return imagePath;
  }

  //   void loadData() async {
  //   final url = Uri.https(firebaseUrl, 'place.json');

  //   try {
  //     final response = await http.get(url);
  //     List<Place> dummy = [];
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       Map<String, dynamic> myData = json.decode(response.body);
  //       myData.entries.map((e) {
  //         List<dynamic> mostVisitedPlacesNew = e.value['mostVisitedPlaces'];
  //         List<String> convertedList =
  //             mostVisitedPlacesNew.map((place) => place.toString()).toList();
  //         print('#Debug admin_home_page.dart => key ${e.key}');
  //         dummy.add(Place(
  //             placeId: e.key,
  //             placeName: e.value['placeName'],
  //             description: e.value['description'],
  //             imagePath: e.value['imagePath'],
  //             special: e.value['special'],
  //             mostVisitedPlaces: convertedList,
  //             funFact: e.value['funFact']));
  //       }).toList();

  //       setState(() {
  //         places = dummy;
  //       });
  //       print('#Debug admin_home_page.dart => plces L ${places.length}');
  //     } else {
  //       print('#Debug admin_home_page.dart => Faild to get the data');
  //     }
  //   } catch (error) {
  //     print('#Debug admin_home_page.dart => error = $error');
  //   }
  // }

  // void loadData() async {
  //   final url = Uri.https(firebaseUrl, 'place.json');

  //   try {
  //     final response = await http.get(url);
  //     List<Place> dummy = [];
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       Map<String, dynamic> myData = json.decode(response.body);
  //       myData.entries.map((e) {
  //         List<dynamic> mostVisitedPlacesNew = e.value['mostVisitedPlaces'];
  //         List<String> convertedList =
  //             mostVisitedPlacesNew.map((place) => place.toString()).toList();
  //         print('#Debug admin_home_page.dart => key ${e.key}');
  //         dummy.add(Place(
  //             placeId: e.key,
  //             placeName: e.value['placeName'],
  //             description: e.value['description'],
  //             imagePath: e.value['imagePath'],
  //             special: e.value['special'],
  //             mostVisitedPlaces: convertedList,
  //             funFact: e.value['funFact']));
  //       }).toList();

  //       setState(() {
  //         places = dummy;
  //       });
  //       print('#Debug admin_home_page.dart => plces L ${places.length}');
  //     } else {
  //       print('#Debug admin_home_page.dart => Faild to get the data');
  //     }
  //   } catch (error) {
  //     print('#Debug admin_home_page.dart => error = $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Home Page'),
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
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
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
                    builder: (context) => QnaCustomerPage(),
                  ),
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
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            opacity: 0.4,
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          padding: EdgeInsets.all(20.0),
          itemCount: places.length,
          itemBuilder: (BuildContext context, int index) {
            return buildImageContainer(context, places[index]);
          },
        ),
      ),
    );
  }

  Widget buildImageContainer(BuildContext context, Place place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceScreen(
              placeId: place.placeId,
              placeName: place.placeName,
              description: place.description,
              imagePath: place.imagePath,
              special: place.special,
              mostVisitedPlaces: place.mostVisitedPlaces,
              funFact: place.funFact,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child: Image.file(
          place.imagePath, // Use the null-aware operator here
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: () {
    //     if (imagePath == 'images/image1.png') {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => JohorScreen()),
    //       );
    //     } else if (imagePath == 'images/ganu.jpg') {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => TerengganuScreen()),
    //       );
    //     } else if (imagePath == 'images/kawi.jpg') {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => KedahScreen()),
    //       );
    //     } else if (imagePath == 'images/makan.jpg') {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => KelantanScreen()),
    //       );
    //     } else if (imagePath == 'images/kinabalu.jpg') {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => SabahScreen()),
    //       );
    //     } else if (imagePath == 'images/roon.jpeg') {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => PahangScreen()),
    //       );
    //     }

    //   },

    //   child: Container(
    //     decoration: BoxDecoration(
    //       border: Border.all(
    //         color: Colors.black,
    //         width: 1.0,
    //       ),
    //     ),
    //     child: Image.asset(
    //       imagePath,
    //       width: 100,
    //       height: 100,
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    // );
  }
}
