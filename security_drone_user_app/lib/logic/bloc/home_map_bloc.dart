import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:security_drone_user_app/data/data_api/home_point_api.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';

part '../event/home_map_event.dart';
part '../state/home_map_state.dart';

class HomeMapBloc extends Bloc<HomeMapEvent, HomeMapState> {

  static const double DISTANCE_OF_SAME_POINT = 0.00008;
  HomePointAPI api = HomePointAPI();

  HomeMapBloc() : super(MapShowingPoint(null));

  @override
  Stream<HomeMapState> mapEventToState(HomeMapEvent event) async* {
    if (event is MapPointClicked) {
      if(state.point == null) {
        yield MapShowingPoint(event.pointClickedOn);
      }
      else {
        var newPoint = event.pointClickedOn;
        yield WantApprovalForResetting(newPoint, state.point);
      }
    }
    else if (event is ApproveResetting) {
      if (state is WantApprovalForResetting) {
        WantApprovalForResetting currState = state as WantApprovalForResetting;
        yield MapShowingPoint(currState.justClicked);
      }
    }
    else if (event is DoNotReset) {
      yield MapShowingPoint(state.point);
    }
    else if (event is DonePickingPoints) {
      yield(SendingDataToServer(state.point));
      //TODO: token
      await api.sendHomePoint(state.point, "");
      yield(DoneSendDataToServer(state.point));
    }

  }
}
