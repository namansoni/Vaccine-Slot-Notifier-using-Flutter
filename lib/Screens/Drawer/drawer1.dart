import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vaccineslotreminder/Screens/ContactUs/contactUs.dart';
import 'package:vaccineslotreminder/Screens/Rive/riveAnimation.dart';
import 'package:vaccineslotreminder/Screens/version.dart';

import '../colors1.dart';

class Drawer1 extends StatefulWidget {
  @override
  _Drawer1State createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Column(
              children: [
                Image.asset(
                  "assets/syringe.png",
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  "Doot- The Vaccine Slot Notifier",
                  style: GoogleFonts.abel(
                    color: blueColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            ListTile(
              onTap: () async {
                String url =
                    "https://doot-vaccine-slot-notifier.firebaseapp.com/";
                await canLaunch(url)
                    ? await launch(url)
                    : throw 'Could not launch $url';
              },
              title: Text(
                "Privacy Policy",
                style: GoogleFonts.abel(
                  color: blueColor,
                  fontSize: 15,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ContactUs();
                }));
              },
              title: Text(
                "Contact Us",
                style: GoogleFonts.abel(
                  color: blueColor,
                  fontSize: 15,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Version: $version",
                style: GoogleFonts.abel(
                  color: blueColor,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
