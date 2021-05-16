import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';
import 'package:security_drone_user_app/data/models/drone_activity.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/data/models/sub_activity.dart';
import 'package:security_drone_user_app/logic/bloc/dashboard_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {

  List<SubActivity> subActivities = [
    SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
    SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
    SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10))
  ];
  DroneActivity droneActivity = DroneActivity(subActivities);

  DashBoardEntry entry = DashBoardEntry(droneActivity,DateTime.now(), DateTime.parse("1999-01-12"), MissionResultType.success, 'clock trigger', '');

  // say that we are testing
  debugTestingProd = 1;
  var index = 0;

  blocTest('Check clicked entry',
      build: () => DashboardBloc.test(entry),
      act: (bloc) => bloc.add(DashboardEntryClicked(index)),
      expect: [ShowDashboardEntry([entry], index)]
  );

  blocTest('Check refresh entries',
      build: () => DashboardBloc(),
      act: (bloc) => bloc.add(RefreshDashboardEntries()),
      expect: [ShowDashboardEntries(DashBoardEntry.dummyFetchAll())]
  );

  blocTest('Check display entries',
      build: () => DashboardBloc(),
      act: (bloc) => bloc.add(DisplayDashboardEntries()),
      expect: [ShowDashboardEntries([DashBoardEntry.dummyFetch()])]
  );
}