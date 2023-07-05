import 'package:flutter/material.dart';

extension TimeOfDayTo24Hours on TimeOfDay {
  String to24Hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final minute = this.minute.toString().padLeft(2, "0");
    return "$hour:$minute";
  }
}
