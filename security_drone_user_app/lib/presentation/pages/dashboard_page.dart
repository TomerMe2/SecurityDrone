import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';
import 'package:security_drone_user_app/logic/dashboard_bloc.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';
import 'package:security_drone_user_app/style.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardPageState();
  }
}

class DashboardPageState extends State<DashboardPage>{
  DashboardBloc _bloc = DashboardBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return DashBoardList(_bloc);
  }
}

class DashBoardList extends StatelessWidget {
  final DashboardBloc _bloc;

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
            return Column(
              children: [
                builder,
                button
              ],
            );
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
            return Text("Unrecognized state");
          }
        },
        listener: (BuildContext context, state) {

        },

      ),
    );
  }
}

