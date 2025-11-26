import 'package:flutter/material.dart';
import '../services/search_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../widgets/skills_widget.dart';
import '../widgets/projects_widget.dart';
import '../widgets/user_presentation_widget.dart';
import '../services/auth_42_service.dart';
import '../widgets/top_search_bar.dart';

class ProfileView extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileView({super.key, required this.onLogout});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final UserService userService;
  final AuthService authService = AuthService();
  final SearchService searchService = SearchService();
  UserModel? _user;
  bool _isUserFound = true;

  @override
  void initState() {
    super.initState();
    userService = UserService(onLogout: widget.onLogout);
    loadUser();
  }

  void loadUser() async {
    final user = await userService.fetchCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  Future<void> handleLogout() async {
    await authService.logout();
    widget.onLogout();
  }

  Future<void> _handleSearch(String Login) async {
    final foundUser = await searchService.fetchUserByLogin(Login);
    setState(() {
      if (foundUser != null) {
        _user = foundUser;
        _isUserFound = true;
        return;
      }
      _isUserFound = false;
    });
    // print('User found: $foundUser');
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
            onPressed: handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopSearchBar(
              onSearch: _handleSearch,
              isUserFound: _isUserFound,
              errorText: 'User not found',
            ),
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
