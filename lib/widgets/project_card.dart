import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/education_form_page.dart';
import 'package:myportofolio_mobile/screens/project_form_page.dart';

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
        onTap: () {
          if (item.name == 'Add Project') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
            return;
          }

          if (item.name == 'Add Education') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EducationFormPage(),
              ),
            );
            return;
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('You pressed the ${item.name} button!')),
            );
        },
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
}
