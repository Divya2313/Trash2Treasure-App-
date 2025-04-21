import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'industry_confirm_order.dart';

class CollectionAddressPage extends StatefulWidget {
  final Map<String, double> selectedWaste;

  CollectionAddressPage({required this.selectedWaste});

  @override
  _CollectionAddressPageState createState() => _CollectionAddressPageState();
}

class _CollectionAddressPageState extends State<CollectionAddressPage> {
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String _selectedDate = "Select Date";
  String _selectedTime = "Select Time";

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
      setState(() {
        locationController.text = "Unable to fetch location.";
      });
    }
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    final String apiKey = "AIzaSyAlwqAWnEvXQj3rW13FtGGr-OmRUnPydF8";
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        return data["results"][0]["formatted_address"];
      }
    }
    return "Address not found";
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collection Address"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_city,
                            color: Colors.green), // City icon added
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "Collection Address",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Street Address",
                        prefixIcon:
                            Icon(Icons.home, color: Colors.green), // Added Icon
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cityController,
                            decoration: InputDecoration(
                              labelText: "City",
                              prefixIcon: Icon(Icons.location_city,
                                  color: Colors.green), // Added Icon
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: stateController,
                            decoration: InputDecoration(
                              labelText: "State",
                              prefixIcon: Icon(Icons.map,
                                  color: Colors.green), // Added Icon
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: zipCodeController,
                      decoration: InputDecoration(
                        labelText: "Zip Code",
                        prefixIcon: Icon(Icons.pin_drop,
                            color: Colors.green), // Added Icon
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.green), // Icon added
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "Date and Time",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.green),
                      title: Text(_selectedDate),
                      onTap: _pickDate,
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time, color: Colors.green),
                      title: Text(_selectedTime),
                      onTap: _pickTime,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.my_location,
                            color: Colors.green), // Icon added
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "Live Location",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: locationController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tap to get location",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.gps_fixed, color: Colors.green),
                          onPressed: _getLiveLocation,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IndustryConfirmOrderPage(orderDetails: {
                        "address": addressController.text,
                        "city": cityController.text,
                        "state": stateController.text,
                        "zipCode": zipCodeController.text,
                        "location": locationController.text,
                        "date": _selectedDate,
                        "time": _selectedTime,
                        "selectedWaste": widget.selectedWaste,
                      }),
                    ),
                  );
                },
                child: Text("Place Order",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
