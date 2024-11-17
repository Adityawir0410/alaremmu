import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alaremmu/ui/widget/homescreen/dokterpopuler_widget.dart';
import 'package:alaremmu/ui/screen/dokter/register/register_dokter_screen.dart';

class ListDokterScreen extends StatefulWidget {
  final String title;

  ListDokterScreen({required this.title});

  @override
  _ListDokterScreenState createState() => _ListDokterScreenState();
}

class _ListDokterScreenState extends State<ListDokterScreen> {
  final supabase = Supabase.instance.client;
  String searchQuery = ""; // Variabel untuk menyimpan kata kunci pencarian

  Future<List<dynamic>> fetchDoctorsByCategory(String category, String query) async {
    try {
      final response = await supabase
          .from('doctors')
          .select()
          .eq('category', category)
          .ilike('name', '%$query%'); // Mencari nama berdasarkan input pencarian
      return response;
    } catch (error) {
      print('Error fetching doctors: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                      widget.title,
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

          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Memperbarui kata kunci pencarian
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF168AAD)),
                  hintText: "Penelusuran...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Daftar Dokter
          Expanded(
            child: FutureBuilder(
              future: fetchDoctorsByCategory(widget.title, searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  final doctors = snapshot.data as List<dynamic>;
                  if (doctors.isEmpty) {
                    return Center(child: Text('Tidak ada data dokter.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterDokterScreen(
                                name: doctor['name'] ?? 'Unknown',
                                specialization: doctor['specialization'] ?? 'Unknown',
                                rating: (doctor['rating'] ?? 0).toDouble(),
                                reviews: doctor['reviews'] ?? 0,
                                imageUrl: doctor['image_url'] ?? '',
                                tentangDokter: doctor['tentang_dokter'] ?? 'Deskripsi tidak tersedia', // Tambahkan ini
                              ),
                            ),
                          );
                        },
                        child: DokterPopulerWidget(
                          name: doctor['name'] ?? 'Unknown',
                          specialization: doctor['specialization'] ?? 'Unknown',
                          rating: (doctor['rating'] ?? 0).toDouble(),
                          reviews: doctor['reviews'] ?? 0,
                          imageUrl: doctor['image_url'] ?? '',
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Tidak ada data dokter.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
