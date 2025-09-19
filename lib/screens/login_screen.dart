import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    String empId = idController.text.trim();
    String code = codeController.text.trim();

    try {
      // 🔎 Look for employee by fields (NOT doc ID)
      final query = await FirebaseFirestore.instance
          .collection('employees')
          .where('employeeId', isEqualTo: empId)
          .where('code', isEqualTo: code)
          .get();

      if (query.docs.isNotEmpty) {
        // Pass empId to Dashboard
        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
          arguments: empId,
        );
      } else {
        setState(() => _error = "Invalid Employee ID or Code");
      }
    } catch (e) {
      setState(() => _error = "Error: $e");
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.bug_report, size: 100, color: Colors.indigo),
                const SizedBox(height: 20),
                const Text("Defect Tracker",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: "Employee ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: "Unique Code",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
