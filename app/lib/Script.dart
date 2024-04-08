// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class Script {
  // ignore: non_constant_identifier_names
  static final List<String> booksH =["בראשית", "שמות", "ויקרא", "במדבר", "דברים", "יהושוע",
            "שופטים", "שמואל א", "שמואל ב", "מלכים א", "מלכים ב", "ישעיה", "ירמיה", "יחזקאל", "הושע", "יואל", "עמוס",
            "עובדיה", "יונה", "מיכה", "נחום", "חבקוק", "צפניה", "חגי", "זכריה", "מלאכי", "תהילים", "משלי", "איוב",
            "שיר השירים", "רות", "איכה", "קהלת", "אסתר", "דניאל", "עזרא", "נחמיה", "דברי הימים א", "דברי הימים ב",
            "מתי", "מרקוס", "לוקס", "יוחנן", "מעשי השליחים", "אל הרומים", "הראשונה אל הקורינתים", "השניה אל הקורינתים",
            "אל הגלטים", "אל האפסים", "אל הפיליפים", "אל הקולוסים", "הראשונה אל התסלונים", "השניה אל התסלונים",
            "הראשונה אל טימותיאוס", "השניה אל טימותיאוס", "אל טיטוס", "אל פילימון", "אל העברים", "אגרת יעקב", "הראשונה לכיפא",
            "השניה לכיפא", "הראשונה ליוחנן", "השניה ליוחנן", "השלישית ליוחנן", "איגרת יהודה", "התגלות"];

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

  static Future<List<String>> search(String searchTerm, int chosenPercent, String filePath) async {
    List<String> results;
    DateTime startTime = DateTime.now();
    if (filePath == "assets/bible.txt") {
      results = await searchInBible(searchTerm, countWords(searchTerm), chosenPercent, books, filePath);
    } else {
      results = await searchInBibleH(searchTerm, countWords(searchTerm), chosenPercent, booksH, filePath);
    }
    DateTime endTime = DateTime.now();
    Duration elapsedTime = endTime.difference(startTime);
  
    print('Elapsed time: ${elapsedTime.inMilliseconds} miliseconds');
    return results;
  }

  static Future<List<String>> searchInBibleH(String searchTerm, int numWords,
    int chosenPercent, List<String> chosenBooks, String filePath) async {
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
    results.sort((a, b) {
    // Extract percentages from strings
    int percentA = int.parse(a.split('אחוזי התאמה: ')[1].split(' ')[0]);
    int percentB = int.parse(b.split('אחוזי התאמה: ')[1].split(' ')[0]);
    // Compare percentages
    return percentB.compareTo(percentA); // Sorting in descending order
    });
    return results;
  }
  static String highlightMatch(String text, String searchTerm) {
    int startIndex = text.indexOf(searchTerm);
    if (startIndex == -1) return text;

    String highlightedText = "${text.substring(0, startIndex)} ";
    highlightedText += '\u001b[34m$searchTerm\u001b[0m'+" "; // ANSI escape code for blue color
    highlightedText += text.substring(startIndex + searchTerm.length);
    print(highlightedText);
    return highlightedText;
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
            String highlightedVerse = highlightMatch(verse, searchTerm);
            results.add("Book: $currentBook Chapter: $currentChapter Verse: $currentVerse\n $highlightedVerse\n Match percent: $percent\n Matching part: ${match[0]}\n-----------------------------------");
          }
        }
      });
    } 
    catch (e) {
      print(e);
    }
    results.sort((a, b) {
    // Extract percentages from strings
    int percentA = int.parse(a.split('Match percent: ')[1].split(' ')[0]);
    int percentB = int.parse(b.split('Match percent: ')[1].split(' ')[0]);
    // Compare percentages
    return percentB.compareTo(percentA); // Sorting in descending order
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