import 'package:flutter/material.dart';

// class LimeData {
//   double weight;
//   TimeOfDay startTime;
//   TimeOfDay endTime;

//   LimeData({
//     required this.weight,
//     required this.startTime,
//     required this.endTime,
//   });

//   void calculateTotals() {
//   totalWeight = 0.0;
//   totalDuration = const Duration();

//   for (var limeData in limeDataList) {
//     totalWeight += limeData.weight;
//     DateTime startDateTime = DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//       limeData.startTime.hour,
//       limeData.startTime.minute,
//     );
//     DateTime endDateTime = DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//       limeData.endTime.hour,
//       limeData.endTime.minute,
//     );
//     totalDuration += endDateTime.difference(startDateTime);
//   }
// }
// }

class LimeData {
  double weight;
  TimeOfDay startTime;
  TimeOfDay endTime;

  LimeData({
    required this.weight,
    required this.startTime,
    required this.endTime,
  });

  Duration getDuration() {
    DateTime now = DateTime.now().toUtc();
    DateTime startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );
    DateTime endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );
    return endDateTime.difference(startDateTime);
  }
}

class Totals {
  final double totalWeight;
  final Duration totalDuration;

  Totals(this.totalWeight, this.totalDuration);
}

Totals calculateTotals(List<LimeData> limeDataList) {
  double totalWeight = 0.0;
  Duration totalDuration = const Duration();

  for (var limeData in limeDataList) {
    totalWeight += limeData.weight;
    totalDuration += limeData.getDuration();
  }

  return Totals(totalWeight, totalDuration);
}
