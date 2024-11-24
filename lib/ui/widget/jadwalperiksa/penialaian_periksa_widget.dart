import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenilaianPeriksaWidget extends StatefulWidget {
  final int doctorId;
  final String doctorName;

  const PenilaianPeriksaWidget({
    required this.doctorId,
    required this.doctorName,
    Key? key,
  }) : super(key: key);

  @override
  _PenilaianPeriksaWidgetState createState() => _PenilaianPeriksaWidgetState();
}

class _PenilaianPeriksaWidgetState extends State<PenilaianPeriksaWidget> {
  int selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  Future<void> saveReview() async {
    try {
      final response = await Supabase.instance.client
          .from('doctor_reviews')
          .select('reviews, stars, total_reviews, average_rating')
          .eq('doctor_id', widget.doctorId)
          .maybeSingle(); // Use maybeSingle instead of single

      if (response == null) {
        // No review exists, insert a new one
        final insertResponse = await Supabase.instance.client
            .from('doctor_reviews')
            .insert({
          'doctor_id': widget.doctorId,
          'doctor_name': widget.doctorName,
          'reviews': _reviewController.text,
          'stars': selectedRating.toString(),
          'total_reviews': 1,
          'average_rating': selectedRating.toDouble(),
        });

        if (insertResponse.error != null) {
          print('Error inserting review: ${insertResponse.error!.message}');
        } else {
          print('Review inserted successfully');
        }
        return;
      }

      // Review exists, update it
      final existingReviews = response['reviews']?.toString() ?? '';
      final existingStars = response['stars']?.toString() ?? '';
      final totalReviews = (response['total_reviews'] as num?)?.toInt() ?? 0;
      final averageRating = (response['average_rating'] as num?)?.toDouble() ?? 0.0;

      final updatedReviews = existingReviews.isEmpty
          ? _reviewController.text
          : '$existingReviews;${_reviewController.text}';
      final updatedStars = existingStars.isEmpty
          ? selectedRating.toString()
          : '$existingStars;${selectedRating.toString()}';
      final newTotalReviews = totalReviews + 1;
      final newAverageRating =
          ((averageRating * totalReviews) + selectedRating) / newTotalReviews;

      final updateResponse = await Supabase.instance.client
          .from('doctor_reviews')
          .update({
        'reviews': updatedReviews,
        'stars': updatedStars,
        'total_reviews': newTotalReviews,
        'average_rating': newAverageRating,
      }).eq('doctor_id', widget.doctorId);

      if (updateResponse.error != null) {
        print('Error updating review: ${updateResponse.error!.message}');
      } else {
        print('Review updated successfully');
      }
    } catch (e) {
      print('Exception during review operation: $e');
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
          Text(
            "Berikan Penilaianmu!",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B4557),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
                icon: Icon(
                  Icons.star,
                  size: 32,
                  color: index < selectedRating
                      ? const Color(0xFF168AAD)
                      : Colors.grey[300],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            "Ulasanmu:",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B4557),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Tuliskan ulasanmu...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFB9DCE6),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF168AAD),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (selectedRating > 0 && _reviewController.text.isNotEmpty) {
                await saveReview();
                _reviewController.clear();
                setState(() {
                  selectedRating = 0;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Harap isi semua kolom!")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF168AAD),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            child: const Text(
              "Kirim",
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
