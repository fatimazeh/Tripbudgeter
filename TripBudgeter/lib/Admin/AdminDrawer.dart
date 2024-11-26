

import 'package:currency/Admin/Dashboard.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black, // Blue color
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboard()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange, color: Colors.white),
            title: const Text('Exchange Rates', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to exchange rate management page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
