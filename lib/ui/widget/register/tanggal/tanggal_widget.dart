import 'package:flutter/material.dart';

class TanggalWidget extends StatelessWidget {
  final List<Map<String, String>> dates = [
    {"day": "15", "weekDay": "Sen"},
    {"day": "16", "weekDay": "Sel"},
    {"day": "17", "weekDay": "Rab"},
    {"day": "18", "weekDay": "Kam"},
    {"day": "19", "weekDay": "Jum"},
    {"day": "20", "weekDay": "Sab"},
  ];

  final int selectedIndex; // Menyimpan tanggal yang dipilih
  final Function(int) onDateSelected; // Callback saat tanggal dipilih

  TanggalWidget({
    required this.selectedIndex,
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                "Nov 2024",
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0), // Lebar lebih besar
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
