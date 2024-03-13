// model/user.dart

class Dbenty {
  String keys;
  String value;

  Dbenty({required this.keys, this.value = "0"});

  Map<String, dynamic> toMap() {
    return {
      'keys': keys,
      'value': value,
    };
  }

  factory Dbenty.fromMap(Map<String, dynamic> map) {
    return Dbenty(
      keys: map['keys'],
      value: map['value'],
    );
  }
}
