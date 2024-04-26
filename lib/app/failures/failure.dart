import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

// 422
class AlreadyRegisteredUserEmailFailure extends Failure {}

enum FailureCode {
  alreadyRegisteredUserEmailFailure('422');

  const FailureCode(this.code);

  final String code;
}
