import 'package:flutter/material.dart';
import 'package:currency/Admin/AddCities.dart';
import 'package:currency/Admin/AdminLogin.dart';
import 'package:currency/Admin/Booking.dart';
import 'package:currency/Admin/Dashboard.dart';
import 'package:currency/Admin/RegisteredUser.dart';
import 'package:currency/Admin/UserContactUs.dart';
import 'package:currency/Admin/UserFeedback.dart';
import 'package:currency/Admin/addtrips.dart';
import 'package:currency/models/shared_pref_admin.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class WebMain extends StatefulWidget {
  const WebMain({super.key});
  static const String id = "WebMain";

  @override
  State<WebMain> createState() => _WebMainState();
}

class _WebMainState extends State<WebMain> {
  Widget _selectedScreen = AdminDashboard();
  String _adminName = 'Admin'; // Default name
  String _selectedRoute = AdminDashboard.id;

  @override
  void initState() {
    super.initState();
    _fetchAdminName();
  }

  Future<void> _fetchAdminName() async {
    final name = await SharedPreferenceHelper().getAdminData();
    if (name != null && name.isNotEmpty) {
      setState(() {
        _adminName = name;
      });
    }
  }

  void _chooseScreen(String? route) {
    setState(() {
      _selectedRoute = route ?? AdminDashboard.id;
      switch (_selectedRoute) {
        case AdminDashboard.id:
          _selectedScreen = AdminDashboard();
          break;
        case TripsPage.id:
          _selectedScreen = const TripsPage();
          break;
        case FetchFeedbackPage.id:
          _selectedScreen = FetchFeedbackPage();
          break;
        case AddCityForm.id:
          _selectedScreen = AddCityForm();
          break;
        case RegisteredUsers.id:
          _selectedScreen = RegisteredUsers();
          break;
        case UserContctUs.id:
          _selectedScreen = UserContctUs();
          break;
        case AdminBookingPage.id:
          _selectedScreen = AdminBookingPage();
          break;
        default:
          _selectedScreen = AdminDashboard();
      }
    });
  }

  void _logout() {
    SharedPreferenceHelper().clearAdminData(); // Clear stored admin data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminLogin()),
    ); // Update with your login route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "Welcome, $_adminName!",
                    style: const TextStyle(
                      color: Color(0xFF05A4C8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Your Control Hub Awaits!",
                    style: TextStyle(
                      color: Color(0xFF05A4C8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.asset(
                  '../assets/Logo/TripGif.gif',
                  height: 40,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF05A4C8)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF05A4C8)),
            onSelected: (value) {
              switch (value) {
                case 'User Panel':
                  Navigator.pushNamed(context, '/userPanel');
                  break;
                case 'About':
                  Navigator.pushNamed(context, '/about');
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'User Panel',
                  child: Text('User Panel'),
                ),
                const PopupMenuItem<String>(
                  value: 'About',
                  child: Text('About'),
                ),
              ];
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF05A4C8)),
            onPressed: _logout, // Call the logout function
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: CustomDrawer(
        selectedRoute: _selectedRoute,
        onSelect: (route) {
          Navigator.pop(context); // Close drawer
          _chooseScreen(route);
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF05A4C8), Colors.black, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AdminScaffold(
          sideBar: SideBar(
            iconColor: const Color(0xFF05A4C8),
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (item) => _chooseScreen(item.route),
            items: const [
              AdminMenuItem(
                title: "Dashboard",
                icon: Icons.dashboard,
                route: AdminDashboard.id,
              ),
              AdminMenuItem(
                title: "Registered Users",
                icon: Icons.person,
                route: RegisteredUsers.id,
              ),
              AdminMenuItem(
                title: "User Contact Us",
                icon: Icons.person,
                route: UserContctUs.id,
              ),
              AdminMenuItem(
                title: "Add Form City",
                icon: Icons.person,
                route: AddCityForm.id,
              ),
              AdminMenuItem(
                title: "User Feedbacks",
                icon: Icons.feedback,
                route: FetchFeedbackPage.id,
              ),
              AdminMenuItem(
                title: "TripsPage",
                icon: Icons.warning,
                route: TripsPage.id,
              ),
              AdminMenuItem(
                title: "Booking",
                icon: Icons.wallet,
                route: AdminBookingPage.id,
              ),
            ],
            selectedRoute: _selectedRoute,
            backgroundColor: Colors.white,
            activeTextStyle: const TextStyle(color: Color(0xFF05A4C8)),
          ),
          body: _selectedScreen,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    final bool isSelected = route == _selectedRoute;
    return ListTile(
      leading: Icon(icon,
          color: isSelected ? const Color(0xFF05A4C8) : Colors.black),
      title: Text(title,
          style: TextStyle(
              color: isSelected ? const Color(0xFF05A4C8) : Colors.black)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        _chooseScreen(route);
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final String selectedRoute;
  final Function(String) onSelect;

  const CustomDrawer({
    Key? key,
    required this.selectedRoute,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF05A4C8),
              Colors.white,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    route: AdminDashboard.id,
                  ),
                  _buildDrawerItem(
                    icon: Icons.feedback,
                    title: 'Feedbacks',
                    route: FetchFeedbackPage.id,
                  ),
                  _buildDrawerItem(
                    icon: Icons.add_location,
                    title: 'Add City',
                    route: AddCityForm.id,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Registered Users',
                    route: RegisteredUsers.id,
                  ),
                  _buildDrawerItem(
                    icon: Icons.contact_mail,
                    title: 'User Contact Us',
                    route: UserContctUs.id,
                  ),
                  _buildDrawerItem(
                    icon: Icons.warning,
                    title: 'TripsPage',
                    route: TripsPage.id,
                  ),
                  _buildDrawerItem(
                    icon: Icons.wallet,
                    title: 'Booking',
                    route: AdminBookingPage.id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    final bool isSelected = route == selectedRoute;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      onTap: () {
        onSelect(route);
      },
    );
  }
}
