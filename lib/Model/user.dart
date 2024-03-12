// model/user.dart

class User {
  String id;
  String pin;

  User({required this.id, this.pin = "0"});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pin': pin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      pin: map['pin'],
    );
  }
}
