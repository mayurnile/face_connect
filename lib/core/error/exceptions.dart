class ServerException implements Exception {
  final String message;
  final int code;
  final String exception;

  const ServerException({
    this.message = 'Something unexpected happened!',
    this.code = -1,
    this.exception = '',
  });
}

class AuthException implements Exception {
  final String message;
  final int code;

  const AuthException({
    this.message = 'Something unexpected happened!',
    this.code = -1,
  });
}

class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Something unexpected happened!',
  });
}

class DeviceException implements Exception {
  final String message;

  const DeviceException({
    this.message = 'Something unexpected happened!',
  });
}

// Some common exceptions
const ServerException SOMETHING_WENT_WRONG = ServerException(
  message: 'Something went wrong...',
  exception: 'Internal server error...',
);
