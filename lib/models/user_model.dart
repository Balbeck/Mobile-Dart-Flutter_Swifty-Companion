class SkillModel {
  final String skill;
  final double level;

  SkillModel({required this.skill, required this.level});

  double get percentage => (level / 20.0) * 100.0; //skill level sur 20 !
}

class ProjectModel {
  final String name;
  final String slug;
  final String status;
  final bool? validated;
  final int? finalMark;

  ProjectModel({
    required this.name,
    required this.slug,
    required this.status,
    this.validated,
    this.finalMark,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json['project']['name'] ?? 'Unknown Project',
      slug: json['project']['slug'] ?? 'unknown-project',
      status: json['status'] ?? 'unknown',
      validated: json['validated'] as bool?,
      finalMark: json['final_mark'] as int?,
    );
  }
}

class UserModel {
  final String login;
  final String firstName;
  final String lastName;
  final String usualFullName;
  final String email;
  final String image;
  final double level;
  final List<SkillModel> skills;
  final List<ProjectModel> projectsUsers;

  UserModel({
    required this.login,
    required this.firstName,
    required this.lastName,
    required this.usualFullName,
    required this.email,
    required this.image,
    required this.level,
    required this.skills,
    required this.projectsUsers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // chemin d'asset par défaut
    String imagePath = 'assets/images/profile_default.jpg';
    double level = 0.0;
    List<SkillModel> skills = [];
    List<ProjectModel> projectsUsers = [];

    // final projectsUsersList = json['projects_users'];
    // print('🔵 projects_users: $projectsUsersList');

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

      final cursusUsers = json['cursus_users'] as List?;
      if (cursusUsers != null && cursusUsers.isNotEmpty) {
        // Cherche le cursus actif (end_at == null)
        for (var cursus in cursusUsers) {
          if (cursus['end_at'] == null) {
            level = (cursus['level'] as num?)?.toDouble() ?? 0.0;

            // On en profite pour extraire les skills
            final skillsList = cursus['skills'] as List?;
            if (skillsList != null) {
              skills = skillsList
                  .map(
                    (s) => SkillModel(
                      skill: s['name'] ?? 'Unknown',
                      level: (s['level'] as num?)?.toDouble() ?? 0.0,
                    ),
                  )
                  .toList();
              break;
            }
          }
        }
      }

      final projectsList = json['projects_users'] as List?;
      if (projectsList != null) {
        projectsUsers = projectsList
            .map((p) => ProjectModel.fromJson(p as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // conserve imagePath par défaut
    }

    return UserModel(
      login: json['login'] ?? 'FToto',
      firstName: json['first_name'] ?? 'Toto',
      lastName: json['last_name'] ?? 'FamilleToto',
      usualFullName: json['usual_full_name'] ?? 'Toto FamilleToto',
      email: json['email'] ?? '',
      image: imagePath,
      level: level,
      skills: skills,
      projectsUsers: projectsUsers,
    );
  }
}
