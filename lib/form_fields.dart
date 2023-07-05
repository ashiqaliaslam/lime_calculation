import 'package:flutter/material.dart';
import 'package:lime_calculation/widgets.dart';

import 'models.dart';

class LimeDataField extends StatelessWidget {
  final LimeData limeData;
  final VoidCallback onDelete;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;
  // final VoidCallback onEdit;

  const LimeDataField({
    super.key,
    required this.limeData,
    required this.onDelete,
    required this.onWeightChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    // required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final limeConsumptionDuration =
        TODtoDuration.duration(limeData.startTime, limeData.endTime);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Card(
        elevation: 10,
        // color: Colors.blue.shade100,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '',
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      hintText: '100',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter the lime weight';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      onWeightChanged(double.tryParse(value) ?? 0);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TimePickerButton(
                      labelText: 'Start Time',
                      time: limeData.startTime,
                      onTimeChanged: onStartTimeChanged),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: TimePickerButton(
                  labelText: 'End Time',
                  time: limeData.endTime,
                  onTimeChanged: onEndTimeChanged,
                )),
                const SizedBox(width: 10),
                DurationWidget(duration: limeConsumptionDuration),

                /// [delete icon]
                // IconButton(
                //   onPressed: onDelete,
                //   icon: const Icon(Icons.delete),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
