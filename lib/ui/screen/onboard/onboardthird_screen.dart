import 'package:flutter/material.dart';

class OnboardThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEFE),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {

                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xFF168AAD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/onboard/onboard3.png',
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Selamat Datang di ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'ALAREM!',
                    style: TextStyle(
                      color: Color(0xFF168AAD),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Lorem ipsum dolor sit amet consectetur. Velit risus lectus nam mauris. Duis massa eleifend nulla aliquet. Elit vestibulum lectus quisque mi. Iaculis sit faucibus cursus eu massa. Facilisi sit vitae vehicula et cras lacus in laoreet scelerisque. Non elit nisl nibh adipiscing.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Spacer(flex: 3),
                SizedBox(width: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.grey),
                    SizedBox(width: 8),
                    Icon(Icons.circle, size: 8, color: Colors.grey),
                    SizedBox(width: 8),
                    Icon(Icons.circle, size: 10, color: Color(0xFF168AAD)),
                  ],
                ),
                Spacer(flex: 2),
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                    backgroundColor: Color(0xFF168AAD),
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
