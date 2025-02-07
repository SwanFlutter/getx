import 'package:intl/intl.dart';

import '../get_utils/get_utils.dart';

extension GetStringUtils on String {
  /// Discover if the String is a valid number
  ///
  /// Example:
  /// ```dart
  /// bool isValid = "123".isNum;
  /// // Result: true
  /// ```
  bool get isNum => GetUtils.isNum(this);

  /// Discover if the String is numeric only
  ///
  /// Example:
  /// ```dart
  /// bool isNumeric = "123".isNumericOnly;
  /// // Result: true
  /// ```
  bool get isNumericOnly => GetUtils.isNumericOnly(this);

  /// Extract numeric characters from the String
  ///
  /// Example:
  /// ```dart
  /// String numeric = "abc123".numericOnly();
  /// // Result: "123"
  /// ```
  String numericOnly({bool firstWordOnly = false}) => GetUtils.numericOnly(this, firstWordOnly: firstWordOnly);

  /// Discover if the String is alphanumeric only
  ///
  /// Example:
  /// ```dart
  /// bool isAlphabet = "abc".isAlphabetOnly;
  /// // Result: true
  /// ```
  bool get isAlphabetOnly => GetUtils.isAlphabetOnly(this);

  /// Discover if the String is a boolean
  ///
  /// Example:
  /// ```dart
  /// bool isBool = "true".isBool;
  /// // Result: true
  /// ```
  bool get isBool => GetUtils.isBool(this);

  /// Discover if the String is a vector file name
  ///
  /// Example:
  /// ```dart
  /// bool isVector = "image.svg".isVectorFileName;
  /// // Result: true
  /// ```
  bool get isVectorFileName => GetUtils.isVector(this);

  /// Discover if the String is an image file name
  ///
  /// Example:
  /// ```dart
  /// bool isImage = "image.png".isImageFileName;
  /// // Result: true
  /// ```
  bool get isImageFileName => GetUtils.isImage(this);

  /// Discover if the String is an audio file name
  ///
  /// Example:
  /// ```dart
  /// bool isAudio = "audio.mp3".isAudioFileName;
  /// // Result: true
  /// ```
  bool get isAudioFileName => GetUtils.isAudio(this);

  /// Discover if the String is a video file name
  ///
  /// Example:
  /// ```dart
  /// bool isVideo = "video.mp4".isVideoFileName;
  /// // Result: true
  /// ```
  bool get isVideoFileName => GetUtils.isVideo(this);

  /// Discover if the String is a text file name
  ///
  /// Example:
  /// ```dart
  /// bool isTxt = "document.txt".isTxtFileName;
  /// // Result: true
  /// ```
  bool get isTxtFileName => GetUtils.isTxt(this);

  /// Discover if the String is a Word document file name
  ///
  /// Example:
  /// ```dart
  /// bool isWord = "document.docx".isDocumentFileName;
  /// // Result: true
  /// ```
  bool get isDocumentFileName => GetUtils.isWord(this);

  /// Discover if the String is an Excel document file name
  ///
  /// Example:
  /// ```dart
  /// bool isExcel = "spreadsheet.xlsx".isExcelFileName;
  /// // Result: true
  /// ```
  bool get isExcelFileName => GetUtils.isExcel(this);

  /// Discover if the String is a PowerPoint document file name
  ///
  /// Example:
  /// ```dart
  /// bool isPPT = "presentation.pptx".isPPTFileName;
  /// // Result: true
  /// ```
  bool get isPPTFileName => GetUtils.isPPT(this);

  /// Discover if the String is an APK file name
  ///
  /// Example:
  /// ```dart
  /// bool isAPK = "app.apk".isAPKFileName;
  /// // Result: true
  /// ```
  bool get isAPKFileName => GetUtils.isAPK(this);

  /// Discover if the String is a PDF file name
  ///
  /// Example:
  /// ```dart
  /// bool isPDF = "document.pdf".isPDFFileName;
  /// // Result: true
  /// ```
  bool get isPDFFileName => GetUtils.isPDF(this);

  /// Discover if the String is an HTML file name
  ///
  /// Example:
  /// ```dart
  /// bool isHTML = "index.html".isHTMLFileName;
  /// // Result: true
  /// ```
  bool get isHTMLFileName => GetUtils.isHTML(this);

  /// Discover if the String is a URL
  ///
  /// Example:
  /// ```dart
  /// bool isURL = "https://example.com".isURL;
  /// // Result: true
  /// ```
  bool get isURL => GetUtils.isURL(this);

  /// Discover if the String is an email
  ///
  /// Example:
  /// ```dart
  /// bool isEmail = "example@example.com".isEmail;
  /// // Result: true
  /// ```
  bool get isEmail => GetUtils.isEmail(this);

  /// Discover if the String is a phone number
  ///
  /// Example:
  /// ```dart
  /// bool isPhoneNumber = "09123456789".isPhoneNumber;
  /// // Result: true
  /// ```
  bool get isPhoneNumber => GetUtils.isPhoneNumber(this);

  /// Discover if the String is a DateTime
  ///
  /// Example:
  /// ```dart
  /// bool isDateTime = "2023-10-10".isDateTime;
  /// // Result: true
  /// ```
  bool get isDateTime => GetUtils.isDateTime(this);

  /// Discover if the String is an MD5 hash
  ///
  /// Example:
  /// ```dart
  /// bool isMD5 = "d41d8cd98f00b204e9800998ecf8427e".isMD5;
  /// // Result: true
  /// ```
  bool get isMD5 => GetUtils.isMD5(this);

  /// Discover if the String is a SHA1 hash
  ///
  /// Example:
  /// ```dart
  /// bool isSHA1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709".isSHA1;
  /// // Result: true
  /// ```
  bool get isSHA1 => GetUtils.isSHA1(this);

  /// Discover if the String is a SHA256 hash
  ///
  /// Example:
  /// ```dart
  /// bool isSHA256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855".isSHA256;
  /// // Result: true
  /// ```
  bool get isSHA256 => GetUtils.isSHA256(this);

  /// Discover if the String is a binary value
  ///
  /// Example:
  /// ```dart
  /// bool isBinary = "101010".isBinary;
  /// // Result: true
  /// ```
  bool get isBinary => GetUtils.isBinary(this);

  /// Discover if the String is an IPv4 address
  ///
  /// Example:
  /// ```dart
  /// bool isIPv4 = "192.168.1.1".isIPv4;
  /// // Result: true
  /// ```
  bool get isIPv4 => GetUtils.isIPv4(this);

  /// Discover if the String is an IPv6 address
  ///
  /// Example:
  /// ```dart
  /// bool isIPv6 = "2001:0db8:85a3:0000:0000:8a2e:0370:7334".isIPv6;
  /// // Result: true
  /// ```
  bool get isIPv6 => GetUtils.isIPv6(this);

  /// Discover if the String is a hexadecimal value
  ///
  /// Example:
  /// ```dart
  /// bool isHexadecimal = "1a2b3c".isHexadecimal;
  /// // Result: true
  /// ```
  bool get isHexadecimal => GetUtils.isHexadecimal(this);

  /// Discover if the String is a palindrome
  ///
  /// Example:
  /// ```dart
  /// bool isPalindrome = "madam".isPalindrome;
  /// // Result: true
  /// ```
  bool get isPalindrome => GetUtils.isPalindrome(this);

  /// Discover if the String is a passport number
  ///
  /// Example:
  /// ```dart
  /// bool isPassport = "A12345678".isPassport;
  /// // Result: true
  /// ```
  bool get isPassport => GetUtils.isPassport(this);

  /// Discover if the String is a currency
  ///
  /// Example:
  /// ```dart
  /// bool isCurrency = "\$100".isCurrency;
  /// // Result: true
  /// ```
  bool get isCurrency => GetUtils.isCurrency(this);

  /// Discover if the String is a CPF number
  ///
  /// Example:
  /// ```dart
  /// bool isCpf = "123.456.789-09".isCpf;
  /// // Result: true
  /// ```
  bool get isCpf => GetUtils.isCpf(this);

  /// Discover if the String is a CNPJ number
  ///
  /// Example:
  /// ```dart
  /// bool isCnpj = "12.345.678/0001-95".isCnpj;
  /// // Result: true
  /// ```
  bool get isCnpj => GetUtils.isCnpj(this);

  /// Discover if the String contains another string case insensitively
  ///
  /// Example:
  /// ```dart
  /// bool contains = "Hello World".isCaseInsensitiveContains("hello");
  /// // Result: true
  /// ```
  bool isCaseInsensitiveContains(String b) => GetUtils.isCaseInsensitiveContains(this, b);

  /// Discover if the String contains any value case insensitively
  ///
  /// Example:
  /// ```dart
  /// bool containsAny = "Hello World".isCaseInsensitiveContainsAny("hello");
  /// // Result: true
  /// ```
  bool isCaseInsensitiveContainsAny(String b) => GetUtils.isCaseInsensitiveContainsAny(this, b);

  /// Capitalize the String
  ///
  /// Example:
  /// ```dart
  /// String capitalized = "hello".capitalize;
  /// // Result: "Hello"
  /// ```
  String get capitalize => GetUtils.capitalize(this);

  /// Capitalize the first letter of the String
  ///
  /// Example:
  /// ```dart
  /// String capitalizedFirst = "hello world".capitalizeFirst;
  /// // Result: "Hello world"
  /// ```
  String get capitalizeFirst => GetUtils.capitalizeFirst(this);

  /// Remove all whitespace from the String
  ///
  /// Example:
  /// ```dart
  /// String noWhitespace = " h e l l o ".removeAllWhitespace;
  /// // Result: "hello"
  /// ```
  String get removeAllWhitespace => GetUtils.removeAllWhitespace(this);

  /// Convert the String to camel case
  ///
  /// Example:
  /// ```dart
  /// String camelCase = "hello world".camelCase;
  /// // Result: "helloWorld"
  /// ```
  String? get camelCase => GetUtils.camelCase(this);

  /// Convert the String to param case
  ///
  /// Example:
  /// ```dart
  /// String paramCase = "Hello World".paramCase;
  /// // Result: "hello-world"
  /// ```
  String? get paramCase => GetUtils.paramCase(this);

  /// Add segments to the String
  ///
  /// Example:
  /// ```dart
  /// String path = "home".createPath(["user", "documents"]);
  /// // Result: "/home/user/documents"
  /// ```
  String createPath([Iterable? segments]) {
    final path = startsWith('/') ? this : '/$this';
    return GetUtils.createPath(path, segments);
  }

  /// Capitalize only the first letter in each word of the String
  ///
  /// Example:
  /// ```dart
  /// String capitalizedWords = "hello world".capitalizeAllWordsFirstLetter();
  /// // Result: "Hello World"
  /// ```
  String capitalizeAllWordsFirstLetter() => GetUtils.capitalizeAllWordsFirstLetter(this);

  /// Reverse the String
  ///
  /// Example:
  /// ```dart
  /// String reversed = "hello".reversed;
  /// // Result: "olleh"
  /// ```
  String get reversed => split('').reversed.join('');

  /// Check if the String is empty or null
  ///
  /// Example:
  /// ```dart
  /// bool isEmpty = "".isNullOrEmpty;
  /// // Result: true
  /// ```
  bool get isNullOrEmpty => isEmpty;

  /// Convert the String to title case
  ///
  /// Example:
  /// ```dart
  /// String titleCased = GetStringUtils.titleCase("hello world");
  /// // Result: "Hello World"
  /// ```
  static String titleCase(String input) {
    if (input.isEmpty) return input;

    return input.split(' ').map((word) {
      if (word.isEmpty) return word;

      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

/// Converts a string to a formatted number representation
extension StringNumberFormatter on String {
  /// Attempts to parse the string to a number and format it
  ///
  /// Example:
  /// ```dart
  /// String formattedNumber = "1234567".toNumberFormatted();
  /// // Result: "1,234,567"
  /// String originalText = "hello".toNumberFormatted();
  /// // Result: "hello"
  /// ```
  String toNumberFormatted() {
    try {
      final number = int.parse(this);
      final formatter = NumberFormat('#,###');
      return formatter.format(number);
    } catch (e) {
      return this;
    }
  }

  /// Attempts to parse the string to a double and format it with two decimal places
  ///
  /// Example:
  /// ```dart
  /// String formattedNumber = "1234.5678".toDoubleFormatted();
  /// // Result: "1,234.57"
  /// String originalText = "hello".toDoubleFormatted();
  /// // Result: "hello"
  /// ```
  String toDoubleFormatted() {
    try {
      final number = double.parse(this);
      final formatter = NumberFormat('#,##0.00');
      return formatter.format(number);
    } catch (e) {
      return this;
    }
  }
}
