import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vaccineslotreminder/Models/reminderModel.dart';

class ReminderProvider extends ChangeNotifier {
  List<ReminderModel> reminders = [];
  MethodChannel channel = new MethodChannel("Alarm");
  Future getReminders() async {
    Database database = await openDatabase1();
    List reminders = await database.rawQuery("SELECT * from Reminders");
    print(reminders);
    await Future.forEach(reminders, (reminder) {
      this.reminders.add(ReminderModel(
            id: reminder['id'],
            pincode: reminder['pincode'],
            availableSlots: reminder['availableSlots'],
            minimumAgeLimit: reminder['minimumAgeLimit'],
          ));
    });
    notifyListeners();
  }

  Future<bool> setReminder(String pincode, int minimumAgeLimit) async {
    try {
      Database database = await openDatabase1();
      await database.rawInsert(
          "INSERT INTO Reminders VALUES(${pincode + minimumAgeLimit.toString()},$pincode,0,$minimumAgeLimit)");
      reminders.add(
        ReminderModel(
          id: pincode + minimumAgeLimit.toString(),
          availableSlots: "15",
          pincode: pincode,
          minimumAgeLimit: minimumAgeLimit,
        ),
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void deleteReminder(ReminderModel reminder) async {
    Database database = await openDatabase1();
    await database.rawDelete("DELETE FROM Reminders WHERE id=${reminder.id}");
    reminders.remove(reminder);
    notifyListeners();
  }

  Future<Database> openDatabase1() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'reminders.db');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Reminders (id TEXT PRIMARY KEY, pincode TEXT, availableSlots TEXT,minimumAgeLimit INTEGER)');
    });
    return database;
  }
}
