import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'akun_page.dart';
import 'goals_page.dart';
import 'mulai_page.dart';
import 'personel_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _currentDate = '';
  String _currentTime = '';
  String _location = "Belum dilacak";
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeDateAndTime();
    _trackLocation();
  }

  @override
  void dispose() {
    // Tidak ada resource yang perlu dihentikan untuk saat ini
    super.dispose();
  }

  /// Menginisialisasi tanggal dan waktu
  void _initializeDateAndTime() {
    initializeDateFormatting('id_ID', null).then((_) {
      if (mounted) {
        setState(() {
          _currentDate = DateFormat('EEEE, d MMM y', 'id_ID').format(DateTime.now());
          _currentTime = DateFormat('HH:mm', 'id_ID').format(DateTime.now());
        });
        _updateTime();
      }
    });
  }

  /// Memperbarui waktu setiap detik
  void _updateTime() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _currentTime = DateFormat('HH:mm', 'id_ID').format(DateTime.now());
        });
      }
    }
  }

  /// Melacak lokasi pengguna
  Future<void> _trackLocation() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (mounted) {
          setState(() {
            _location = placemarks[0].thoroughfare ?? "Lokasi tidak ditemukan";
          });
        }
      } catch (e) {
        print("Error saat mendapatkan lokasi: $e");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// Aksi untuk tombol "LARI"
  void _onRunPressed() {
    print("Tombol LARI ditekan");
  }

  /// Aksi untuk tombol "JALAN"
  void _onWalkPressed() {
    print("Tombol JALAN ditekan");
  }

  /// Aksi untuk navigasi bottom bar
  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonelPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AkunPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton('LARI', _onRunPressed),
                const SizedBox(width: 20),
                _buildActionButton('JALAN', _onWalkPressed),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoSection(),
            const SizedBox(height: 20),
            _buildProgressIndicators(),
            const Spacer(),
            _buildStartButton(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF282828),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFFd9d9d9)),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(_currentDate),
            const SizedBox(height: 10),
            _buildInfoCard(_location),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildInfoCard(_currentTime, fontSize: 24),
            const SizedBox(height: 10),
            _buildActionButton('Lacak', _trackLocation),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String text, {double fontSize = 18}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: const Color(0xFFd9d9d9), fontSize: fontSize),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    return Column(
      children: [
        _buildProgressIndicator(Icons.map, '4000 Meter', 0.4, Colors.green),
        const SizedBox(height: 20),
        _buildProgressIndicator(Icons.directions_walk, '8000 Langkah', 0.8, Colors.blue),
        const SizedBox(height: 20),
        _buildProgressIndicator(Icons.local_fire_department, '500 Kkal', 0.5, Colors.orange),
        const SizedBox(height: 20),
        _buildProgressIndicator(Icons.timer, '20 Menit', 0.2, Colors.yellow),
      ],
    );
  }

  Widget _buildProgressIndicator(IconData icon, String title, double progress, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: const Color(0xFF555555),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(color: Color(0xFFd9d9d9))),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFFd9d9d9),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MulaiPage()),
          );
        },
        child: const Text(
          'MULAI',
          style: TextStyle(color: Color(0xFF161616), fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Personel'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: _onBottomNavTapped,
    );
  }
}
