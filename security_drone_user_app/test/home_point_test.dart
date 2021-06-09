import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/logic/bloc/home_map_bloc.dart';
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
      build: () => HomeMapBloc(),
      act: (bloc) => bloc.add(MapPointClicked(point)),
      expect: [MapShowingPoint(point)]
  );

  blocTest('Check add close point',
      build: () => HomeMapBloc(),
      act: (bloc) {
        bloc.add(MapPointClicked(point));
        bloc.add(MapPointClicked(closePoint));
      },
      expect: [MapShowingPoint(point), WantApprovalForResetting(closePoint, point)]
  );

  blocTest('Check add far point',
      build: () => HomeMapBloc(),
      act: (bloc) {
        bloc.add(MapPointClicked(point));
        bloc.add(MapPointClicked(farPoint));
      },
      expect: [MapShowingPoint(point), WantApprovalForResetting(farPoint, point)]
  );

  blocTest('Check do not delete close point',
      build: () => HomeMapBloc(),
      act: (bloc) {
        bloc.add(MapPointClicked(point));
        bloc.add(MapPointClicked(closePoint));
        bloc.add(DoNotReset());
      },
      expect: [MapShowingPoint(point), WantApprovalForResetting(closePoint, point), MapShowingPoint(point)]
  );

  blocTest('Check delete close point',
      build: () => HomeMapBloc(),
      act: (bloc) {
        bloc.add(MapPointClicked(point));
        bloc.add(MapPointClicked(closePoint));
        bloc.add(ApproveResetting());
      },
      expect: [MapShowingPoint(point), WantApprovalForResetting(closePoint, point), MapShowingPoint(closePoint)]
  );


  blocTest('Check send waypoints to server',
      build: () {
        cleanFile();
        return HomeMapBloc();
      },
      act: (bloc) {
        bloc.add(MapPointClicked(point));
        bloc.add(DonePickingPoints());
      },
      expect: [MapShowingPoint(point),
        SendingDataToServer(point),
        DoneSendDataToServer(point)],
  );


}