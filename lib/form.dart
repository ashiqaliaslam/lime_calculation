import 'package:flutter/material.dart';
import 'package:lime_calculation/text_styles.dart';

import 'functions.dart';
import 'form_fields.dart';
import 'models.dart';

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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
