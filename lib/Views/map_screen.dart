import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/Controllers/mapscreen_controller.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapController map = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          body: GoogleMap(
            myLocationEnabled: true,
            polylines: map.polyline_,
            markers: Set<Marker>.of(map.marker.value),
            mapType: MapType.normal,
            initialCameraPosition: map.kGooglePlex.value,
            onMapCreated: (GoogleMapController controller) {
              map.controllermap.value.complete(controller);
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.location_on),
            onPressed: (() {
              map.determinePosition().then((value) {
                print('location');
                print(value.latitude.toString() +
                    " " +
                    value.longitude.toString());
                map.getexactlocation(value);
                map.marker.add(Marker(
                  markerId: MarkerId('3'),
                  position: LatLng(value.latitude, value.longitude),
                  icon: map.selficon.value,
                  infoWindow: InfoWindow(title: 'Maaz Home'),
                ));
              });
            }),
          ),
        ),
      ),
    );
  }
}
