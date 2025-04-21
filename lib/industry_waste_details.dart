import 'package:flutter/material.dart';
import 'requestpage.dart';

class WasteDetailsPage extends StatefulWidget {
  @override
  _WasteDetailsPageState createState() => _WasteDetailsPageState();
}

class _WasteDetailsPageState extends State<WasteDetailsPage> {
  // Stores waste type and weight details
  List<Map<String, dynamic>> wasteDetails = [
    {"wasteType": null, "weight": null}
  ];

  // Waste type options
  final List<String> wasteTypes = [
    "Plastics",
    "Paper",
    "Metals",
    "E-Waste",
    "Bio-Waste",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Waste Details",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Add navigation or function for the profile icon here
              },
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              Text(
                "Enter the details for waste collection:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Dynamic List of Waste Details
              ...wasteDetails.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> wasteDetail = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Waste Type Dropdown
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          items: wasteTypes.map((type) {
                            return DropdownMenuItem(
                              child: Text(type),
                              value: type,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              wasteDetails[index]["wasteType"] = value;
                            });
                          },
                          value: wasteDetail["wasteType"],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Waste Type",
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      // Weight Input Field
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Weight (Kg)",
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              wasteDetails[index]["weight"] =
                                  double.tryParse(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),

                      // Add/Remove Button
                      IconButton(
                        icon: Icon(
                          index == wasteDetails.length - 1
                              ? Icons.add_circle
                              : Icons.remove_circle,
                          color: index == wasteDetails.length - 1
                              ? Colors.green
                              : Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            if (index == wasteDetails.length - 1) {
                              // Add a new entry
                              wasteDetails
                                  .add({"wasteType": null, "weight": null});
                            } else {
                              // Remove the current entry
                              wasteDetails.removeAt(index);
                            }
                          });
                        },
                        tooltip: index == wasteDetails.length - 1
                            ? "Add more fields"
                            : "Remove this field",
                      ),
                    ],
                  ),
                );
              }).toList(),

              SizedBox(height: 30),

              // Additional Notes Section
              Text(
                "Additional Notes:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter any additional information...",
                ),
              ),
              SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add submit functionality here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestStatusPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
