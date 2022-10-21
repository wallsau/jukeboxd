//regex for email text form
String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Email address is required';
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid email address format';

  return null;
}

//regex for password text form(8 char, 0 < capitals, 0 < symbols)
String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required';
  }

  String pattern = r'^(?=.*?[A-Z])(?=.*[a-z])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return 'Password must be at least 8 characters and include an uppercase letter, number and symbol';
  }

  return null;
}
