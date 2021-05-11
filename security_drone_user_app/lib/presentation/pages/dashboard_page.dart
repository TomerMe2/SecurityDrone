import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';
import 'package:security_drone_user_app/logic/dashboard_bloc.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';
import 'package:security_drone_user_app/style.dart';

import '../image_banner.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardPageState();
  }
}

class DashboardPageState extends State<DashboardPage>{

  @override
  Widget build(BuildContext context){
    // ignore: close_sinks
    DashboardBloc _bloc = DashboardBloc();

    return Scaffold(
        body: DashboardListClass(_bloc),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () => _bloc.add(
                RefreshDashboardEntries(),
              ),
            ),
          ],
        )
    );
  }
}

// ignore: must_be_immutable
class DashboardListClass extends StatelessWidget {
  DashboardBloc _bloc;

  DashboardListClass(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security Drone"),
        actions: [
          ImageBanner('assets/images/icon.jpg')
        ],
      ),
      body: DashBoardList(_bloc),
    );
  }
}

// ignore: must_be_immutable
class DashBoardList extends StatelessWidget {
  DashboardBloc _bloc;

  DashBoardList(this._bloc);

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        cubit: _bloc,
        buildWhen: (prev, curr){
          return curr.entries.isNotEmpty;
        },
        // ignore: missing_return,
        builder: (context, state) {
          if (state is ShowDashboardEntries) {
            var builder = ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                itemCount: state.entries.length,
                itemBuilder: (context, index) {
                  var color;
                  if (state.entries[index].missionResult == MissionResultType.success){
                    color = Colors.green;
                  }
                  else if (state.entries[index].missionResult == MissionResultType.fail){
                    color = Colors.red;
                  }
                  else {
                    color = Colors.grey;
                  }
                  return Card(
                    child: ListTile(
                      tileColor: color,
                      contentPadding: EdgeInsets.symmetric(horizontal: 50),
                      title: Text(
                          state.entries[index].entryMinimalDescription(),
                          style: Body1TextStyle
                      ),
                      subtitle: Text(index.toString()),
                      onTap: () => _bloc.add(DashboardEntryClicked(index)),
                    ),
                  );
                }
            );
            return builder;
          }
          else if (state is ShowDashboardEntry){
            var index = state.focusedIndex;
            var display = Column(
              children: [
                TextSection(
                    "Action Full Desctiption:",
                    state.entries[index].toString()
                ),
                ElevatedButton(
                    child: Icon(Icons.keyboard_return),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                    ),
                    onPressed: () => _bloc.add(
                        DisplayDashboardEntries()
                    ))
              ],
            );
            return display;
          }
          else {
            return Text("OK");
          }
        },
        listener: (BuildContext context, state) {
          /*
          var text;
          if (state is ShowDashboardEntries) {
            text = "Display entries";
          }
          else if (state is ShowDashboardEntry) {
            text = "Display entry";
          }
          return Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(text))
          );
           */
        },

      ),
    );
  }
}

