import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/models/thief_entry.dart';
import 'package:security_drone_user_app/logic/thief_page_bloc.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';

import '../image_banner.dart';

class ViewThiefPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewThiefPageState();
  }
}

class ViewThiefPageState extends State<ViewThiefPage>{

  @override
  Widget build(BuildContext context){
    // ignore: close_sinks
    ThiefPageBloc _bloc = ThiefPageBloc();

    return Scaffold(
      body: ThiefListClass(_bloc),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () => _bloc.add(
              RefreshThiefEntries(),
            ),
          ),
        ],
      )
    );
  }
}

// ignore: must_be_immutable
class ThiefListClass extends StatelessWidget {
  ThiefPageBloc _bloc;

  ThiefListClass(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security Drone"),
        actions: [
          ImageBanner('assets/images/icon.jpg')
        ],
      ),
      body: ThiefList(_bloc),
    );
  }
}

// ignore: must_be_immutable
class ThiefList extends StatelessWidget {
  ThiefPageBloc _bloc;

  ThiefList(this._bloc);

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: BlocConsumer<ThiefPageBloc, ThiefPageState>(
        cubit: _bloc,
        buildWhen: (prev, curr){
          return curr.entries.isNotEmpty;
        },
        // ignore: missing_return,
        builder: (context, state) {
          if (state is ShowThiefEntries) {
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
            return builder;
          }
          else if (state is ShowThiefEntry){
            var index = state.focusedIndex;
            var display = Column(
              children: [
                state.entries[index].image,
                TextSection(
                  state.entries[index].date.toString(),
                  state.entries[index].waypoint.toString()
                ),
                RaisedButton(
                    child: Icon(Icons.keyboard_return),
                    color: Colors.blue,
                    onPressed: () => _bloc.add(
                      DisplayThiefEntries()
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
          var text;
          if (state is ShowThiefEntries) {
            text = "Display entries";
          }
          else if (state is ShowThiefEntry) {
            text = "Display entry";
          }
          return Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(text))
          );
        },

      ),
    );
  }
}

