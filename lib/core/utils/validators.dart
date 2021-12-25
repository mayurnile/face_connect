class Validators {
  // constructor
  const Validators();

  // To check if the field is empty or not
  static String? isFieldEmpty(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'This field cannot be empty!';
    }
  }

  // To check if the the input email is valid or not
  static String? isValidEmail(String? value) {
    if (value != null) {
      final result = isFieldEmpty(value);
      if (result == null) {
        if (value.trim().contains("+") || value.trim().contains("/") || value.trim().contains("'")) {
          return 'Please enter valid email!';
        }
        if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value.trim())) {
          return 'Please enter valid email!';
        }
      } else {
        return result;
      }
    }
  }
}
