import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../widgets/skills_widget.dart';
import '../widgets/projects_widget.dart';
import '../widgets/user_presentation_widget.dart';

class ProfileView extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileView({super.key, required this.onLogout});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserService _userService = UserService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _userService.fetchCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onLogout,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_user != null) ...[
              ProfileHeaderWidget(user: _user!),
              SkillsListWidget(skills: _user!.skills),
              const SizedBox(height: 20),
              ProjectsWidget(projects: _user!.projectsUsers),
            ] else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
