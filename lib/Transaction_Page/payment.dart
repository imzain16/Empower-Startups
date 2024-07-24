import 'package:empower/profiles/entrepreneur_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../profiles/investor_profile.dart';
import '../profiles/mentor_profile.dart';

class Payment extends StatefulWidget {
  final String userType;
  final String selectedPlan;

  const Payment({super.key, required this.userType, required this.selectedPlan});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool cashOnDelivery = false;
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  TextEditingController cVV = TextEditingController();

  Future<void> _savePaymentDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("PaymentDetails").doc(user.email).set({
        'cardHolderName': cardHolderName.text,
        'cardNumber': cardNumber.text,
        'userType': widget.userType,
        'selectedPlan': widget.selectedPlan,
        'expiryDate': expiryDate.text,
        'cvv': cVV.text,
      });
      _showSuccessAlertDialog();
    } else {
      Get.snackbar('Error', 'User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Payment method'),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              const Text(
                'Select Payment method',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: cashOnDelivery ? 'Credit Card' : 'Cash on Delivery',
                items: const [
                  DropdownMenuItem(
                    value: 'Cash on Delivery',
                    child: Text('Cash on Delivery'),
                  ),
                  DropdownMenuItem(
                    value: 'Credit Card',
                    child: Text('Credit Card'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    cashOnDelivery = value == 'Credit Card';
                  });
                },
              ),
              if (cashOnDelivery) ...[
                const SizedBox(height: 20),
                const Text(
                  'Enter Details',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                _buildTextField(controller: cardNumber, hintText: 'Card Number'),
                const SizedBox(height: 10),
                _buildTextField(controller: cardHolderName, hintText: 'Card Holder Name'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(controller: expiryDate, hintText: 'Expiry Date'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(controller: cVV, hintText: 'CVV'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (cashOnDelivery) {
                    if (cardNumber.text.isEmpty || cardHolderName.text.isEmpty || expiryDate.text.isEmpty || cVV.text.isEmpty) {
                      Get.snackbar('Field Missing', 'Please enter complete data');
                    } else {
                      _savePaymentDetails();
                    }
                  } else {
                    _proceedToProfile(widget.userType);
                  }
                },
                child: const Text('PAY NOW'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text('Successfully subscribed to the ${widget.selectedPlan} plan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _proceedToProfile(widget.userType);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _proceedToProfile(String userType) {
    // Navigate to different profiles based on userType
    if (userType == 'Entrepreneur') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EntrepreneurProfile()),
      );
    } else if (userType == 'Mentor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MentorProfile()),
      );
    } else if (userType == 'Investor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InvestorProfile()),
      );
    }
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String userType;

  const ProfilePage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userType Profile'),
      ),
      body: Center(
        child: Text('Welcome to the $userType profile page'),
      ),
    );
  }
}
