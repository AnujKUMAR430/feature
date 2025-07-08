// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';


// import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart'
//     hide PermissionStatus;

// class UserLocationMap extends StatefulWidget {
//   @override
//   _UserLocationMapState createState() => _UserLocationMapState();
// }

// class _UserLocationMapState extends State<UserLocationMap> {
//   Location location = Location();
//   LocationData? currentLocation;
//   final mapController = MapController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserLocation();
//   }

//   Future<void> _fetchUserLocation() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) serviceEnabled = await location.requestService();

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//     }

//     if (permissionGranted == PermissionStatus.granted ||
//         permissionGranted == PermissionStatus.grantedLimited) {
//       LocationData locationData = await location.getLocation();
//       setState(() => currentLocation = locationData);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("MapmyIndia Location")),
//       body: currentLocation == null
//           ? Center(child: CircularProgressIndicator())
//           : FlutterMap(
//               mapController: mapController,
//               options: MapOptions(
//                 center: LatLng(
//                   currentLocation!.latitude!,
//                   currentLocation!.longitude!,
//                 ),
//                 zoom: 15.0,
//                 backgroundColor: Colors.white,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       'https://apis.mapmyindia.com/advancedmaps/v1/8a2bd893e47ebcb1721d4c7128e823d5/tiles/256/{z}/{x}/{y}.png',
//                   tileProvider: NetworkTileProvider(
//                     headers: {
//                       // This header is required by MapmyIndia
//                       'User-Agent':
//                           "com.example.reel_section", // Replace with your app's actual package name
//                     },
//                   ),
//                 ),

//                 TileLayer(
//                   urlTemplate:
//                       'https://apis.mapmyindia.com/advancedmaps/v1/8a2bd893e47ebcb1721d4c7128e823d5/tiles/256/{z}/{x}/{y}.png',
//                   userAgentPackageName: "com.example.reel_section",
//                 ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: LatLng(
//                         currentLocation!.latitude!,
//                         currentLocation!.longitude!,
//                       ),
//                       width: 50,
//                       height: 50,
//                       child: Icon(
//                         Icons.location_pin,
//                         color: Colors.red,
//                         size: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }
// }



