class UserModel {
  final String login;
  final String firstName;
  final String lastName;
  // final String email;
  final String image;

  UserModel({
    required this.login,
    required this.firstName,
    required this.lastName,
    // required this.email,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // chemin d'asset par défaut
    String imagePath = 'assets/images/profile_default.jpg';

    try {
      final image = json['image'];
      if (image != null) {
        // préférer versions.medium > large > small > link
        final versions = image['versions'];
        if (versions != null) {
          imagePath =
              versions['medium'] ??
              versions['large'] ??
              versions['small'] ??
              image['link'] ??
              imagePath;
        } else {
          imagePath = image['link'] ?? imagePath;
        }
      }
    } catch (_) {
      // conserve imagePath par défaut
    }

    return UserModel(
      login: json['login'] ?? 'FToto',
      firstName: json['first_name'] ?? 'Toto',
      lastName: json['last_name'] ?? 'FamilleToto',
      image: imagePath,
    );
  }
}
