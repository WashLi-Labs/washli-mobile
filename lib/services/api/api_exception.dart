abstract class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException(this.message, this.statusCode);

  static ApiException fromStatusCode(int statusCode, String message) {
    switch (statusCode) {
      case 401: return UnauthenticatedException(message);
      case 403: return ForbiddenException(message);
      case 404: return NotFoundException(message);
      case 409: return ConflictException(message);
      case 422: return ValidationException(message);
      case 500: return ServerException(message);
      default:  return ServerException(message);
    }
  }

  @override
  String toString() => '$runtimeType: $message';
}

class UnauthenticatedException extends ApiException {
  const UnauthenticatedException(String message) : super(message, 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(String message) : super(message, 403);
}

class NotFoundException extends ApiException {
  const NotFoundException(String message) : super(message, 404);
}

class ConflictException extends ApiException {
  const ConflictException(String message) : super(message, 409);
}

class ValidationException extends ApiException {
  const ValidationException(String message) : super(message, 422);
}

class ServerException extends ApiException {
  const ServerException(String message) : super(message, 500);
}

class NetworkException extends ApiException {
  const NetworkException(String message) : super(message, 0);
}
