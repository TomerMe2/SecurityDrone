import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:security_drone_user_app/logic/bloc/mission_bloc.dart';
import 'package:security_drone_user_app/presentation/text_section.dart';

import '../../style.dart';

class MissionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MissionPageState();
  }
}

class MissionPageState extends State<MissionPage> {
  final MissionBloc _bloc = MissionBloc();

  @override
  Widget build(BuildContext context) {

    Widget createButton(Function() func, String text) {
      return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: func,
          child: Text(text,
              textAlign: TextAlign.center,
              style: Body1TextStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }

    var page = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextSection("Mission center", "available mission requests:"),
          SizedBox(height: 30.0),
          createButton(() => _bloc.add(PatrolRequest()), "Patrol request"),
          SizedBox(height: 25.0),
          createButton(() => _bloc.add(WatchHerdRequest()), "Watch herd request"),
          SizedBox(height: 25.0),
          createButton(() => _bloc.add(AbortMissionRequest()), "Abort request")
        ],
      ),
      constraints: BoxConstraints(
          maxHeight: 100.0,
          maxWidth: 100.0
      ),
    );

    var loading = Align(
      alignment: Alignment.center,
      child: Container(
          width: 350,
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent, width: 6)
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sending to server...', style: TextStyle(fontSize: 23)),
                LoadingBouncingGrid.square(backgroundColor: Colors.blueAccent)
              ]
          )
      ),
    );

    return BlocConsumer(
        cubit: _bloc,
        builder: (context, state) {
          if (state is SendingRequest){
            return loading;
          }
          else {
            return page;
          }
        },
        listenWhen: (prev, curr) {
          return curr is RequestReceived;
        },
        listener: (prev, curr) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                MissionState currState = curr as MissionState;
                return AlertDialog(
                  title: TextSection("Request sent:", currState.requestType.toString().split('.').last),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Ok")),
                  ],
                );
              }
          );
        }
    );
  }
}