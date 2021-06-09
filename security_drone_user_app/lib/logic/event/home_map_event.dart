part of '../bloc/home_map_bloc.dart';

@immutable
abstract class HomeMapEvent {}

class MapPointClicked extends HomeMapEvent {
  final LatLngPoint pointClickedOn;

  MapPointClicked(this.pointClickedOn);
}

class ApproveResetting extends HomeMapEvent {}

class DoNotReset extends HomeMapEvent {}

class DonePickingPoints extends HomeMapEvent {}


