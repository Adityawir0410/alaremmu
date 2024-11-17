import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alaremmu/ui/widget/homescreen/dokterpopuler_widget.dart';
import 'package:alaremmu/ui/screen/dokter/kategori/kategori_doktor_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  int _currentIndex = 0; // Indeks tab aktif

  Future<List<dynamic>> fetchDoctors() async {
    try {
      final response = await supabase.from('doctors').select();
      print('Doctors data: $response');
      return response as List<dynamic>;
    } catch (e) {
      print('Error fetching doctors: $e');
      throw Exception('Failed to fetch doctors: $e');
    }
  }

  final List<Widget> _pages = [
    HomeContentPage(), // Halaman Home
    KategoriDoktorScreen(), // Placeholder untuk tab Dokter
    Center(child: Text("Jadwal")), // Placeholder untuk tab Jadwal
    Center(child: Text("Profil")), // Placeholder untuk tab Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih
      body: _pages[_currentIndex], // Halaman sesuai tab aktif
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Indeks tab aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mengganti halaman saat tab ditekan
          });
        },
        type: BottomNavigationBarType.fixed, // Navbar tetap
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF168AAD), // Warna tab aktif
        unselectedItemColor: Colors.grey, // Warna tab tidak aktif
        showSelectedLabels: false, // Menyembunyikan label tab aktif
        showUnselectedLabels: false, // Menyembunyikan label tab tidak aktif
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ikon Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined), // Ikon Dokter
            label: 'Dokter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), // Ikon Jadwal
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Ikon Profil
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomeContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Top Banner
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/homescreen/banneratas.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo,',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Jadwalkan pemeriksaanmu!',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Bagian Temukan Doktermu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Temukan Doktermu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B4557),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Kategori Dokter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDoctorCategory(
                  title: 'Neurologi',
                  imagePath: 'assets/homescreen/neurologi.png',
                ),
                _buildDoctorCategory(
                  title: 'Kardiologi',
                  imagePath: 'assets/homescreen/kardiologi.png',
                ),
                _buildDoctorCategory(
                  title: 'Ortopedi',
                  imagePath: 'assets/homescreen/ortopedi.png',
                ),
                _buildDoctorCategory(
                  title: 'Oftalmologi',
                  imagePath: 'assets/homescreen/neurologi.png',
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Bagian Dokter Populer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Dokter Populer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B4557),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Placeholder untuk daftar Dokter Populer
          FutureBuilder(
            future: Supabase.instance.client
                .from('doctors')
                .select()
                .limit(4), // Batasi hasil menjadi 4 entri saja
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                final doctors = snapshot.data as List<dynamic>;
                return Column(
                  children: doctors.map((doctor) {
                    return DokterPopulerWidget(
                      name: doctor['name'] ?? 'Unknown',
                      specialization: doctor['specialization'] ?? 'Unknown',
                      rating: (doctor['rating'] ?? 0).toDouble(),
                      reviews: doctor['reviews'] ?? 0,
                      imageUrl: doctor['image_url'] ?? '',
                    );
                  }).toList(),
                );
              } else {
                return Center(child: Text('No doctors available'));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCategory(
      {required String title, required String imagePath}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFFB9DCE6),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF0B4557),
          ),
        ),
      ],
    );
  }
}
