 import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, String>> projects = const [
    {"title": "Inventory Management", "status": "In Progress"},
    {"title": "Defect Tracker", "status": "Completed"},
    {"title": "E-commerce App", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              Navigator.pushNamed(context, '/location');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(projects[index]["title"]!),
                subtitle: Text("Status: ${projects[index]["status"]}"),
                leading: const Icon(Icons.folder, color: Colors.indigo),
              ),
            );
          },
        ),
      ),
    );
  }
}
