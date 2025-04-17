class AppException implements Exception {
  final dynamic message;

  AppException([this.message]);

  @override
  String toString() {
    return '$message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([super.message]);
}

class DefaultException extends AppException {
  DefaultException([super.message]);
}

class CancelException extends AppException {
  CancelException([super.message]);
}

class BadRequestException extends AppException {
  BadRequestException([super.message]);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([super.message]);
}

class InvalidInputException extends AppException {
  InvalidInputException([super.message]);
}

class UserSessionExpiredException extends AppException {
  UserSessionExpiredException([super.message]);
}

class PageNotFoundException extends AppException {
  PageNotFoundException([super.message]);
}

class InternalServerException extends AppException {
  InternalServerException([super.message]);
}

class NoInternetException extends AppException {
  NoInternetException([super.message]);
}
