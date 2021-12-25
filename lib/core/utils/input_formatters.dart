import 'package:flutter/services.dart';

class InputFormatters {
  // Input formatter for making the user input only [a-z], [A-Z] and space
  FilteringTextInputFormatter onlyAlphabestInput = FilteringTextInputFormatter.allow(
    RegExp("[a-z|A-Z|\\s+]"),
  );

  // Input formatter for making the user input a paragraph details
  FilteringTextInputFormatter paragraphInput = FilteringTextInputFormatter.deny(
    RegExp("!|@|#|%|^|"),
  );

  // Input formatter for proper email only input
  FilteringTextInputFormatter onlyEmailInput = FilteringTextInputFormatter.deny(
    RegExp(r"!|#|\$|%|\^|\&|\*|-|=|\+\*|\?|,|;|:|\(|\)|\[|\]|\{|\}|\s"),
  );

  // Input formatter for numbers only input
  FilteringTextInputFormatter onlyNumbersInput = FilteringTextInputFormatter.allow(
    RegExp("[0-9]"),
  );

  // Input formatter for social handle input
  FilteringTextInputFormatter socialMediaHandleInput = FilteringTextInputFormatter.deny(
    RegExp("@|#"),
  );
}
