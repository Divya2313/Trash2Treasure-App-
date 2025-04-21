import 'package:flutter/material.dart';
import 'industry_track_order.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'dart:convert'; // For JSON encoding and decoding

Future<void> _placeIndustryOrder(
    BuildContext context, Map<String, dynamic> orderDetails) async {
  const String apiUrl =
      "http://localhost:5000/api/place-industry-order"; // Use localhost for emulator

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(orderDetails),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Industry order placed successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to place industry order")),
      );
    }
  } catch (error) {
    print("❌ Error: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error connecting to server")),
    );
  }
}

class IndustryConfirmOrderPage extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  IndustryConfirmOrderPage({required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background for contrast
      appBar: AppBar(
        title: Text("Confirm Order"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ ORDER PLACED SECTION
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "Order Placed Successfully!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // ✅ ORDER SUMMARY SECTION
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Summary",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Divider(color: Colors.green),
                    SizedBox(height: 8),

                    // Waste Details
                    Text("Waste Selected:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: orderDetails['selectedWaste']
                          .entries
                          .map<Widget>((entry) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key, style: TextStyle(fontSize: 16)),
                              Text("${entry.value} kg",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // ✅ ADDRESS, DATE & TIME, LIVE LOCATION BOX
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pickup Address
                    Row(
                      children: [
                        Icon(Icons.location_city, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Pickup Address",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${orderDetails['address']}, ${orderDetails['city']}, ${orderDetails['state']}, ${orderDetails['zipCode']}",
                      style: TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 16),

                    // Date & Time
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Scheduled Date & Time",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("${orderDetails['date']} at ${orderDetails['time']}",
                        style: TextStyle(fontSize: 16)),

                    SizedBox(height: 16),

                    // Live Location
                    Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Live Location",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(orderDetails['location'],
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // ✅ TRACK ORDER BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  await _placeIndustryOrder(context, orderDetails);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndustryTrackOrderPage(),
                    ),
                  );
                },
                child: Text("Track Order",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
