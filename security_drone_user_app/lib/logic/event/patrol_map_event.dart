part of '../bloc/patrol_map_bloc.dart';

@immutable
abstract class PatrolMapEvent {}

class PatrolMapPointClicked extends PatrolMapEvent {
  final LatLngPoint pointClickedOn;

  PatrolMapPointClicked(this.pointClickedOn);
}

class ApproveDeletion extends PatrolMapEvent {}

class DoNotDelete extends PatrolMapEvent {}

class DonePickingPoints extends PatrolMapEvent {}


