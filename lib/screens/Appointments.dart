import 'package:cnmat/screens/AppScaffold.dart';
import 'package:flutter/material.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  List<Map<String, String>> upcomingAppointments = [
    {
      'date': '29th Dec, 2024 at 2:00 PM',
      'service': 'General Checkup',
      'Nurse': 'Miss Angela'
    },
    {
      'date': '15th Dec, 2024 at 11:00 AM',
      'service': 'Follow-up',
      'Nurse': 'Miss Angela'
    },
  ];

  List<Map<String, String>> pastAppointments = [
    {
      'date': '29th Oct, 2024 at 2:00 PM',
      'service': 'General Checkup',
      'Nurse': 'Miss Angela'
    },
    {
      'date': '15th Sept, 2024 at 11:00 AM',
      'service': 'Follow-up',
      'Nurse': 'Miss Angela'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Appointments',
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppointmentSection(
              context,
              title: 'Upcoming Appointments',
              appointments: upcomingAppointments,
              color: Colors.lightBlue[50],
            ),
            const SizedBox(height: 25),
            _buildAppointmentSection(
              context,
              title: 'Past Appointments',
              appointments: pastAppointments,
              color: Colors.grey[100],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentSection(
    BuildContext context, {
    required String title,
    required dynamic appointments,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  if (appointments is List<Map<String, String>>) {
                    return _buildAppointmentTile(
                      context,
                      appointment: appointments[index]['date'] ?? '',
                      service: appointments[index]['service'] ?? '',
                    );
                  } else if (appointments is List<String>) {
                    return _buildAppointmentTile(context,
                        appointment: appointments[index]);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTile(
    BuildContext context, {
    required String appointment,
    String? service,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          _showAppointmentDetails(context, appointment, service);
        },
        hoverColor: Colors.blue.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (service != null)
                Text(
                  'Service: $service',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(
    BuildContext context,
    String appointment,
    String? service,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Appointment Details'),
          content: Text('Appointment: $appointment\nService: $service'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
