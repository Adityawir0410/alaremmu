import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AntrianPeriksaWidget extends StatefulWidget {
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;

  const AntrianPeriksaWidget({
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    Key? key,
  }) : super(key: key);

  @override
  _AntrianPeriksaWidgetState createState() => _AntrianPeriksaWidgetState();
}

class _AntrianPeriksaWidgetState extends State<AntrianPeriksaWidget> {
  String patientName = "Loading...";
  String nik = "Loading...";
  String phoneNumber = "Loading...";
  String bpjsNumber = "-";
  String location = "Gedung I R4.1";
  String queueNumber = "000";

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
  try {
    // Fetch data using the Supabase client
    final response = await Supabase.instance.client
        .from('patient_appointments')
        .select('patient_name, nik, phone_number, bpjs_number')
        .eq('doctor_name', widget.doctorName)
        .eq('appointment_date', widget.appointmentDate)
        .eq('appointment_time', widget.appointmentTime)
        .order('created_at') // Ensure ordered queue based on creation time
        .execute();

    if (response.data != null) {
      final List<dynamic> data = response.data as List<dynamic>;

      if (data.isNotEmpty) {
        // Use the first record as the primary patient
        final record = data.first;

        setState(() {
          patientName = record['patient_name'] ?? "Unknown";
          nik = record['nik'] ?? "Unknown";
          phoneNumber = record['phone_number'] ?? "Unknown";
          bpjsNumber = record['bpjs_number'] ?? "-";
          queueNumber = (data.indexOf(record) + 1).toString().padLeft(3, '0');
        });
      } else {
        setState(() {
          patientName = "No Data";
          queueNumber = "001"; // Default queue number
        });
      }
    } else {
      setState(() {
        patientName = "Error Loading Data";
      });
    }
  } catch (e) {
    print("Error fetching patient data: $e");
    setState(() {
      patientName = "Error Loading Data";
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header for Schedule Information
          Text(
            "Jadwal Pemeriksaan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B4557),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Hari, Tanggal"),
              Text(widget.appointmentDate),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pukul"),
              Text(widget.appointmentTime),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Lokasi"),
              Text(location),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nomor Antrian"),
              Text(queueNumber),
            ],
          ),
          const Divider(thickness: 1, color: Color(0xFFB9DCE6)),

          // Patient Data
          const SizedBox(height: 16),
          Text(
            "Data Pasien",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B4557),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nama"),
              Text(patientName),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("NIK"),
              Text(nik),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("No. Telepon"),
              Text(phoneNumber),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nomor BPJS"),
              Text(bpjsNumber),
            ],
          ),
          const Divider(thickness: 1, color: Color(0xFFB9DCE6)),

          // Doctor Information
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nama Dokter"),
              Text(widget.doctorName),
            ],
          ),

          // PDF Button
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Add your PDF generation logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("PDF Generation Coming Soon!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF168AAD),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            child: const Text(
              "Cetak PDF",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
