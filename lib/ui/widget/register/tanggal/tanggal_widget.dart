import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TanggalWidget extends StatelessWidget {
  final int selectedIndex; // Menyimpan tanggal yang dipilih
  final Function(int) onDateSelected; // Callback saat tanggal dipilih

  TanggalWidget({
    required this.selectedIndex,
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  // Fungsi untuk menghasilkan daftar tanggal real-time (6 hari ke depan)
  List<Map<String, String>> _generateDates() {
    DateTime today = DateTime.now();
    return List.generate(6, (index) {
      DateTime date = today.add(Duration(days: index));
      return {
        "day": DateFormat('d', 'id_ID').format(date), // Tanggal (contoh: 15)
        "weekDay": DateFormat('EEE', 'id_ID').format(date), // Hari (contoh: Sen)
        "monthYear": DateFormat('MMM yyyy', 'id_ID').format(date), // Bulan dan Tahun (contoh: Nov 2024)
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> dates = _generateDates();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilih Tanggal",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B4557),
                ),
              ),
              Text(
                dates[0]["monthYear"]!, // Bulan dan tahun real-time
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0B4557),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dates.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> date = entry.value;
                bool isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () => onDateSelected(index), // Callback ke parent
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFF168AAD) : Color(0xFFB9DCE6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          date["day"]!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Color(0xFF168AAD),
                          ),
                        ),
                      ),
                      SizedBox(height: 4), // Jarak kecil antara kotak dan teks
                      Text(
                        date["weekDay"]!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B4557),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
