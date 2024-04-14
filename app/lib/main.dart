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
  const MyApp({Key? key}) : super(key: key);

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
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _SearchBar(), // Search bar widget
            const SizedBox(height: 20), // Add space between search bar and selectors
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PercentageDropdownButton(),
                  const SizedBox(width: 20), // Custom dropdown button for percentage choice
                  _LanguageDropdownButton(),
                ],
              ),
            ),
          ],
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

  bool _isHebrew = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              String filePath = _getFilePath();
              int chosenPercent = PercentageDropdownController.of(context).percentageNotifier.value;
              
              List<String> results = await Script.search(searchTerm, chosenPercent, filePath,_LanguageDropdownButtonState()._selectedBookStart!,_LanguageDropdownButtonState()._selectedBookEnd!);
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
                        child: const Text('סגור'), // Close
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

  String _getFilePath() {
    final languageDropdownState = _LanguageDropdownButtonState();
    final selectedLanguage = languageDropdownState.getSelectedLanguage();
    return selectedLanguage == 'English' ? 'assets/bible.txt' : 'assets/bibleH.txt';
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

  const PercentageDropdownController({Key? key, required this.child}) : super(key: key);

  static _PercentageDropdownControllerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PercentageDropdownController>()!.controller;
  }

  @override
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

  const _PercentageDropdownController({Key? key, required this.controller, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_PercentageDropdownController oldWidget) {
    return oldWidget.controller != controller;
  }
}

class _LanguageDropdownButton extends StatefulWidget {
  @override
  _LanguageDropdownButtonState createState() => _LanguageDropdownButtonState();
}

class _LanguageDropdownButtonState extends State<_LanguageDropdownButton> {
  String _selectedLanguage = 'Hebrew'; // Default language
  String _selectedBookHebrewStart = 'בראשית';
  String _selectedBookHebrewEnd = 'התגלות'; // Selected book for Hebrew language
  String _selectedBookEnglishStart = 'Genesis';
  String _selectedBookEnglishEnd = 'Revelation'; // Selected book for English language
  String? _selectedBookStart = 'בראשית';
   String? _selectedBookEnd = "התגלות"; // Selected book for the current language

  String getSelectedLanguage() {
    return _selectedLanguage;
  }

  List<String> getBooks() {
    return _selectedLanguage == 'Hebrew' ? Script.booksH : Script.books;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
                // Reset selected book when language changes
                if (newValue == "Hebrew") {
                  _selectedBookStart = _selectedBookHebrewStart;
                  _selectedBookEnd = _selectedBookHebrewEnd;
                } else {
                  _selectedBookStart = _selectedBookEnglishStart;
                  _selectedBookEnd = _selectedBookEnglishEnd;
                }
              });
            },
            items: <String>['Hebrew', 'English']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedBookStart,
            onChanged: (String? newValue) {
              setState(() {
                _selectedBookStart = newValue!;
                if (_selectedLanguage == 'Hebrew') {
                  _selectedBookHebrewStart = newValue;
                } else {
                  _selectedBookEnglishStart = newValue;
                }
              });
            },
            items: getBooks()
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                .toList(),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedBookEnd,
            onChanged: (String? newValue) {
              setState(() {
                _selectedBookEnd = newValue!;
              });
            },
            items: getBooks()
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                .toList(),
          ),
        ],
      ),
    );
  }
}
