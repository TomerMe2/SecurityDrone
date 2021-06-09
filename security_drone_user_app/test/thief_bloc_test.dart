import 'package:flutter/cupertino.dart';
import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/data/models/thief_entry.dart';
import 'package:security_drone_user_app/logic/bloc/thief_page_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {

  var point = LatLngPoint(35.12, 34.11);
  var entry = ThiefEntry(Image.asset("assets/images/thief.jpg"), DateTime.now(), point);

  // say that we are testing
  debugTestingProd = 1;
  var index = 0;

  blocTest('Check clicked entry',
      build: () => ThiefPageBloc.test(entry),
      act: (bloc) => bloc.add(ThiefEntryClicked(index)),
      expect: [ShowThiefEntry([entry], index)]
  );

  blocTest('Check refresh entries',
      build: () => ThiefPageBloc(),
      act: (bloc) => bloc.add(RefreshThiefEntries()),
      expect: [ShowThiefEntries(ThiefEntry.dummyFetchAll())]
  );

  blocTest('Check display entries',
      build: () => ThiefPageBloc(),
      act: (bloc) => bloc.add(DisplayThiefEntries()),
      expect: [ShowThiefEntries([ThiefEntry.dummyFetch()])]
  );
}