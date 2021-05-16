import 'package:vaccineslotreminder/providers/reminderProvider.dart';

class ReminderModel {
  String id;
  String pincode;
  String availableSlots;
  int minimumAgeLimit;
  ReminderModel({
    this.id,
    this.pincode,
    this.availableSlots,
    this.minimumAgeLimit
  });
}
