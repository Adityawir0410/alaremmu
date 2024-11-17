import 'package:flutter/material.dart';
// import 'list_dokter_screen.dart';
import 'package:alaremmu/ui/screen/dokter/list/list_dokter_screen.dart';

class KategoriDoktorScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'title': 'Neurologi', 'image': 'assets/kategoridokter/neurologi2.png'},
    {'title': 'Kardiologi', 'image': 'assets/kategoridokter/kardiologi2.png'},
    {'title': 'Pulmonolog', 'image': 'assets/kategoridokter/pulmonolog.png'},
    {'title': 'THT', 'image': 'assets/kategoridokter/tht.png'},
    {'title': 'Dermatologi', 'image': 'assets/kategoridokter/dermatologi.png'},
    {'title': 'Nefrologi', 'image': 'assets/kategoridokter/nefrologi.png'},
    {'title': 'Dentist', 'image': 'assets/kategoridokter/dentist.png'},
    {'title': 'Oftalmologi', 'image': 'assets/kategoridokter/oftalmologi.png'},
    {'title': 'Ortopedi', 'image': 'assets/kategoridokter/ortopedi2.png'},
    {'title': 'Hematologi', 'image': 'assets/kategoridokter/hematologi.png'},
    {'title': 'Gastro-enterologi', 'image': 'assets/kategoridokter/gastroenterologi.png'},
    {'title': 'Onkologi', 'image': 'assets/kategoridokter/onkologi.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header dengan Gambar dan Teks
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/kategoridokter/temukandokter.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20, // Posisi teks di bagian kiri bawah
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temukan',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Doktermu,',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'jadwalkan pemeriksaanmu!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Teks "Kategori Dokter"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Kategori Dokter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B4557),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Grid Kategori Dokter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), // Agar scroll hanya di SingleChildScrollView
                shrinkWrap: true, // Agar GridView bisa berada di dalam ScrollView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Jumlah kolom
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDokterScreen(title: category['title']!),
                        ),
                      );
                    },
                    child: _buildCategoryItem(
                      title: category['title']!,
                      imagePath: category['image']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({required String title, required String imagePath}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48, // Ukuran lingkaran tetap
          backgroundColor: Color(0xFFB9DCE6),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding diperbesar agar gambar lebih kecil
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain, // Menyesuaikan gambar agar tidak penuh
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF0B4557),
          ),
        ),
      ],
    );
  }
}
