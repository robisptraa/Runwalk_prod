import 'package:flutter/material.dart';

import 'akun_page.dart';
import 'dashboard_page.dart';
import 'data_personel.dart';  // Import the DataPersonelPage
import 'peringkat_page.dart';  // Import the PeringkatPage

class PersonelPage extends StatefulWidget {
  const PersonelPage({super.key});

  @override
  _PersonelPageState createState() => _PersonelPageState();
}

class _PersonelPageState extends State<PersonelPage> {
  int _currentIndex = 1;  // Set initial index to 1 to reflect that we are on the 'Personel' page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616), // Set the AppBar background to match the main background
        title: const Text(
          'Data Personel',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Set the back button color to white
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Main content of the page
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30), // Padding ke kiri dan kanan
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Memastikan elemen berada di tengah secara vertikal
                crossAxisAlignment: CrossAxisAlignment.stretch,  // Mengisi lebar layar
                children: [
                  _buildButtonSection('DATA PERSONEL', context),
                  const SizedBox(height: 10,),
                  _buildButtonSection('PERINGKAT', context),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Navigation Bar
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

  // Button section for showing the titles and buttons
  Widget _buildButtonSection(String title, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            ),
            onPressed: () {
              if (title == 'DATA PERSONEL') {
                // Navigate to DataPersonelPage when 'DATA PERSONEL' is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataPersonelPage()),
                );
              } else if (title == 'PERINGKAT') {
                // Navigate to PeringkatPage when 'PERINGKAT' is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PeringkatPage()),
                );
              }
            },
            child: const Text(
              'Lihat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle bottom navigation bar tap events
  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Implementasikan navigasi ke halaman yang sesuai
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        break;
      case 1:
        // Do nothing on 'Personel' page
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AkunPage()),
        );
        break;
    }
  }
}
