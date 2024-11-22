import 'package:flutter/material.dart';

class DataPersonelPage extends StatelessWidget {
  const DataPersonelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616), // Set background color to the specified color
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // DataTable widget with border and sample rows
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 1, // Border thickness
                ),
                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 40,
                  dataRowHeight: 60,
                  columns: const [
                    DataColumn(label: Text('NO', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('NAMA', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('NRP', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Harian', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Pencapaian', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Kurang', style: TextStyle(color: Colors.white))),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('1', style: TextStyle(color: Colors.white))),
                      DataCell(Text('Andi', style: TextStyle(color: Colors.white))),
                      DataCell(Text('123456', style: TextStyle(color: Colors.white))),
                      DataCell(Text('10', style: TextStyle(color: Colors.white))),
                      DataCell(Text('100%', style: TextStyle(color: Colors.white))),
                      DataCell(Text('0', style: TextStyle(color: Colors.white))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2', style: TextStyle(color: Colors.white))),
                      DataCell(Text('Budi', style: TextStyle(color: Colors.white))),
                      DataCell(Text('654321', style: TextStyle(color: Colors.white))),
                      DataCell(Text('8', style: TextStyle(color: Colors.white))),
                      DataCell(Text('90%', style: TextStyle(color: Colors.white))),
                      DataCell(Text('2', style: TextStyle(color: Colors.white))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('3', style: TextStyle(color: Colors.white))),
                      DataCell(Text('Charlie', style: TextStyle(color: Colors.white))),
                      DataCell(Text('112233', style: TextStyle(color: Colors.white))),
                      DataCell(Text('7', style: TextStyle(color: Colors.white))),
                      DataCell(Text('80%', style: TextStyle(color: Colors.white))),
                      DataCell(Text('3', style: TextStyle(color: Colors.white))),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
