
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/models/thief_entry.dart';
part 'thief_page_event.dart';
part 'thief_page_state.dart';


class ThiefPageBloc extends Bloc<ThiefPageEvent, ThiefPageState> {
  //TODO: replace current dummy thief entries and add api request for said entries

  ThiefPageBloc() : super(ShowThiefEntries([ThiefEntry.dummyFetch()]));

  // for testing purposes
  ThiefPageBloc.test(ThiefEntry entry) : super(ShowThiefEntries([entry]));

  @override
  Stream<ThiefPageState> mapEventToState(ThiefPageEvent event) async* {

    if (event is ThiefEntryClicked){
      yield ShowThiefEntry(state.entries, event.clickedOn);
    }
    else if (event is RefreshThiefEntries) {
      print('api request to refresh the entries');
      List<ThiefEntry> entries = ThiefEntry.dummyFetchAll();
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