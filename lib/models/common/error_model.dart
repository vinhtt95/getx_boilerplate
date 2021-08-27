import '../../util/constants/locale_keys.dart';

enum ErrorType { TIME_OUT, NO_INTERNET, CANCELLED, UNKNOWN }

class ErrorModel {
  int code;
  String description;
  String message;
  ErrorType type;

  ErrorModel({
    this.code = 0,
    this.message = LocaleKeys.error,
    this.description = LocaleKeys.unknown_error,
    this.type = ErrorType.UNKNOWN,
  });
}
