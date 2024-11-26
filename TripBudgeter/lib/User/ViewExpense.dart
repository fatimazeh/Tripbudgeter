import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewExpensesPage extends StatefulWidget {
  const ViewExpensesPage({super.key});

  @override
  _ViewExpensesPageState createState() => _ViewExpensesPageState();
}

class _ViewExpensesPageState extends State<ViewExpensesPage> {
  String _selectedCategory = 'All';
  DateTimeRange? _selectedDateRange;
  double? _minAmount;
  double? _maxAmount;

  // Firestore reference
  final CollectionReference expensesCollection = FirebaseFirestore.instance.collection('expenses');

  Stream<QuerySnapshot> _getFilteredExpenses() {
    Query query = expensesCollection;

    if (_selectedCategory != 'All') {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    if (_selectedDateRange != null) {
      query = query
          .where('date', isGreaterThanOrEqualTo: _selectedDateRange!.start)
          .where('date', isLessThanOrEqualTo: _selectedDateRange!.end);
    }

    if (_minAmount != null) {
      query = query.where('amount', isGreaterThanOrEqualTo: _minAmount);
    }

    if (_maxAmount != null) {
      query = query.where('amount', isLessThanOrEqualTo: _maxAmount);
    }

    return query.snapshots();
  }

  // Method to select date range
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange ?? DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Expenses')),
      body: Column(
        children: [
          // Filters section
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedCategory,
                items: ['All', 'Food', 'Travel', 'Shopping', 'Bills', 'Entertainment'].map((String category) {
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
                hint: const Text('Category'),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDateRange(context),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {}); // Apply filters
                },
                child: const Text('Filter'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredExpenses(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var expense = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text('\$${expense['amount']}'),
                      subtitle: Text('${expense['category']} - ${DateFormat.yMd().format((expense['date'] as Timestamp).toDate())}'),
                      trailing: Text(expense['notes']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
