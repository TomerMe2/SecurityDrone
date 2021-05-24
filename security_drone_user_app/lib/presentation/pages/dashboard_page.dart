import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/logic/bloc/dashboard_bloc.dart';
import 'package:security_drone_user_app/style.dart';
import 'package:date_format/date_format.dart';

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

    Widget mapOnPoint(LatLngPoint point) {
      CameraPosition pointLoc = CameraPosition(
        target: LatLng(point.lat, point.lng),
        zoom: 17.4746);
      Marker marker = Marker(
          markerId: MarkerId('loc'),
          position: LatLng(point.lat, point.lng));

      return Align(
        alignment: Alignment.bottomCenter,
        child: GoogleMap(
          mapType: MapType.satellite,
          initialCameraPosition: pointLoc,
          markers: {marker},
        )
      );
    }

    Widget displayDashboardEntry(DashBoardEntry entry) {

      String endReason = "And ended as Expected.";
      if (entry.missionResult == MissionResultType.fail) {
        endReason = "Aborted because of ${entry.abortReason}.";
      }
      else if (entry.missionResult == MissionResultType.ongoing) {
        endReason = "Currently ongoing.";
      }

      String startDate = formatDate(entry.startTime, [dd, '/', mm, '/', yy, ' ', HH, ':', nn]);
      String endDate = formatDate(entry.endTime, [dd, '/', mm, '/', yy, ' ', HH, ':', nn]);

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Mission duration from $startDate\n"
                + "to $endDate.\n"
                + "Started because of ${entry.startReason}.\n"
                + endReason),
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
                    color = Colors.greenAccent;
                  }
                  else if (state.entries[index].missionResult == MissionResultType.fail) {
                    color = Colors.redAccent;
                  }
                  else if (state.entries[index].missionResult == MissionResultType.ongoing) {
                    color = Colors.orangeAccent;
                  }
                  else {
                    color = Colors.grey;
                  }
                  return Card(
                    color: color,
                    child: ListTile(
                      tileColor: color,
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      title: displayDashboardEntry(state.entries[index]),
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
            Widget entryView = displayDashboardEntry(entry);
            ListView builder = ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(2.0),
                itemCount: entry.activity.activities.length,
                itemBuilder: (context, subIndex) {
                  String date = formatDate(entry.activity.activities[subIndex].date, [dd, '/', mm, '/', yy, ' ', HH, ':', nn]);
                  return Card(
                    child: ListTile(
                      leading: Text("${entry.activity.activities[subIndex].type.toString().split('.').last}"
                          + " at $date"),
                      trailing: TextButton(
                          child: Text("View location", style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue)
                          ),
                          onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.all(10.0),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: [
                                        mapOnPoint(entry.activity.activities[subIndex].location)
                                      ],
                                    ),
                                  );
                                }
                            )
                          }
                      ),
                    )
                  );
                }
            );

            return Column(
              children: [
                Text("Mission Full Description", style: TitleTextStyle),
                Divider(
                  height: 5.0, thickness: 5.0, indent: 10.0, endIndent: 10, color: Colors.black38,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 10),
                    entryView
                  ],
                ),
                SizedBox(height: 10),
                Text("Mission log", style: Body1TextStyle),
                builder,
                TextButton(
                    child: Icon(Icons.keyboard_return, color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                    ),
                    onPressed: () => _bloc.add(
                        DisplayDashboardEntries()
                    )),
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

