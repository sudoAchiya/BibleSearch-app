// ignore_for_file: library_private_types_in_public_api

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
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'BibleSearch',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 20),
                  _SearchBar(),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable:
                              PercentageDropdownController.of(context)
                                  .selectedLanguageNotifier,
                          builder: (context, selectedLanguage, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _PercentageDropdownButton(),
                                if (selectedLanguage == 'עברית') ...[
                                  const SizedBox(width: 20),
                                  _VersionDropdownButton(),
                                ],
                                const SizedBox(width: 20),
                                _LanguageDropdownButton(),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            _BookStartDropdownButton(),
                            const SizedBox(height: 20),
                          ],
                        ),
                        Column(
                          children: [
                            _BookEndDropdownButton(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 120,
                child: Image.asset(
                  'assets/book.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
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
              _search();
            },
            icon: const Icon(Icons.search),
          ),
        ),
        onChanged: (text) {
          setState(() {
            _isHebrew = isHebrew(text);
          });
        },
        onSubmitted: (text) {
          _search();
        },
      ),
    );
  }

  void _search() async {
    String searchTerm = _searchController.text;
    String filePath = _getFilePath();
    int chosenPercent =
        PercentageDropdownController.of(context).percentageNotifier.value;
    String start = PercentageDropdownController.of(context)
        ._bookStartDropdownButtonState
        ._selectedBookStart;
    String end = PercentageDropdownController.of(context)
        ._bookEndDropdownButtonState
        ._selectedBookEnd;
    List<String> results =
        await Script.search(searchTerm, chosenPercent, filePath, start, end);

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
                    textDirection:
                        _isHebrew ? TextDirection.rtl : TextDirection.ltr,
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
              child: const Text('סגור'),
            ),
          ],
        );
      },
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
    final controller = PercentageDropdownController.of(context);
    final selectedLanguage =
        controller._languageDropdownButtonState.getSelectedLanguage();

    if (selectedLanguage == 'אנגלית') return 'assets/bible.txt';

    final version = controller._versionDropdownButtonState.getSelectedVersion();
    return version == 'דליטש' ? 'assets/bibleH.txt' : 'assets/bibleHN.txt';
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
          items: <int>[60, 75, 85, 90, 100].map((int value) {
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

  static _PercentageDropdownControllerState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PercentageDropdownController>()!
        .controller;
  }

  @override
  _PercentageDropdownControllerState createState() =>
      _PercentageDropdownControllerState();
}

class _PercentageDropdownControllerState
    extends State<PercentageDropdownController> {
  late ValueNotifier<int> _selectedPercentageNotifier;
  late _LanguageDropdownButtonState _languageDropdownButtonState;
  late _BookStartDropdownButtonState _bookStartDropdownButtonState;
  late _BookEndDropdownButtonState _bookEndDropdownButtonState;
  late _VersionDropdownButtonState _versionDropdownButtonState;

  ValueNotifier<int> get percentageNotifier => _selectedPercentageNotifier;
  final ValueNotifier<String> selectedLanguageNotifier =
      ValueNotifier<String>('עברית');

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
  }

  void setBookStartDropdownButtonState(_BookStartDropdownButtonState state) {
    _bookStartDropdownButtonState = state;
  }

  void setBookEndDropdownButtonState(_BookEndDropdownButtonState state) {
    _bookEndDropdownButtonState = state;
  }

  void setVersionDropdownButtonState(_VersionDropdownButtonState state) {
    _versionDropdownButtonState = state;
  }

  @override
  void dispose() {
    _selectedPercentageNotifier.dispose();
    super.dispose();
  }
}

class _PercentageDropdownController extends InheritedWidget {
  final _PercentageDropdownControllerState controller;
  const _PercentageDropdownController(
      {required this.controller, required super.child});
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
  String _selectedLanguage = 'עברית';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = PercentageDropdownController.of(context);
    controller.selectedLanguageNotifier.value = _selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final controller = PercentageDropdownController.of(context);
    controller.setLanguageDropdownButtonState(this);

    return DropdownButton<String>(
      value: _selectedLanguage,
      onChanged: (String? newValue) {
        setState(() {
          _selectedLanguage = newValue!;
        });
        controller.selectedLanguageNotifier.value = _selectedLanguage;
      },
      items: <String>['עברית', 'אנגלית'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String getSelectedLanguage() => _selectedLanguage;
}

class _VersionDropdownButton extends StatefulWidget {
  @override
  _VersionDropdownButtonState createState() => _VersionDropdownButtonState();
}

class _VersionDropdownButtonState extends State<_VersionDropdownButton> {
  String _selectedVersion = 'מודרני';

  @override
  Widget build(BuildContext context) {
    final controller = PercentageDropdownController.of(context);
    controller.setVersionDropdownButtonState(this);

    return DropdownButton<String>(
      value: _selectedVersion,
      onChanged: (String? newValue) {
        setState(() {
          _selectedVersion = newValue!;
        });
      },
      items: <String>['מודרני', 'דליטש'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String getSelectedVersion() => _selectedVersion;
}

class _BookStartDropdownButton extends StatefulWidget {
  @override
  _BookStartDropdownButtonState createState() =>
      _BookStartDropdownButtonState();
}

class _BookStartDropdownButtonState extends State<_BookStartDropdownButton> {
  String _selectedBookStart = 'בראשית';

  @override
  Widget build(BuildContext context) {
    final controller = PercentageDropdownController.of(context);
    controller.setBookStartDropdownButtonState(this);

    return DropdownButton<String>(
      value: _selectedBookStart,
      onChanged: (String? newValue) {
        setState(() {
          _selectedBookStart = newValue!;
        });
      },
      items: Script.booksH.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String getSelectedBookStart() => _selectedBookStart;
}

class _BookEndDropdownButton extends StatefulWidget {
  @override
  _BookEndDropdownButtonState createState() => _BookEndDropdownButtonState();
}

class _BookEndDropdownButtonState extends State<_BookEndDropdownButton> {
  String _selectedBookEnd = 'התגלות';

  @override
  Widget build(BuildContext context) {
    final controller = PercentageDropdownController.of(context);
    controller.setBookEndDropdownButtonState(this);

    return DropdownButton<String>(
      value: _selectedBookEnd,
      onChanged: (String? newValue) {
        setState(() {
          _selectedBookEnd = newValue!;
        });
      },
      items: Script.booksH.reversed.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String getSelectedBookEnd() => _selectedBookEnd;
}
