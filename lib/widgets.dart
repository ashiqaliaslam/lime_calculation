import 'package:flutter/material.dart';
import 'package:lime_calculation/extensions.dart';
import 'package:lime_calculation/text_styles.dart';

/// TimePickerButton to pick the time
class TimePickerButton extends StatelessWidget {
  final String labelText;
  final TimeOfDay time;
  final Function(TimeOfDay) onTimeChanged;

  const TimePickerButton({
    super.key,
    required this.labelText,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(labelText),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            // padding: const EdgeInsets.all(5.0),
            elevation: 10,
          ),
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: time,
              useRootNavigator: false,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: true,
                  ),
                  child: child!,
                );
              },
            ).then((pickedTime) {
              if (pickedTime != null) {
                onTimeChanged(pickedTime);
              }
            });
          },
          child: Text(time.to24Hours()),
        ),
      ],
    );
  }
}

/// Calculate duration from two TimeOfDay values
class TODtoDuration {
  static String duration(TimeOfDay startTime, TimeOfDay endTime) {
    DateTime now = DateTime.now().toUtc();
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    Duration difference = endDateTime.difference(startDateTime);
    return '${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}';
  }
}

/// Show the duration on top of the app
class DurationWidget extends StatelessWidget {
  final String duration;

  const DurationWidget({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text('Duration'),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text(
            duration,
            style: TextStyles.medium,
          ),
        ),
      ],
    );
  }
}
