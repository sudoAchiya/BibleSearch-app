// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class Script {
  // ignore: non_constant_identifier_names
static final List<String> booksH =[
  "בראשית", "שמות", "ויקרא", "במדבר", "דברים", "יהושוע",
  "שופטים", "שמואל א", "שמואל ב", "מלכים א", "מלכים ב", "ישעיה", "ירמיה", "יחזקאל", "הושע", "יואל", "עמוס",
  "עובדיה", "יונה", "מיכה", "נחום", "חבקוק", "צפניה", "חגי", "זכריה", "מלאכי", "תהילים", "משלי", "איוב",
  "שיר השירים", "רות", "איכה", "קהלת", "אסתר", "דניאל", "עזרא", "נחמיה", "דברי הימים א", "דברי הימים ב",
  "מתי", "מרקוס", "לוקס", "יוחנן", "מעשי השליחים", "אל הרומים", "הראשונה אל הקורינתים", "השניה אל הקורינתים",
  "אל הגלטים", "אל האפסים", "אל הפיליפים", "אל הקולוסים", "הראשונה אל התסלונים", "השניה אל התסלונים",
  "הראשונה אל טימותיאוס", "השניה אל טימותיאוס", "אל טיטוס", "אל פילימון", "אל העברים", "אגרת יעקב", "הראשונה לכיפא",
  "השניה לכיפא", "הראשונה ליוחנן", "השניה ליוחנן", "השלישית ליוחנן", "איגרת יהודה", "התגלות"];
static final Map<String, int> bookIndexMap = {
  "בראשית": 65, "שמות": 64, "ויקרא": 63, "במדבר": 62, "דברים": 61,
  "יהושוע": 60, "שופטים": 59, "שמואל א": 58, "שמואל ב": 57, "מלכים א": 56,
  "מלכים ב": 55, "ישעיה": 54, "ירמיה": 53, "יחזקאל": 52, "הושע": 51,
  "יואל": 50, "עמוס": 49, "עובדיה": 48, "יונה": 47, "מיכה": 46,
  "נחום": 45, "חבקוק": 44, "צפניה": 43, "חגי": 42, "זכריה": 41,
  "מלאכי": 40, "תהילים": 39, "משלי": 38, "איוב": 37, "שיר השירים": 36,
  "רות": 35, "איכה": 34, "קהלת": 33, "אסתר": 32, "דניאל": 31,
  "עזרא": 30, "נחמיה": 29, "דברי הימים א": 28, "דברי הימים ב": 27, 
  "מתי": 26, "מרקוס": 25, "לוקס": 24, "יוחנן": 23, "מעשי השליחים": 22, 
  "אל הרומים": 21, "הראשונה אל הקורינתים": 20, "השניה אל הקורינתים": 19,
  "אל הגלטים": 18, "אל האפסים": 17, "אל הפיליפים": 16, "אל הקולוסים": 15,
  "הראשונה אל התסלונים": 14, "השניה אל התסלונים": 13, "הראשונה אל טימותיאוס": 12,
  "השניה אל טימותיאוס": 11, "אל טיטוס": 10, "אל פילימון": 9, "אל העברים": 8,
  "אגרת יעקב": 7, "הראשונה לכיפא": 6, "השניה לכיפא": 5, "הראשונה ליוחנן": 4,
  "השניה ליוחנן": 3, "השלישית ליוחנן": 2, "איגרת יהודה": 1, "התגלות": 0,
};
static final Map<String, int> bookIndexMapE = {
  "Genesis": 65, "Exodus": 64, "Leviticus": 63, "Numbers": 62, "Deuteronomy": 61,
  "Joshua": 60, "Judges": 59, "Ruth": 58, "1 Samuel": 57, "2 Samuel": 56,
  "1 Kings": 55, "2 Kings": 54, "1 Chronicles": 53, "2 Chronicles": 52, "Ezra": 51,
  "Nehemiah": 50, "Esther": 49, "Job": 48, "Psalm": 47, "Proverbs": 46,
  "Ecclesiastes": 45, "Song of Solomon": 44, "Isaiah": 43, "Jeremiah": 42, "Lamentations": 41,
  "Ezekiel": 40, "Daniel": 39, "Hosea": 38, "Joel": 37, "Amos": 36,
  "Obadiah": 35, "Jonah": 34, "Micah": 33, "Nahum": 32, "Habakkuk": 31,
  "Zephaniah": 30, "Haggai": 29, "Zechariah": 28, "Malachi": 27, "Matthew": 26,
  "Mark": 25, "Luke": 24, "John": 23, "Acts": 22, "Romans": 21,
  "1 Corinthians": 20, "2 Corinthians": 19, "Galatians": 18, "Ephesians": 17, "Philippians": 16,
  "Colossians": 15, "1 Thessalonians": 14, "2 Thessalonians": 13, "1 Timothy": 12, "2 Timothy": 11,
  "Titus": 10, "Philemon": 9, "Hebrews": 8, "James": 7, "1 Peter": 6,
  "2 Peter": 5, "1 John": 4, "2 John": 3, "3 John": 2, "Jude": 1,
  "Revelation": 0,
};
  static final List<String> books = [
    "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", 
    "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", 
    "Esther", "Job", "Psalm", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", 
    "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", 
    "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", 
    "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", 
    "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", 
    "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"
  ];
  static final Map<String, String> bookDictionary = {
  "בראשית": "Genesis", "שמות": "Exodus", "ויקרא": "Leviticus", "במדבר": "Numbers", "דברים": "Deuteronomy",
  "יהושוע": "Joshua", "שופטים": "Judges", "שמואל א": "1 Samuel", "שמואל ב": "2 Samuel", "מלכים א": "1 Kings",
  "מלכים ב": "2 Kings", "ישעיה": "Isaiah", "ירמיה": "Jeremiah", "יחזקאל": "Ezekiel", "הושע": "Hosea",
  "יואל": "Joel", "עמוס": "Amos", "עובדיה": "Obadiah", "יונה": "Jonah", "מיכה": "Micah",
  "נחום": "Nahum", "חבקוק": "Habakkuk", "צפניה": "Zephaniah", "חגי": "Haggai", "זכריה": "Zechariah",
  "מלאכי": "Malachi", "תהילים": "Psalms", "משלי": "Proverbs", "איוב": "Job", "שיר השירים": "Song of Solomon",
  "רות": "Ruth", "איכה": "Lamentations", "קהלת": "Ecclesiastes", "אסתר": "Esther", "דניאל": "Daniel",
  "עזרא": "Ezra", "נחמיה": "Nehemiah", "דברי הימים א": "1 Chronicles", "דברי הימים ב": "2 Chronicles",
  "מתי": "Matthew", "מרקוס": "Mark", "לוקס": "Luke", "יוחנן": "John", "מעשי השליחים": "Acts",
  "אל הרומים": "Romans", "הראשונה אל הקורינתים": "1 Corinthians", "השניה אל הקורינתים": "2 Corinthians",
  "אל הגלטים": "Galatians", "אל האפסים": "Ephesians", "אל הפיליפים": "Philippians", "אל הקולוסים": "Colossians",
  "הראשונה אל התסלונים": "1 Thessalonians", "השניה אל התסלונים": "2 Thessalonians", "הראשונה אל טימותיאוס": "1 Timothy",
  "השניה אל טימותיאוס": "2 Timothy", "אל טיטוס": "Titus", "אל פילימון": "Philemon", "אל העברים": "Hebrews",
  "אגרת יעקב": "James", "הראשונה לכיפא": "1 Peter", "השניה לכיפא": "2 Peter", "הראשונה ליוחנן": "1 John",
  "השניה ליוחנן": "2 John", "השלישית ליוחנן": "3 John", "איגרת יהודה": "Jude", "התגלות": "Revelation",
};
  static String decodeUnicode(String encodedStr) {
    StringBuffer sb = StringBuffer();
    int i = 0;
    while (i < encodedStr.length) {
      if (encodedStr[i] == '\\' &&
          i + 1 < encodedStr.length &&
          encodedStr[i + 1] == 'u') {
        String hexCode = encodedStr.substring(i + 2, i + 6);
        int unicodeValue = int.parse(hexCode, radix: 16);
        sb.write(String.fromCharCode(unicodeValue));
        i += 6;
      } else {
        sb.write(encodedStr[i]);
        i++;
      }
    }
    return sb.toString();
  }

  static int countWords(String input) {
    if (input.isEmpty) {
      return 0;
    }

    // Split the input string by whitespace characters
    List<String> words = input.trim().split(RegExp(r'\s+'));

    // Return the number of resulting substrings (words)
    return words.length;
  }
  // ignore: non_constant_identifier_names
  static List<String> ChoosenBooks(String start, String end, List<String> inputList) {
  List<String> result = [];
  bool startFound = false;
  bool good = false;

  for (String item in inputList) {
    if (startFound) {
      if (item == end) {
        // End string found, add it to the result and break the loop
        result.add(item);
        good = true;
        break;
        
      } else {
        result.add(item);
      }
    } else {
      if (item == start) {
        // Start string found, start adding to the result list
        result.add(item);
        startFound = true;
      }
    }
  }
  if(good==false) {
    return [];
  }
  return result;
}
  static Future<List<String>> search(String searchTerm, int chosenPercent, String filePath, String startBook, String endBook) async {
    List<String> results;
    DateTime startTime = DateTime.now();
    if (filePath == "assets/bible.txt") {
      startBook = bookDictionary[startBook]!;
      endBook = bookDictionary[endBook]!;
      results = await searchInBible(searchTerm, countWords(searchTerm), chosenPercent, ChoosenBooks(startBook,endBook,books), filePath);
    } else {
      results = await searchInBibleH(searchTerm, countWords(searchTerm), chosenPercent, ChoosenBooks(startBook,endBook,booksH), filePath);
    }
    DateTime endTime = DateTime.now();
    Duration elapsedTime = endTime.difference(startTime);
  
    print('Elapsed time: ${elapsedTime.inMilliseconds} miliseconds');
    return results;
  }

  static Future<List<String>> searchInBibleH(String searchTerm, int numWords,int chosenPercent, List<String> chosenBooks, String filePath) async {
    List<String> results = [];
    int maxPercent = 0;
    bool flag = false;
    String currentBook ="";
    try {
      String fileContents = await rootBundle.loadString(filePath);
      LineSplitter.split(fileContents).forEach((line)  {
        if (line.startsWith("\$:")) {
          currentBook = line.split(":")[1].trim();
          flag = chosenBooks.contains(currentBook);
        } else if (flag) {
          String verseText = line.trim();
          List<String> versePartsList = createWordGroups(numWords, verseText);
          List<String> match = bestMatch(searchTerm, versePartsList, currentBook, verseText);
          int percent = int.parse(match[1]);
          if (maxPercent < percent) {
            maxPercent = percent;
          }
          
          if (percent >= chosenPercent) {
            String currentVerse = verseText.split(RegExp(r'\s+'))[0].split(":")[1];
            String currentChapter = verseText.split(RegExp(r'\s+'))[0].split(":")[0];
            String verse = verseText.split(RegExp(r'\s+')).sublist(1).join(" ");
            results.add(
                "ספר: $currentBook פרק: $currentChapter פסוק: $currentVerse\n $verse\n אחוזי התאמה: $percent\n חלק מתאים: ${match[0]}\n-----------------------------------");
          }
        }
      });
    } 
    catch (e) {
      print(e);
    }
    
    results.sort((a,b){
      int placmentA = int.parse(a.split('אחוזי התאמה: ')[1].split(' ')[0])*1000000
      + bookIndexMap[a.split('ספר: ')[1].split("פרק: ")[0].substring(0,a.split('ספר: ')[1].split("פרק: ")[0].length-1)]!*10000+
      int.parse(b.split('פרק: ')[1].split(' ')[0])*-100 +int.parse(b.split('פסוק: ')[1].split(' ')[0])*-1;
      int placmentB = int.parse(b.split('אחוזי התאמה: ')[1].split(' ')[0])*1000000
      + bookIndexMap[b.split('ספר: ')[1].split("פרק: ")[0].substring(0,b.split('ספר: ')[1].split("פרק: ")[0].length-1)]!*10000+
      int.parse(b.split('פרק: ')[1].split(' ')[0])*-100 +int.parse(b.split('פסוק: ')[1].split(' ')[0])*-1;
      return placmentB.compareTo(placmentA);
    });
    return results;
  }
  static Future<List<String>> searchInBible(String searchTerm, int numWords,int chosenPercent, List<String> chosenBooks, String filePath) async {
    List<String> results = [];
    int maxPercent = 0;
    bool flag = false;
    String currentBook ="";
    try {
      String fileContents = await rootBundle.loadString(filePath);
      LineSplitter.split(fileContents).forEach((line)  {
        if (line.startsWith("T:")) {
          currentBook = line.split(":")[1].trim();
          flag = chosenBooks.contains(currentBook);
        } else if (flag) {
          String verseText = line.trim();
          List<String> versePartsList = createWordGroups(numWords, verseText);
          List<String> match = bestMatch(searchTerm, versePartsList, currentBook, verseText);
          int percent = int.parse(match[1]);
          if (maxPercent < percent) {
            maxPercent = percent;
          }
          
          if (percent >= chosenPercent) {
            String currentVerse = verseText.split(RegExp(r'\s+'))[0].split(":")[1];
            String currentChapter = verseText.split(RegExp(r'\s+'))[0].split(":")[0];
            String verse = verseText.split(RegExp(r'\s+')).sublist(1).join(" ");
            results.add("Book: $currentBook Chapter: $currentChapter Verse: $currentVerse\n $verse\n Match percent: $percent\n Matching part: ${match[0]}\n-----------------------------------");
          }
        }
      });
    } 
    catch (e) {
      print(e);
    }
    results.sort((a, b) {
    // Parse matched percent from string 'a'
int matchPercentA = int.parse(a.split('Match percent: ')[1].split(' ')[0]);

// Parse book name from string 'a'
String bookNameA = a.split('Book: ')[1].split("Chapter: ")[0].substring(0, a.split('Book: ')[1].split("Chapter: ")[0].length - 1);

// Get the index of the book from the map and multiply it by 10,000
int bookIndexA = bookIndexMapE[bookNameA]! * 10000;

// Parse chapter number from string 'b'
int chapterNumberA = int.parse(a.split('Chapter: ')[1].split(' ')[0]);

// Parse verse number from string 'b'
int verseNumberA = int.parse(a.split('Verse: ')[1].split(' ')[0]);

// Combine all parts into 'placementA'
int placementA = matchPercentA * 1000000 + bookIndexA + chapterNumberA * -100 + verseNumberA * -1;
// Parse matched percent from string 'b'
int matchPercentB = int.parse(b.split('Match percent: ')[1].split(' ')[0]);

// Parse book name from string 'b'
String bookNameB = b.split('Book: ')[1].split("Chapter: ")[0].substring(0, b.split('Book: ')[1].split("Chapter: ")[0].length - 1);

// Get the index of the book from the map and multiply it by 10,000
int bookIndexB = bookIndexMapE[bookNameB]! * 10000;

// Parse chapter number from string 'b'
int chapterNumberB = int.parse(b.split('Chapter: ')[1].split(' ')[0]);

// Parse verse number from string 'b'
int verseNumberB = int.parse(b.split('Verse: ')[1].split(' ')[0]);

// Combine all parts into 'placementB'
int placementB = matchPercentB * 1000000 + bookIndexB + chapterNumberB * -100 + verseNumberB * -1;

      return placementB.compareTo(placementA);
    });
    return results;
  }

  static List<String> createWordGroups(int numWords, String text) {
    List<String> wordGroups = [];
    List<String> words = text.split(RegExp(r'\s+'));
    for (int i = 0; i <= words.length - numWords; i++) {
      StringBuffer wordGroup = StringBuffer();
      for (int j = 0; j < numWords; j++) {
        wordGroup.write("${words[i + j]} ");
      }
      wordGroups.add(wordGroup.toString().trim());
    }
    return wordGroups;
  }

  static int getLevenshteinDistance(String s, String t) {
    int n = s.length;
    int m = t.length;

    if (n == 0) {
      return m;
    }
    if (m == 0) {
      return n;
    }

    if (n > m) {
      // swap the input strings to consume less memory
      String tmp = s;
      s = t;
      t = tmp;
      n = m;
      m = t.length;
    }

    List<int> p = List<int>.generate(n + 1, (int index) => index);
    // indexes into strings s and t
    int i; // iterates through s
    int j; // iterates through t
    int upperleft;
    int upper;

    String jOfT; // jth character of t
    int cost;

    for (i = 0; i <= n; i++) {
      p[i] = i;
    }

    for (j = 1; j <= m; j++) {
      upperleft = p[0];
      jOfT = t[j - 1];
      p[0] = j;

      for (i = 1; i <= n; i++) {
        upper = p[i];
        cost = s[i - 1] == jOfT ? 0 : 1;
        // minimum of cell to the left+1, to the top+1, diagonally left and up +cost
        p[i] = [p[i - 1] + 1, p[i] + 1, upperleft + cost].reduce((a, b) => a < b ? a : b);
        upperleft = upper;
      }
    }

    return p[n];
  }

  static List<String> bestMatch(String searchTerm, List<String> list, String currentBook, String currentVerse) {
    String maxMatch = "aa";
    int maxSimilarity = 0;
    try{
    for (String wordGroup in list) {
      String wordGroupl = wordGroup.toLowerCase().replaceAll(',', '').replaceAll('.', '').replaceAll(':', '').replaceAll('', '');
      if (wordGroupl[0]==searchTerm[0]||wordGroupl[1]==searchTerm[1]||wordGroupl[1]==searchTerm[0]||wordGroupl[0]==searchTerm[1]) {//fast search
          int distance = getLevenshteinDistance(wordGroupl, searchTerm);
          int maxLength = [wordGroupl.length, searchTerm.length].reduce((a, b) => a > b ? a : b);
          int similarity = (((maxLength - distance) / maxLength) * 100).toInt();
          if (similarity > maxSimilarity) {
            maxSimilarity = similarity;
            maxMatch = wordGroup.replaceAll(',', '').replaceAll('.', '').replaceAll(':', '').replaceAll('', '');
          }
      }
    }
    }
    // ignore: empty_catches
    on RangeError {}
    return [maxMatch, maxSimilarity.toString()];
  }
}