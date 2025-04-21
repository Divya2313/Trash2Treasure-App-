import 'package:flutter/material.dart';
import 'industry_address.dart';

class IndustryWasteSelection extends StatefulWidget {
  @override
  _IndustryWasteSelectionState createState() => _IndustryWasteSelectionState();
}

class _IndustryWasteSelectionState extends State<IndustryWasteSelection> {
  // Stores selected waste types and their weights
  Map<String, TextEditingController> wasteControllers = {
    "Plastics": TextEditingController(),
    "Paper": TextEditingController(),
    "Metals": TextEditingController(),
    "E-Waste": TextEditingController(),
    "Bio-Waste": TextEditingController(),
  };
  Map<String, bool> selectedWasteTypes = {
    "Plastics": false,
    "Paper": false,
    "Metals": false,
    "E-Waste": false,
    "Bio-Waste": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Waste Selection",
                style: TextStyle(fontSize: 20),
              ),
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select waste types and specify weights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: selectedWasteTypes.keys.map((wasteType) {
                  return _buildWasteTypeCard(
                    wasteType: wasteType,
                    icon: _getWasteIcon(wasteType),
                    isOn: selectedWasteTypes[wasteType]!,
                    controller: wasteControllers[wasteType]!,
                    onChanged: (bool newValue) {
                      setState(() {
                        selectedWasteTypes[wasteType] = newValue;
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
                  Map<String, double> selectedWasteWithWeights = {};
                  selectedWasteTypes.forEach((key, value) {
                    if (value && wasteControllers[key]!.text.isNotEmpty) {
                      selectedWasteWithWeights[key] =
                          double.tryParse(wasteControllers[key]!.text) ?? 0.0;
                    }
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollectionAddressPage(
                        selectedWaste: selectedWasteWithWeights,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWasteIcon(String wasteType) {
    switch (wasteType) {
      case "Plastics":
        return Icons.recycling;
      case "Paper":
        return Icons.description;
      case "Metals":
        return Icons.build;
      case "E-Waste":
        return Icons.memory;
      case "Bio-Waste":
        return Icons.biotech;
      default:
        return Icons.help;
    }
  }

  Widget _buildWasteTypeCard({
    required String wasteType,
    required IconData icon,
    required bool isOn,
    required TextEditingController controller,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green, size: 30),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wasteType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Weight (Kg)",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Switch(
              value: isOn,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
