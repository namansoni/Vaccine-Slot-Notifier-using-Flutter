import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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
        itemCount: reminderProvider.reminders.length,
        itemBuilder: (context, index) {
          ReminderModel reminder = reminderProvider.reminders[index];
          return FadeInUp(
            from: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  selectedTileColor: blueColor,
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      reminderProvider.deleteReminder(reminder);
                    },
                  ),
                  onTap: () {},
                  title: Text(
                    reminder.pincode,
                  ),
                  subtitle: Text(
                    "Minimum Age Limit ${reminder.minimumAgeLimit}+",
                  ),
                ),
              ),
            ),
          );
        });
  }

  void getReminder() async {
    await Provider.of<ReminderProvider>(context, listen: false).getReminders();
  }
}
