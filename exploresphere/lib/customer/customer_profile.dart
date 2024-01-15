

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:exploresphere/customer/home_page.dart';
import 'package:exploresphere/customer/qna_customer.dart';
import 'package:exploresphere/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:exploresphere/models/logout.dart';

class Profile {
  final String key;
  String name;
  String bio;
  String email;
  String phone;
  Uint8List? imageBytes;

  Profile({
    required this.key,
    required this.name,
    required this.bio,
    required this.email,
    required this.phone,
    this.imageBytes,
  });
}

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String firebaseUrl =
      "https://travelmate-c4bd1-default-rtdb.asia-southeast1.firebasedatabase.app/";
  final String databasePath = "profiles.json";

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? profileImage;

  Uint8List? profilesImageBytes;

  final ImagePicker _imagePicker = ImagePicker();

  List<Profile> profiles = [];

  bool isEditing = false;

  Future<void> addProfile() async {
    final response = await http.patch(
      Uri.parse('$firebaseUrl$databasePath'),
      body: json.encode({
        'name': nameController.text,
        'bio': bioController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'imagePath': base64Encode(profileImage!.readAsBytesSync()),
      }),
    );
    final anotherResponse = await http.patch(
      Uri.parse('$firebaseUrl/user/${widget.user.phone}".json'),
      body: json.encode({
        'username': nameController.text,
        
        'email': emailController.text,

      }),
    );

    if (response.statusCode == 200 && anotherResponse.statusCode == 200) {
      print('Profile added successfully!');
      clearControllers();
      fetchProfiles();
    } else {
      print('Failed to add profile. Status Code: ${response.statusCode}');
    }
  }

  Future<void> fetchProfiles() async {
    final response = await http.get(Uri.parse('$firebaseUrl$databasePath'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Profile> updatedProfiles = [];

      data.forEach((key, value) {
        updatedProfiles.add(Profile(
          key: key,
          name: value['name'],
          bio: value['bio'],
          email: value['email'],
          phone: value['phone'],
          imageBytes: base64Decode(value['imagePath']),
        ));
      });
      for (final tempProfile in updatedProfiles) {
        if (tempProfile.email.toString() == widget.user.email.toString()) {
          print("email matched with the profile email is ${tempProfile.email}");
          setState(() {
            profiles = updatedProfiles;
          });
        }
      }
    } else {
      print('Failed to fetch profiles. Status Code: ${response.statusCode}');
    }
  }

  Future<void> deleteProfile(String key) async {
    final response =
        await http.delete(Uri.parse('$firebaseUrl$databasePath/$key.json'));

    if (response.statusCode == 200) {
      print('Profile deleted successfully!');
      clearControllers();
      fetchProfiles();
      toggleEditing();
    } else {
      print('Failed to delete profile. Status Code: ${response.statusCode}');
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = File(pickedFile.path).readAsBytesSync();
      setState(() {
        profileImage = File(pickedFile.path);
        profilesImageBytes = Uint8List.fromList(imageBytes);
      });
    }
  }

  void clearControllers() {
    nameController.clear();
    bioController.clear();
    emailController.clear();
    phoneController.clear();
    profileImage = null;
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  void initState() {
    nameController = TextEditingController(text: widget.user.username);
    bioController = TextEditingController(text: profiles.isEmpty?'':profiles[0].bio);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: profiles.isEmpty?'':profiles[0].phone);
    super.initState();
    fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profiles'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                // Save changes
                addProfile();
              }
              toggleEditing();
            },
          ),
          if (isEditing)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Assume you have the key of the profile to be deleted
                String profileKey = 'your_profile_key';
                deleteProfile(profileKey);
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
                    builder: (context) => ProfilePage(
                      user: widget.user,
                    ),
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
                    builder: (context) => QnaCustomerPage(
                      user: widget.user,
                    ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: isEditing ? pickImage : null,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: profiles.isNotEmpty
                    ? MemoryImage(profiles[0].imageBytes!)
                    : null,
              ),

            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              enabled: isEditing,
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(labelText: 'Bio'),
              enabled: isEditing,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: isEditing,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              enabled: isEditing,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
