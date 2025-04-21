import 'package:flutter/material.dart';
import 'industry_details.dart';

class IndustryRegistrationPage extends StatefulWidget {
  @override
  _IndustryRegistrationPageState createState() =>
      _IndustryRegistrationPageState();
}

class _IndustryRegistrationPageState extends State<IndustryRegistrationPage> {
  // Text controllers for input fields
  TextEditingController industryNameController = TextEditingController();
  TextEditingController industryAddressController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController industryTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Industry Registration",
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Registration Form Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Industry Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Industry Name
                    _buildTextField(
                      controller: industryNameController,
                      label: "Industry Name",
                      hint: "Enter your industry name",
                    ),
                    const SizedBox(height: 16),

                    // Industry Address
                    _buildTextField(
                      controller: industryAddressController,
                      label: "Industry Address",
                      hint: "Enter your industry address",
                    ),
                    const SizedBox(height: 16),

                    // Industry Type
                    _buildTextField(
                      controller: industryTypeController,
                      label: "Industry Type",
                      hint:
                          "Enter your industry type (e.g., Manufacturing, Retail, Food)",
                    ),
                    const SizedBox(height: 16),

                    // Business Registration Number
                    _buildTextField(
                      controller: registrationNumberController,
                      label: "Business Registration Number",
                      hint: "Enter your registration number",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Proceed Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndustryDetailsPage()),
                  );
                },
                child: const Text(
                  "Proceed",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Already Registered Button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndustryDetailsPage()),
                  );
                },
                child: const Text(
                  "Already Registered?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Text Field Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
