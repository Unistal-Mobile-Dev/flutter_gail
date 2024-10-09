class PhoneValidation {
  static Future<bool> checkPhoneValidation({required String phone}) async {
    if (phone.isEmpty) {
      return false;
    }
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phone);
  }
}
