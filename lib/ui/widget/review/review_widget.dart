import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewWidget extends StatelessWidget {
  final int doctorId;

  const ReviewWidget({
    required this.doctorId,
    Key? key,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchReviews(int doctorId) async {
    try {
      final response = await Supabase.instance.client
          .from('doctor_reviews')
          .select('reviews, stars')
          .eq('doctor_id', doctorId)
          .maybeSingle(); // Use maybeSingle instead of single

      if (response == null) {
        return []; // Handle case where no matching doctor exists
      }

      final reviews = response['reviews'] as String? ?? '';
      final stars = response['stars'] as String? ?? '';

      // Split reviews and stars into lists and combine them as map
      final reviewList = reviews.isNotEmpty ? reviews.split(';') : [];
      final starList = stars.isNotEmpty ? stars.split(';') : [];

      return List.generate(
        reviewList.length,
        (index) => {
          'review': reviewList[index],
          'star': index < starList.length ? int.parse(starList[index]) : 0,
        },
      );
    } catch (e) {
      print("Error fetching reviews: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchReviews(doctorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Gagal memuat ulasan."));
        }

        final reviews = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ulasan:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B4557),
              ),
            ),
            const SizedBox(height: 8),
            if (reviews.isEmpty)
              const Text(
                "Belum ada ulasan untuk dokter ini.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              )
            else
              ...reviews.map(
                (item) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background putih
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12, // Blur lebih halus
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Icon
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Review Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row for stars
                              Row(
                                children: List.generate(
                                  item['star'],
                                  (index) => const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Row for review text
                              Text(
                                item['review'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0B4557),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
