import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:security_drone_user_app/data/data_api/mission_request_api.dart';
import 'package:security_drone_user_app/data/models/request_type.dart';

part '../event/mission_event.dart';
part '../state/mission_state.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {
  MissionAPI api = MissionAPI();

  MissionBloc() : super(NoRequest());

  @override
  Stream<MissionState> mapEventToState(MissionEvent event) async* {
    if (event is PatrolRequest) {
     yield SendingRequest(RequestType.Patrol);
     //TODO: Token
     await api.sendMission("patrol", "");
     yield RequestReceived(RequestType.Patrol);
    }
    else if (event is WatchHerdRequest) {
      yield SendingRequest(RequestType.WatchHerd);
      //TODO: Token
      await api.sendMission("watch herd", "");
      yield RequestReceived(RequestType.WatchHerd);
    }
    else if (event is AbortMissionRequest) {
      yield SendingRequest(RequestType.Abort);
      //TODO: Token
      await api.sendMission("abort", "");
      yield RequestReceived(RequestType.Abort);
    }
    else {
      yield NoRequest();
    }
  }
}
