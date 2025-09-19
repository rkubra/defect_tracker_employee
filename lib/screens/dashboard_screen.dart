import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String empId;
  const DashboardScreen({super.key, required this.empId});

  Future<Map<String, dynamic>?> _getProjectDetails(String projectId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .where('projectId', isEqualTo: projectId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assigned Projects"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('assignments')
            .where('employeeId', isEqualTo: empId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No projects assigned"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final assignment = docs[index];
              final projectId = assignment['projectId'];
              final role = assignment['role'];

              return FutureBuilder<Map<String, dynamic>?>(
                future: _getProjectDetails(projectId),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading project..."));
                  }

                  if (!projectSnapshot.hasData || projectSnapshot.data == null) {
                    return const ListTile(title: Text("Project not found"));
                  }

                  final project = projectSnapshot.data!;

                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(
                        project['name'] ?? "Unknown Project",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Role: $role\nDuration: ${project['duration'] ?? 'N/A'}\nDescription: ${project['description'] ?? ''}",
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Location: ${position.latitude}, ${position.longitude}"),
            ));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Location error: $e")),
            );
          }
        },
        icon: const Icon(Icons.location_on),
        label: const Text("Live Location"),
      ),
    );
  }
}
