import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedCategory = 'Food'; // Default category
  DateTime _selectedDate = DateTime.now();

  // Firestore reference
  final CollectionReference expensesCollection = FirebaseFirestore.instance.collection('expenses');

  Future<void> _addExpense() async {
    if (_formKey.currentState!.validate()) {
      await expensesCollection.add({
        'amount': double.parse(_amountController.text),
        'category': _selectedCategory,
        'date': _selectedDate,
        'notes': _notesController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense added successfully!')));
      
      // Clear form
      _amountController.clear();
      _notesController.clear();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Color(0xFF05a4c8),
          //       Color.fromARGB(255, 183, 127, 127),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Expense",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "Fill in the details below to add your expense.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField("Amount", _amountController, keyboardType: TextInputType.number),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: ['Food', 'Travel', 'Shopping', 'Bills', 'Entertainment'].map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Category',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Text('Date: ${DateFormat.yMd().format(_selectedDate)}', style: const TextStyle(color: Colors.white))),
                          IconButton(
                            icon: const Icon(Icons.calendar_today, color: Colors.white),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField("Notes", _notesController, maxLines: 2),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF05a4c8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: _addExpense,
                          child: const Text(
                            "Add Expense",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscureText = false, TextInputType? keyboardType, int? maxLines}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
    );
  }
}
