import 'package:flutter/material.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        title: const Text(
          '16 Sep - 21 Sep 2024',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distance Goal
            _buildGoalProgress(
              '4000/10000 Meter',
              Icons.location_on,
              Colors.green,
              0.4,
            ),
            const SizedBox(height: 20),
            // Steps Goal
            _buildGoalProgress(
              '8000/20000 Langkah',
              Icons.directions_walk,
              Colors.blue,
              0.4,
            ),
            const SizedBox(height: 20),
            // Calories Goal
            _buildGoalProgress(
              '500/1000 Kkal',
              Icons.local_fire_department,
              Colors.orange,
              0.5,
            ),
            const SizedBox(height: 30),
            // Ranking Section
            const Text(
              '🏆 Peringkat Saya',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: const [
                  Text(
                    '🏆 Peringkat 🏆',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgress(String goal, IconData icon, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              goal,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[800],
          color: color,
          minHeight: 10,
        ),
      ],
    );
  }
}
