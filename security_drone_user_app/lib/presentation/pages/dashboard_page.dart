import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';
import 'package:security_drone_user_app/logic/bloc/dashboard_bloc.dart';
import 'package:security_drone_user_app/style.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardPageState();
  }
}

class DashboardPageState extends State<DashboardPage> {
  DashboardBloc _bloc = DashboardBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DashBoardList(_bloc),
    );
  }
}

class DashBoardList extends StatelessWidget {
  final DashboardBloc _bloc;

  DashBoardList(this._bloc);

  @override
  Widget build(BuildContext context) {

    Widget displayDashboardEntry(DashBoardEntry entry, int index){

      List <Widget> endReason = [];
      if (entry != null && entry.abortReason != "") {
        endReason.add(Text("Abort reason: ${entry.abortReason}"));
      }

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(index.toString()),
            SizedBox(width: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Start date: ${DateFormat.yMd().add_jm().format(entry.startTime)}"),
                Text("End date: ${DateFormat.yMd().add_jm().format(entry.endTime)}"),
                Text("Start reason: ${entry.startReason}"),
              ] + endReason,
            )
          ]
        )
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(2.0),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        cubit: _bloc,
        buildWhen: (prev, curr) {
          return curr.entries.isNotEmpty;
        },
        builder: (context, state) {
          if (state is ShowDashboardEntries) {
            var button = TextButton(
              child: Icon(Icons.refresh),
              onPressed: () => _bloc.add(
                RefreshDashboardEntries(),
              ),
            );
            var builder = ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(2.0),
                itemCount: state.entries.length,
                itemBuilder: (context, index) {
                  Color color;
                  if (state.entries[index].missionResult == MissionResultType.success) {
                    color = Colors.green;
                  }
                  else if (state.entries[index].missionResult == MissionResultType.fail) {
                    color = Colors.red;
                  }
                  else if (state.entries[index].missionResult == MissionResultType.ongoing) {
                    color = Colors.orange;
                  }
                  else {
                    color = Colors.grey;
                  }
                  return Card(
                    color: color,
                    child: ListTile(
                      tileColor: color,
                      contentPadding: EdgeInsets.symmetric(horizontal: 50),
                      title: displayDashboardEntry(state.entries[index], index),
                      onTap: () => _bloc.add(DashboardEntryClicked(index)),
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
          else if (state is ShowDashboardEntry) {
            int index = state.focusedIndex;
            DashBoardEntry entry = state.entries[index];

            List <Widget> info = [
              Text("Start date: ${DateFormat.yMd().add_jm().format(entry.startTime)}"),
              Text("End date: ${DateFormat.yMd().add_jm().format(entry.endTime)}"),
              Text("Start reason: ${entry.startReason}"),
              Text("Abort reason: ${entry.abortReason}"),
              Text("Mission result: ${entry.missionResult.toString().split('.').last}"),
              SizedBox(height: 10),
              Text("Activity Log: ", style: Body1TextStyle),
              Container(height: 1.0, color: Colors.black38)
            ];

            for (int i = 0 ; i < entry.activity.activities.length ; i++) {
              info.add(Text("Sub activity ${i.toString()}:"));
              info.add(Text("Type: ${entry.activity.activities[i].type}"));
              info.add(Text("Time: ${DateFormat.jms().format(entry.activity.activities[i].date)}"));
              info.add(Text("Latitude: ${entry.activity.activities[i].location.lat}"));
              info.add(Text("Longitude: ${entry.activity.activities[i].location.lng}"));
              info.add(SizedBox(height: 10.0));
            }

            var builder = ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(2.0),
                itemCount: 1,
                itemBuilder: (context, _) {
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 50),
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: info,
                        ),
                      ),
                      onTap: () => _bloc.add(DashboardEntryClicked(index)),
                    ),
                  );
                }
            );

            return Column(
              children: [
                Text("Action Full Description:", style: TitleTextStyle),
                Divider(
                  height: 5.0, thickness: 5.0, indent: 10.0, endIndent: 10, color: Colors.black38,
                ),
                builder,
                TextButton(
                    child: Icon(Icons.keyboard_return, color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                    ),
                    onPressed: () => _bloc.add(
                        DisplayDashboardEntries()
                    ))
              ],
            );

          }
          else {
            return Text("Unrecognized state");
          }
        },
        listenWhen: (prev, curr) {
          // return true only for new ongoing mission
          for (int i = 0; i < prev.entries.length; i++) {
            if (prev.entries[i].missionResult == MissionResultType.ongoing) {
              return false;
            }
          }
          for (int i = 0; i < curr.entries.length; i++) {
            if(curr.entries[i].missionResult == MissionResultType.ongoing) {
              return true;
            }
          }
          return false;
        },
        listener: (BuildContext context, state) {
          for (int i = 0; i < state.entries.length; i++) {
            if (state.entries[i].missionResult == MissionResultType.ongoing) {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Drone is currently on a mission"),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Ok")),
                        TextButton(onPressed: () => {
                          Navigator.of(context).pop(),
                          _bloc.add(DashboardEntryClicked(i)),
                          }, child: Text("View"))
                      ],
                    );
                  }
              );
            }
          }
        },

      ),
    );
  }
}

