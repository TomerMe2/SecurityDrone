part of '../bloc/mission_bloc.dart';

@immutable
abstract class MissionState extends Equatable {
  final RequestType requestType;

  MissionState(this.requestType);

  @override
  List<Object> get props => [requestType];
}
class NoRequest extends MissionState {
  NoRequest() : super(RequestType.none);
}

class SendingRequest extends MissionState {
  SendingRequest(requestType) : super(requestType);
}

class RequestReceived extends MissionState{
  RequestReceived(requestType) : super(requestType);
}

