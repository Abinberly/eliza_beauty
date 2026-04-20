
class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "*Email is required";
    
    // final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // if (!emailRegex.hasMatch(value)) return AppConstants.errEmailInvalid;
    
    return null;
  }

static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "*Password is required";
    }
    
    if (value.length < 6) {
      return "*Minimum 6 characters required";
    }

    // // RegEx breakdown:
    // // (?=.*?[A-Z])       - At least one uppercase letter
    // // (?=.*?[a-z])       - At least one lowercase letter
    // // (?=.*?[0-9])       - At least one digit
    // // (?=.*?[!@#\$&*~])  - At least one special character
    // final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])');

    // if (!passwordRegex.hasMatch(value)) {
    //   return AppConstants.errPasswordComplexity;
    // }

    return null;
  }
}