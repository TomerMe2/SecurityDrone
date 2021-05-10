part of 'dashboard_bloc.dart';


@immutable
abstract class DashboardEvent {}

// ignore: must_be_immutable
class DashboardEntryClicked extends DashboardEvent {
  int clickedOn;
  DashboardEntryClicked(this.clickedOn);
}

class RefreshDashboardEntries extends DashboardEvent{}

class DisplayDashboardEntries extends DashboardEvent{}



