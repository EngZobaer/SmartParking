import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

import 'navbar.dart';
import 'new.dart';
import 'drawer.dart'; // Import the CustomDrawer

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _currentTime = '';
  String _currentDate = '';
  String _selectedFilter = 'Today Parked'; // Default filter
  late Timer _timer;

  String? _expandedVehicleId;

  int _currentIndex = 0;
  String _searchQuery = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _parkedVehiclesStream;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) _updateDateTime();
    });

    _parkedVehiclesStream =
        FirebaseFirestore.instance
            .collection('parking_info')
            .orderBy('timestamp', descending: true)
            .snapshots();

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

  List<Map<String, dynamic>> _filterParkedVehicles(QuerySnapshot snapshot) {
    List<Map<String, dynamic>> filtered = [];

    filtered =
        snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;

          String token = data['token'] ?? 'N/A';
          String name = data['name'] ?? 'No Name';
          String id = data['studentId'] ?? 'N/A';
          String status =
              (data['parked']?.isEmpty ?? true)
                  ? 'N/A'
                  : data['status'] ?? 'N/A';
          String vehicleType = data['vehicleType'] ?? 'N/A';
          String serial =
              (data['serial'] ?? '').toString().isEmpty
                  ? 'N/A'
                  : data['serial'].toString();

          DateTime timestamp =
              (data['timestamp'] as Timestamp)
                  .toDate(); // Convert Timestamp to DateTime

          return {
            'token': token,
            'name': name,
            'id': id,
            'status': status,
            'vehicleType': vehicleType,
            'serial': serial,
            'timestamp': timestamp,
            'date': DateFormat(
              'yyyy-MM-dd',
            ).format(timestamp), // Format date for display
          };
        }).toList();

    // Apply search query filter (if any)
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((vehicle) {
            return vehicle['id']!.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          }).toList();
    }

    // Apply the filter for Today Parked status
    if (_selectedFilter == 'Today Parked') {
      final today = DateTime.now();

      filtered =
          filtered.where((vehicle) {
            // Convert timestamp to the local timezone
            DateTime vehicleDate = vehicle['timestamp']!;
            DateTime localDate = DateTime(
              vehicleDate.year,
              vehicleDate.month,
              vehicleDate.day,
            ); // Normalize to date only

            return vehicle['status'] == 'parked' &&
                localDate.isAtSameMomentAs(today); // Compare with today's date
          }).toList();
    } else if (_selectedFilter == 'Release Parked') {
      filtered =
          filtered.where((vehicle) => vehicle['status'] == 'released').toList();
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

  void _releaseVehicle(String id) async {
    // Implement release vehicle functionality
    print("Releasing vehicle with ID: $id");
  }

  void _cancelParking(String id) async {
    // Implement cancel parking functionality
    print("Cancelling parking for vehicle with ID: $id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parking Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Exit App',
            onPressed: () {
              SystemNavigator.pop();
            },
            color: Colors.white, // Set logout icon color to black
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Set all icons in AppBar to black
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _parkedVehiclesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No vehicles found'));
                  }

                  final filteredVehicles = _filterParkedVehicles(
                    snapshot.data!,
                  );

                  return Scrollbar(
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle['date']!, // Show formatted date here
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),

                                      Text(
                                        vehicle['token']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle['serial'] ??
                                            '', // Display empty if no serial
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Text(
                                        vehicle['id']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      vehicle['name']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      vehicle['vehicleType']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  isExpanded
                                      ? Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed:
                                                () => _releaseVehicle(
                                                  vehicle['id']!,
                                                ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Release'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed:
                                                () => _cancelParking(
                                                  vehicle['id']!,
                                                ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      )
                                      : IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        color: Colors.white,
                                        iconSize: 28,
                                        tooltip: 'Actions',
                                        onPressed: () {
                                          setState(() {
                                            if (_expandedVehicleId ==
                                                vehicle['id']) {
                                              _expandedVehicleId = null;
                                            } else {
                                              _expandedVehicleId =
                                                  vehicle['id'];
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
                  );
                },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(filterName),
    );
  }
}
