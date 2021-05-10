part of 'thief_page_bloc.dart';

@immutable
abstract class ThiefPageEvent {}

class CloseMap extends ThiefPageEvent {}

// ignore: must_be_immutable
class ThiefEntryClicked extends ThiefPageEvent {
  int clickedOn;
  ThiefEntryClicked(this.clickedOn);
}

// ignore: must_be_immutable
class RefreshThiefEntries extends ThiefPageEvent{}

class DisplayThiefEntries extends ThiefPageEvent{}



