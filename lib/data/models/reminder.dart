
import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final TimeOfDay time;
  final String title;      // e.g., "Glucophage 500mg" or user label
  final String note;       // e.g., "Medication", "Wound Care" etc.
  final List<int> weekdays; // 1..7 (Mon..Sun). Empty if one-off.
  final DateTime? oneOffDate; // specific calendar date (local)
  bool enabled;

  Reminder({
    required this.id,
    required this.time,
    required this.title,
    required this.note,
    required this.weekdays,
    this.oneOffDate,
    this.enabled = true,
  });

  bool repeatsDaily() => oneOffDate == null && weekdays.length == 7;
  bool isOneOff() => oneOffDate != null;
}
