import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'confirm_order.dart';

class NextPage extends StatefulWidget {
  final Map<String, String> selectedWaste;

  NextPage({required this.selectedWaste});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String apiKey = "AIzaSyAlwqAWnEvXQj3rW13FtGGr-OmRUnPydF8"; // Replace with your actual API key

  Future<void> _getLiveLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String address =
          await _getAddressFromLatLng(position.latitude, position.longitude);
      setState(() {
        locationController.text = address;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        locationController.text = "Unable to get location";
      });
    }
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == "OK") {
        return data["results"][0]["formatted_address"];
      }
    }
    return "Address not found";
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Collection Address"),
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collection Address Title
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Collection Address",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Address Section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildTextField(
                        "Street Address", Icons.home, addressController),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(
                                "City", Icons.location_city, cityController)),
                        SizedBox(width: 12),
                        Expanded(
                            child: _buildTextField(
                                "State", Icons.map, stateController)),
                      ],
                    ),
                    _buildTextField("Zip Code", Icons.numbers, zipController,
                        inputType: TextInputType.number),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Live Location Section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.green, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Live Location",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _buildTextField(
                      "Current Location",
                      Icons.place,
                      locationController,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.gps_fixed, color: Colors.green),
                        onPressed: _getLiveLocation,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Place Order Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmOrderPage(
                          selectedWaste: widget.selectedWaste,
                          address: addressController.text,
                          city: cityController.text,
                          state: stateController.text,
                          zip: zipController.text,
                          liveLocation: locationController.text,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.green.shade700,
                  ),
                  child: Text("Place Order",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
