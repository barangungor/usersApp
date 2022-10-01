class User {
  int? id;
  String? name, surname, phoneNumber, identity;
  double? sallary;
  DateTime? birthDate;
  User(
      {required this.id,
      required this.name,
      required this.surname,
      required this.birthDate,
      required this.phoneNumber,
      required this.identity,
      required this.sallary});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    birthDate = json['birthdate'];
    phoneNumber = json['phone_number'];
    identity = json['identity'];
    sallary = json['sallary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['birthdate'] = birthDate;
    data['phone_number'] = phoneNumber;
    data['identity'] = identity;
    data['sallary'] = sallary;
    return data;
  }
}
