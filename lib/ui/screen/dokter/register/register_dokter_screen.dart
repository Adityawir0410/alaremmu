import 'package:flutter/material.dart';
import 'package:alaremmu/ui/widget/register/tanggal/tanggal_widget.dart';
import 'package:alaremmu/ui/widget/register/waktu/waktu_widget.dart';
import 'package:alaremmu/ui/screen/dokter/datapasien/datapasien_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterDokterScreen extends StatefulWidget {
  final String name;
  final String specialization;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String tentangDokter;
  final int doctorId;

  const RegisterDokterScreen({
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.tentangDokter,
    required this.doctorId,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterDokterScreen> createState() => _RegisterDokterScreenState();
}

class _RegisterDokterScreenState extends State<RegisterDokterScreen> {
  int selectedDateIndex = 0;
  String? selectedTime;

  // Fungsi untuk menyimpan data appointment
  void _saveAppointment() async {
    final selectedDate =
        DateTime.now().add(Duration(days: selectedDateIndex)).toIso8601String();

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pilih waktu terlebih dahulu!")),
      );
      return;
    }

    final response = await Supabase.instance.client
        .from('appointments')
        .insert({
          'doctor_id': widget.doctorId,
          'date': selectedDate,
          'time_slot': selectedTime,
        })
        .select('id')
        .single();

    if (response == null || response.containsKey('error')) {
      print("Error: ${response['error']}");
      return;
    }

// Ambil ID dari respons
    final appointmentId = response['id'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataPasienScreen(
          appointmentId: appointmentId,
          doctorName: widget.name,
          appointmentDate: selectedDate, // Kirim tanggal pemeriksaan
          appointmentTime: selectedTime!, // Kirim waktu pemeriksaan
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF168AAD), Color(0xFF76BDC2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 16,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF168AAD),
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      Text(
                        "Registrasi",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Detail Dokter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.imageUrl.isNotEmpty
                        ? NetworkImage(widget.imageUrl)
                        : AssetImage('assets/placeholder.png') as ImageProvider,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B4557),
                        ),
                      ),
                      Text(
                        widget.specialization,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0B4557),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            "${widget.rating.toStringAsFixed(1)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "(${widget.reviews})",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Tentang Dokter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Tentang Dokter",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B4557),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.tentangDokter,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Pilih Tanggal
            TanggalWidget(
              selectedIndex: selectedDateIndex,
              onDateSelected: (index) {
                setState(() {
                  selectedDateIndex = index;
                });
              },
            ),
            SizedBox(height: 16),

            // Pilih Waktu
            WaktuWidget(
              doctorId: widget.doctorId, // Sertakan doctorId
              onTimeSelected: (time) {
                // Callback untuk waktu terpilih
                setState(() {
                  selectedTime = time;
                });
              },
            ),

            SizedBox(height: 30),

            // Tombol Lanjutkan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _saveAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF168AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
