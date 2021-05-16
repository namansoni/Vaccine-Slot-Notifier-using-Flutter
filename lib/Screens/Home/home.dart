import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vaccineslotreminder/Models/reminderModel.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          showDialog1();
          //
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Vaccine Slot Reminder",
          style: styleBlue,
        ),
      ),
      body: ListOfReminders(),
    );
  }

  void showDialog1() {
    showDialog(
        context: context,
        builder: (_) {
          return MyDialog();
        });
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
      title: Text("Set Reminder"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              controller: pincodeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Pincode",
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Minimum Age Limit",
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    minimumAgeLimit = 18;
                  });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 8, bottom: 8, right: 10),
                    child: Text("18+"),
                  ),
                  color: minimumAgeLimit == 18 ? Colors.blue : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    minimumAgeLimit = 45;
                  });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 8, bottom: 8, right: 10),
                    child: Text("45+"),
                  ),
                  color: minimumAgeLimit == 45 ? Colors.blue : Colors.white,
                ),
              ),
            ],
          )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<ReminderProvider>(context, listen: false)
                      .setReminder(pincodeController.text,minimumAgeLimit);
                  pincodeController.text = "";
                },
                child: Text("Add"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
