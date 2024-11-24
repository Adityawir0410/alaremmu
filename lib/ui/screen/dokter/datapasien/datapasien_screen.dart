import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataPasienScreen extends StatelessWidget {
  final int appointmentId;
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;

  const DataPasienScreen({
    required this.appointmentId,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _nikController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _bpjsController = TextEditingController();

    Future<void> _saveData() async {
      final String name = _nameController.text.trim();
      final String nik = _nikController.text.trim();
      final String phoneNumber = _phoneController.text.trim();
      final String bpjsNumber = _bpjsController.text.trim();

      if (name.isEmpty || nik.isEmpty || phoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap lengkapi semua data yang wajib diisi!')),
        );
        return;
      }

      try {
        final response = await Supabase.instance.client
            .from('patient_appointments')
            .insert({
              'appointment_id': appointmentId,
              'patient_name': name,
              'nik': nik,
              'phone_number': phoneNumber,
              'bpjs_number': bpjsNumber.isNotEmpty ? bpjsNumber : null,
              'doctor_name': doctorName,
              'appointment_date': appointmentDate,
              'appointment_time': appointmentTime,
            })
            .select();

        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data pasien berhasil disimpan')),
          );
          Navigator.pop(context); // Kembali ke layar sebelumnya
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "Data Pasien" title
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
                      "Data Pasien",
                      style: TextStyle(
                        fontSize: 28,
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

          // Form Fields
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardField(
                    'Nama Lengkap',
                    'Masukkan nama lengkapmu...',
                    _nameController,
                  ),
                  _buildCardField(
                    'NIK',
                    'Masukkan NIK...',
                    _nikController,
                  ),
                  _buildCardField(
                    'Nomor Telepon',
                    '+62',
                    _phoneController,
                  ),
                  _buildCardField(
                    'Nomor BPJS (Opsional)',
                    'Masukkan nomor BPJS...',
                    _bpjsController,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF168AAD),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardField(
      String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B4557),
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
