import 'package:security_drone_user_app/data/models/request_type.dart';
import 'package:security_drone_user_app/logic/bloc/mission_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {

  //TODO: add tests for failed requests

  blocTest('Check Patrol request',
      build: () => MissionBloc(),
      act: (bloc) => bloc.add(PatrolRequest()),
      expect: [SendingRequest(RequestType.Patrol), RequestReceived(RequestType.Patrol)]
  );

  blocTest('Check WatchHerdRequest',
      build: () => MissionBloc(),
      act: (bloc) => bloc.add(WatchHerdRequest()),
      expect: [SendingRequest(RequestType.WatchHerd), RequestReceived(RequestType.WatchHerd)]
  );

  blocTest('Check AbortMissionRequest',
      build: () => MissionBloc(),
      act: (bloc) => bloc.add(AbortMissionRequest()),
      expect: [SendingRequest(RequestType.Abort), RequestReceived(RequestType.Abort)]
  );
}