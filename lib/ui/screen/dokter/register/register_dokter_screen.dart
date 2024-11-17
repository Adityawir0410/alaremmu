import 'package:flutter/material.dart';
import 'package:alaremmu/ui/widget/register/tanggal/tanggal_widget.dart';

class RegisterDokterScreen extends StatefulWidget {
  final String name;
  final String specialization;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String tentangDokter; // Tambahkan tentangDokter

  const RegisterDokterScreen({
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.tentangDokter,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterDokterScreen> createState() => _RegisterDokterScreenState();
}

class _RegisterDokterScreenState extends State<RegisterDokterScreen> {
  int selectedDateIndex = 0; // Menyimpan index tanggal yang dipilih

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
                widget.tentangDokter, // Tampilkan konten tentangDokter
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
                  selectedDateIndex = index; // Perbarui tanggal yang dipilih
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
