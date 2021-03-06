part of '../bloc/dashboard_bloc.dart';


@immutable
abstract class DashboardState extends Equatable {
  final List<DashBoardEntry> entries;

  DashboardState(this.entries);

  @override
  List<Object> get props => [entries];
}

class ShowDashboardEntry extends DashboardState {
  final int focusedIndex;

  ShowDashboardEntry(List<DashBoardEntry> entries, this.focusedIndex) : super(entries);

  @override
  List<Object> get props => super.props + [focusedIndex];
}

class ShowDashboardEntries extends DashboardState{
  ShowDashboardEntries(List<DashBoardEntry> entries) : super(entries);
}

