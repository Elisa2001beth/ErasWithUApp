class UserProfile {
  final String name;
  final String imagePath;
  final String university;
  final String city;
  final String about;

  const UserProfile({
    required this.name,
    required this.imagePath,
    required this.about,
    required this.city,
    required this.university,
  });

  UserProfile copy({
    String? imagePath,
    String? name,
    String? city,
    String? university,
    String? about,
  }) =>
      UserProfile(
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        city: city ?? this.city,
        university: university ?? this.university,
        about: about ?? this.about,
      );

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
        imagePath: json['imagePath'],
        name: json['name'],
        city: json['city'],
        university: json['university'],
        about: json['about'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'about': about,
        'city': city,
        'university': university,
      };
}
