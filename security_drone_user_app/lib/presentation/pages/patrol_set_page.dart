import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/logic/patrol_map_bloc.dart';

class PatrolSetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PatrolSetPageState();
  }
}

class PatrolSetPageState extends State<PatrolSetPage> {
  GoogleMapController _controller;
  PatrolMapBloc _bloc = PatrolMapBloc();

  static final CameraPosition _farmLoc = CameraPosition(
    target: LatLng(31.27161090846282, 34.44436545742859),
    zoom: 17.4746,
  );

  @override
  Widget build(BuildContext context) {

    Widget createOnMapButton(String text, bool isBorderToRight, Function() func) {
      var child = Padding(
        padding: EdgeInsets.all(3),
        child: SizedBox(
          width: 75,
          child: TextButton(
            //padding: EdgeInsets.all(0),
            onPressed: func,
            child: Text(text,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13)
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.all(Colors.blueAccent),
              padding: MaterialStateProperty.all(EdgeInsets.all(0))
            ),
            // color: Colors.transparent,
            // highlightColor: Colors.blueAccent,
          ),
        ),
      );

      if (isBorderToRight) {
        return Container(
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(width: 2, color: Colors.blueAccent)
              )
            ),
            child: child
        );
      }
      else {
        return Container(
            child: child
        );
      }
    }

    return BlocBuilder<PatrolMapBloc, PatrolMapState>(
        cubit: _bloc,
        builder: (BuildContext context, PatrolMapState state) {
          List<Marker> markers = [];
          for (int i = 0; i < state.points.length; i++) {
            markers.add(Marker(
              markerId: MarkerId(i.toString()),
              position: LatLng(state.points[i].lat, state.points[i].lng)
            ));
          }

          List<Widget> children = [GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: _farmLoc,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: markers.toSet(),
            onLongPress: (LatLng loc) {
              _bloc.add(
                  PatrolMapPointClicked(LatLngPoint(loc.latitude, loc.longitude)));
            },

          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: TextButton(
                  onPressed: () {_bloc.add(DonePickingPoints());},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)
                  ),
                  //color: Colors.blue,
                  child:  Text('done',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19, color: Colors.white)
                   )),
            )
          ),

          ];

          if (state is WantApprovalForDeletion) {
            var futureCrds = _controller.getScreenCoordinate(LatLng(state.justClicked.lat, state.justClicked.lng));
            var tooltipWidget = FutureBuilder(
                future: futureCrds,
                builder: (BuildContext context, AsyncSnapshot<ScreenCoordinate> snapshot) {
                  if (snapshot.hasData) {
                    var crds = snapshot.data;

                    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                    return Positioned(
                        left: crds.x.toDouble() / pixelRatio - 75,
                        top: crds.y.toDouble() / pixelRatio,
                        child: Container(
                          width: 170,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.blueAccent),
                            color: Colors.white
                          ),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              createOnMapButton('Delete Point', true, () {_bloc.add(ApproveDeletion());}),
                              createOnMapButton('Add Close Point', false, () {_bloc.add(DoNotDelete());})
                            ],
                          ),
                        ));
                  }
                  else {
                    return SizedBox.shrink();  // minimal widget
                  }
                });
            children.add(tooltipWidget);
          } else if (state is SendingDataToServer || state is DoneSendDataToServer) {
            List<Widget> innerChildren;
            if (state is SendingDataToServer) {
              innerChildren = [
                Text('Sending to server...', style: TextStyle(fontSize: 23)),
                LoadingBouncingGrid.square(backgroundColor: Colors.blueAccent)
              ];
            }
            else {
              innerChildren = [
                Text('Done sending data!', style: TextStyle(fontSize: 23)),
              ];
            }
            children.add(
              Align(
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
                    children: innerChildren
                  )
                ),
              )
            );
          }

          return Stack(
            children: children
          );
        });
  }
}
