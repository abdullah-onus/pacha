import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/theme.dart';
import '../globals.dart';

enum LimitLocation {
  left,
  up,
  down,
  right,
}

class MapPicker extends StatefulWidget {
  const MapPicker({
    Key? key,
  }) : super(key: key);
  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  LatLng myLocation = LatLng(
    Globals.challenge!.mapCenterLatitude!,
    Globals.challenge!.mapCenterLongitude!,
  ); // initial location
  LatLng restrictedLocation = LatLng(17.98, -76.8); // to have first default value
  LatLng targetMarkerLocation = LatLng(17.98, -76.8); // initial target marker location
  // boundLimits
  LatLng northWestLimit = LatLng(
    Globals.challenge!.mapNorthwestLatitude!,
    Globals.challenge!.mapNorthwestLongitude!,
  );
  LatLng southEastLimit = LatLng(
    Globals.challenge!.mapSoutheastLatitude!,
    Globals.challenge!.mapSoutheastLongitude!,
  );
  // overlay
  LatLng overlayNorthWest = LatLng(
    Globals.challenge!.overlayNorthwestLatitude!,
    Globals.challenge!.overlayNorthwestLongitude!,
  );
  LatLng overlaySouthEast = LatLng(
    Globals.challenge!.overlaySoutheastLatitude!,
    Globals.challenge!.overlaySoutheastLongitude!,
  );
  final MapController _controller = MapController();
  bool isOverlay = true;
  bool outOfLimit = false;
  bool isMarked = false;
  String _mapType = 'mapbox/satellite-streets-v11';
  // longitute = horizontal
  // latitude = vertical
  bool positionLimitCheck(MapPosition position) {
    if (myLocation.latitude + northWestLimit.latitude < myLocation.latitude + position.center!.latitude) {
      restrictedLocation = getLocation(LimitLocation.up, position);
      return outOfLimit = true;
    }
    if (myLocation.latitude - southEastLimit.latitude < myLocation.latitude - position.center!.latitude) {
      restrictedLocation = getLocation(LimitLocation.down, position);
      return outOfLimit = true;
    }
    if (myLocation.longitude - northWestLimit.longitude < myLocation.longitude - position.center!.longitude) {
      restrictedLocation = getLocation(LimitLocation.left, position);
      return outOfLimit = true;
    }
    if (myLocation.longitude + southEastLimit.longitude < myLocation.longitude + position.center!.longitude) {
      restrictedLocation = getLocation(LimitLocation.right, position);
      return outOfLimit = true;
    }
    return outOfLimit = false;
  }

  LatLng getLocation(LimitLocation location, MapPosition position) {
    if (location == LimitLocation.down) {
      double downLimitLongitude = position.center!.longitude;
      return LatLng(
        southEastLimit.latitude,
        downLimitLongitude,
      );
    } else if (location == LimitLocation.left) {
      double leftLimitLatitude = position.center!.latitude;
      return LatLng(
        leftLimitLatitude,
        northWestLimit.longitude,
      );
    } else if (location == LimitLocation.right) {
      double rightLimitLatitude = position.center!.latitude;
      return LatLng(
        rightLimitLatitude,
        southEastLimit.longitude,
      );
    } else if (location == LimitLocation.up) {
      double upLimitLongitude = position.center!.longitude;
      return LatLng(
        northWestLimit.latitude,
        upLimitLongitude,
      );
    }
    return myLocation;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                onPositionChanged: (position, hasGesture) {
                  // target location marker coordinates, better stay in case we need it.
                  // print(
                  //     "Marker Location latitude: ${targetMarkerLocation.latitude}");
                  // print(
                  //     "Marker Location longitude: ${targetMarkerLocation.longitude}");
                  if (positionLimitCheck(position)) {
                    try {
                      _controller.move(restrictedLocation, _controller.zoom);
                    } catch (e) {
                      _controller.move(myLocation, _controller.zoom);
                    }
                  }
                },
                maxZoom: Globals.challenge!.mapMaxZoom! * 1.0,
                minZoom: Globals.challenge!.mapMinZoom! * 1.0,
                zoom: Globals.challenge!.mapDefaultZoom! * 1.0,
                center: myLocation,
                onTap: (tapPosition, point) {
                  setState(() {
                    isMarked = true;
                    targetMarkerLocation = point;
                  });
                },
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5hcnMiLCJhIjoiY2tlZGowaHY1MDFldTJ6b3oyeW9pNTN2bSJ9.jIFUKXstg5M4vuD6_KuNyg",
                  additionalOptions: {
                    'id': _mapType,
                  },
                ),
                MarkerLayerOptions(
                  rotate: true,
                  markers: [
                    // these shall stay, in case we need to check boundaries...
                    // Marker(
                    //   width: 80.0,
                    //   height: 80.0,
                    //   point: overlayNorthWest,
                    //   builder: (ctx) => const Icon(
                    //     Icons.location_on,
                    //     color: Colors.grey,
                    //     size: 45,
                    //   ),
                    // ),
                    // Marker(
                    //   width: 80.0,
                    //   height: 80.0,
                    //   point: overlaySouthEast,
                    //   builder: (ctx) => const Icon(
                    //     Icons.location_on,
                    //     color: Colors.amber,
                    //     size: 45,
                    //   ),
                    // ),
                    // Marker(
                    //   width: 80.0,
                    //   height: 80.0,
                    //   point: northWestLimit,
                    //   builder: (ctx) => const Icon(
                    //     Icons.location_on,
                    //     color: Colors.blue,
                    //     size: 45,
                    //   ),
                    // ),
                    // Marker(
                    //   width: 80.0,
                    //   height: 80.0,
                    //   point: southEastLimit,
                    //   builder: (ctx) => const Icon(
                    //     Icons.location_on,
                    //     color: Colors.green,
                    //     size: 45,
                    //   ),
                    // ),
                    // Marker(
                    //   width: 80.0,
                    //   height: 80.0,
                    //   point: myLocation,
                    //   builder: (ctx) => const Icon(
                    //     Icons.location_on,
                    //     color: Colors.blue,
                    //     size: 45,
                    //   ),
                    // ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: targetMarkerLocation,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: isMarked == false ? Colors.transparent : Colors.red,
                        size: 45,
                      ),
                    ),
                  ],
                ),
                OverlayImageLayerOptions(
                  overlayImages: [
                    OverlayImage(
                      bounds: LatLngBounds(overlayNorthWest, overlaySouthEast),
                      opacity: isOverlay ? 1 : 0,
                      imageProvider: NetworkImage(
                        Globals.challenge!.overlayImage!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        hintText: 'Search for Location',
                        contentPadding: EdgeInsets.all(Constants().padding),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: Constants().padding * 7,
              right: Constants().padding,
              child: CircleAvatar(
                foregroundColor: PachaTheme.get.primaryColorLight,
                child: PopupMenuButton(
                  tooltip: 'Map Type',
                  enabled: true,
                  itemBuilder: (context) => [
                    mapTypes('Light map', 'mapbox/light-v10'),
                    mapTypes('Dark map', 'mapbox/dark-v10'),
                    mapTypes('Street map', 'mapbox/streets-v11'),
                    mapTypes('Outdoor map', 'mapbox/outdoors-v11'),
                    mapTypes('Satellite map', 'mapbox/satellite-streets-v11'),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: Constants().padding * 2,
              right: Constants().padding,
              child: CircleAvatar(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isOverlay = !isOverlay;
                    });
                  },
                  icon: Icon(
                    isOverlay ? Icons.hide_image : Icons.image,
                    color: PachaTheme.get.primaryColorLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> mapTypes(String title, String value) {
    return PopupMenuItem(
      onTap: () {
        setState(() {
          _mapType = value;
        });
      },
      value: value,
      child: Center(
          child: Text(
        title,
        style: TextStyle(
          color: _mapType == value ? Theme.of(context).colorScheme.primary : Colors.white,
        ),
      )),
    );
  }
}
