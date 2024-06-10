import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> with WidgetsBindingObserver {
  late GoogleMapController _mapController;

  // Define the coordinates for the marker
  static const LatLng markerLocation = LatLng(5.187612, -262.853269);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid && state == AppLifecycleState.resumed) {
      setState(() {
        forceReRender();
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> forceReRender() async {
    await _mapController.setMapStyle('[]');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: markerLocation, // Set initial camera position to the marker location
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('marker'),
            icon: BitmapDescriptor.defaultMarker,
            position: markerLocation,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
