import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:security_drone_user_app/logic/bloc/thief_page_bloc.dart';

import '../../style.dart';

class ThiefPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewThiefPageState();
  }
}

class ViewThiefPageState extends State<ThiefPage> {
  ThiefPageBloc _bloc = ThiefPageBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ThiefList(_bloc),
    );
  }
}

class ThiefList extends StatelessWidget {
  final ThiefPageBloc _bloc;

  ThiefList(this._bloc);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: BlocConsumer<ThiefPageBloc, ThiefPageState>(
        cubit: _bloc,
        buildWhen: (prev, curr) {
          return curr.entries.isNotEmpty;
        },
        builder: (context, state) {
          if (state is ShowThiefEntries) {
            var button = TextButton(
              child: Icon(Icons.refresh),
              onPressed: () => _bloc.add(
                RefreshThiefEntries(),
              ),
            );
            var builder = ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                itemCount: state.entries.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 50),
                      title: SizedBox(
                        height: 400.0,
                        width: 300.0,
                        child: state.entries[index].image,
                      ),
                      onTap: () => _bloc.add(ThiefEntryClicked(index)),
                    ),
                  );
                }
            );
            return Column(
              children: [
                builder,
                button
              ],
            );
          }
          else if (state is ShowThiefEntry) {
            var index = state.focusedIndex;
            var display = Column(
              children: [
                SizedBox(
                  width: 400.0,
                  height: 400.0,
                  child: state.entries[index].image,
                ),
                SizedBox(height: 10.0),
                Divider(
                  height: 5.0,
                  thickness: 5.0,
                  indent: 10.0,
                  endIndent: 10,
                  color: Colors.black38,
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date taken:\n${DateFormat.yMd().add_jm().format(state.entries[index].date)}",
                          style: TitleTextStyle),
                      SizedBox(height: 7.0),
                      Text("Latitude: ${state.entries[index].waypoint.lat}",
                      style: Body1TextStyle),
                      Text("Longitude: ${state.entries[index].waypoint.lng}",
                      style: Body1TextStyle)
                    ],
                  ),
                ),
                ElevatedButton(
                    child: Icon(Icons.keyboard_return),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () => _bloc.add(
                      DisplayThiefEntries()
                    ))
              ],
            );
            return display;
          } else {
            return Text("Unrecognized state");
          }
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }
}

