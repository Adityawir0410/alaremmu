import 'package:flutter/material.dart';

class DokterPopulerWidget extends StatelessWidget {
  final String name;
  final String specialization;
  final double rating;
  final int reviews;
  final String imageUrl;

  const DokterPopulerWidget({
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6, // Membuat shadow tetap ada tetapi lembut
      shadowColor: Colors.black12, // Intensitas shadow lebih rendah
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background putih
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // Warna shadow dengan opacity lebih rendah
              blurRadius: 10, // Blur tetap ada
              spreadRadius: 2, // Shadow lebih sempit
              offset: Offset(0, 12), // Posisi shadow sedikit lebih rendah
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Gambar Dokter
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : AssetImage('assets/placeholder.png') as ImageProvider,
                  ),
                  SizedBox(width: 16),
                  // Detail Dokter
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B4557),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          specialization,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0B4557), // Warna teks spesialisasi
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              "${rating.toStringAsFixed(1)}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "(${reviews.toString()})",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Tombol Registrasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print("Registrasi untuk $name");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF168AAD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12), // Tinggi tombol
                  ),
                  child: Text(
                    "Registrasi",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Teks putih
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
