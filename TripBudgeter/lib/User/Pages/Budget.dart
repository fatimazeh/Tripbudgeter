import 'package:currency/User/Pages/addbudget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Budgetscreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const Budgetscreen({super.key, required this.userData});

  @override
  _BudgetscreenState createState() => _BudgetscreenState();
}

class _BudgetscreenState extends State<Budgetscreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double totalBalance = 0.00;
  double latestIncome = 0.00;
  double accountBalance = 0.00;
  double TotalTripExpens = 0.00;

  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> tripTransactions = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchAllIncomeTransactions();
    _fetchTripExpensTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllIncomeTransactions() async {
    try {
      User? currentUser = _auth.currentUser;
      String? uid = currentUser?.uid;

      if (uid != null) {
        QuerySnapshot incomeSnapshot = await _firestore
            .collection('Add Budgets')
            .doc(uid)
            .collection('Budgets')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

        QuerySnapshot expenseSnapshot = await _firestore
            .collection('Add Budgets')
            .doc(uid)
            .collection('Budgets')
            .orderBy('createdAt', descending: true)
            .get();

        double latestIncome = 0.00;
        if (incomeSnapshot.docs.isNotEmpty) {
          var data = incomeSnapshot.docs.first.data() as Map<String, dynamic>;
          latestIncome = data['amount'] ?? 0.00;
        }

        List<Map<String, dynamic>> expenseTransactions =
            expenseSnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            "category": data['category'] ?? 'Expense',
            "amount": data['amount'],
            "icon": Icons.arrow_upward,
            "date": data['date'] ?? 'N/A',
            "type": "expense",
          };
        }).toList();

        double totalBalance = expenseTransactions.fold(0, (sum, item) => sum + (item['amount'] ?? 0.0));

        setState(() {
          transactions = expenseTransactions;
          this.totalBalance = totalBalance;
          this.latestIncome = latestIncome;
          this.accountBalance = totalBalance - TotalTripExpens;
        });
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  Future<void> _fetchTripExpensTransactions() async {
    try {
      User? currentUser = _auth.currentUser;
      String? uid = currentUser?.uid;

      if (uid != null) {
        QuerySnapshot bookExpenseSnapshot = await _firestore
            .collection('bookings')
            .where('userId', isEqualTo: uid)
            .get();

        List<Map<String, dynamic>> tripTransactionsList = bookExpenseSnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            "category": data['tripName'] ?? 'Trip Expense',
            "amount": data['budget'] ?? 0.0,
            "icon": Icons.arrow_downward,
            "date": (data['StartDate'] as Timestamp).toDate().toString() ?? 'N/A',
            "type": "expense",
          };
        }).toList();

        double totalTripExpenses = tripTransactionsList.fold(0, (sum, item) => sum + (item['amount'] ?? 0.0));

        setState(() {
          TotalTripExpens = totalTripExpenses;
          tripTransactions = tripTransactionsList;
        });
      }
    } catch (e) {
      print('Error fetching trip expenses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Color.fromARGB(255, 233, 117, 253)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Account Balance\n\$${accountBalance.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Income\n\$${latestIncome.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
                          Text('Total Expenses\n\$${TotalTripExpens.toStringAsFixed(2)}', style: const TextStyle(color: Color.fromARGB(255, 255, 225, 0), fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Transaction In"),
                    Tab(text: "Transaction Out"),
                  ],
                ),
                const SizedBox(height: 10),
                // Using a SizedBox instead of Expanded to give the TabBarView a fixed height
                SizedBox(
                  height: 400, // Adjust this height as needed
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      transactions.isNotEmpty
                          ? ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  leading: CircleAvatar(
                                    backgroundColor: transaction['type'] == "income" ? Colors.green : Colors.red,
                                    child: Icon(transaction['icon'], color: Colors.white),
                                  ),
                                  title: Text(transaction['category']),
                                  subtitle: Text(transaction['date']),
                                  trailing: Text(
                                    '\$${transaction['amount'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: transaction['type'] == "income" ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(child: Text('No transactions available')),
                      tripTransactions.isNotEmpty
                          ? ListView.builder(
                              itemCount: tripTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction = tripTransactions[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(transaction['icon'], color: Colors.white),
                                  ),
                                  title: Text(transaction['category']),
                                  subtitle: Text(transaction['date']),
                                  trailing: Text(
                                    '\$${transaction['amount'].toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            )
                          : const Center(child: Text('No trip transactions available')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
