import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form_page.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/widgets/portfolio_action_card.dart';
import 'package:myportofolio_mobile/widgets/portfolio_drawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String npm = '2506546062';
  final String name = 'Tiffany';
  final String kelas = 'PBP E';

  static const List<ItemHomepage> items = [
    ItemHomepage('View Projects', Icons.folder),
    ItemHomepage('Add Project', Icons.add_circle),
    ItemHomepage('Add Education', Icons.school),
    ItemHomepage('Logout', Icons.logout),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final actionCardAspectRatio = screenWidth < 360
        ? 0.55
        : screenWidth < 480
        ? 0.8
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const PortfolioDrawer(currentPage: 'home'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InfoCard(title: 'NPM', content: npm),
                ),
                Expanded(
                  child: InfoCard(title: 'Name', content: name),
                ),
                Expanded(
                  child: InfoCard(title: 'Class', content: kelas),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PortfolioActionCard(
              key: const Key('add-education-action'),
              title: 'Add Education',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EducationFormPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Welcome to MyPortfolio Mobile!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                childAspectRatio: actionCardAspectRatio,
                children: items.map((item) => ItemCard(item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(content, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
