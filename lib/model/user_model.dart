class User {
  String id;
  String name;
  String phone;
  String email;
  String? password;
  String? dateOfBirth;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.password,
    this.dateOfBirth,
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
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      dateOfBirth: json['date_of_birth'],
    );
  }
}
