class User {
  final String? id;
  final String? token;
  final String? name;
  final String? email;
  final String? countryCode;
  final String? mobile;
  String? image;

  final DateTime? time; //user created time

  User(
      {this.id,
      this.token,
      this.name,
      this.email,
      this.countryCode,
      this.mobile,
      this.image,
      this.time});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        token: json["token"],
        name: json["name"],
        email: json["email"],
        countryCode: json["countryCode"],
        mobile: json["mobile"],
        image: json["image"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "token": token,
        "name": name,
        "email": email,
        "countryCode": countryCode,
        "mobile": mobile,
        "image": image,
        "time": time?.toIso8601String(),
      };

  @override
  String toString() {
    return  ""
        "Id=$id\n"
        "token=$token\n"
        "name=$name\n"
        "email=$email\n"
        "countryCode=$countryCode\n"
        "mobile=$mobile\n"
        "image=$image\n"
        "time=$time\n"

    ;
  }
}
