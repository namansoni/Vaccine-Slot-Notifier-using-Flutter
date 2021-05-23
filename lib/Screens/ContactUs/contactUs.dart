import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vaccineslotreminder/Screens/colors1.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: blueColor),
        backgroundColor: Colors.white,
        title: Text(
          "Contact Us",
          style: GoogleFonts.abel(
            color: blueColor,
          ),
        ),
      ),
      body: Column(
        children: [
          nameWidget("Naman Soni", "soninaman62626@gmail.com"),
          nameWidget("Adarsh Agarwala", "adarshagarwala31@gmail.com"),
          nameWidget("Pulkit Kumar Kukreja", "pulkitkkukreja@gmail.com"),
        ],
      ),
    );
  }

  Widget nameWidget(String name, String email) {
    return ListTile(
      title: Text(
        name,
        style: GoogleFonts.abel(
          color: blueColor,
        ),
      ),
      subtitle: Text(
        email,
        style: GoogleFonts.abel(
          color: blueColor.withOpacity(0.5),
        ),
      ),
    );
  }
}
