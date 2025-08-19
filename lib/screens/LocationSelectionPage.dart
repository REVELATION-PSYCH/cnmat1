import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationSelectionPage extends StatefulWidget {
  final Position currentPosition;

  const LocationSelectionPage(
      {super.key,
      required this.currentPosition,
      required String service,
      required DateTime date});

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  late LatLng selectedLocation;
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    selectedLocation = LatLng(
        widget.currentPosition.latitude, widget.currentPosition.longitude);
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: selectedLocation,
          initialZoom: 15.0, // Set initial zoom level here
          onTap: (tapPosition, point) {
            setState(() {
              selectedLocation = point;
            });
          },
        ),
        mapController: mapController,
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: selectedLocation,
                width: 80.0,
                height: 80.0,
                child:
                    const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ], // Pass the map controller
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedLocation);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
