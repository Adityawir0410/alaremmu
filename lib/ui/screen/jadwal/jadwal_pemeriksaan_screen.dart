import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alaremmu/ui/widget/jadwalperiksa/jadwal_periksa_widget.dart';
import 'package:alaremmu/ui/screen/jadwal/detail_jadwal_screen.dart';

class JadwalPemeriksaanScreen extends StatefulWidget {
  @override
  _JadwalPemeriksaanScreenState createState() =>
      _JadwalPemeriksaanScreenState();
}

class _JadwalPemeriksaanScreenState extends State<JadwalPemeriksaanScreen> {
  List<Map<String, dynamic>> todayAppointments = [];
  List<Map<String, dynamic>> upcomingAppointments = [];
  List<Map<String, dynamic>> completedAppointments = [];
  bool isLoading = true;
  bool isUpcomingSelected = true; // Tab to toggle between "Mendatang" and "Selesai"

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('patient_appointments')
          .select('doctor_name, appointment_date, appointment_time, status')
          .execute();

      final List<dynamic> data = response.data as List<dynamic>;

      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String tomorrow = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(Duration(days: 1)));

      setState(() {
        // Filter "Hari Ini" appointments
        todayAppointments = data
            .where((entry) =>
                entry['appointment_date'] == today &&
                entry['status'] == 'proses')
            .map((entry) => {
                  'doctor_name': entry['doctor_name'] ?? 'Unknown',
                  'appointment_date': entry['appointment_date'] ?? 'Unknown Date',
                  'appointment_time': entry['appointment_time'] ?? 'Unknown Time',
                })
            .toList();

        // Filter "Mendatang" appointments
        upcomingAppointments = data
            .where((entry) =>
                entry['appointment_date'] != null &&
                entry['appointment_date'] != today &&
                entry['status'] == 'proses')
            .map((entry) => {
                  'doctor_name': entry['doctor_name'] ?? 'Unknown',
                  'appointment_date': entry['appointment_date'] ?? 'Unknown Date',
                  'appointment_time': entry['appointment_time'] ?? 'Unknown Time',
                })
            .toList();

        // Filter "Selesai" appointments
        completedAppointments = data
            .where((entry) => entry['status'] == 'done')
            .map((entry) => {
                  'doctor_name': entry['doctor_name'] ?? 'Unknown',
                  'appointment_date': entry['appointment_date'] ?? 'Unknown Date',
                  'appointment_time': entry['appointment_time'] ?? 'Unknown Time',
                })
            .toList();
      });

      print("Today's Appointments: $todayAppointments");
      print("Upcoming Appointments: $upcomingAppointments");
      print("Completed Appointments: $completedAppointments");
    } catch (e) {
      print("Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for other fields
    const dummySpecialization = 'Spesialis Jantung';
    const dummyImageUrl = 'https://via.placeholder.com/150';

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
                top: 40,
                left: 26,
                child: Text(
                  "Jadwal\nPemeriksaanmu",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isUpcomingSelected = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isUpcomingSelected
                          ? Color(0xFF168AAD)
                          : Color(0xFFB9DCE6),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "Mendatang",
                      style: TextStyle(
                        color: isUpcomingSelected
                            ? Colors.white
                            : Color(0xFF168AAD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isUpcomingSelected = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: !isUpcomingSelected
                          ? Color(0xFF168AAD)
                          : Color(0xFFB9DCE6),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "Selesai",
                      style: TextStyle(
                        color: !isUpcomingSelected
                            ? Colors.white
                            : Color(0xFF168AAD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Loader or Data Display
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Upcoming Section
                        if (isUpcomingSelected) ...[
                          if (todayAppointments.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Hari Ini",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B4557),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            ...todayAppointments.map((appointment) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailJadwalScreen(
                                          doctorName:
                                              appointment['doctor_name'],
                                          appointmentDate:
                                              appointment['appointment_date'],
                                          appointmentTime:
                                              appointment['appointment_time'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: JadwalPeriksaWidget(
                                    doctorName: appointment['doctor_name'],
                                    specialization: dummySpecialization,
                                    appointmentDate:
                                        appointment['appointment_date'],
                                    appointmentTime:
                                        appointment['appointment_time'],
                                    doctorImageUrl: dummyImageUrl,
                                  ),
                                )),
                          ],
                          if (upcomingAppointments.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Mendatang",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B4557),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            ...upcomingAppointments.map((appointment) =>
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailJadwalScreen(
                                          doctorName:
                                              appointment['doctor_name'],
                                          appointmentDate:
                                              appointment['appointment_date'],
                                          appointmentTime:
                                              appointment['appointment_time'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: JadwalPeriksaWidget(
                                    doctorName: appointment['doctor_name'],
                                    specialization: dummySpecialization,
                                    appointmentDate:
                                        appointment['appointment_date'],
                                    appointmentTime:
                                        appointment['appointment_time'],
                                    doctorImageUrl: dummyImageUrl,
                                  ),
                                )),
                          ],
                        ],

                        // Completed Section
                        if (!isUpcomingSelected) ...[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Selesai",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B4557),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          ...completedAppointments.map((appointment) =>
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailJadwalScreen(
                                        doctorName: appointment['doctor_name'],
                                        appointmentDate:
                                            appointment['appointment_date'],
                                        appointmentTime:
                                            appointment['appointment_time'],
                                      ),
                                    ),
                                  );
                                },
                                child: JadwalPeriksaWidget(
                                  doctorName: appointment['doctor_name'],
                                  specialization: dummySpecialization,
                                  appointmentDate:
                                      appointment['appointment_date'],
                                  appointmentTime:
                                      appointment['appointment_time'],
                                  doctorImageUrl: dummyImageUrl,
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
