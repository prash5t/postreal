class TextFieldValidator {
  static captionValidator(caption) {
    if (caption.length > 50) {
      return "Caption cannot be longer than 50chars";
    }
    return null;
  }

  static emailValidator(email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      return null;
    } else {
      return "Enter valid email address";
    }
  }

  static bioValidator(bio) {
    if (bio!.isEmpty || bio.length < 6) {
      return "Bio length must be atleast 6";
    }
    return null;
  }

  static passwordValidator(password) {
    if (password!.isEmpty || password.length < 6) {
      return "Password length must be atleast 6";
    }

    return null;
  }

  static validateUsername(username) {
    // The username can only contain letters, numbers, periods, and underscores.
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9._]+$');

    if (username.isEmpty) {
      return 'Username is required';
    } else if (username.length < 4) {
      return 'Username must be at least 4 characters';
    } else if (username.length > 30) {
      return 'Username must be less than 30 characters';
    } else if (!usernameRegex.hasMatch(username)) {
      return 'Username can only contain letters, numbers, periods, and underscores';
    }

    return null;
  }
}
