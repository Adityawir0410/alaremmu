import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalPeriksaWidget extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String appointmentDate;
  final String appointmentTime;
  final String doctorImageUrl;

  const JadwalPeriksaWidget({
    required this.doctorName,
    required this.specialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.doctorImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Konversi hari dari tanggal
    final dayOfWeek = DateFormat('EEEE', 'id_ID').format(DateTime.parse(appointmentDate));
    final formattedDay = _convertDayToIndonesian(dayOfWeek);

    // Konversi tanggal ke format Indonesia
    final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(appointmentDate));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF168AAD), // Warna biru seperti di desain
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Atas: Foto dan Detail Dokter
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Dokter
              CircleAvatar(
                radius: 30,
                backgroundImage: doctorImageUrl.isNotEmpty
                    ? NetworkImage(doctorImageUrl)
                    : AssetImage('assets/placeholder.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              // Detail Dokter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialization,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bagian Bawah: Hari, Tanggal, dan Jam
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Color(0xFF7EBED1).withOpacity(0.75), // Background dengan opacity 75%
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$formattedDay, $formattedDate',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appointmentTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mengonversi nama hari ke bahasa Indonesia
  String _convertDayToIndonesian(String day) {
    switch (day) {
      case 'Monday':
        return 'Senin';
      case 'Tuesday':
        return 'Selasa';
      case 'Wednesday':
        return 'Rabu';
      case 'Thursday':
        return 'Kamis';
      case 'Friday':
        return 'Jumat';
      case 'Saturday':
        return 'Sabtu';
      case 'Sunday':
        return 'Minggu';
      default:
        return day;
    }
  }
}
