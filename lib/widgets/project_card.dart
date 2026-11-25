import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form_page.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_form_page.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemHomepage {
  const ItemHomepage(this.name, this.icon);

  final String name;
  final IconData icon;
}

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    if (item.name == 'View Projects') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const ProjectListScreen(),
        ),
      );
      return;
    }

    if (item.name == 'Add Project') {
      if (!await ensureLoggedIn(context) || !context.mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
      );
      return;
    }

    if (item.name == 'Add Education') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const EducationFormPage()),
      );
      return;
    }

    if (item.name == 'Logout') {
      if (!context.read<AuthState>().isLoggedIn) {
        _showMessage(context, 'You are not logged in.');
        return;
      }

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

    _showMessage(context, 'You pressed the ${item.name} button!');
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
