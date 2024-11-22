import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:track_lari/pages/login_page.dart';
import 'package:track_lari/service/Auth_Service.dart';
import 'package:track_lari/service/info_user.dart';

import 'dashboard_page.dart';
import 'personel_page.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  int _currentIndex = 2; // Set the initial index to 2 for the "Akun" page

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the appropriate page based on the tapped index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PersonelPage()),
        );
        break;
      case 2:
        // Stay on the current page for "Akun"
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF161616),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Smaller Profile Picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/image/logo_lari.png', // Path to the profile picture
                      width: 50, // Smaller width
                      height: 50, // Smaller height
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Profile Information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: InfoUser().infoMazzeh(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return Text('nama Tidak ditemukan');
                          }
                          return Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                      Text(
                        'Serka',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '2140058000894',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Baurang Tonma Pussimpur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  CircleAvatar(
                    child: IconButton(
                      onPressed: () async {
                        await AuthService().keluar();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Circular Profile Icons for Viewing Others
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[800],
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Post Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Postingan Saya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print('Add Post button pressed');
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Posting'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF282828),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Post Card with Data
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏆 Peringkat',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatInfo('Jarak', '4000m', Colors.green, Icons.map),
                      _buildStatInfo('Langkah', '8000', Colors.blue,
                          Icons.directions_walk),
                      _buildStatInfo('Kkal', '500', Colors.orange,
                          Icons.local_fire_department),
                      _buildStatInfo(
                          'Durasi', '20mnt', Colors.purple, Icons.timer),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Personel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        onTap: _onBottomNavTapped,
      ),
    );
  }

  // Widget for displaying each statistic
  Widget _buildStatInfo(
      String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
