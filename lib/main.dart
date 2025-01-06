import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure your ApiService is imported

void main() {
  runApp(const SurfSecureApp());
}

class SurfSecureApp extends StatelessWidget {
  const SurfSecureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surf Secure',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  String _classificationResult = '';
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService =
        ApiService('http://127.0.0.1:5000/predict'); // Your Flask server URL
  }

  void classifyUrl(String url) async {
    if (url.isEmpty) {
      setState(() {
        _classificationResult = 'Please enter a valid URL';
      });
      return;
    }

    try {
      final result = await apiService.fetchData(url); // Call the API
      setState(() {
        _classificationResult = result == 1
            ? "probably safe"
            : "probably a phishing URL"; // Update the result
      });
    } catch (e) {
      setState(() {
        _classificationResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // App Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF033AA8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Surf Secure',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    TextButton(
                        onPressed: () {},
                        child: const Text('About Us',
                            style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Content
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),
                            const Text('Enter URL to verify:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Container(
                              height: 50, // Fixed height for TextField
                              child: TextField(
                                controller: _urlController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter URL',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  classifyUrl(_urlController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0)),
                                child: const Text('Submit'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_classificationResult.isNotEmpty)
                              Text(
                                _classificationResult,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _classificationResult ==
                                          "probably a phishing URL"
                                      ? Colors.red // Red for unsafe
                                      : Colors.green, // Green for safe
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right Column
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/big_logo.jpeg',
                          fit: BoxFit.contain,
                          width: 300, // Fixed width for image
                          height: 300, // Fixed height for image
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
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
