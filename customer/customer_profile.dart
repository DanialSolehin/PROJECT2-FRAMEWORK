// // import 'package:exploresphere/customer/home_page.dart';
// // import 'package:exploresphere/customer/qna_customer.dart';
// // import 'package:exploresphere/models/logout.dart';

// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';

// // class ProfileScreen extends StatefulWidget {
// //   @override
// //   _ProfileScreenState createState() => _ProfileScreenState();
// // }

// // class _ProfileScreenState extends State<ProfileScreen> {

// // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// //   String userName = 'John Doe'; // Default name
// //   String userEmail = 'johndoe@example.com'; // Default email
// //   String userRole = 'User'; // Default role
// //   String userPhone = '123-456-7890'; // Default phone number
// //   File? _image; // Variable to store the selected image

// //   final picker = ImagePicker();
// //   TextEditingController nameController = TextEditingController();
// //   TextEditingController emailController = TextEditingController();
// //   TextEditingController roleController = TextEditingController();
// //   TextEditingController phoneController = TextEditingController();

// //   bool isEditing = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     nameController.text = userName;
// //     emailController.text = userEmail;
// //     roleController.text = userRole;
// //     phoneController.text = userPhone;
// //   }

// //   Future getImage() async {
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

// //     setState(() {
// //       if (pickedFile != null) {
// //         _image = File(pickedFile.path);
// //       } else {
// //         print('No image selected.');
// //       }
// //     });
// //   }

// //   void toggleEditing() {
// //     setState(() {
// //       isEditing = !isEditing;
// //     });
// //   }

// //   void saveChanges() {
// //     setState(() {
// //       userName = nameController.text;
// //       userEmail = emailController.text;
// //       userRole = roleController.text;
// //       userPhone = phoneController.text;
// //       isEditing = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       appBar: AppBar(
// //         title: Text('Profile'),
// // leading: IconButton(
// //   icon: Icon(Icons.menu),
// //   onPressed: () {
// //     _scaffoldKey.currentState?.openDrawer();
// //   },
// // ),

// //         actions: [
// //           IconButton(
// //             onPressed: () {
// //               toggleEditing();
// //             },
// //             icon: Icon(Icons.edit),
// //           ),
// //         ],
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //                 children: [
// //                   ListTile(
// //                     leading: Icon(Icons.home),
// //                     title: Text('Home'),
// //                     onTap: () {
// //                       Navigator.pop(context); // Close drawer
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) =>
// //                                 HomePage()), // Navigate to HomePage
// //                       );
// //                     },
// //                   ),
// //                   ListTile(
// //                     leading: Icon(Icons.person),
// //                     title: Text('Profile'),
// //                     onTap: () {
// //                       Navigator.pop(context); // Close drawer
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) =>
// //                                 ProfileScreen()), // Navigate to HomePage
// //                       );
// //                     },
// //                   ),
// //                   ListTile(
// //                     leading: Icon(Icons.question_answer),
// //                     title: Text('QnA'),
// //                     onTap: () {
// //                       Navigator.pop(context); // Close drawer
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) =>
// //                                 QnaCustomerPage()), // Navigate to HomePage
// //                       );
// //                     },
// //                   ),
// //             ListTile(
// //               leading: Icon(Icons.exit_to_app),
// //               title: Text('Log Out'),
// //               onTap: () {
// //                 logout(context);
// //               },
// //             ),
// //                   // Add more list items as needed
// //                 ],
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(20.0),
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// // GestureDetector(
// //   onTap: getImage,
// //   child: CircleAvatar(
// //     radius: 60,
// //     backgroundImage: _image != null
// //       ? FileImage(_image!)
// //       : AssetImage('images/default_profile_pic.png') as ImageProvider,
// //   ),
// // ),
// //               SizedBox(height: 20),
// //               TextField(
// //                 controller: nameController,
// //                 enabled: isEditing,
// //                 decoration: InputDecoration(labelText: 'Name'),
// //               ),
// //               SizedBox(height: 10),
// //               TextField(
// //                 controller: emailController,
// //                 enabled: isEditing,
// //                 decoration: InputDecoration(labelText: 'Email'),
// //               ),
// //               SizedBox(height: 10),
// //               TextField(
// //                 controller: roleController,
// //                 enabled: isEditing,
// //                 decoration: InputDecoration(labelText: 'Role'),
// //               ),
// //               SizedBox(height: 10),
// //               TextField(
// //                 controller: phoneController,
// //                 enabled: isEditing,
// //                 decoration: InputDecoration(labelText: 'Phone Number'),
// //               ),
// //               SizedBox(height: 20),
// //               if (isEditing)
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     ElevatedButton(
// //                       onPressed: saveChanges,
// //                       child: Text('Save'),
// //                     ),
// //                     ElevatedButton(
// //                       onPressed: toggleEditing,
// //                       child: Text('Cancel'),
// //                     ),
// //                   ],
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:exploresphere/customer/home_page.dart';
// import 'package:exploresphere/customer/qna_customer.dart';
// import 'package:exploresphere/models/logout.dart';
// import 'package:exploresphere/models/place.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:exploresphere/models/user.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http; // Import the User model

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   User? userProfile; // Variable to store the user profile
//   File? _image;
//   final picker = ImagePicker();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController roleController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   bool isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     // Assuming you have the user's email, you can fetch the user profile here
//     fetchUserProfile();
//   }

//    Future<User?> getUserByEmail(String email) async {
//     try {
//       final url = Uri.https(firebaseUrl,'/user?email=$email');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> userData = json.decode(response.body);
//         return User(
//           username: userData['username'],
//           email: userData['email'],
//           role: userData['role'],
//           phone: userData['phone'],
//           password: userData['password'],
//         );
//       } else {
//         print('Failed to fetch user data. Status code: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error during user data fetch: $e');
//       return null;
//     }
//   }

//   Future<void> updateUserProfile(User updatedUser) async {
//   try {
//     final url = Uri.https(firebaseUrl, '/user/${updatedUser.email}');
//     final response = await http.put(
//       url,
//       body: json.encode({
//         'username': updatedUser.username,
//         'email': updatedUser.email,
//         'role': updatedUser.role,
//         'phone': updatedUser.phone,
//         'password': updatedUser.password,
//       }),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       // Update successful, you may want to show a success message
//       print('User profile updated successfully.');
//     } else {
//       print('Failed to update user profile. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error during user profile update: $e');
//   }
// }

//   Future<void> fetchUserProfile() async {
//     // Replace 'user_email@example.com' with the actual user's email
//     userProfile = await getUserByEmail('user_email@example.com');

//     if (userProfile != null) {
//       nameController.text = userProfile!.username;
//       emailController.text = userProfile!.email;
//       roleController.text = userProfile!.role;
//       phoneController.text = userProfile!.phone;
//     } else {
//       // Handle the case where the user profile is not found
//       print('User profile not found.');
//     }
//   }

//   Future<void> getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   void toggleEditing() {
//     setState(() {
//       isEditing = !isEditing;
//     });
//   }

//   void saveChanges() {
//     setState(() {
//       if (userProfile != null) {
//         userProfile!.username = nameController.text;
//         userProfile!.email = emailController.text;
//         userProfile!.role = roleController.text;
//         userProfile!.phone = phoneController.text;

//         updateUserProfile(userProfile!);
//       }
//       isEditing = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text('Profile'),
//         backgroundColor: Colors.teal,
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               toggleEditing();
//             },
//             icon: Icon(Icons.edit),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 Navigator.pop(context); // Close drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//               onTap: () {
//                 Navigator.pop(context); // Close drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProfileScreen(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.question_answer),
//               title: Text('QnA'),
//               onTap: () {
//                 Navigator.pop(context); // Close drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => QnaCustomerPage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text('Log Out'),
//               onTap: () {
//                 logout(context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: getImage,
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundImage: _image != null
//                       ? FileImage(_image!)
//                       : AssetImage('images/default_profile_pic.png')
//                           as ImageProvider,
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: nameController,
//                 enabled: isEditing,
//                 decoration: InputDecoration(labelText: 'Name'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: emailController,
//                 enabled: isEditing,
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: roleController,
//                 enabled: isEditing,
//                 decoration: InputDecoration(labelText: 'Role'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: phoneController,
//                 enabled: isEditing,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//               ),
//               SizedBox(height: 20),
//               if (isEditing)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: saveChanges,
//                       child: Text('Save'),
//                     ),
//                     ElevatedButton(
//                       onPressed: toggleEditing,
//                       child: Text('Cancel'),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:exploresphere/customer/home_page.dart';
import 'package:exploresphere/customer/qna_customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:exploresphere/models/logout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

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
    final response = await http.post(
      Uri.parse('$firebaseUrl$databasePath'),
      body: json.encode({
        'name': nameController.text,
        'bio': bioController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'imagePath': base64Encode(profileImage!.readAsBytesSync()),
      }),
    );

    if (response.statusCode == 200) {
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

      setState(() {
        profiles = updatedProfiles;
      });
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: isEditing ? pickImage : null,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    profileImage != null ? FileImage(profileImage!) : null,
                child: profileImage == null && isEditing
                    ? Icon(Icons.add_a_photo, size: 40, color: Colors.white)
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
            if (!isEditing)
              Column(
                children: profiles.map((profile) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: profile.imageBytes != null
                            ? MemoryImage(profile.imageBytes!)
                            : null,
                      ),
                      title: Text(profile.name),
                      subtitle: Text(profile.email),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
