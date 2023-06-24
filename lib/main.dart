import 'package:flutter/material.dart';
import 'package:lime_calculation/color_schemes.g.dart';

void main() {
  runApp(const MyApp());
}

class LimeData {
  double weight;
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
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
  double totalWeight = 0;
  Duration totalDuration = const Duration();
  final _formKey = GlobalKey<FormState>();

  double _estimatedWeight(double totalWeight, Duration totalDuration) {
    if (totalDuration.inMinutes == 0) {
      return 0;
    }

    double rateOfConsumption = totalWeight / totalDuration.inMinutes;
    // calculate the projected weight in 24 hours
    return rateOfConsumption * 24 * 60;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          mediumText('Total Lime Weight'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              largeText(totalWeight.toStringAsFixed(2)),
                              const SizedBox(width: 5),
                              largeText('Ton'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // const VerticalDivider(
                    //   color: Colors.black,
                    //   thickness: 2,
                    // ),
                    if (totalDuration.inMinutes > 1440)
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            errorText(
                                '⛔️ The total duration cannot exceed 24 hours.'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                largeErrorText(
                                    formattedDuration(totalDuration)),
                                const SizedBox(width: 5),
                                largeErrorText('Hours'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (totalDuration.inMinutes <= 1440)
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            mediumText('Total Duration'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                largeText(formattedDuration(totalDuration)),
                                const SizedBox(width: 5),
                                largeText('Hours'),
                              ],
                            ),
                          ],
                        ),
                      )
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mediumText('Projected Lime Consumed'),
                    const SizedBox(width: 10),
                    largeBoldText(_estimatedWeight(totalWeight, totalDuration)
                        .toStringAsFixed(2)),
                    const SizedBox(width: 5),
                    largeText('Ton'),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: limeDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: ValueKey(limeDataList[index]),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            limeDataList.removeAt(index);
                            calculateTotals();
                          });
                        },
                        // onUpdate: (details) {
                        //   calculateTotals();
                        // },
                        child: LimeDataField(
                          limeData: limeDataList[index],
                          onDelete: () {
                            setState(() {
                              limeDataList.removeAt(index);
                              calculateTotals();
                            });
                          },
                          // onDelete: Dismissible(),
                          onWeightChanged: (weight) {
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
                        ),
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
                          if (limeDataList.isNotEmpty) {
                            limeDataList.add(
                              LimeData(
                                  weight: 0,
                                  startTime: limeDataList.last.endTime,
                                  endTime: TimeOfDay.now()),
                            );
                          } else {
                            limeDataList.add(
                              LimeData(
                                weight: 0,
                                startTime:
                                    const TimeOfDay(hour: 00, minute: 00),
                                endTime: TimeOfDay.now(),
                              ),
                            );
                          }
                        });
                      },
                      child: const Text('Add Data'),
                    ),
                    const SizedBox(width: 10),
                    const ElevatedButton(
                      onPressed: null,
                      child: Row(
                        children: [
                          Icon(Icons.clear_all),
                          SizedBox(width: 10),
                          Text('Clear All'),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateTotals() {
    totalWeight = 0.0;
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

  void removeTatals() {
    limeDataList.clear();
  }
}

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
        LimeConsumption.calculateDuration(limeData.startTime, limeData.endTime);

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

                /// [TimePickerButton] // TODO:
                // Expanded(child: TimePickerButton(labelText: 'test btn', time:,)),
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

String formattedDuration(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minuts = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  return '$hours:$minuts';
}

class TextStyles {
  static const TextStyle small = TextStyle(
    fontSize: 14,
  );
  static const TextStyle medium = TextStyle(
    fontSize: 16,
  );
  static const TextStyle large = TextStyle(
    fontSize: 22,
  );
  static const TextStyle largeBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle error = TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle largeError = TextStyle(
    color: Colors.red,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}

Widget smallText(String text) {
  return Text(text, style: TextStyles.small, softWrap: true);
}

Widget mediumText(String text) {
  return Text(text, style: TextStyles.medium, softWrap: true);
}

Widget largeText(String text) {
  return Text(text, style: TextStyles.large, softWrap: true);
}

Widget largeBoldText(String text) {
  return Text(text, style: TextStyles.largeBold, softWrap: true);
}

Widget largeErrorText(String text) {
  return Text(text, style: TextStyles.largeError, softWrap: true);
}

Widget errorText(String text) {
  return Text(
    text,
    style: TextStyles.error,
    textAlign: TextAlign.center,
    softWrap: true,
  );
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


/// [elevated button for calculate data]
                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (_formKey.currentState!.validate()) {
                    //       calculateTotals();
                    //       if (totalDuration.inMinutes > 1440) {
                    //         showDialog(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return AlertDialog(
                    //               title: smallText('Duration Exceeded'),
                    //               content: Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   errorText(
                    //                       '⛔️ The total duration cannot exceed 24 hours.'),
                    //                   Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       const SizedBox(width: 5),
                    //                       largeErrorText(
                    //                           formattedDuration(totalDuration)),
                    //                       const SizedBox(width: 5),
                    //                       largeErrorText('Hours'),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //               actions: [
                    //                 TextButton(
                    //                   onPressed: () {
                    //                     Navigator.of(context).pop();
                    //                   },
                    //                   child: const Text('OK'),
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //         );
                    //       } else {
                    //         showDialog(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return AlertDialog(
                    //               title: const Text('Calculation Results'),
                    //               content: Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   mediumText('Projected Lime Consumed'),
                    //                   Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       const SizedBox(width: 10),
                    //                       largeBoldText(_estimatedWeight(
                    //                               totalWeight, totalDuration)
                    //                           .toStringAsFixed(2)),
                    //                       const SizedBox(width: 5),
                    //                       largeText('Ton'),
                    //                     ],
                    //                   ),
                    //                   const Divider(),
                    //                   mediumText('Total Lime Weight'),
                    //                   Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       largeText(
                    //                           totalWeight.toStringAsFixed(2)),
                    //                       const SizedBox(width: 5),
                    //                       largeText('Ton'),
                    //                     ],
                    //                   ),
                    //                   const Divider(),
                    //                   Column(
                    //                     children: [
                    //                       mediumText('Total Duration'),
                    //                       Row(
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.center,
                    //                         children: [
                    //                           const SizedBox(width: 5),
                    //                           largeText(formattedDuration(
                    //                               totalDuration)),
                    //                           const SizedBox(width: 5),
                    //                           largeText('Hours'),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //               actions: [
                    //                 TextButton(
                    //                   onPressed: () {
                    //                     Navigator.of(context).pop();
                    //                   },
                    //                   child: const Text('OK'),
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //         );
                    //       }
                    //     }
                    //   },
                    //   child: const Text('Calculate'),
                    // ),