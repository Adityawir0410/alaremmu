import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WaktuWidget extends StatefulWidget {
  final int doctorId; // ID dokter
  final Function(String) onTimeSelected; // Callback untuk waktu terpilih

  const WaktuWidget({
    required this.doctorId,
    required this.onTimeSelected,
    Key? key,
  }) : super(key: key);

  @override
  _WaktuWidgetState createState() => _WaktuWidgetState();
}

class _WaktuWidgetState extends State<WaktuWidget> {
  String? selectedTime; // Menyimpan waktu yang dipilih
  String? selectedPeriod; // Menyimpan periode waktu yang dipilih
  Map<String, List<String>> timeSlots = {}; // Data waktu

  @override
  void initState() {
    super.initState();
    _fetchTimeSlots(); // Ambil data waktu dari Supabase
  }

  Future<void> _fetchTimeSlots() async {
    try {
      final response = await Supabase.instance.client
          .from('doctor_schedule')
          .select()
          .eq('doctor_id', widget.doctorId);

      if (response != null && response.isNotEmpty) {
        // Mengelompokkan data berdasarkan time_period (Pagi, Siang, Malam)
        final Map<String, List<String>> slots = {};
        for (var schedule in response) {
          final period = schedule['time_period'] as String;
          final slot = schedule['time_slot'] as String;

          if (!slots.containsKey(period)) {
            slots[period] = [];
          }
          slots[period]?.add(slot);
        }

        setState(() {
          timeSlots = slots;
        });
      } else {
        print('Error fetching time slots: No data found.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Pilih Waktu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B4557),
            ),
          ),
        ),
        if (timeSlots.isEmpty)
          Center(child: CircularProgressIndicator()) // Tampilkan loading jika data kosong
        else
          ...timeSlots.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (Pagi, Siang, Malam)
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B4557),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Time Buttons
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 card per row
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 12.0,
                          childAspectRatio: 3, // Sesuaikan rasio tampilan
                        ),
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          final time = entry.value[index];
                          final isSelectedPeriod = selectedPeriod == entry.key;
                          final isSelectedTime = selectedTime == time;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedPeriod == entry.key) {
                                  selectedTime = time; // Set waktu yang dipilih
                                } else {
                                  selectedPeriod = entry.key; // Set periode waktu
                                  selectedTime = time; // Reset waktu yang dipilih
                                }
                              });
                              widget.onTimeSelected(selectedTime!);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelectedPeriod && isSelectedTime
                                    ? Color(0xFF168AAD)
                                    : Color(0xFFB9DCE6),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: isSelectedPeriod && isSelectedTime
                                      ? Colors.white
                                      : Color(0xFF168AAD),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}
