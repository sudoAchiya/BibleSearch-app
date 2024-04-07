import 'package:flutter/material.dart';
import 'Script.dart';

void main() {
  runApp(
    const PercentageDropdownController(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'BibleSearch',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _SearchBar(), // Search bar widget
                  const SizedBox(width: 10), // Add some space between the search bar and dropdown button
                  _PercentageDropdownButton(), // Custom dropdown button for percentage choice
                ],
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: const Center(child: Text("")),
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  bool _isHebrew = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        textDirection: _isHebrew ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: _isHebrew ? 'הזן מונח חיפוש...' : 'Enter search term...',
          suffixIcon: IconButton(
            onPressed: () async {
              String searchTerm = _searchController.text;
              String filePath = "assets/bibleHN.txt"; // Assuming you're using the Hebrew Bible file
              int chosenPercent = PercentageDropdownController.of(context).percentageNotifier.value;
              List<String> results = await Script.search(searchTerm, chosenPercent, filePath);
              // Display results in the app
              showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        _isHebrew ? 'תוצאות חיפוש' : 'Search Results',
                        textDirection: _isHebrew ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                results[index],
                                textDirection: _isHebrew ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            );
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('סגור' ), // Close
                        ),
                      ],
                    );

                },
              );
            },
            icon: const Icon(Icons.search),
          ),
        ),
        onChanged: (text) {
          setState(() {
            _isHebrew = isHebrew(text);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isHebrew(String text) {
    // Check if the text contains Hebrew characters
    final RegExp regex = RegExp(r'[\u0590-\u05FF\s]+');
    return regex.hasMatch(text);
  }
}

class _PercentageDropdownButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final percentageController = PercentageDropdownController.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: percentageController.percentageNotifier,
      builder: (context, selectedPercentage, _) {
        return DropdownButton<int>(
          value: selectedPercentage,
          onChanged: (int? newValue) {
            percentageController.updateSelectedPercentage(newValue!);
          },
          items: <int>[60, 75, 85, 90, 100] // Define your percentage options here
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value%'),
            );
          }).toList(),
        );
      },
    );
  }
}


class PercentageDropdownController extends StatefulWidget {
  final Widget child;

  const PercentageDropdownController({super.key, required this.child});

  // ignore: library_private_types_in_public_api
  static _PercentageDropdownControllerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PercentageDropdownController>()!.controller;
  }

  @override
  // ignore: library_private_types_in_public_api
  _PercentageDropdownControllerState createState() => _PercentageDropdownControllerState();
}

class _PercentageDropdownControllerState extends State<PercentageDropdownController> {
  late ValueNotifier<int> _selectedPercentageNotifier;

  ValueNotifier<int> get percentageNotifier => _selectedPercentageNotifier;

  @override
  void initState() {
    super.initState();
    _selectedPercentageNotifier = ValueNotifier<int>(85);
  }

  @override
  Widget build(BuildContext context) {
    return _PercentageDropdownController(
      controller: this,
      child: widget.child,
    );
  }

  void updateSelectedPercentage(int newPercentage) {
    _selectedPercentageNotifier.value = newPercentage;
  }

  @override
  void dispose() {
    _selectedPercentageNotifier.dispose();
    super.dispose();
  }
}


class _PercentageDropdownController extends InheritedWidget {
  final _PercentageDropdownControllerState controller;

  const _PercentageDropdownController({required this.controller, required super.child});

  @override
  bool updateShouldNotify(_PercentageDropdownController oldWidget) {
    return oldWidget.controller != controller;
  }
}
