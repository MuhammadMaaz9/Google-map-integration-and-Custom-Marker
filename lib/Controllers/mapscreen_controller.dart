import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/Views/map_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class MapController extends GetxController {
  final Set<Polyline> polyline_ = {};

  var image = 'asset/ambulance.png'.obs;

  Uint8List? markerimagr;
  Rx<BitmapDescriptor> selficon = BitmapDescriptor.defaultMarker.obs;
  ///////////CUSTOM MARKER//////////
  RxList<Marker> marker = <Marker>[].obs;

  RxList<LatLng> latlng = [
    const LatLng(24.871941, 66.988060),
    const LatLng(24.8043, 67.0577),
    const LatLng(24.891941, 66.988060),
  ].obs;
  // List<Marker> list_ = [
  //   Marker(
  //       markerId: MarkerId('1'),
  //       position: LatLng(24.871941, 66.988060),
  //       infoWindow: InfoWindow(title: 'My Current location')),
  //   Marker(
  //       markerId: MarkerId('2'),
  //       position: LatLng(24.891941, 66.988060),
  //       infoWindow: InfoWindow(title: 'My Current location')),
  //   Marker(
  //       markerId: MarkerId('4'),
  //       position: LatLng(24.8043, 67.0577),
  //       infoWindow: InfoWindow(title: 'Defence')),
  // ].obs;

  /////////////////Google Map Controller + getting location by longitude and latitude///////////////////////

  Rx<Completer> controllermap = Completer().obs;

  final Rx<CameraPosition> kGooglePlex = const CameraPosition(
    target: LatLng(24.8607, 67.0011),
    zoom: 14.4746,
  ).obs;

  @override
  void onInit() {
    getmarker();
    //addicon();
    // getbytesfromassets(path, width)
    super.onInit();

    //marker_.addAll(list_);
    //forpolyline();
  }

  Future<Uint8List> getbytesfromassets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

//  Getting custom marker
  getmarker() async {
    for (var i = 0; i < latlng.length; i++) {
      final Uint8List icon = await getbytesfromassets(image.value, 70);
      marker.add(Marker(
        markerId: MarkerId(i.toString()),
        position: latlng[i],
        icon: BitmapDescriptor.fromBytes(icon),
      ));
    }
  }

////////////////////////// by pressing on floating button this will take you to the given longitude and latitude///////
  Future<void> location() async {
    GoogleMapController controller = await controllermap.value.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(target: LatLng(24.8387, 67.1209), zoom: 14)));
  }

  /////////////////Asking for your permission to enable location////////////////

  Future<Position> determinePosition() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('Error :' + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  /////////getting exact location////////////////////////
  Future getexactlocation(value) async {
    GoogleMapController controller_new = await controllermap.value.future;

    CameraPosition camera = CameraPosition(
        zoom: 18, target: LatLng(value.latitude, value.longitude));

    controller_new.animateCamera(CameraUpdate.newCameraPosition(camera));
  }
  // Custom Icon

  // void addicon() async {
  //   try {
  //     selficon.value = await BitmapDescriptor.fromAssetImage(
  //         const ImageConfiguration(), 'asset/map.png');
  //     print('icon added');

  //     refresh();
  //   } catch (e) {
  //     print('catch : $e');
  //   }
  // }

  // forpolyline() {
  //   polyline_.add(Polyline(
  //     width: 5,
  //     color: Colors.red,
  //     polylineId: PolylineId('1'),
  //     points: latlng_,
  //   ));
  // }
}
