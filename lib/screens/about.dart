import 'package:cnmat/screens/AppScaffold.dart';
import 'package:flutter/material.dart';

class about extends StatelessWidget {
  const about({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'About App',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Name
            const Center(
              child: Text(
                'CNMAT - Clinical Nursing Mobile Application',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // App Description
            const Text(
              'CNMAT is a platform that connects patients with nurses for home care follow-up services. It is designed to make requesting nursing care easier, faster, and more accessible, ensuring patients receive quality care in the comfort of their own homes.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Features Section
            _buildSectionTitle('Features'),
            _buildFeatureItem(
              icon: Icons.health_and_safety,
              title: 'Home Care Services',
              description:
                  'Request home care services from qualified nurses nearby.',
            ),

            _buildFeatureItem(
              icon: Icons.chat_bubble_outline,
              title: 'In-app Messaging',
              description:
                  'Communicate directly with your nurse for follow-up care details.',
            ),
            _buildFeatureItem(
              icon: Icons.payment,
              title: 'Secure Payments',
              description:
                  'Easily manage payments for services securely through the app.',
            ),

            const SizedBox(height: 20),

            // App Version and Contact Information
            _buildSectionTitle('Version & Contact'),
            _buildInfoItem('Version', '1.0.0'),
            _buildInfoItem('Support Email', 'support@cnmatapp.com'),
          ],
        ),
      ),
    );
  }

  // Widget to create a section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  // Widget for app features with icons
  Widget _buildFeatureItem(
      {required IconData icon,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for app info (version, contact, etc.)
  Widget _buildInfoItem(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            info,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
