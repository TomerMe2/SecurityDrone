import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:security_drone_user_app/communication/data_sender/to_server.dart';
import 'package:security_drone_user_app/data/models/request_type.dart';

part '../event/mission_event.dart';
part '../state/mission_state.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {

  MissionBloc() : super(NoRequest());

  @override
  Stream<MissionState> mapEventToState(MissionEvent event) async* {
    if (event is PatrolRequest) {
     yield SendingRequest(RequestType.Patrol);
     //TODO: add support for failed transmission operation
     await sendRequest("Patrol request");
     yield RequestReceived(RequestType.Patrol);
    }
    else if (event is WatchHerdRequest) {
      yield SendingRequest(RequestType.WatchHerd);
      //TODO: add support for failed transmission operation
      await sendRequest("Watch herd request");
      yield RequestReceived(RequestType.WatchHerd);
    }
    else if (event is AbortMissionRequest) {
      yield SendingRequest(RequestType.Abort);
      //TODO: add support for failed transmission operation
      await sendRequest("Abort request");
      yield RequestReceived(RequestType.Abort);
    }
    else {
      yield NoRequest();
    }
  }
}
