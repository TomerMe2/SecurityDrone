import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/data_api/dashboard_api.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';

part '../event/dashboard_event.dart';
part '../state/dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  DashboardAPI api = DashboardAPI();

  DashboardBloc() : super(ShowDashboardEntries([]));

  // for testing purposes
  DashboardBloc.test(entry) : super(ShowDashboardEntries([entry]));

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {

    if (event is DashboardEntryClicked) {
      yield ShowDashboardEntry(state.entries, event.clickedOn);
    }
    else if (event is RefreshDashboardEntries) {
      //TODO: token
      List<DashBoardEntry> entries = await api.getDashboardEntries("");
      yield ShowDashboardEntries(entries);
    }
    else if (event is DisplayDashboardEntries) {
      yield ShowDashboardEntries(state.entries);
    }
    else {
      throw Exception("Event not found $event");
    }
  }




}