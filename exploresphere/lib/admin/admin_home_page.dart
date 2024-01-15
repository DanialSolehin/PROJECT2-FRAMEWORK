import 'package:exploresphere/admin/feedback_admin_page.dart';
import 'package:exploresphere/admin/qna_admin.dart';
import 'package:flutter/material.dart';
import 'package:exploresphere/models/place.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exploresphere/models/logout.dart';
import 'package:exploresphere/models/question_answer.dart';
import 'package:path_provider/path_provider.dart';





class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Place> places = [];
  List<QuestionAnswer> quesList = [];
  bool isAppBarOpen = false;
  bool isEditing = false;

  Future<String> saveImage(List<int> imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final _image =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    await File(_image).writeAsBytes(imageBytes);
    return _image;
  }

  // void loadData() async {
  //   try {
  //     final url = Uri.https(firebaseUrl, 'place.json');
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       Map<String, dynamic> myData = json.decode(response.body);

  //       List<Place> dummy = await _parseData(myData);

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

  Future<List<Place>> _parseData(Map<String, dynamic> myData) async {
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

//         // Declare imagePath here
//         String imagePath = '';

//         // Download the image from the URL
//         final imageResponse = await http.get(Uri.parse(e.value['imagePath']));
//         imagePath = await saveImage(imageResponse.bodyBytes);

//         dummy.add(Place(
//           placeId: e.key,
//           placeName: e.value['placeName'],
//           description: e.value['description'],
//           imagePath: imagePath,
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

    void loadData() async {
    final url = Uri.https(firebaseUrl, 'place.json');

    // try {
      final response = await http.get(url);
      List<Place> dummy = [];
      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> myData = json.decode(response.body);
        
        myData.entries.map((e) {
          print('#Debug admin_home_page.dart uwu => key ${e.toString()}');
          List<dynamic> mostVisitedPlacesNew = e.value['mostVisitedPlaces'];
          List<String> convertedList =
              mostVisitedPlacesNew.map((place) => place.toString()).toList();
             print(e.value['special']);

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
        print('ehe');
        print('#Debug admin_home_page.dart => plces L ${places.length}');
      } else {
        print('#Debug admin_home_page.dart => Faild to get the data');
      }
    // } catch (error) {
    //   print('#Debug admin_home_page.dart => error = $error');
    // }
  }

// void loadData() async {
//   final url = Uri.https(firebaseUrl, 'place.json');

//   try {
//     final response = await http.get(url);

//     // if you want to save your data in a list of the object you are using
//     List<Place> places = [];

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);

//       for (final entry in responseData.entries) {
//         Map<String, dynamic> data = entry.value;
//         List<dynamic> mostVisitedPlacesNew = data['mostVisitedPlaces'];
//         List<String> convertedList =
//             mostVisitedPlacesNew.map((place) => place.toString()).toList();

//         // Declare imagePath here
//         String imagePath = '';

//         // Download the image from the URL
//         final imageResponse = await http.get(Uri.parse(data['imagePath']));
//         imagePath = await saveImage(imageResponse.bodyBytes);

//         places.add(Place(
//           placeId: entry.key,
//           placeName: data['placeName'],
//           description: data['description'],
//           imagePath: imagePath,
//           special: data['special'],
//           mostVisitedPlaces: convertedList,
//           funFact: data['funFact'],
//         ));
//       }

//       setState(() {
//         // put your list here, and this will rebuild the screen and display your data
//         // I'm assuming you have a variable named 'places' to store your data
//         places = places;
//       });
//       print('#Debug admin_home_page.dart => places length ${places.length}');
//     } else {
//       print('#Debug admin_home_page.dart => Failed to get the data');
//     }
//   } catch (error) {
//     print('#Debug admin_home_page.dart => error = $error');
//   }
// }



  @override
  void initState() {
    loadData();
    super.initState();
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

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
        actions: [
          IconButton(
            onPressed: () {
              loadData();
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
          ),
        ),
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 15, 15, 15),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(places[index].placeName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editPlace(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletePlace(index, places[index].placeId);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddPlaceScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddPlaceScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPlaceScreen()),
    ).then((newPlace) {
      if (newPlace != null) {
        setState(() {
          places.add(newPlace);
        });
      }
    });
  }

  void _editPlace(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPlaceScreen(place: places[index])),
    ).then((editedPlace) {
      if (editedPlace != null) {
        setState(() {
          places[index] = editedPlace;
        });
      }
    });
  }

  void _deletePlace(int index, String placeId) async {
    // i want to come here
    final url = Uri.https(firebaseUrl, 'place/$placeId.json');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print("debug _deletePlace deleted");
      } else {
        print("debug _deletePlace error is ");
      }
    } catch (error) {
      print("debug _deletePlace error ");
    }
    setState(() {
      places.removeAt(index);
    });
  }
}

class AddPlaceScreen extends StatefulWidget {
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  String placeName = '';
  String description = '';
  String _image = '';
  String special = '';
  List<String> mostVisitedPlaces = [];
  String funFact = '';

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage.path;
      });
    } else {
      // Handle the case where the user canceled or encountered an error while picking an image.
      // You might want to show a message or perform some other action.
      print('Image picking canceled or failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    placeName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Place Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    special = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Special',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    funFact = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'funFact',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    mostVisitedPlaces
                        .clear(); // Clear the list before adding new values
                    mostVisitedPlaces.addAll(value.split(',').take(
                        3)); // Split the input by commas and add to the list
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Most Visited Places (Max 3, separated by commas)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
ElevatedButton(
  onPressed: _pickImage,
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    padding: EdgeInsets.all(20.0), // Adjust padding as needed
    primary: Colors.white, // Button background color
    side: BorderSide(
      color: Colors.grey[800]!, // Border color
      width: 2.0,
    ),
  ),
  child: _image.isNotEmpty
      ? Image.file(
          File(_image),
          width: 100.0, // Adjust the width as needed
          height: 100.0, // Adjust the height as needed
          fit: BoxFit.cover,
        )
      : Icon(
          Icons.add_a_photo_outlined,
          size: 40.0,
          color: Colors.grey[800],
        ),
),

              // if (_image != null) 
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _savePlaceToFirebase();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditPlaceScreen extends StatefulWidget {
  final Place place;

  EditPlaceScreen({required this.place});

  @override
  _EditPlaceScreenState createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {
  late TextEditingController _placeNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imagePathController;

  late TextEditingController _specialController;
  late TextEditingController _mostVisitedPlacesController;
  late TextEditingController _funFactController;

  

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePathController.text = pickedImage.path;
      });
    } else {
      // Handle the case where the user canceled or encountered an error while picking an image.
      // You might want to show a message or perform some other action.
      print('Image picking canceled or failed.');
    }
  }

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController(text: widget.place.placeName);
    _descriptionController =
        TextEditingController(text: widget.place.description);

    _imagePathController = TextEditingController(text: widget.place.imagePath);
    _specialController = TextEditingController(text: widget.place.special);
    _mostVisitedPlacesController =
        TextEditingController(text: widget.place.mostVisitedPlaces.join(', '));
    _funFactController = TextEditingController(text: widget.place.funFact);
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    _descriptionController.dispose();
    _imagePathController.dispose();
    _specialController.dispose();
    _mostVisitedPlacesController.dispose();
    _funFactController.dispose();
    super.dispose();
  }

 Future<void> _updatePlace() async {
    Place editedPlace = Place(
      placeId: widget.place.placeId,
      placeName: _placeNameController.text,
      description: _descriptionController.text,
      imagePath: _imagePathController.text,
      special: _specialController.text,
      mostVisitedPlaces: _mostVisitedPlacesController.text.split(', '),
      funFact: _funFactController.text,
    );

    final updatedData = editedPlace.toMap();
    final url = Uri.https(firebaseUrl, 'place/${editedPlace.placeId}.json');

    try {
      final response = await http.put(
        url,
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, editedPlace);
      } else {
        print('Failed to update place: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to update place: $error');
    }
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField('Place Name', _placeNameController),
            _buildTextField('Description', _descriptionController),
ElevatedButton(
  onPressed: _pickImage,
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.all(16.0),
    primary: Colors.white,
  ),
  child: _imagePathController.text.isNotEmpty
      ? Image.file(
          File(_imagePathController.text),
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        )
      : Icon(
          Icons.add_a_photo_outlined,
          size: 40.0,
          color: Colors.grey[800],
        ),
),
            _buildTextField('Special', _specialController),
            _buildTextField('Most Visited Places', _mostVisitedPlacesController),
            _buildTextField('Fun Fact', _funFactController),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _updatePlace();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Edit Place'),
  //     ),
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           _buildTextField('Place Name', _placeNameController),
  //           _buildTextField('Description', _descriptionController),
  //           // GestureDetector(
  //           //   onTap: _pickImage,
  //           //   child: CircleAvatar(
  //           //     radius: 50.0,
  //           //     backgroundColor: Colors.white,
  //           //     backgroundImage: _image != null ? FileImage(_image!) : null,
  //           //     child: _image == null
  //           //         ? Icon(
  //           //             Icons.add_a_photo_outlined,
  //           //             size: 40.0,
  //           //             color: Colors.grey[800],
  //           //           )
  //           //         : null,
  //           //   ),
  //           // ),
  //           if (_image != null)
  //             Image.file(
  //               _image!,
  //               width: 100,
  //               height: 100,
  //               fit: BoxFit.cover,
  //             ),
  //            ElevatedButton(
  //               onPressed: () async {
  //                 await _pickImage();
  //               },
  //               child: Text('Select Image'),
  //             ),
  //             if (_imagePathController.text.isNotEmpty)
  //               Image.file(
  //                 File(_imagePathController.text),
  //                 width: 100,
  //                 height: 100,
  //                 fit: BoxFit.cover,
  //               ),
  //           _buildTextField('Special', _specialController),
  //           _buildTextField(
  //               'Most Visited Places', _mostVisitedPlacesController),
  //           _buildTextField('Fun Fact', _funFactController),
  //           SizedBox(height: 20.0),
  //           ElevatedButton(
  //             onPressed: () {
  //               _updatePlace();
  //               Place editedPlace = Place(
  //                 placeId:
  //                   widget.place.placeId, //TODO: MODIFY IT WHEN YOU MAKE THE UPDATE FUNCTIONALITY
  //               placeName: _placeNameController.text,
  //               description: _descriptionController.text,
  //               imagePath: _imagePathController.text,
  //               special: _specialController.text,
  //               mostVisitedPlaces:
  //                   _mostVisitedPlacesController.text.split(', '),
  //               funFact: _funFactController.text,
  //               );
  //               Navigator.pop(context, editedPlace);
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
