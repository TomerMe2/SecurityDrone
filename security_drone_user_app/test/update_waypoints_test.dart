import 'dart:convert';

import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/logic/bloc/patrol_map_bloc.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'dart:io';

void cleanFile() {
  final file = new File(testsOutputFile);
  file.writeAsStringSync('');
}

void main() {

  var point = LatLngPoint(35.12, 34.11);
  var closePoint = LatLngPoint(point.lat + 0.00000001, point.lng);
  var farPoint = LatLngPoint(point.lat, point.lng + 0.01);

  // say that we are testing
  debugTestingProd = 1;

  blocTest('Check add point',
    build: () => PatrolMapBloc(),
    act: (bloc) => bloc.add(PatrolMapPointClicked(point)),
    expect: [PatrolMapShowingPoints([point])]
  );

  blocTest('Check add close point',
      build: () => PatrolMapBloc(),
      act: (bloc) {
        bloc.add(PatrolMapPointClicked(point));
        bloc.add(PatrolMapPointClicked(closePoint));
      },
      expect: [PatrolMapShowingPoints([point]), WantApprovalForDeletion(closePoint, point, [point])]
  );

  blocTest('Check add far point',
      build: () => PatrolMapBloc(),
      act: (bloc) {
        bloc.add(PatrolMapPointClicked(point));
        bloc.add(PatrolMapPointClicked(farPoint));
      },
      expect: [PatrolMapShowingPoints([point]), PatrolMapShowingPoints([point, farPoint])]
  );

  blocTest('Check do not delete close point',
      build: () => PatrolMapBloc(),
      act: (bloc) {
        bloc.add(PatrolMapPointClicked(point));
        bloc.add(PatrolMapPointClicked(closePoint));
        bloc.add(DoNotDelete());
      },
      expect: [PatrolMapShowingPoints([point]), WantApprovalForDeletion(closePoint, point, [point]), PatrolMapShowingPoints([point, closePoint])]
  );

  blocTest('Check delete close point',
      build: () => PatrolMapBloc(),
      act: (bloc) {
        bloc.add(PatrolMapPointClicked(point));
        bloc.add(PatrolMapPointClicked(closePoint));
        bloc.add(ApproveDeletion());
      },
      expect: [PatrolMapShowingPoints([point]), WantApprovalForDeletion(closePoint, point, [point]), PatrolMapShowingPoints([])]
  );


  blocTest('Check send waypoints to server',
      build: () {
        cleanFile();
        return PatrolMapBloc();
      },
      act: (bloc) {
        bloc.add(PatrolMapPointClicked(point));
        bloc.add(PatrolMapPointClicked(farPoint));
        bloc.add(DonePickingPoints());
      },
      expect: [PatrolMapShowingPoints([point]),
        PatrolMapShowingPoints([point, farPoint]),
        SendingDataToServer([point, farPoint]),
        DoneSendDataToServer([point, farPoint])],
      verify: (PatrolMapBloc bloc) async {
        final file = new File(testsOutputFile);
        String strFromFile = file.readAsStringSync();
        expect(strFromFile, equals(jsonEncode(bloc.state.points)));
      }
  );


}