import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vaccineslotreminder/Models/reminderModel.dart';
import 'package:vaccineslotreminder/Screens/Drawer/drawer1.dart';
import 'package:vaccineslotreminder/Screens/colors1.dart';
import 'package:vaccineslotreminder/Screens/styles1.dart';
import 'package:vaccineslotreminder/providers/reminderProvider.dart';

import 'listOfReminder.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MethodChannel channel = new MethodChannel("Alarm");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    channel.invokeMethod("startAlarm");
    askForBatteryOptimizationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    return Scaffold(
      drawer: Drawer1(),
      drawerScrimColor: blueColor,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          MethodChannel channel = new MethodChannel("Alarm");
          bool res = await channel.invokeMethod("checkForBatteryOptimization");
          if (res) {
            showDialog1();
          } else {
            await channel.invokeMethod("launchBatteryOptimizationDialog");
          }

          //
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: blueColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        title: Text(
          "Vaccine Slot Notifier",
          style: GoogleFonts.abel(color: blueColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListOfReminders(),
            Divider(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [blueColor, blueColor.withOpacity(0.8)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        "Notifications may be blocked by the phone's battery saver, you must set the battery saver to \"No Restrictions\" to make it operable.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abel(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blueColor),
                      ),
                      onPressed: () {
                        channel.invokeMethod("openAppInfo");
                      },
                      child: Text(
                        "Open Settings",
                        style: GoogleFonts.abel(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Tip: Adding more pincodes may help you get a slot faster, though the centre may be a bit far.",
                style: GoogleFonts.abel(),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  void showDialog1() {
    showDialog(
        context: context,
        builder: (_) {
          return MyDialog();
        });
  }

  void askForBatteryOptimizationPermission() async {
    MethodChannel channel = new MethodChannel("Alarm");
    bool res = await channel.invokeMethod("checkForBatteryOptimization");
    if (!res) {
      await channel.invokeMethod("launchBatteryOptimizationDialog");
    }
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  TextEditingController pincodeController = TextEditingController();
  int minimumAgeLimit = 45;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.notifications_active_rounded,
            color: blueColor,
          ),
          SizedBox(width: 5),
          Text(
            "Add Notifier",
            style: GoogleFonts.abel(
              color: blueColor,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                controller: pincodeController,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(6),
                ],
                keyboardType: TextInputType.number,
                style: GoogleFonts.aleo(
                  color: blueColor,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor)),
                    labelText: "Enter Pincode",
                    labelStyle: GoogleFonts.aleo(color: blueColor)),
                cursorColor: blueColor,
              ),
            ),
            SizedBox(height: 10),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    "Minimum age limit",
                    style: GoogleFonts.aleo(color: blueColor),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          minimumAgeLimit = 18;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blueColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(3),
                          color:
                              minimumAgeLimit == 18 ? blueColor : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 8, bottom: 8, right: 10),
                          child: Text(
                            "18+",
                            style: GoogleFonts.aleo(
                                color: minimumAgeLimit == 18
                                    ? Colors.white
                                    : blueColor),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          minimumAgeLimit = 45;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blueColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(3),
                          color:
                              minimumAgeLimit == 45 ? blueColor : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 8, bottom: 8, right: 10),
                          child: Text(
                            "45+",
                            style: GoogleFonts.aleo(
                                color: minimumAgeLimit == 45
                                    ? Colors.white
                                    : blueColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.aleo(
                      color: blueColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(blueColor),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    bool res = await Provider.of<ReminderProvider>(context,
                            listen: false)
                        .setReminder(pincodeController.text, minimumAgeLimit);
                    if (!res) {
                      print("Not Added");
                      Flushbar(
                        title: "Sorry, Something went wrong",
                        backgroundColor: blueColor,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        message: "The notifier may be already added.",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                    pincodeController.text = "";
                  },
                  child: Text(
                    "Add",
                    style: GoogleFonts.aleo(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
