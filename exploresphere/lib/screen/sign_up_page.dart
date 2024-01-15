import 'package:exploresphere/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exploresphere/models/user.dart';

class SignUpScreens extends StatefulWidget {
  final User? user;
  const SignUpScreens({Key? key, this.user});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreens> {
  void _navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _selectedRole;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _selectedRole = 'Customer'; // Set default role
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final url = Uri.https(
          'travelmate-c4bd1-default-rtdb.asia-southeast1.firebasedatabase.app',
          'user.json');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<User> user = data.entries
            .map((entry) => User.fromJson(entry.key, entry.value))
            .toList();

        // Find the user with the matching email
        User? foundUser;
        for (var user in user) {
          if (user.email == email) {
            foundUser = user;
            break;
          }
        }

        return foundUser;
      } else {
        print('Failed to get user data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during user data retrieval: $e');
      return null;
    }
  }

  Future<void> signUp(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        final url = Uri.https(
            'travelmate-c4bd1-default-rtdb.asia-southeast1.firebasedatabase.app',
            'user.json');

        final response = await http.post(
          url,
          body: jsonEncode({
            'username': _usernameController.text,
            'email': _emailController.text,
            'password':
                _passwordController.text, // Not secure, consider hashing
            'role': _selectedRole,
          }),
        );

        if (response.statusCode == 200) {
          print('Signed up successfully!');

          // Retrieve user data based on the entered email
          final User? newUser = await getUserByEmail(_emailController.text);

          if (newUser != null) {
            print('User data retrieved: ${newUser.username}');
            // Now you have the user data, you can do whatever you want with it.
          } else {
            print('Failed to retrieve user data for the new user');
          }

          _navigateToLoginPage(context);
        } else {
          print('Failed to sign up. Status code: ${response.statusCode}');
          // Handle signup failure
        }
      }
    } catch (e) {
      print('Error during sign up: $e');
      // Handle error
    }
  }

// Future<void> signUp(BuildContext context) async {
//   try {
//     if (_formKey.currentState!.validate()) {
//       final url = Uri.https('travelmate-c4bd1-default-rtdb.asia-southeast1.firebasedatabase.app',
//       'user.json');

//       final response = await http.post(
//         url,
//         body: jsonEncode({
//           'username': _usernameController.text,
//           'email': _emailController.text,
//           'password': _passwordController.text, // Not secure, consider hashing
//           'role': _selectedRole,
//         }),
//       );

//       if (response.statusCode == 200) {
//         print('Signed up successfully!');
//         _navigateToLoginPage(context);
//       } else {
//         print('Failed to sign up. Status code: ${response.statusCode}');
//         // Handle signup failure
//       }
//     }
//   } catch (e) {
//     print('Error during sign up: $e');
//     // Handle error
//   }
// }

  // Widget _inputFields(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Form(
  //       key: _formKey,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           TextFormField(
  //             controller: _usernameController,
  //             decoration: InputDecoration(
  //               labelText: 'Username',
  //               border: OutlineInputBorder(),
  //             ),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter a username';
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(height: 10),
  //           TextFormField(
  //             controller: _emailController,
  //             decoration: InputDecoration(
  //               labelText: 'Email',
  //               border: OutlineInputBorder(),
  //             ),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter an email';
  //               }
  //               // Add email validation logic if needed
  //               return null;
  //             },
  //           ),
  //           SizedBox(height: 10),
  //           TextFormField(
  //             controller: _passwordController,
  //             decoration: InputDecoration(
  //               labelText: 'Password',
  //               border: OutlineInputBorder(),
  //             ),
  //             obscureText: true,
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter a password';
  //               }
  //               // Add password validation logic if needed
  //               return null;
  //             },
  //           ),
  //           SizedBox(height: 10),
  //           DropdownButtonFormField<String>(
  //             value: _selectedRole,
  //             items: <String>['Admin', 'Customer'].map((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //             onChanged: (String? newValue) {
  //               if (newValue != null) {
  //                 // Uncomment the following line if you have a setState method in a StatefulWidget
  //                 // context.read<YourViewModel>().updateSelectedRole(newValue);
  //                 // For a StatelessWidget, you may want to handle this through a callback to the parent widget.
  //               }
  //             },
  //           ),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () async {
  //               print('yes');
  //               // await signUp(context);
  //               print('yes');
  //               // _navigateToLoginPage(context); // Call the signup function here
  //             },
  //             child: Text(
  //               'Sign Up',
  //               style: TextStyle(fontSize: 20),
  //             ),
  //             style: ElevatedButton.styleFrom(
  //               shape: StadiumBorder(),
  //               padding: EdgeInsets.symmetric(vertical: 16),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _inputFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              // Add email validation logic if needed
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              // Add password validation logic if needed
              return null;
            },
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            items: <String>['Admin', 'Customer'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedRole = newValue;
                });
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              print('yes');
              await signUp(context);
              print('yes');
              _navigateToLoginPage(context); // Call the signup function here
            },
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       body: Container(
  //         margin: EdgeInsets.all(24),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _header(),
  //             _inputFields(context),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputFields(context),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _header() {
    return Column(
      children: [
        SizedBox(height: 15),
        Text(
          'Create Account',
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
        Text('Enter details to get started'),
      ],
    );
  }
}
