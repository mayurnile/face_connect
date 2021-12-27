class UserModel {
  String? id;
  String? email;
  String? phoneNumber;
  String? name;
  String? city;
  String? gender;
  DateTime? dob;
  String? profilePicture;

  UserModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.name,
    this.city,
    this.gender,
    this.dob,
    this.profilePicture,
  });

  factory UserModel.fromJSON(Map<String, dynamic> data) {
    return UserModel(
      id: data["_id"] as String,
      name: data["name"] as String,
      phoneNumber: data["mobileNumber"] as String,
      email: data["email"] as String,
      dob: DateTime.tryParse(data["dateOfBirth"] as String),
      gender: data["gender"] as String,
      city: data["city"] as String,
      profilePicture: data["displayPicture"] as String,
    );
  }
}
