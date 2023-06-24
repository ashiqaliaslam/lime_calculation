// import 'package:flutter/material.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

// void main() {
//   runApp(const MyApp());
// }

// class LimeData {
//   int weight;
//   DateTime startTime;
//   DateTime endTime;

//   LimeData(
//       {required this.weight, required this.startTime, required this.endTime});
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Lime Data',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // ignore: prefer_const_constructors
//       home: LimeDataForm(),
//     );
//   }
// }

// class LimeDataForm extends StatefulWidget {
//   const LimeDataForm({super.key});

//   @override
//   State<LimeDataForm> createState() => _LimeDataFormState();
// }

// class _LimeDataFormState extends State<LimeDataForm> {
//   List<LimeData> limeDataList = [];
//   int totalWeight = 0;
//   Duration totalDuration = const Duration();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lime Data'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Enter Lime Data',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: limeDataList.length,
//                   itemBuilder: (context, index) {
//                     return LimeDataField(
//                       limeData: limeDataList[index],
//                       onDelete: () {
//                         setState(() {
//                           limeDataList.removeAt(index);
//                           calculateTotals();
//                         });
//                       },
//                       onWeightChanged: (int weight) {
//                         setState(() {
//                           limeDataList[index].weight = weight;
//                           calculateTotals();
//                         });
//                       },
//                       onStartTimeChanged: (DateTime startTime) {
//                         setState(() {
//                           limeDataList[index].startTime = startTime;
//                           calculateTotals();
//                         });
//                       },
//                       onEndTimeChanged: (DateTime endTime) {
//                         setState(() {
//                           limeDataList[index].endTime = endTime;
//                           calculateTotals();
//                         });
//                       },
//                       onEdit: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => EditLimeDataScreen(
//                               limeData: limeDataList[index],
//                               onUpdate: (LimeData updatedData) {
//                                 setState(() {
//                                   limeDataList[index] = updatedData;
//                                   calculateTotals();
//                                 });
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         limeDataList.add(LimeData(
//                             weight: 0,
//                             startTime: DateTime.now(),
//                             endTime: DateTime.now()));
//                       });
//                     },
//                     child: const Text('Add Data'),
//                   ),
//                   const SizedBox(width: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         calculateTotals();
//                         if (totalDuration.inHours >= 24) {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Duration Exceeded'),
//                                 content: const Text(
//                                     'Total duration cannot exceed 24 hours.'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: const Text('OK'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         } else {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Calculation Results'),
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Total Lime Weight: $totalWeight'),
//                                     Text(
//                                         'Total Duration: ${totalDuration.inHours} hours and ${totalDuration.inMinutes.remainder(60)} minutes'),
//                                   ],
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: const Text('OK'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         }
//                       }
//                     },
//                     child: const Text('Calculate'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void calculateTotals() {
//     totalWeight = 0;
//     totalDuration = const Duration();

//     for (var limeData in limeDataList) {
//       totalWeight += limeData.weight;
//       totalDuration += limeData.endTime.difference(limeData.startTime);
//     }
//   }
// }

// class LimeDataField extends StatelessWidget {
//   final LimeData limeData;
//   final VoidCallback onDelete;
//   final ValueChanged<int> onWeightChanged;
//   final ValueChanged<DateTime> onStartTimeChanged;
//   final ValueChanged<DateTime> onEndTimeChanged;
//   final VoidCallback onEdit;

//   const LimeDataField({
//     super.key,
//     required this.limeData,
//     required this.onDelete,
//     required this.onWeightChanged,
//     required this.onStartTimeChanged,
//     required this.onEndTimeChanged,
//     required this.onEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Lime Data',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     initialValue: limeData.weight.toString(),
//                     decoration: const InputDecoration(labelText: 'Weight'),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter the lime weight';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       onWeightChanged(int.parse(value));
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: TimePickerSpinner(
//                     is24HourMode: true,
//                     normalTextStyle: const TextStyle(fontSize: 18),
//                     highlightedTextStyle: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                     spacing: 30,
//                     minutesInterval: 5,
//                     itemHeight: 40,
//                     onTimeChange: (time) {
//                       onStartTimeChanged(DateTime(
//                         DateTime.now().year,
//                         DateTime.now().month,
//                         DateTime.now().day,
//                         time.hour,
//                         time.minute,
//                       ));
//                     },
//                     time: limeData.startTime,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: TimePickerSpinner(
//                     is24HourMode: true,
//                     normalTextStyle: const TextStyle(fontSize: 18),
//                     highlightedTextStyle: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                     spacing: 30,
//                     minutesInterval: 5,
//                     itemHeight: 40,
//                     onTimeChange: (time) {
//                       onEndTimeChanged(DateTime(
//                         DateTime.now().year,
//                         DateTime.now().month,
//                         DateTime.now().day,
//                         time.hour,
//                         time.minute,
//                       ));
//                     },
//                     time: limeData.endTime,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: onDelete,
//                   icon: const Icon(Icons.delete),
//                 ),
//                 IconButton(
//                   onPressed: onEdit,
//                   icon: const Icon(Icons.edit),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
//               TimePickerSpinner(
//                 is24HourMode: true,
//                 normalTextStyle: const TextStyle(fontSize: 18),
//                 highlightedTextStyle:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 spacing: 30,
//                 minutesInterval: 5,
//                 itemHeight: 40,
//                 onTimeChange: (time) {
//                   setState(() {
//                     _limeData.startTime = DateTime(
//                       DateTime.now().year,
//                       DateTime.now().month,
//                       DateTime.now().day,
//                       time.hour,
//                       time.minute,
//                     );
//                   });
//                 },
//                 time: _limeData.startTime,
//               ),
//               const SizedBox(height: 16),
//               TimePickerSpinner(
//                 is24HourMode: true,
//                 normalTextStyle: const TextStyle(fontSize: 18),
//                 highlightedTextStyle:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 spacing: 30,
//                 minutesInterval: 5,
//                 itemHeight: 40,
//                 onTimeChange: (time) {
//                   setState(() {
//                     _limeData.endTime = DateTime(
//                       DateTime.now().year,
//                       DateTime.now().month,
//                       DateTime.now().day,
//                       time.hour,
//                       time.minute,
//                     );
//                   });
//                 },
//                 time: _limeData.endTime,
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
