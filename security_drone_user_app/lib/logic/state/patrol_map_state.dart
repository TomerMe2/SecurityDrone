part of '../bloc/patrol_map_bloc.dart';



@immutable
abstract class PatrolMapState extends Equatable {
  final List<LatLngPoint> points;

  PatrolMapState(this.points);

  @override
  List<Object> get props => List<Object>.from(points);
}

class PatrolMapShowingPoints extends PatrolMapState {

  PatrolMapShowingPoints(List<LatLngPoint> points) : super(points);
}

class WantApprovalForDeletion extends PatrolMapState {
  final LatLngPoint maybeDelete;
  final LatLngPoint justClicked;

  WantApprovalForDeletion(this.justClicked, this.maybeDelete, List<LatLngPoint> points) : super(points);

  @override
  List<Object> get props => super.props + [maybeDelete, justClicked];
}


class SendingDataToServer extends PatrolMapState {
  SendingDataToServer(List<LatLngPoint> points) : super(points);
}

class DoneSendDataToServer extends PatrolMapState {
  DoneSendDataToServer(List<LatLngPoint> points) : super(points);
}