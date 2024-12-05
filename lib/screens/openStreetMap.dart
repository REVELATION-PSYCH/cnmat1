import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// To provide LatLng

class OpenStreetMapScreen extends StatelessWidget {
  const OpenStreetMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: FlutterMap(
        options: const MapOptions(
            // center:
            //    LatLng(51.5, -0.09), // Replace with your user's location lat/long
            // zoom: 13.0,
            ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
        ],
      ),
    );
  }
}
