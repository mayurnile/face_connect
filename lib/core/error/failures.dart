import 'package:equatable/equatable.dart';

/// A [Failure] Represents Exception
/// This Failure class is super class of all other failures
/// All of the other failures extends this Failure class for writing abstract methods easier and generalizing return type
abstract class Failure extends Equatable {
  const Failure() : super();

  @override
  List<Object?> get props => [];
}

/// A [ServerFailure] represents error from the Server EndPoint
/// [message] contains the text to be shown in UI
/// [exception] contains the actual exception caught by the program for debugging
/// [code] is an extra field for now for future uses
class ServerFailure extends Failure with EquatableMixin {
  final String message;
  final String exception;
  final int code;

  const ServerFailure({
    required this.message,
    this.exception = '',
    this.code = -1,
  });

  @override
  List<Object?> get props => [message, exception, code];
}

/// A [AuthFailure] represents error while the auth process
/// [message] contains the text to be shown in UI
/// [exception] contains the actual exception caught by the program for debugging
/// [code] is an extra field for now for future uses
class AuthFailure extends Failure with EquatableMixin {
  final String message;
  final String exception;
  final int code;

  const AuthFailure({
    required this.message,
    this.exception = '',
    this.code = -1,
  });

  @override
  List<Object?> get props => [message, exception, code];
}

/// A [DeviceFailure] represents error while the interacting with device data, eg. Location, Contacts, Internet Connectivity, etc.
/// [message] contains the text to be shown in UI
/// [exception] contains the actual exception caught by the program for debugging
/// [code] is an extra field for now for future uses
class DeviceFailure extends Failure with EquatableMixin {
  final String message;
  final String exception;
  final int code;

  const DeviceFailure({
    required this.message,
    this.exception = '',
    this.code = -1,
  });

  @override
  List<Object?> get props => [message, exception, code];
}

/// A [CacheFailure] represents error while interacting with caches or data storage
/// [message] contains the text to be shown in UI
/// [exception] contains the actual exception caught by the program for debugging
/// [code] is an extra field for now for future uses
class CacheFailure extends Failure with EquatableMixin {
  final String message;
  final String exception;
  final int code;

  const CacheFailure({
    required this.message,
    this.exception = '',
    this.code = -1,
  });

  @override
  List<Object?> get props => [message, exception, code];
}
