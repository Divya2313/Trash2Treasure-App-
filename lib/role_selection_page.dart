import 'package:flutter/material.dart';
import 'waste_selection_page.dart';
import 'waste_category_identify.dart';
import 'plastics_info_page.dart';
import 'paper_info_page.dart';
import 'ewaste_info_page.dart';
import 'metals_info_page.dart';
import 'organic_info_page.dart';
import 'bio_info_pafe.dart';
import 'ai_upcycling_idea_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Role"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Select how you'll participate in making our environment cleaner",
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WasteSelectionPage()),
                    );
                  },
                  child: const RoleCard(
                      icon: Icons.person, text: "Individual Consumer"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AIUpcyclingIdeaPage()),
                    );
                  },
                  child: const RoleCard(
                      icon: Icons.apartment, text: "AI Waste Upcycling Ideas"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Waste Categories for recycle information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size.width > 600 ? 3 : 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final categories = [
                    {
                      "icon": Icons.recycling,
                      "text": "Plastics",
                      "page": PlasticsInfoPage()
                    },
                    {
                      "icon": Icons.description,
                      "text": "Paper",
                      "page": PaperInfoPage()
                    },
                    {
                      "icon": Icons.memory,
                      "text": "E-Waste",
                      "page": EwasteInfoPage()
                    },
                    {
                      "icon": Icons.build,
                      "text": "Metals",
                      "page": MetalsInfoPage()
                    },
                    {
                      "icon": Icons.eco,
                      "text": "Organic Waste",
                      "page": OrganicInfoPage()
                    },
                    {
                      "icon": Icons.biotech,
                      "text": "Bio-Waste",
                      "page": BioInfoPage()
                    },
                  ];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                categories[index]['page'] as Widget),
                      );
                    },
                    child: CategoryCard(
                      icon: categories[index]['icon'] as IconData,
                      text: categories[index]['text'] as String,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const RoleCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.green),
          const SizedBox(height: 8),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const CategoryCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 3, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.green),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
