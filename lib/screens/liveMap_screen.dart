import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LiveMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  late GoogleMapController mapController;
  bool _isMapLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Location"),
        backgroundColor: const Color(0xFF870474),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
            _isMapLoaded = true;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 16.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("current_location"),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
