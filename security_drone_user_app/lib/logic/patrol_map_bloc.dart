import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:security_drone_user_app/communication/to_server.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';

part 'patrol_map_event.dart';
part 'patrol_map_state.dart';

class PatrolMapBloc extends Bloc<PatrolMapEvent, PatrolMapState> {

  static const double DISTANCE_OF_SAME_POINT = 0.00008;
  PatrolMapBloc() : super(PatrolMapShowingPoints([]));

  @override
  Stream<PatrolMapState> mapEventToState(
    PatrolMapEvent event,
  ) async* {
    if (event is PatrolMapPointClicked) {
      var newPoint = event.pointClickedOn;


      double closestDistance;
      LatLngPoint closestPoint;

      for (var currPoint in state.points) {
        var distance = newPoint.l2Distance(currPoint);
        if (closestDistance == null || distance < closestDistance) {
          closestDistance = distance;
          closestPoint = currPoint;
        }
      }

      if (closestDistance != null && closestDistance < DISTANCE_OF_SAME_POINT) {
        yield WantApprovalForDeletion(newPoint, closestPoint, state.points);
      }
      else {
        yield PatrolMapShowingPoints(state.points + [newPoint]);
      }
    }

    else if (event is ApproveDeletion) {
      if (state is WantApprovalForDeletion) {
        var currState = state as WantApprovalForDeletion;
        List<LatLngPoint> points = List<LatLngPoint>.from(state.points);
        points.remove(currState.maybeDelete);
        yield PatrolMapShowingPoints(points);
      }
    }

    else if (event is DoNotDelete) {
      yield PatrolMapShowingPoints(state.points + [(state as WantApprovalForDeletion).justClicked]);
    }

    else if (event is DonePickingPoints) {
      yield(SendingDataToServer(state.points));
      await sendPatrolWaypoints(state.points);
      yield(DoneSendDataToServer(state.points));
    }

  }
}
