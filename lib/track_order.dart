import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackOrderPage extends StatefulWidget {
  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? _userLocation; // User's live location
  LatLng _agentLocation =
      LatLng(9.9252, 78.1198); // Default: Madurai agent location
  Set<Polyline> _polylines = {}; // Stores the route

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // 🔹 Get User's Live Location
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _drawRoute(); // Draw the route when location is available
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_userLocation!));
  }

  // 🔹 Draw Route from Agent to User
  void _drawRoute() {
    if (_userLocation == null) return;

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: [
            _agentLocation,
            _userLocation!
          ], // Draws a line from agent to user
          color: Colors.green,
          width: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Your Order"),
        backgroundColor: Colors.green[700],
      ),
      body: _userLocation == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading until location loads
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _agentLocation, // Start at Madurai
                      zoom: 14,
                    ),
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                        markerId: MarkerId("user"),
                        position: _userLocation!,
                        infoWindow: InfoWindow(title: "Your Location"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                      ),
                      Marker(
                        markerId: MarkerId("agent"),
                        position: _agentLocation,
                        infoWindow: InfoWindow(title: "Waste Collection Agent"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen),
                      ),
                    },
                    polylines: _polylines, // Draw route
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.green, size: 80),
                      SizedBox(height: 10),
                      Text(
                        "Your waste collection is on the way!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(color: Colors.green[700]),
                      SizedBox(height: 20),
                      Text("Estimated arrival: 10-15 minutes"),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
