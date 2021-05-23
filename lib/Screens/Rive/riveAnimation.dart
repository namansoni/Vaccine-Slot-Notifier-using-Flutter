import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:vaccineslotreminder/Screens/Home/home.dart';
import 'package:vaccineslotreminder/Screens/colors1.dart';
import 'package:vaccineslotreminder/Screens/version.dart';

class RiveAnimation extends StatefulWidget {
  @override
  _RiveAnimationState createState() => _RiveAnimationState();
}

class _RiveAnimationState extends State<RiveAnimation> {
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _riveArtboard;
  RiveAnimationController _controller;

  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Home();
      }));
    });
    rootBundle.load('assets/dootanimation.riv').then(
      (data) async {
       
        final file = RiveFile.import(data);
       
        final artboard = file.mainArtboard;
        
        artboard.addController(_controller = SimpleAnimation('Animation 1'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            child: Center(
              child: _riveArtboard == null
                  ? const SizedBox()
                  : Rive(
                      artboard: _riveArtboard,
                      alignment: Alignment.center,
                    ),
            ),
          ),
          Text(
            "Doot",
            style: GoogleFonts.abel(
              color: blueColor,
              fontSize: 30,
            ),
          ),
          Text(
            "The Vaccine Slot Notifier",
            style: GoogleFonts.abel(
              color: blueColor.withOpacity(0.5),
              fontSize: 15,
            ),
          ),
           Text(
            version,
            style: GoogleFonts.abel(
              color: blueColor.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
