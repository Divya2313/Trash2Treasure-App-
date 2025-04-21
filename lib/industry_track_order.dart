import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class IndustryTrackOrderPage extends StatefulWidget {
  @override
  _IndustryTrackOrderPageState createState() => _IndustryTrackOrderPageState();
}

class _IndustryTrackOrderPageState extends State<IndustryTrackOrderPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _industryLocation;
  LatLng _agentLocation = LatLng(9.9252, 78.1198);
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getIndustryLocation();
  }

  Future<void> _getIndustryLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _industryLocation = LatLng(position.latitude, position.longitude);
      _drawRoute();
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_industryLocation!));
  }

  void _drawRoute() {
    if (_industryLocation == null) return;
    setState(() {
      _polylines.add(Polyline(
          polylineId: PolylineId("route"),
          points: [_agentLocation, _industryLocation!],
          color: Colors.blue,
          width: 5));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Collection Agent"),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          // 🚛 Delivery Tracking Info
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

          // 🗺 Google Map View
          Expanded(
            child: _industryLocation == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: _agentLocation, zoom: 14),
                    markers: {
                      Marker(
                          markerId: MarkerId("industry"),
                          position: _industryLocation!,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue)),
                      Marker(
                          markerId: MarkerId("agent"),
                          position: _agentLocation,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen)),
                    },
                    polylines: _polylines,
                    onMapCreated: (GoogleMapController controller) =>
                        _controller.complete(controller),
                  ),
          ),
        ],
      ),
    );
  }
}
