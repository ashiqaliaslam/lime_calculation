import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Strings

const appBarTitle = 'Lime Consumption Calculator';
const appTitle = 'Lime Calculation';

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
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Boiler1(),
    const Boiler2(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(appBarTitle),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.one_k),
            label: 'Boiler-1',
            tooltip: 'Boiler-1',
            backgroundColor: Colors.grey.shade100,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.two_k),
            label: 'Boiler-2',
            tooltip: 'Boiler-2',
            backgroundColor: Colors.cyan.shade200,
          ),
        ],
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Boiler-1',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
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
                          )),
                    ),
                  ),
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
  const Boiler2({super.key});

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
  void dispose() {
    limeWeightController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: limeWeightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (tons)',
                      hintText: '50',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: startTimeController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      hintText: '00:00',
                      prefix: IconButton(
                        onPressed: () {},
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
                Expanded(
                  child: TextFormField(
                    // initialValue: '23:59',
                    controller: endTimeController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      hintText: '23:59',
                      prefix: IconButton(
                        onPressed: () {},
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
                return ListTile(
                  title: Text(_data[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
