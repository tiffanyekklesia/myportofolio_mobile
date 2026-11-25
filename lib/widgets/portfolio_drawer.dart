import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form_page.dart';
import 'package:myportofolio_mobile/screens/home_page.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form_page.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key, required this.currentPage});

  final String currentPage;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final menuItems = [
      const _DrawerItem('Home', Icons.home, 'home'),
      const _DrawerItem('View Projects', Icons.folder, 'projects'),
      const _DrawerItem('Add Project', Icons.add_circle, 'add_project'),
      const _DrawerItem('Add Education', Icons.school, 'add_education'),
      if (isLoggedIn)
        const _DrawerItem('Logout', Icons.logout, 'logout')
      else
        const _DrawerItem('Login', Icons.login, 'login'),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.person, size: 40, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'MyPortfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Explore projects & experiences',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          ...menuItems.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              selected: item.route == currentPage,
              selectedTileColor: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.12),
              onTap: () => _selectItem(context, item),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _selectItem(BuildContext context, _DrawerItem item) async {
    Navigator.pop(context);

    if (item.route == 'home') {
      if (currentPage == 'home') return;
      await Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(builder: (_) => const MyHomePage()),
      );
      return;
    }

    if (item.route == 'login') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
      return;
    }

    if (item.route == 'logout') {
      try {
        await context.read<AuthState>().logout();
        if (context.mounted) _showMessage(context, 'Logged out.');
      } on ApiException catch (error) {
        if (!context.mounted) return;
        final message = error.statusCode == null
            ? 'Local session ended, but the server could not be reached.'
            : 'Local session ended, but logout failed (HTTP ${error.statusCode}).';
        _showMessage(context, message);
      }
      return;
    }

    if (item.route == 'add_project') {
      if (!await ensureLoggedIn(context) || !context.mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
      );
      return;
    }

    if (item.route == 'projects') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const ProjectListScreen()),
      );
      return;
    }

    if (item.route == 'add_education') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const EducationFormPage()),
      );
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DrawerItem {
  const _DrawerItem(this.title, this.icon, this.route);

  final String title;
  final IconData icon;
  final String route;
}
