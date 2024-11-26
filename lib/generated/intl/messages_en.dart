// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addTask_AddTask": MessageLookupByLibrary.simpleMessage("Add New Task"),
        "addTask_Category": MessageLookupByLibrary.simpleMessage("Category"),
        "addTask_Date": MessageLookupByLibrary.simpleMessage("Date"),
        "addTask_Notes": MessageLookupByLibrary.simpleMessage("Notes"),
        "addTask_Save": MessageLookupByLibrary.simpleMessage("Save"),
        "addTask_TaskTitle": MessageLookupByLibrary.simpleMessage("Task Title"),
        "addTask_Time": MessageLookupByLibrary.simpleMessage("Time"),
        "addTask_Update": MessageLookupByLibrary.simpleMessage("Update"),
        "auth_ConfirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "auth_CreateSuccess": MessageLookupByLibrary.simpleMessage(
            "Successfully create new account"),
        "auth_Password": MessageLookupByLibrary.simpleMessage("Password"),
        "auth_Register": MessageLookupByLibrary.simpleMessage("Register"),
        "auth_SignIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "common_Delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "common_EmptyField":
            MessageLookupByLibrary.simpleMessage("Field cannot be empty!"),
        "common_Error": MessageLookupByLibrary.simpleMessage("Error occurred"),
        "common_InvalidEmail":
            MessageLookupByLibrary.simpleMessage("Invalid email"),
        "common_PasswordErrorLength": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 8 characters long"),
        "common_PasswordErrorMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "common_Success": MessageLookupByLibrary.simpleMessage("Success"),
        "home_Complete": MessageLookupByLibrary.simpleMessage("Completed"),
        "home_EmptyData": MessageLookupByLibrary.simpleMessage("Empty Data"),
        "home_Title": MessageLookupByLibrary.simpleMessage("My Todo List")
      };
}
