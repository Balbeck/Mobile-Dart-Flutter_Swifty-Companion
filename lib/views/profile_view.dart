import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../widgets/skills_widget.dart';
import '../widgets/projects_widget.dart';

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
    final imageProvider = (_user != null && _user!.image.startsWith('http'))
        ? NetworkImage(_user!.image) as ImageProvider
        : const AssetImage('assets/images/profile_default.jpg');

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec avatar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundImage: imageProvider),
                  const SizedBox(height: 20),
                  Text(
                    'Login: ${_user?.login ?? 'TheToto'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Last name: ${_user?.lastName ?? 'FamilleToto'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'First name: ${_user?.firstName ?? 'Toto'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Full name: ${_user?.usualFullName ?? 'Toto FamilleToto'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Email: ${_user?.email ?? 'toto@42.email.com'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Level: ${_user?.level.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            if (_user != null) ...[
              SkillsListWidget(skills: _user!.skills),
              const SizedBox(height: 20),
              ProjectsWidget(projects: _user!.projectsUsers),
            ] else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Loading...'),
              ),
          ],
        ),
      ),
    );
  }
}
