import 'package:flutter/material.dart';

class PenilaianPeriksaWidget extends StatefulWidget {
  const PenilaianPeriksaWidget({Key? key}) : super(key: key);

  @override
  _PenilaianPeriksaWidgetState createState() => _PenilaianPeriksaWidgetState();
}

class _PenilaianPeriksaWidgetState extends State<PenilaianPeriksaWidget> {
  int selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

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
          // Title
          Text(
            "Berikan Penilaianmu!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B4557),
            ),
          ),
          const SizedBox(height: 16),

          // Star Rating
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
                      ? Color(0xFF168AAD)
                      : Colors.grey[300],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Review Input
          Text(
            "Ulasanmu:",
            style: TextStyle(
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
                borderSide: BorderSide(
                  color: Color(0xFFB9DCE6),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xFF168AAD),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Submit Button
          ElevatedButton(
            onPressed: () {
              if (selectedRating > 0 && _reviewController.text.isNotEmpty) {
                // Submit logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Penilaian berhasil dikirim!"),
                  ),
                );
                _reviewController.clear();
                setState(() {
                  selectedRating = 0;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Harap isi semua kolom!"),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF168AAD),
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
