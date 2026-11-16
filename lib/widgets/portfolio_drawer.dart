import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/home_page.dart';
import 'package:myportofolio_mobile/screens/education_form_page.dart';

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key, required this.currentPage});

  final String currentPage;

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      const _DrawerItem('Home', Icons.home, 'home'),
      const _DrawerItem('Add Project', Icons.add_circle, 'add_project'),
      const _DrawerItem('Add Education', Icons.school, 'add_education'),
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
              ],
            ),
          ),
          ...menuItems.map((item) {
            final isSelected = item.route == currentPage;

            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              selected: isSelected,
              selectedTileColor: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.12),
              onTap: () {
                Navigator.pop(context);

                if (item.route == 'home') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                  return;
                }

                if (item.route == 'add_project') {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Add Project page is not yet implemented.',
                        ),
                      ),
                    );
                  return;
                }

                if (item.route == 'add_education') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EducationFormPage(),
                    ),
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }
}

class _DrawerItem {
  const _DrawerItem(this.title, this.icon, this.route);

  final String title;
  final IconData icon;
  final String route;
}
