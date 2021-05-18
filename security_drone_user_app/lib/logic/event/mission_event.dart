part of '../bloc/mission_bloc.dart';

@immutable
abstract class MissionEvent {}

class PatrolRequest extends MissionEvent {}

class WatchHerdRequest extends MissionEvent {}

class AbortMissionRequest extends MissionEvent {}




