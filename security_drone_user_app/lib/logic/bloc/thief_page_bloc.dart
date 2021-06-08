
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/data_api/thief_api.dart';
import 'package:security_drone_user_app/data/models/thief_entry.dart';
part '../event/thief_page_event.dart';
part '../state/thief_page_state.dart';


class ThiefPageBloc extends Bloc<ThiefPageEvent, ThiefPageState> {
  ThiefAPI api = ThiefAPI();

  ThiefPageBloc() : super(ShowThiefEntries([]));

  // for testing purposes
  ThiefPageBloc.test(ThiefEntry entry) : super(ShowThiefEntries([entry]));

  @override
  Stream<ThiefPageState> mapEventToState(ThiefPageEvent event) async* {

    if (event is ThiefEntryClicked) {
      yield ShowThiefEntry(state.entries, event.clickedOn);
    }
    else if (event is RefreshThiefEntries) {
      //TODO: Token
      List<ThiefEntry> entries = await api.getThieves(DateTime.parse("1900-01-01"), DateTime.now(), 0, 10, "");
      yield ShowThiefEntries(entries);
    }
    else if (event is DisplayThiefEntries) {
      yield ShowThiefEntries(state.entries);
    }
    else {
      throw Exception("Event not found $event");
    }
  }




}