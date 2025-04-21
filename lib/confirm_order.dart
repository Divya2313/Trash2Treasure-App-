import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'track_order.dart';

class ConfirmOrderPage extends StatelessWidget {
  final Map<String, String> selectedWaste;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String liveLocation;

  ConfirmOrderPage({
    required this.selectedWaste,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.liveLocation,
  });

  Future<void> _storeOrder(BuildContext context) async {
    const String apiUrl = "http://localhost:5000/api/place-order";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "selectedWaste": selectedWaste,
          "address": address,
          "city": city,
          "state": state,
          "zip": zip,
          "liveLocation": liveLocation,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order placed successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to place order")),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error connecting to server")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Order"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 10),
              Text(
                "Order Placed!",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700),
              ),
              SizedBox(height: 20),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "📦 Order Summary",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.grey.shade400),
                      SizedBox(height: 8),
                      Text("🗑️ Waste Selected:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      ...selectedWaste.entries.map(
                          (entry) => Text("• ${entry.key}: ${entry.value}Kg")),
                      SizedBox(height: 10),
                      Text("📍 Pickup Address:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("$address, $city, $state - $zip",
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 6),
                      Text("🌍 Live Location:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(liveLocation, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Store Order Button
              ElevatedButton(
                onPressed: () async {
                  await _storeOrder(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("💾 Store Order",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),

              SizedBox(height: 20),

              // Track Order Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TrackOrderPage()), // Navigate to Track Order Page
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
                child: Text(
                  "📍 Track Order",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
