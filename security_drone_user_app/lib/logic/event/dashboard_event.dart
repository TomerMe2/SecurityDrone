part of '../bloc/dashboard_bloc.dart';


@immutable
abstract class DashboardEvent {}


class DashboardEntryClicked extends DashboardEvent {
  final int clickedOn;
  DashboardEntryClicked(this.clickedOn);
}

class RefreshDashboardEntries extends DashboardEvent{}

class DisplayDashboardEntries extends DashboardEvent{}



