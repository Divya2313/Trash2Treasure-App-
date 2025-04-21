import 'package:flutter/material.dart';
import 'industry_waste_selection.dart';
import 'industry_waste_details.dart';

class IndustryDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Industry Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Select an Option",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOptionCard(
                  context,
                  "Schedule Waste Pickup",
                  "assets/images/swp.jpg",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndustryWasteSelection()),
                    );
                  },
                ),
                SizedBox(width: 20),
                _buildOptionCard(
                  context,
                  "Request Waste for Recycling",
                  "assets/images/rwr.PNG",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WasteDetailsPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String text, String imagePath,
      VoidCallback onPressed) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 150, // Square-like appearance
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity, // Ensures button takes full width
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
