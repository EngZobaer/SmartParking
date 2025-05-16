import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'navbar.dart';
import 'new.dart';
import 'login.dart'; // Import your login page here

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _currentTime = '';
  String _currentDate = '';
  String _selectedFilter = 'Today Parked';
  late Timer _timer;

  String? _expandedVehicleId;

  int _currentIndex = 0;
  String _searchQuery = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, String>> _parkedVehicles = [
    {'serial': '1', 'name': 'Zobaer', 'type': 'Motor Cycle', 'id': '101', 'status': 'parked'},
    {'serial': '2', 'name': 'Sojib', 'type': 'Car', 'id': '102', 'status': 'released'},
    {'serial': '3', 'name': 'Rifat', 'type': 'Bike', 'id': '103', 'status': 'parked'},
    {'serial': '4', 'name': 'Mitu', 'type': 'Car', 'id': '104', 'status': 'released'},
    {'serial': '5', 'name': 'Zobaer', 'type': 'Motor Cycle', 'id': '105', 'status': 'parked'},
    {'serial': '6', 'name': 'Sojib', 'type': 'Car', 'id': '106', 'status': 'parked'},
    {'serial': '7', 'name': 'Rifat', 'type': 'Bike', 'id': '107', 'status': 'released'},
    {'serial': '8', 'name': 'Mitu', 'type': 'Car', 'id': '108', 'status': 'parked'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) _updateDateTime();
    });

    // Redirect to login if no user is logged in
    if (_auth.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    setState(() {
      _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
  }

  List<Map<String, String>> _filterParkedVehicles() {
    List<Map<String, String>> filtered = _parkedVehicles;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((vehicle) {
        return vehicle['id']!.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedFilter == 'Today Parked') {
      filtered = filtered.where((v) => v['status'] == 'parked').toList();
    } else if (_selectedFilter == 'Release Parked') {
      filtered = filtered.where((v) => v['status'] == 'released').toList();
    }

    return filtered;
  }

  void _onNavBarTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewDataForm()),
      );
    } else {
      setState(() {
        _currentIndex = index;
        _expandedVehicleId = null;
      });
    }
  }

  void _releaseVehicle(String id) {
    setState(() {
      int idx = _parkedVehicles.indexWhere((v) => v['id'] == id);
      if (idx != -1) {
        _parkedVehicles[idx]['status'] = 'released';
      }
      _expandedVehicleId = null;
    });
  }

  void _cancelParking(String id) {
    setState(() {
      _parkedVehicles.removeWhere((v) => v['id'] == id);
      _expandedVehicleId = null;
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    // Navigate to login page and clear all previous routes
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = _filterParkedVehicles();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parking Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   tooltip: 'Logout',
          //   onPressed: _logout,
          // ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Exit App',
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  _currentDate,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by Vehicle ID...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('Today Parked'),
                _buildFilterButton('Release Parked'),
                _buildFilterButton('All Vehicles'),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  SizedBox(
                    width: 40,
                    child: Text(
                      'Sl',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Vehicle Type',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      'Action',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredVehicles.isEmpty
                  ? Center(
                child: Text(
                  'No vehicles found',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
                ),
              )
                  : Scrollbar(
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(5),
                child: ListView.separated(
                  itemCount: filteredVehicles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vehicle = filteredVehicles[index];
                    final isExpanded = _expandedVehicleId == vehicle['id'];

                    return Material(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  vehicle['serial']!,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  vehicle['name']!,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  vehicle['type']!,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              isExpanded
                                  ? Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _releaseVehicle(vehicle['id']!),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Release'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _cancelParking(vehicle['id']!),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              )
                                  : IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.white,
                                iconSize: 28,
                                tooltip: 'Actions',
                                onPressed: () {
                                  setState(() {
                                    if (_expandedVehicleId == vehicle['id']) {
                                      _expandedVehicleId = null;
                                    } else {
                                      _expandedVehicleId = vehicle['id'];
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

  Widget _buildFilterButton(String filterName) {
    final bool isSelected = _selectedFilter == filterName;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filterName;
          _expandedVehicleId = null;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.teal : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(filterName),
    );
  }
}
