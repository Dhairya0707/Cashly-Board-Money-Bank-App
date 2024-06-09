// ignore: file_names
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Cashly Board Money Bank App!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'The Perfect Companion for Your Board Games!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Say goodbye to messy cash handling and hello to seamless game management.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 30.0),
            const Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeatureItem(
                  title: 'User Authentication',
                  description:
                      'Simple login and sign-up process with random avatar selection.',
                ),
                FeatureItem(
                  title: 'Game Management',
                  description: 'Create and join game rooms with ease.',
                ),
                FeatureItem(
                  title: 'Direct Code Sharing',
                  description:
                      'Share game room codes directly within the app for quick access.',
                ),
                FeatureItem(
                  title: 'Transaction Handling',
                  description: 'Seamless money transfers between players.',
                ),
                FeatureItem(
                  title: 'In-App Chat',
                  description:
                      'Communicate with friends instantly during the game.',
                ),
                FeatureItem(
                  title: 'Transaction History',
                  description: 'Keep track of all your transactions.',
                ),
                FeatureItem(
                  title: 'Firebase Integration',
                  description: 'Secure and reliable data storage.',
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            const Text(
              'Developer:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              onTap: () {
                _launchUrl("https://dhairyadarji.web.app/");
              },
              leading: const Icon(Icons.person),
              title: const Text(
                'Dhairya Darji',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              onTap: () {
                _launchUrl("mailto:dhairyadarji025@gmail.com");
              },
              leading: const Icon(Icons.email),
              title: const Text('Email: dhairyadarji025@gmail.com'),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              onTap: () {
                _launchUrl(
                    "https://famous-arithmetic-ef4.notion.site/Cashly-Board-Money-Bank-App-5e5e46efdf6b4493a5da595eee42b018?pvs=4");
              },
              leading: const Icon(Icons.web),
              title: const Text('Cashly website for latest updates'),
            ),
            const SizedBox(height: 30.0),
            const Text(
              'GitHub Repository:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              onTap: () {
                _launchUrl(
                    "https://github.com/Dhairya0707/Cashly-Board-Money-Bank-App");
              },
              leading: const Icon(Icons.code),
              title:
                  const Text('Cashly Board Money Bank App GitHub Repository'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const FeatureItem(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              '$title: $description',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
