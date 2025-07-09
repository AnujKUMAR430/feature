import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class OSMCurrentLocationPage extends StatefulWidget {
  const OSMCurrentLocationPage({super.key});

  @override
  State<OSMCurrentLocationPage> createState() => _OSMCurrentLocationPageState();
}

class _OSMCurrentLocationPageState extends State<OSMCurrentLocationPage> {
  final mapController = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );

  bool permissionGranted = false;
  bool mapReady = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission is required")),
      );
    }
  }

  Future<void> _showCurrentLocation() async {
    if (!permissionGranted || !mapReady) return;

    try {
      final userLocation = await mapController.myLocation();
      await mapController.addMarker(
        userLocation,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_on, size: 60, color: Colors.blue),
        ),
      );
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Current Location")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_on),
        onPressed: () {
          _showCurrentLocation();
        },
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  initZoom: 15,
                  minZoomLevel: 8,
                  maxZoomLevel: 18,
                ),
                userTrackingOption: const UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
                ),
                showDefaultInfoWindow: true,
                enableRotationByGesture: true,
                showZoomController: true,
              ),
              onMapIsReady: (isReady) async {
                if (isReady && permissionGranted && !mapReady) {
                  setState(() => mapReady = true);
                  await mapController.enableTracking();
                  await _showCurrentLocation();
                }
              },
              onLocationChanged: (location) {
                debugPrint("User location changed: $location");
              },
            ),
          );
        },
      ),
    );
  }
}
