part of '../bloc/thief_page_bloc.dart';

@immutable
abstract class ThiefPageState extends Equatable {
  final List<ThiefEntry> entries;

  ThiefPageState(this.entries);

  @override
  List<Object> get props => [entries];
}

class ShowThiefEntry extends ThiefPageState {
  final int focusedIndex;

  ShowThiefEntry(List<ThiefEntry> entries, this.focusedIndex) : super(entries);

  @override
  List<Object> get props => super.props + [focusedIndex];
}

class ShowThiefEntries extends ThiefPageState {
  ShowThiefEntries(List<ThiefEntry> entries) : super(entries);

  @override
  bool operator ==(Object other) {
    if (other is ShowThiefEntries) {
      if (entries.length != other.entries.length) {
        return false;
      }
      else {
        for(int i=0;i<entries.length;i++) {
          if (entries[i] != other.entries[i]) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

}

