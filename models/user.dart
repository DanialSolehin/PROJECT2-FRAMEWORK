class User {
  late String username;
  late String password;
  late String email;
  late String role;
  late String phone;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.phone,
  });

    factory User.fromJson(String key, Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone']?? '',
    );
  }
}

void main() {
  // Creating an instance of User
  User newUser = User(
    username: 'example_username',
    password: 'example_password',
    email: 'example@example.com',
    role: 'user_role',
    phone: 'phone',
  );

  // Accessing user properties
  print('Username: ${newUser.username}');
  print('Email: ${newUser.email}');
  print('Role: ${newUser.role}');
}
