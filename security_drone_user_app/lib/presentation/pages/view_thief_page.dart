import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/logic/bloc/thief_page_bloc.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';

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
                      title: state.entries[index].image,
                      subtitle: Text(index.toString()),
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
                state.entries[index].image,
                TextSection(
                  state.entries[index].date.toString(),
                  state.entries[index].waypoint.toString()
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

