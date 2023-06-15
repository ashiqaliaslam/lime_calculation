import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const MyApp());
}

/// Strings

const appBarTitle = 'Lime Consumption Calculator';
const appTitle = 'Lime Calculation';
const appBarTitleBoiler1 = 'Boiler-1';
const appBarTitleBoiler2 = 'Boiler-2';

/// MyApp Class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static const List<Destination> allDestinations = [
    Destination(
      index: 0,
      title: 'Boiler-1',
      icon: Icons.home,
      color: Colors.orange,
    ),
    Destination(
      index: 1,
      title: 'Boiler-2',
      icon: Icons.business,
      color: Colors.blue,
    ),
  ];

  // late final List<GlobalKey<NavigatorState>> navigatorKeys;
  // late final List<GlobalKey> destinationKeys;
  // late final List<AnimationController> destinationFaders;
  // late final List<Widget> destinationViews;
  int _selectedIndex = 0;

  // final List<Widget> _pages = [
  //   const Boiler1(),
  //   const Boiler2(),
  // ];

  // @override
  // void initState() {
  //   super.initState();
  //   navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
  //       allDestinations.length, (int index) => GlobalKey()).toList();
  //   // destinationFaders =
  //   destinationViews = allDestinations.map((Destination destination) {
  //     return DestinationView(
  //       destination: destination,
  //       navigatorKey: navigatorKeys[destination.index],
  //     );
  //   }).toList();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: const Text(appBarTitle),
      // ),
      // body: _pages[_selectedIndex],
      body: <Widget>[const Boiler1(), const Boiler2()][_selectedIndex],
      // body: SafeArea(
      //   top: false,
      //   // child: Stack(
      //   //   children: [
      //   //     allDestinations.map((Destination destination) {
      //   //       final int index = destination.index;
      //   //       final Widget view = destinationViews[index];
      //   //       if (index == _selectedIndex) {

      //   //       }

      //   //     }).toList()
      //   //   ],
      //   // ),
      // ),
      bottomNavigationBar: NavigationBar(
        // backgroundColor: Colors.blueAccent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: allDestinations.map((Destination destination) {
          return NavigationDestination(
            icon: Icon(destination.icon, color: destination.color),
            label: destination.title,
          );
        }).toList(),

        // items: [
        //   BottomNavigationBarItem(
        //     icon: const Icon(Icons.one_k),
        //     label: 'Boiler-1',
        //     tooltip: 'Boiler-1',
        //     backgroundColor: Colors.grey.shade100,
        //   ),
        //   BottomNavigationBarItem(
        //     icon: const Icon(Icons.two_k),
        //     label: 'Boiler-2',
        //     tooltip: 'Boiler-2',
        //     backgroundColor: Colors.cyan.shade200,
        //   ),
        // ],
      ),
    );
  }
}

/// Boiler-1
class Boiler1 extends StatefulWidget {
  const Boiler1({super.key});

  @override
  State<Boiler1> createState() => _Boiler1State();
}

class _Boiler1State extends State<Boiler1> {
  TextEditingController limeWeightController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        startTimeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          appBarTitleBoiler1,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight (tons)',
                        hintText: '50',
                        prefix: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.monitor_weight_outlined),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: TextField(
                      controller: startTimeController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        hintText: '00:00',
                        prefix: IconButton(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: TextField(
                      controller: endTimeController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        hintText: '23:59',
                        prefix: IconButton(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Add Data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Boiler-2
class Boiler2 extends StatefulWidget {
  const Boiler2({
    super.key,
    // required this.destination,
  });

  // final Destination destination;

  @override
  State<Boiler2> createState() => _Boiler2State();
}

class _Boiler2State extends State<Boiler2> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _data = [];

  TextEditingController limeWeightController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // limeWeightController = TextEditingController(text: '50');
    // startTimeController = TextEditingController(text: '00:00');
    // endTimeController = TextEditingController(text: '23:59');
  }

  @override
  void dispose() {
    limeWeightController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final int intValue = 0;
    // final ThemeData theme = Theme.of(context);
    // final time =
    //     TimePicker.selectTime(context, const TimeOfDay(hour: 00, minute: 00));
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text(appBarTitleBoiler2),
        // backgroundColor: widget.destination.color,
      ),
      backgroundColor: Colors.cyan.shade400,
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: limeWeightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Weight (tons)',
                        hintText: '50',
                        prefixIcon: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('How much is lime weight'),
                                  content: NumberPicker(
                                    value: limeWeightController.text != ""
                                        ? int.parse(limeWeightController.text)
                                        : 0,
                                    minValue: 0,
                                    maxValue: 500,
                                    step: 1,
                                    onChanged: (value) {
                                      setState(() {
                                        limeWeightController.text =
                                            value.toString();
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                            // showModalBottomSheet(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return NumberPicker(
                            //       minValue: 0,
                            //       maxValue: 200,
                            //       value: limeWeightController.text != ""
                            //           ? int.parse(limeWeightController.text)
                            //           : 0,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           limeWeightController.text =
                            //               value.toString();
                            //         });
                            //       },
                            //     );
                            //   },
                            // );

                            /// [change]
                            // NumberPicker(
                            //   value: intValue,
                            //   minValue: 0,
                            //   maxValue: 200,
                            //   step: 10,
                            //   onChanged: (value) => setState(() {
                            //     limeWeightController.text = value.toString();
                            //   }),
                            //   // onChanged: (value) {
                            //   //   // limeWeightController.text = value.toString();
                            //   //   return value;
                            //   // },
                            // );
                            // if (result != null) {
                            //   limeWeightController.text = result.toString();
                            // }
                          },
                          icon: const Icon(Icons.monitor_weight_outlined),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: startTimeController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        hintText: '00:00',
                        border: const OutlineInputBorder(),
                        prefixIcon: IconButton(
                          onPressed: () async {
                            final TimeOfDay? pickedTime =
                                await TimePickerHelper.selectTime(context,
                                    initialTime: TimeOfDay.now());
                            if (pickedTime != null) {
                              setState(() {
                                startTimeController.text =
                                    pickedTime.format(context);
                              });
                            }
                          },
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      // initialValue: '23:59',
                      controller: endTimeController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'End Time',
                        hintText: '23:59',
                        prefixIcon: IconButton(
                          onPressed: () async {
                            final TimeOfDay? pickedTime =
                                await TimePickerHelper.selectTime(context,
                                    initialTime: TimeOfDay.now());
                            if (pickedTime != null) {
                              setState(() {
                                endTimeController.text =
                                    pickedTime.format(context);
                              });
                            }
                          },
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    setState(() {
                      _data.add(limeWeightController.text);
                      _data.add(startTimeController.text);
                      _data.add(endTimeController.text);
                      limeWeightController.clear();
                      startTimeController.clear();
                      endTimeController.clear();
                    });
                  }
                },
                child: const Text('Add Data'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      ListTile(
                        title: Text(_data[index]),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Destination {
  const Destination(
      {required this.index,
      required this.title,
      required this.icon,
      required this.color});

  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
}

// class TimePicker {
//   static Future<TimeOfDay?> selectTime(
//     BuildContext context,
//     TimeOfDay initialTime,
//   ) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: initialTime,
//     );
//     return picked;
//   }
// }

class TimePickerHelper {
  static Future<TimeOfDay?> selectTime(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    return picked;
    // }
  }
}

// class NumberPickerHelper {
//   static Future<int?> selectNumber(
//     BuildContext context, {
//     required int minValue,
//     required int maxValue,
//     required int step,
//     required int initialIntegerValue,
//   }) async {
//     final int? result = await NumberPicker(
//       context: context,
//       minValue: minValue,
//       maxValue: maxValue,
//       step: step,
//       initialIntegerValue: initialIntegerValue,
//     );
//     return result;
//   }
// }

    // if (picked != null) {
    //   final localizations = MaterialLocalizations.of(context);
    //   String formattedTime = localizations.formatTimeOfDay(picked, alwaysUse24HourFormat: true);
    // }




// class DestinationView extends StatefulWidget {
//   const DestinationView({
//     super.key,
//     required this.destination,
//     required this.navigatorKey,
//   });

//   final Destination destination;
//   final Key navigatorKey;

//   @override
//   State<DestinationView> createState() => _DestinationViewState();
// }

// class _DestinationViewState extends State<DestinationView> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: widget.navigatorKey,
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute<void>(
//           settings: settings,
//           builder: (BuildContext context) {
//             switch (settings.name) {
//               case '/':
//                 // return Boiler1Page(destination: widget.destination);
//                 return const Placeholder();
//               case '/boiler2':
//                 return Boiler2(
//                     // destination: widget.destination,
//                     );
//               // return Placeholder();
//             }
//             assert(false);
//             return const SizedBox();
//           },
//         );
//       },
//     );
//   }
// }

