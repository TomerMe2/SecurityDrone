part of '../bloc/home_map_bloc.dart';



@immutable
abstract class HomeMapState extends Equatable {
  final LatLngPoint point;

  HomeMapState(this.point);

  @override
  List<Object> get props => [point];
}

class MapShowingPoint extends HomeMapState {
  MapShowingPoint(LatLngPoint point) : super(point);
}

class WantApprovalForResetting extends HomeMapState {
  final LatLngPoint justClicked;

  WantApprovalForResetting(this.justClicked, LatLngPoint maybeReset) : super(maybeReset);

  @override
  List<Object> get props => super.props + [justClicked];
}

class SendingDataToServer extends HomeMapState {
  SendingDataToServer(LatLngPoint point) : super(point);
}

class DoneSendDataToServer extends HomeMapState {
  DoneSendDataToServer(LatLngPoint point) : super(point);
}