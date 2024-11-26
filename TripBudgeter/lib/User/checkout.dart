import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency/services/share_preference.dart';

class CheckoutPage extends StatefulWidget {
  final QueryDocumentSnapshot trip;

  const CheckoutPage({Key? key, required this.trip}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController travelersController = TextEditingController();
  String? email;
  String? name;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userEmail = await SharedPrefHelper().getUserEmail();
      final userName = await SharedPrefHelper().getUserName();
      setState(() {
        email = userEmail;
        name = userName;
        isLoading = false; // Stop loading once data is fetched
      });
    } catch (error) {
      print('Error fetching user info: $error');
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var tripName = widget.trip['tripName'] ?? 'No Trip Name';
    var destination = widget.trip['destination'] ?? 'No Destination';
    var budget = widget.trip['budget'] ?? 0.0;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF05a4c8),
                Color.fromARGB(255, 183, 127, 127),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTripInfo(tripName, destination, budget),
                  const SizedBox(height: 20),
                  const Text(
                    'Traveler Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  _buildUserInfo(),
                  _buildTravelerInput(),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentInput(),
                  const SizedBox(height: 20),
                  _buildConfirmButton(tripName),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripInfo(String tripName, String destination, double budget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tripName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          'Destination: $destination',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          'Budget: \$${budget.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (email != null && name != null) {
      return Column(
        children: [
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            readOnly: true,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: email,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            readOnly: true,
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const Text('User information not available', style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildTravelerInput() {
    return TextFormField(
      controller: travelersController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Number of Travelers',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the number of travelers';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentInput() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the expiry date';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the CVV';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmButton(String tripName) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking confirmed for $tripName')),
            );
          }
        },
        child: const Text('Confirm Booking'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
