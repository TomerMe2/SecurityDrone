import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';
import 'package:security_drone_user_app/logic/bloc/dashboard_bloc.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
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
                padding: EdgeInsets.all(10.0),
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
            return Column(
              children: [
                builder,
                button
              ],
            );
          }
          else if (state is ShowDashboardEntry) {
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

