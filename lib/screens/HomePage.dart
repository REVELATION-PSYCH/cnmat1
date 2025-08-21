// home_page.dart
import 'package:cnmat/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ✅ import ApiService

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;

  final LatLng _initialPosition = const LatLng(-15.416, 28.282); // Lusaka

  // Service list
  final List<String> services = [
    'Wound Care',
    'Medication Administration',
    'IV Therapy',
    'Physiotherapy',
    'Post-Surgery Care'
  ];

  // Selected services
  final List<bool> selectedServices = List.generate(5, (_) => false);

  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  String loadingMessage = "Requesting a nurse...";

  // Helper function
  String _getSelectedServices(List<bool> selections, List<String> services) {
    List<String> chosen = [];
    for (int i = 0; i < selections.length; i++) {
      if (selections[i]) chosen.add(services[i]);
    }
    return chosen.join(", ");
  }

  void _onMapTap(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void _showRequestNurseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Request Nurse"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Select Services"),
                    const SizedBox(height: 10),
                    ...List.generate(
                      services.length,
                      (index) => CheckboxListTile(
                        title: Text(services[index]),
                        value: selectedServices[index],
                        onChanged: (val) {
                          setDialogState(() {
                            selectedServices[index] = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Date: "),
                        Text("${selectedDate.toLocal()}".split(' ')[0]),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setDialogState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (selectedLocation == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please select a location on map')),
                            );
                            return;
                          }

                          String selectedServicesStr =
                              _getSelectedServices(selectedServices, services);

                          if (selectedServicesStr.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please select at least one service')),
                            );
                            return;
                          }

                          setDialogState(() {
                            isLoading = true;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Request in Progress'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 20),
                                    Text(loadingMessage),
                                  ],
                                ),
                              );
                            },
                          );

                          // ✅ Call backend
                          bool success = await ApiService().requestNurse(
                            selectedServicesStr,
                            selectedDate.toIso8601String(),
                            selectedLocation!.latitude,
                            selectedLocation!.longitude,
                          );

                          Navigator.of(context, rootNavigator: true)
                              .pop(); // close progress

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Nurse requested successfully ✅')),
                            );
                            Navigator.pop(context); // close main dialog
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to request nurse ❌')),
                            );
                          }

                          setDialogState(() {
                            isLoading = false;
                          });
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Request"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              onTap: _onMapTap,
              markers: selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId("selected"),
                        position: selectedLocation!,
                      )
                    }
                  : {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showRequestNurseDialog,
              child: const Text("Request Nurse"),
            ),
          ),
        ],
      ),
    );
  }
}
