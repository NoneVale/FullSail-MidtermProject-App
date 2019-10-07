class UserModel {
   String username;
   String email;
   String birthday;
   String userId;
   String profilePictureUrl;
   String name;

   List<dynamic> followers;
   List<dynamic> following;

   bool verified;

   UserModel(String username, String email, String birthday, String userId, String profilePictureUrl, String name, List<dynamic> followers, List<dynamic> following, bool verified) {
     this.username = username;
     this.email = email;
     this.birthday = birthday;
     this.userId = userId;
     this.profilePictureUrl = profilePictureUrl;
     this.name = name;

     this.followers = followers;
     this.following = following;

     this.verified = verified;
   }

   factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
     return new UserModel(
         parsedJson['username'],
         parsedJson['email'],
         parsedJson['birthday'],
         parsedJson['userId'],
         parsedJson['profilePictureUrl'],
         parsedJson['name'],
         parsedJson['followers'],
         parsedJson['following'],
         parsedJson['verified']);
   }
}