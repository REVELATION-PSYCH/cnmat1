import 'package:carousel_slider/carousel_slider.dart';
import 'package:cnmat/screens/AppScaffold.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cnmat/screens/LocationSelectionPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> upcomingAppointments = [
    '29th Dec, 2024 at 2:00 PM',
    '15th Dec, 2024 at 11:00 AM',
  ];
  String userLocation = 'Fetching location...';
  bool isLoading = false;
  String loadingMessage = "Looking for available nurses nearby...";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        userLocation = 'Location services are disabled';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          userLocation = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        userLocation =
            'Location permissions are permanently denied, we cannot request location.';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    // Use geocoding to get the location name from the coordinates
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0]; // Take the first placemark result
      setState(() {
        userLocation = '${place.locality}, ${place.country}'; // Location name
      });
    } catch (e) {
      setState(() {
        userLocation = 'Failed to get location name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppScaffold(
      title: 'CNMAT',
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card Request for Follow Up Care
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Animation/picture
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        'assets/images/animation.json',
                      ),
                    ),
                    const SizedBox(width: 25),
                    // Text + button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Follow Up Care?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Request for a Nurse Now',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              _showRequestNurseDialog(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'Request',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),

            // Upcoming Appointments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.green[800] : Colors.greenAccent[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Appointments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'You have ${upcomingAppointments.length} upcoming appointments with your nurse:',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: upcomingAppointments
                          .map((appointment) => Text(
                                '- $appointment',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Sliding Images
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 6),
                enlargeCenterPage: true,
              ),
              items: [
                'assets/images/image1.jpg',
                'assets/images/image2.jpg',
                'assets/images/image3.png',
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[700] : Colors.amber,
                      ),
                      child: Image.asset(
                        i,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestNurseDialog(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    List<String> services = [
      'Medication Administration',
      'Wound Dressing and Care',
      'Vital Sign Monitoring',
      'Patient Education and Counseling',
      'Rehabilitation Exercises',
    ];
    List<bool> selectedServices =
        List.generate(services.length, (index) => false);

    LatLng? selectedLocation; // To track the selected location
    bool isLocationSelected = false; // To track if location is selected
    bool isLoading = false;
    String loadingMessage = "Looking for available nurses nearby...";
    String locationName = ""; // Variable to store the location name

    Future<void> getLocationName(double latitude, double longitude) async {
      try {
        // Use geocoding to get the location name from the coordinates
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0]; // Take the first placemark result
        locationName = '${place.locality}, ${place.country}'; // Location name
      } catch (e) {
        locationName = "Lusaka";
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> startLoadingSimulation() async {
              setState(() {
                isLoading = true;
              });

              // Update messages over time
              await Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  loadingMessage = "This won't take long...";
                });
              });

              await Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  loadingMessage = "We'll contact you soon.";
                });
              });

              await Future.delayed(const Duration(seconds: 2), () {
                // Close the "Request in Progress" dialog first
                Navigator.pop(context); // This closes the inner progress dialog

                // Close the main dialog after the progress dialog closes
                Navigator.of(context, rootNavigator: true)
                    .pop(); // Close the main dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nurse requested successfully')),
                );
                setState(() {
                  isLoading = false;
                });
              });
            }

            return AlertDialog(
              title: const Text('Request a Nurse'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date and Time Picker
                  InkWell(
                    onTap: () => _pickDateAndTime(context, (pickedDateTime) {
                      if (pickedDateTime.isAfter(DateTime.now())) {
                        setState(() {
                          selectedDate = pickedDateTime;
                        });
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year} at ${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}"),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location Selection Button
                  ElevatedButton(
                    onPressed: () async {
                      Position position = await Geolocator.getCurrentPosition();
                      LatLng? location = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationSelectionPage(
                            currentPosition: position,
                            service: '',
                            date: selectedDate,
                          ),
                        ),
                      );
                      if (location != null) {
                        setState(() {
                          selectedLocation = location;
                          isLocationSelected = true;
                        });
                        await getLocationName(selectedLocation!.latitude,
                            selectedLocation!.longitude);
                      }
                    },
                    child: const Text('Select Location'),
                  ),
                  if (isLocationSelected)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Location selected: $locationName",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Service Selection Checkboxes
                  ...services.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String service = entry.value;
                    return CheckboxListTile(
                      title: Text(service),
                      value: selectedServices[idx],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedServices[idx] = value ?? false;
                        });
                      },
                    );
                  }),
                ],
              ),
              actions: [
                // Request Button
                if (isLocationSelected)
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
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
                            await startLoadingSimulation();
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
                        : const Text('Request'),
                  ),
                // Cancel Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _pickDateAndTime(
      BuildContext context, Function(DateTime) onDateTimePicked) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimePicked(pickedDateTime);
      }
    }
  }

  String _getSelectedServices(
      List<bool> selectedServices, List<String> services) {
    return services
        .asMap()
        .entries
        .where((entry) => selectedServices[entry.key])
        .map((entry) => entry.value)
        .join(', ');
  }

  void _resetServiceSelection(List<bool> selectedServices) {
    for (int i = 0; i < selectedServices.length; i++) {
      selectedServices[i] = false;
    }
  }
}
