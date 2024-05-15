class CustomUser {
  String? firstName;
  String? lastName;
  List<String>? favourites;

  CustomUser({required this.firstName, required this.lastName}){
    favourites = List.empty(growable: true);
  }

  static String getKey(String email){
    return email.replaceAll(RegExp("\\."), "");
  }

  factory CustomUser.fromJson(Map jsonMap) {
    return CustomUser(
      firstName: jsonMap["firstName"],
      lastName: jsonMap["lastName"],
    )..favourites = List.from(jsonMap["favourites"]?.cast<String>() ?? List.empty(growable: true), growable: true);
  }

  Map toJson() {
    return {
      "firstName" : firstName,
      "lastName" : lastName,
      "favourites" : favourites
    };
  }
}