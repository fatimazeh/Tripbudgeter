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
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
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
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              Row(
                children: [
                  Expanded(child: Text('Date: ${DateFormat.yMd().format(_selectedDate)}')),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              ElevatedButton(
                onPressed: _addExpense,
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
