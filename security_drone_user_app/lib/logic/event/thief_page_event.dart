part of '../bloc/thief_page_bloc.dart';

@immutable
abstract class ThiefPageEvent {}

class CloseMap extends ThiefPageEvent {}

class ThiefEntryClicked extends ThiefPageEvent {
  final int clickedOn;
  ThiefEntryClicked(this.clickedOn);
}

class RefreshThiefEntries extends ThiefPageEvent {}

class DisplayThiefEntries extends ThiefPageEvent {}



