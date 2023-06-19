import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class LimeData {
  int weight;
  TimeOfDay startTime;
  TimeOfDay endTime;

  LimeData(
      {required this.weight, required this.startTime, required this.endTime});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lime Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Lime Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditLimeDataScreen(
                              limeData: limeDataList[index],
                              onUpdate: (LimeData updatedData) {
                                setState(() {
                                  limeDataList[index] = updatedData;
                                  calculateTotals();
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
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
                  const SizedBox(width: 16),
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
  final VoidCallback onEdit;

  const LimeDataField({
    super.key,
    required this.limeData,
    required this.onDelete,
    required this.onWeightChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lime Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // const SizedBox(
                //   height: 200,
                //   child: Column(
                //     children: [],
                //   ),
                // ),
                Expanded(
                  child: TextFormField(
                    initialValue: limeData.weight.toString(),
                    decoration: const InputDecoration(labelText: 'Weight'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the lime weight';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // onWeightChanged(int.parse(value));
                      onWeightChanged(int.tryParse(value) ?? 0);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: limeData.startTime,
                      ).then((pickedTime) {
                        if (pickedTime != null) {
                          onStartTimeChanged(pickedTime);
                        }
                      });
                    },
                    child: Text(
                        'Start Time: ${limeData.startTime.format(context)}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: limeData.endTime,
                      ).then((pickedTime) {
                        if (pickedTime != null) {
                          onEndTimeChanged(pickedTime);
                        }
                      });
                    },
                    child:
                        Text('End Time: ${limeData.endTime.format(context)}'),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
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

class EditLimeDataScreen extends StatefulWidget {
  final LimeData limeData;
  final ValueChanged<LimeData> onUpdate;

  const EditLimeDataScreen(
      {super.key, required this.limeData, required this.onUpdate});

  @override
  State<EditLimeDataScreen> createState() => _EditLimeDataScreenState();
}

class _EditLimeDataScreenState extends State<EditLimeDataScreen> {
  late LimeData _limeData;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _limeData = widget.limeData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lime Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Lime Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _limeData.weight.toString(),
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the lime weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  _limeData.weight = int.parse(value!);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showTimePicker(
                    context: context,
                    initialTime: _limeData.startTime,
                  ).then((pickedTime) {
                    if (pickedTime != null) {
                      setState(() {
                        _limeData.startTime = pickedTime;
                      });
                    }
                  });
                },
                child:
                    Text('Start Time: ${_limeData.startTime.format(context)}'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showTimePicker(
                    context: context,
                    initialTime: _limeData.endTime,
                  ).then((pickedTime) {
                    if (pickedTime != null) {
                      setState(() {
                        _limeData.endTime = pickedTime;
                      });
                    }
                  });
                },
                child: Text('End Time: ${_limeData.endTime.format(context)}'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.onUpdate(_limeData);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
