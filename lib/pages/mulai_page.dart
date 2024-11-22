import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class MulaiPage extends StatefulWidget {
  const MulaiPage({super.key});

  @override
  _MulaiPageState createState() => _MulaiPageState();
}

class _MulaiPageState extends State<MulaiPage> {
  late Timer _timer;
  int _seconds = 0;
  String _formattedTime = "00:00:00";

  int _steps = 0;
  int _calories = 0;
  double _distance = 0.0;
  double _speed = 0.0; // Speed in meters per second

  final int _rank = 0;
  late StreamSubscription<StepCount> _stepCountSubscription;
  int _initialStepCount = 0;

  bool _isTracking = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    requestActivityRecognitionPermission(); // Request permission on initialization
  }

  // Request Activity Recognition Permission
  void requestActivityRecognitionPermission() async {
    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      await Permission.activityRecognition.request();
    }
  }

  void _startStepCountStream() {
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  void _onStepCount(StepCount stepCount) {
    print("Current step count: ${stepCount.steps}"); // Debug logging

    // If it's the first step count, store it as the initial step count
    if (_initialStepCount == 0) {
      _initialStepCount = stepCount.steps;
    }

    // Calculate steps taken since tracking started
    int stepsDuringSession = stepCount.steps - _initialStepCount;

    // Only update if steps during the session are greater than 0
    if (stepsDuringSession >= 0) {
      setState(() {
        _steps = stepsDuringSession;
        _calories = (_steps * 0.04).toInt(); // 0.04 calories per step
        _distance = _steps * 0.7; // Assume 0.7 meters per step
      });
    }
  }

  void _startTracking() {
    if (_isTracking) return;

    setState(() {
      _isTracking = true;
      _isPaused = false;
    });

    _initialStepCount = 0; // Reset initial step count when starting
    _startStepCountStream();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _formattedTime = _formatDuration(_seconds);

        // Calculate speed in meters per second
        if (_seconds > 0) {
          _speed = _distance / _seconds;
        }
      });
    });
  }

  void _pauseTracking() {
    if (!_isTracking || _isPaused) return;

    setState(() {
      _isPaused = true;
    });
    _timer.cancel();
    _stepCountSubscription.pause();
  }

  void _resumeTracking() {
    if (!_isTracking || !_isPaused) return;

    setState(() {
      _isPaused = false;
    });
    _startStepCountStream();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _formattedTime = _formatDuration(_seconds);

        if (_seconds > 0) {
          _speed = _distance / _seconds;
        }
      });
    });
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
      _isPaused = false;
      _seconds = 0;
      _formattedTime = "00:00:00";
      _steps = 0;
      _calories = 0;
      _distance = 0.0;
      _speed = 0.0;
      _initialStepCount = 0;
    });
    _timer.cancel();
    _stepCountSubscription.cancel();
  }

  String _formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    _stepCountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Mulai Olahraga',
                    style: TextStyle(
                      color: Color(0xFFd9d9d9),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      _formattedTime,
                      style: const TextStyle(
                        color: Color(0xFFd9d9d9),
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Durasi',
                      style: TextStyle(
                        color: Color(0xFFd9d9d9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildMetricCard(Icons.map, 'Jarak', '${_distance.toStringAsFixed(2)} Meter', Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildMetricCard(Icons.directions_walk, 'Langkah', '$_steps', Colors.blue),
                        ),
                        Expanded(
                          child: _buildMetricCard(Icons.speed, 'Kecepatan', '${_speed.toStringAsFixed(2)} m/s', Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildMetricCard(Icons.local_fire_department, 'Kalori', '$_calories', Colors.orange),
                        ),
                        Expanded(
                          child: _buildMetricCard(Icons.emoji_events, 'Peringkat', '$_rank', Colors.yellow),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (_isTracking && !_isPaused)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pauseTracking,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16.0), // Atur padding vertikal untuk memperbesar tinggi tombol
                          minimumSize: const Size.fromHeight(50), // Atur tinggi minimal tombol
                        ),
                        child: const Text(
                          'PAUSE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Memperbesar ukuran font jika diinginkan
                          ),
                        ),
                      ),
                    ),
                  if (_isPaused)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _resumeTracking,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          'RESUME',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isTracking ? _stopTracking : _startTracking,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFFd9d9d9),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text(
                        _isTracking ? 'STOP' : 'MULAI',
                        style: const TextStyle(
                          color: Color(0xFF161616),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String label, String value, Color color) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
