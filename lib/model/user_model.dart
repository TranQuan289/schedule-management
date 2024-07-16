class User {
  String name;
  String phone;
  String email;
  String password;
  String dateOfBirth;

  User({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'date_of_birth': dateOfBirth,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      dateOfBirth: json['date_of_birth'],
    );
  }
}
