import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  //TODO: replace current dummy thief entries and add api request for said entries

  DashboardBloc() : super(ShowDashboardEntries([DashBoardEntry.dummyFetch()]));

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {

    if (event is DashboardEntryClicked){
      yield ShowDashboardEntry(state.entries, event.clickedOn);
    }
    else if (event is RefreshDashboardEntries) {
      print('api request to refresh the entries');
      List<DashBoardEntry> entries = DashBoardEntry.dummyFetchAll();
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