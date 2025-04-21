import 'package:flutter/material.dart';
import 'next_page.dart';

class WasteSelectionPage extends StatefulWidget {
  @override
  _WasteSelectionPageState createState() => _WasteSelectionPageState();
}

class _WasteSelectionPageState extends State<WasteSelectionPage> {
  Map<String, bool> selectedWasteTypes = {
    "Plastics": false,
    "Paper": false,
    "Metals": false,
    "E-Waste": false,
    "Bio-Waste": false,
  };

  Map<String, TextEditingController> weightControllers = {
    "Plastics": TextEditingController(),
    "Paper": TextEditingController(),
    "Metals": TextEditingController(),
    "E-Waste": TextEditingController(),
    "Bio-Waste": TextEditingController(),
  };

  @override
  void dispose() {
    weightControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Waste Types"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select waste types and enter weights",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: selectedWasteTypes.keys.map((wasteType) {
                  return WasteTypeCard(
                    title: wasteType,
                    isChecked: selectedWasteTypes[wasteType]!,
                    controller: weightControllers[wasteType]!,
                    onChanged: (bool? newValue) {
                      setState(() {
                        selectedWasteTypes[wasteType] = newValue!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Map<String, String> selectedWaste = {};
                  selectedWasteTypes.forEach((key, value) {
                    if (value && weightControllers[key]!.text.isNotEmpty) {
                      selectedWaste[key] = weightControllers[key]!.text;
                    }
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NextPage(selectedWaste: selectedWaste),
                    ),
                  );
                },
                child: Text("Proceed"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WasteTypeCard extends StatelessWidget {
  final String title;
  final bool isChecked;
  final TextEditingController controller;
  final ValueChanged<bool?> onChanged;

  WasteTypeCard({
    required this.title,
    required this.isChecked,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.recycling, color: Colors.green),
                    SizedBox(width: 8),
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 4),

                // ✅ Rounded Box for Weight Input
                Container(
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Light background for better UI
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Weight (kg)",
                      border: InputBorder.none, // Removes default underline
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: Colors.green),
          ],
        ),
      ),
    );
  }
}
