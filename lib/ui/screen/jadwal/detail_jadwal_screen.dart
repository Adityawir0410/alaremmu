import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alaremmu/ui/widget/jadwalperiksa/antrian_periksa_widget.dart';
import 'package:alaremmu/ui/widget/jadwalperiksa/penialaian_periksa_widget.dart';

class DetailJadwalScreen extends StatelessWidget {
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final String status;

  const DetailJadwalScreen({
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    Key? key,
  }) : super(key: key);

  Future<Map<String, dynamic>?> fetchDoctorDetails(String doctorName) async {
    try {
      final response = await Supabase.instance.client
          .from('doctors')
          .select('id, specialization, rating, reviews, tentang_dokter, image_url')
          .eq('name', doctorName)
          .single()
          .execute();

      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching doctor details: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchDoctorDetails(doctorName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat detail dokter.'));
          }

          final doctorDetails = snapshot.data!;
          final doctorId = doctorDetails['id'];
          final specialization = doctorDetails['specialization'] ?? 'N/A';
          final rating = doctorDetails['rating'] ?? 0.0;
          final reviews = doctorDetails['reviews'] ?? 0;
          final description =
              doctorDetails['tentang_dokter'] ?? 'Tidak ada deskripsi.';
          final imageUrl = doctorDetails['image_url'] ?? '';

          return SingleChildScrollView(
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
                        borderRadius: const BorderRadius.only(
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
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Color(0xFF168AAD),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Text(
                            "Detail Jadwal",
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
                const SizedBox(height: 16),

                // Doctor Information
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : const AssetImage('assets/placeholder.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B4557),
                            ),
                          ),
                          Text(
                            specialization,
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF0B4557).withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "$rating ($reviews)",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // About Doctor
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tentang Dokter",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B4557),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Queue Information Widget
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AntrianPeriksaWidget(
                    doctorName: doctorName,
                    appointmentDate: appointmentDate,
                    appointmentTime: appointmentTime,
                  ),
                ),

                // Penilaian Widget (Hanya untuk status "done")
                if (status == 'done') ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PenilaianPeriksaWidget(
                      doctorId: doctorId,
                      doctorName: doctorName,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
