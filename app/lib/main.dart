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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PercentageDropdownButton(), // Custom dropdown button for percentage choice
                    const SizedBox(width: 20), // Add space between selectors
                    _LanguageDropdownButton(), 
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BookStartDropdownButton(),
                    const SizedBox(width: 20), // Add space between selectors
                    _BookEndDropdownButton()
                  ],
                ),
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
              String start = PercentageDropdownController.of(context)._bookStartDropdownButtonState._selectedBookStart;
              String end = PercentageDropdownController.of(context)._bookEndDropdownButtonState._selectedBookEnd;
              List<String> results = await Script.search(searchTerm, chosenPercent, filePath,start,end);
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
    final RegExp regex = RegExp(r'[\u0590-\u05FF\s]+');
    return regex.hasMatch(text);
  }

  String _getFilePath() {
    final languageDropdownState = PercentageDropdownController.of(context)._languageDropdownButtonState;
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
  late _LanguageDropdownButtonState _languageDropdownButtonState;
  late _BookStartDropdownButtonState _bookStartDropdownButtonState;
  late _BookEndDropdownButtonState _bookEndDropdownButtonState;

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

  void setLanguageDropdownButtonState(_LanguageDropdownButtonState state) {
    _languageDropdownButtonState = state;
    print("hola");
    if(state._selectedLanguage == 'Hebrew')
    {
    }
    else
    {
      _bookStartDropdownButtonState.books = Script.books;
      // _bookStartDropdownButtonState._selectedBookStart = "Genesis";
    }
  }
  void setBookStartDropdownButtonState(_BookStartDropdownButtonState state,String lang) {
    if(lang == 'h')
    {
      _bookStartDropdownButtonState.books = Script.booksH;
      // _bookStartDropdownButtonState._selectedBookStart = "בראשית";
    }
    else
    {
      _bookStartDropdownButtonState.books = Script.books;
      // _bookStartDropdownButtonState._selectedBookStart = "Genesis";
    }
    _bookStartDropdownButtonState = state;
  }
  void setBookEndDropdownButtonState(_BookEndDropdownButtonState state) {
    _bookEndDropdownButtonState = state;
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

  // Define lists of books for each language
  late List<String> _books;
  late String _selectedStartBook;
  late String _selectedEndBook;

  @override
  void initState() {
    super.initState();
    // Initialize lists of books
    // Initialize selected start and end books
    _selectedStartBook =  Script.booksH.first;
    _selectedEndBook =  Script.booksH.last;
  }

  String getSelectedLanguage() {
    return _selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final percentageController = PercentageDropdownController.of(context);
    percentageController.setLanguageDropdownButtonState(this);

    return DropdownButton<String>(
      value: _selectedLanguage,
      onChanged: (String? newValue) {
        setState(() {
          _selectedLanguage = newValue!;
          // Update lists of books based on the selected language
          _books = _selectedLanguage == 'English' ? Script.books : Script.booksH;
          // Update selected start and end books
          _selectedStartBook = _books.first;
          _selectedEndBook = _books.last;
        });
      },
      items: <String>['English', 'Hebrew'] // Define your language options here
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}




class _BookStartDropdownButton extends StatefulWidget {
  @override
  _BookStartDropdownButtonState createState() => _BookStartDropdownButtonState();
}

class _BookStartDropdownButtonState extends State<_BookStartDropdownButton> {
  List<String> books = Script.booksH;
  String _selectedBookStart = Script.booksH.first;
  String getSelectedBookStart() {
    return _selectedBookStart;
  }

  @override
  Widget build(BuildContext context) {
    final percentageController = PercentageDropdownController.of(context);
    if(percentageController._languageDropdownButtonState._selectedLanguage=="Hebrew") {
      percentageController.setBookStartDropdownButtonState(this,"h");
    }
    else
    {
      percentageController.setBookStartDropdownButtonState(this,"e");
    }
    return DropdownButton<String>(
      value: _selectedBookStart,
      onChanged: (String? newValue) {
        setState(() {
          _selectedBookStart = newValue!;
        });
      },
      items: books.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
class _BookEndDropdownButton extends StatefulWidget {
  @override
  _BookEndDropdownButtonState createState() => _BookEndDropdownButtonState();
}

class _BookEndDropdownButtonState extends State<_BookEndDropdownButton> {
  String _selectedBookEnd = 'התגלות'; // Default language

  String getSelectedBookEnd() {
    return _selectedBookEnd;
  }

  @override
  Widget build(BuildContext context) {
    final percentageController = PercentageDropdownController.of(context);
    percentageController.setBookEndDropdownButtonState(this);

    return DropdownButton<String>(
      value: _selectedBookEnd,
      onChanged: (String? newValue) {
        setState(() {
          print("hola"+  _selectedBookEnd);
          _selectedBookEnd = newValue!;
          print("holas"+  _selectedBookEnd);
        });
      },
      items: Script.booksH.reversed.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}