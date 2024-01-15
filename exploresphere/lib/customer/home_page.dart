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
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';





class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isAppBarOpen = false;

  List<Place> places = [];

  String placeName = '';
  String description = '';
  String _image = '';
  String special = '';
  List<String> mostVisitedPlaces = [];
  String funFact = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // void loadData() async {
  //   final url = Uri.https(firebaseUrl, 'place.json');

  //   try {
  //     final response = await http.get(url);
  //     List<Place> dummy = [];
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       Map<String, dynamic> myData = json.decode(response.body);
  //       await Future.wait(myData.entries.map((e) async {
  //         List<dynamic> mostVisitedPlacesNew = e.value['mostVisitedPlaces'];
  //         List<String> convertedList =
  //             mostVisitedPlacesNew.map((place) => place.toString()).toList();
  //         print('#Debug admin_home_page.dart => key ${e.key}');

  //         // Download the image from the URL
  //         final imageResponse = await http.get(Uri.parse(e.value['imagePath']));
  //         final imagePath = await saveImage(imageResponse.bodyBytes);

  //         dummy.add(Place(
  //           placeId: e.key,
  //           placeName: e.value['placeName'],
  //           description: e.value['description'],
  //           imagePath: e.value['imagePath'],
  //           special: e.value['special'],
  //           mostVisitedPlaces: convertedList,
  //           funFact: e.value['funFact'],
  //         ));
  //       }).toList());

  //       setState(() {
  //         places = dummy;
  //       });
  //       print('#Debug admin_home_page.dart => places length ${places.length}');
  //     } else {
  //       print('#Debug admin_home_page.dart => Failed to get the data');
  //     }
  //   } catch (error) {
  //     print('#Debug admin_home_page.dart => error = $error');
  //   }
  // }

  //   Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = pickedImage.path;
  //     });
  //   } else {
  //     // Handle the case where the user canceled or encountered an error while picking an image.
  //     // You might want to show a message or perform some other action.
  //     print('Image picking canceled or failed.');
  //   }
  // }

  Future<String> saveImage(List<int> imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final _image =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    await File(_image).writeAsBytes(imageBytes);
    return _image;
  }

      void loadData() async {
    final url = Uri.https(firebaseUrl, 'place.json');

    try {
      final response = await http.get(url);
      List<Place> dummy = [];
      if (response.statusCode == 200) {
        // print(response.body);
        Map<String, dynamic> myData = json.decode(response.body);
        myData.entries.map((e) {
          print(e);
          List<dynamic> mostVisitedPlacesNew = e.value['mostVisitedPlaces'];
          List<String> convertedList =
              mostVisitedPlacesNew.map((place) => place.toString()).toList();
          print('#Debug admin_home_page.dart => key ${e.key}');
          dummy.add(Place(
              placeId: e.key,
              placeName: e.value['placeName'],
              description: e.value['description'],
              imagePath: e.value['imagePath'],
              special: e.value['special'],
              mostVisitedPlaces: convertedList,
              funFact: e.value['funFact']));
        }).toList();

        setState(() {
          places = dummy;
        });
        print('#Debug admin_home_page.dart => plces L ${places.length}');
      } else {
        print('#Debug admin_home_page.dart => Faild to get the data');
      }
    } catch (error) {
      print('#Debug admin_home_page.dart => error = $error');
    }
  }

  //     void loadData() async {
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

    Future<List<Place>> _parseData(Map<String, dynamic> myData) async { //satu
    List<Place> dummy = [];

    await Future.wait(myData.entries.map((e) async {
      List<dynamic> mostVisitedPlacesNew = e.value['mostVisitedPlaces'];
      List<String> convertedList =
          mostVisitedPlacesNew.map((place) => place.toString()).toList();
      print('#Debug admin_home_page.dart => key ${e.key}');

      String _image = '';

      final imageResponse = await http.get(Uri.parse(e.value['imagePath']));
      _image = await saveImage(imageResponse.bodyBytes);

      dummy.add(Place(
        placeId: e.key,
        placeName: e.value['placeName'],
        description: e.value['description'],
        imagePath: _image,
        special: e.value['special'],
        mostVisitedPlaces: convertedList,
        funFact: e.value['funFact'],
      ));
    }).toList());

    return dummy;
  }

  Future<void> _savePlaceToFirebase() async {

    if (_image != null){
      // List<int> imageBytes = await _image.readAsBytes();
      //  String base64Image = base64Encode(imageBytes);
    
    /**
     * if (placeName.isNotEmpty) {
                    Place newPlace = Place(
                      placeName: placeName,
                      description: description,
                      imagePath: imagePath,
                      special: special,
                      mostVisitedPlaces: mostVisitedPlaces,
                      funFact: funFact,
                    );
                    _savePlaceToFirebase(newPlace);
                    Navigator.pop(
                        context, newPlace); // Send the newPlace object back
                  } else {
                    // Show an error message or prompt the user to enter a valid place name
                  }
     */
    final url = Uri.https(
      firebaseUrl,
      'place.json',
    ); // Update with your Firebase DB URL

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'placeName': placeName,
          'description': description,
          'imagePath': _image,
          'special': special,
          'mostVisitedPlaces': mostVisitedPlaces,
          'funFact': funFact,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> myKey = json.decode(response.body);
        if (placeName.isNotEmpty) {
          Place newPlace = Place(
            placeId: myKey['name'],
            placeName: placeName,
            description: description,
            imagePath: _image,
            special: special,
            mostVisitedPlaces: mostVisitedPlaces,
            funFact: funFact,
          );
          Navigator.pop(context, newPlace); // Send the newPlace object back
        } else {
          // Show an error message or prompt the user to enter a valid place name
        }
      } else {
        // Handle error if the request was not successful
        print('Failed to add place: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle any exceptions that occurred during the HTTP request
      print('Failed to add place: $error');
    }
    }
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
                    builder: (context) => HomePage(user: widget.user),
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
                    builder: (context) => ProfilePage(user: widget.user,),
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
                    builder: (context) => QnaCustomerPage(user: widget.user),
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
              user: widget.user,
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
    File(place.imagePath),
     // Assuming place.imagePath is a URL
    width: 100,
    height: 100,
    fit: BoxFit.cover,
  ),
  // child: Placeholder(),
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
