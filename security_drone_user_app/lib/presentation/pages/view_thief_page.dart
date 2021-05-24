import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/logic/bloc/thief_page_bloc.dart';
import 'package:date_format/date_format.dart';

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
            int index = state.focusedIndex;
            String date = formatDate(state.entries[index].date, [dd, '/', mm, '/', yy, ' ', HH, ':', nn]);
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Taken on $date",
                          style: TitleTextStyle),
                      SizedBox(height: 7.0),
                      TextButton(
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
                                        mapOnPoint(state.entries[index].waypoint)
                                      ],
                                    ),
                                  );
                                }
                            )
                          }
                      )
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

