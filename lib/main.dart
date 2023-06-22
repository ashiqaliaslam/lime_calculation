import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class LimeData {
  int weight;
  TimeOfDay startTime;
  TimeOfDay endTime;

  LimeData({
    required this.weight,
    required this.startTime,
    required this.endTime,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lime Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LimeDataForm(),
    );
  }
}

class LimeDataForm extends StatefulWidget {
  const LimeDataForm({super.key});

  @override
  State<LimeDataForm> createState() => _LimeDataFormState();
}

class _LimeDataFormState extends State<LimeDataForm> {
  List<LimeData> limeDataList = [];
  int totalWeight = 0;
  Duration totalDuration = const Duration();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lime Data'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Lime Weight',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Text(
                    '$totalWeight',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Ton',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              // Text(
              //   '${totalWeight / totalDuration.inMinutes}',
              //   style: const TextStyle(
              //     color: Colors.black,
              //   ),
              // ),
              if (totalDuration.inHours > 24)
                const Text(
                  'The total duration cannot exceed 24 hours.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (totalDuration.inHours <= 24)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Duration:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${totalDuration.inHours}:${totalDuration.inMinutes.remainder(60)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Hours',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: limeDataList.length,
                  itemBuilder: (context, index) {
                    return LimeDataField(
                      limeData: limeDataList[index],
                      onDelete: () {
                        setState(() {
                          limeDataList.removeAt(index);
                          calculateTotals();
                        });
                      },
                      onWeightChanged: (int weight) {
                        setState(() {
                          limeDataList[index].weight = weight;
                          calculateTotals();
                        });
                      },
                      onStartTimeChanged: (TimeOfDay startTime) {
                        setState(() {
                          limeDataList[index].startTime = startTime;
                          calculateTotals();
                        });
                      },
                      onEndTimeChanged: (TimeOfDay endTime) {
                        setState(() {
                          limeDataList[index].endTime = endTime;
                          calculateTotals();
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        limeDataList.add(LimeData(
                            weight: 0,
                            startTime: TimeOfDay.now(),
                            endTime: TimeOfDay.now()));
                      });
                    },
                    child: const Text('Add Data'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        calculateTotals();
                        if (totalDuration.inHours >= 24) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Duration Exceeded'),
                                content: const Text(
                                    'The total duration cannot exceed 24 hours.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Calculation Results'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Lime Weight: $totalWeight'),
                                    Text(
                                        'Total Duration: ${totalDuration.inHours} hours and ${totalDuration.inMinutes.remainder(60)} minutes'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text('Calculate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateTotals() {
    totalWeight = 0;
    totalDuration = const Duration();

    for (var limeData in limeDataList) {
      totalWeight += limeData.weight;
      DateTime startDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        limeData.startTime.hour,
        limeData.startTime.minute,
      );
      DateTime endDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        limeData.endTime.hour,
        limeData.endTime.minute,
      );
      totalDuration += endDateTime.difference(startDateTime);
    }
  }
}

class LimeDataField extends StatelessWidget {
  final LimeData limeData;
  final VoidCallback onDelete;
  final ValueChanged<int> onWeightChanged;
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

  // TextEditingController limeWeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final limeConsumptionDuration =
        LimeConsumption.calculateDuration(limeData.startTime, limeData.endTime);

    return Card(
      elevation: 10,
      // color: Colors.blue.shade100,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                      // if (value!.isEmpty) {
                      //   return 'Please enter the lime weight';
                      // }
                      if (value?.isEmpty ?? true) {
                        return 'Please enter the lime weight';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // value = value.trim();
                      // if (value.isNotEmpty) {
                      //   onWeightChanged(int.parse(value));
                      // }
                      onWeightChanged(int.tryParse(value) ?? 0);
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
                Column(
                  children: [
                    const Text('Duration'),
                    Text(
                      limeConsumptionDuration,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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

extension TimeOfDayTo24Hours on TimeOfDay {
  String to24Hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final minute = this.minute.toString().padLeft(2, "0");
    return "$hour:$minute";
  }
}

class LimeConsumption {
  static String calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    DateTime now = DateTime.now();
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    Duration difference = endDateTime.difference(startDateTime);
    return '${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}';
  }
}

/// [TimePickerFormField]
// class TimePickerFormField extends StatelessWidget {
//   final String labelText;
//   final TimeOfDay initialTime;
//   final Function(TimeOfDay) onTimeChanged;

//   const TimePickerFormField({
//     super.key,
//     required this.labelText,
//     required this.initialTime,
//     required this.onTimeChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: labelText,
//         prefixIcon: const Icon(Icons.access_time),
//         border: const OutlineInputBorder(),
//       ),
//       initialValue: initialTime.format(context),
//       onTap: () async {
//         final pickedTime = await showTimePicker(
//           context: context,
//           initialTime: initialTime,
//         );
//         if (pickedTime != null) {
//           onTimeChanged(pickedTime);
//         }
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a time';
//         }
//         return null;
//       },
//       onSaved: (newValue) {
//         final time = TimeOfDay.fromDateTime(DateTime.parse(newValue!));
//         onTimeChanged(time);
//       },
//     );
//   }
// }

/// [EditLimeDataScreen]
// class EditLimeDataScreen extends StatefulWidget {
//   final LimeData limeData;
//   final ValueChanged<LimeData> onUpdate;

//   const EditLimeDataScreen(
//       {super.key, required this.limeData, required this.onUpdate});

//   @override
//   State<EditLimeDataScreen> createState() => _EditLimeDataScreenState();
// }

// class _EditLimeDataScreenState extends State<EditLimeDataScreen> {
//   late LimeData _limeData;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _limeData = widget.limeData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Lime Data'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Edit Lime Data',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 initialValue: _limeData.weight.toString(),
//                 decoration: const InputDecoration(labelText: 'Weight'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter the lime weight';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _limeData.weight = int.parse(value!);
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   showTimePicker(
//                     context: context,
//                     initialTime: _limeData.startTime,
//                   ).then((pickedTime) {
//                     if (pickedTime != null) {
//                       setState(() {
//                         _limeData.startTime = pickedTime;
//                       });
//                     }
//                   });
//                 },
//                 child:
//                     Text('Start Time: ${_limeData.startTime.format(context)}'),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   showTimePicker(
//                     context: context,
//                     initialTime: _limeData.endTime,
//                   ).then((pickedTime) {
//                     if (pickedTime != null) {
//                       setState(() {
//                         _limeData.endTime = pickedTime;
//                       });
//                     }
//                   });
//                 },
//                 child: Text('End Time: ${_limeData.endTime.format(context)}'),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _formKey.currentState!.save();
//                         widget.onUpdate(_limeData);
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text('Save'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
