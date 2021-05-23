import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vaccineslotreminder/Models/reminderModel.dart';
import 'package:vaccineslotreminder/Screens/colors1.dart';
import 'package:vaccineslotreminder/providers/reminderProvider.dart';

class ListOfReminders extends StatefulWidget {
  @override
  _ListOfRemindersState createState() => _ListOfRemindersState();
}

class _ListOfRemindersState extends State<ListOfReminders> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReminder();
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: reminderProvider.reminders.length,
        itemBuilder: (context, index) {
          ReminderModel reminder = reminderProvider.reminders[index];
          return FadeInUp(
            from: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 6,
                margin: index == reminderProvider.reminders.length - 1
                    ? EdgeInsets.only(bottom: 50)
                    : EdgeInsets.only(bottom: 0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    child: Image.asset(
                      "assets/syringe.png",
                    ),
                    backgroundColor: Colors.white,
                  ),
                  selectedTileColor: blueColor,
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: blueColor,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MyDeleteDialog(reminder);
                          });
                      //
                    },
                  ),
                  onTap: () {},
                  title: Text(
                    "Notifier for " + reminder.pincode,
                    style: GoogleFonts.abel(
                      color: blueColor,
                    ),
                  ),
                  subtitle: Text(
                    "Minimum age limit is set to ${reminder.minimumAgeLimit}+",
                    style: GoogleFonts.aleo(
                      color: blueColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void getReminder() async {
    await Provider.of<ReminderProvider>(context, listen: false).getReminders();
    setState(() {});
  }
}

class MyDeleteDialog extends StatefulWidget {
  ReminderModel reminder;
  MyDeleteDialog(this.reminder);
  @override
  _MyDeleteDialogState createState() => _MyDeleteDialogState();
}

class _MyDeleteDialogState extends State<MyDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    return AlertDialog(
      title: Text(
        "Confirm",
        style: GoogleFonts.aleo(
          color: blueColor,
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Do you want to delete this notifier ?",
            style: GoogleFonts.abel(color: blueColor.withOpacity(0.5)),
          ),
          SizedBox(height: 10),
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
                  reminderProvider.deleteReminder(widget.reminder);
                },
                child: Text(
                  "Delete it",
                  style: GoogleFonts.aleo(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
