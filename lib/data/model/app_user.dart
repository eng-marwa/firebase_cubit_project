class AppUser {
  final String uid;
  String? name;
  final String email;
  String? address;
  String? phone;
  String? pic;

  AppUser(
      {required this.uid,
      this.name,
      required this.email,
      this.address,
      this.phone,
      this.pic});

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'address': address,
        'phone': phone,
        'pic': pic
      };

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        phone: map['phone'],
        address: map['address'],
        pic: map['pic']);
  }

  @override
  String toString() {
    return 'AppUser{uid: $uid, name: $name, email: $email, address: $address, phone: $phone, pic: $pic}';
  }
}
