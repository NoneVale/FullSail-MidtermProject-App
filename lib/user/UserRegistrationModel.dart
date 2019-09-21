class UserRegistrationModel {
  String email;
  String firstName;
  String lastName;
  String username;
  String password;

  int birthDay;
  int birthMonth;
  int birthYear;

  UserRegistrationModel(String email, String firstName, String lastName, String username, String password,
      int birthDay, int birthMonth, int birthYear) {
    this.email = email;
    this.firstName = firstName;
    this.lastName = lastName;
    this.username = username;
    this.password = password;

    this.birthDay = birthDay;
    this.birthMonth = birthMonth;
    this.birthYear = birthYear;
  }

  Map<String, Object> toJson() {
    return {"email": email, "firstName": firstName, "lastName": lastName, "username": username, "password": password,
      "birthDay": birthDay, "birthMonth": birthMonth, "birthYear": birthYear};
  }
}