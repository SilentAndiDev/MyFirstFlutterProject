import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uno_point_sale/api_web_services/customer_id_details_service.dart';
import 'package:uno_point_sale/camera_picker.dart';
import 'package:uno_point_sale/language_change_provider.dart';
import 'package:uno_point_sale/models/customer_id_details.dart';
import 'package:uno_point_sale/shared_preferences/local_preferences.dart';
import '../camera_page.dart';
import '../common_utils.dart';
import '../db/app_database.dart';
import '../db/model/note.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import '../generated/l10n.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _MyFirstScreenState();
}

class _MyFirstScreenState extends State<FirstScreen> {
  CustomerIDDetails? customerIDDetails;
  List<CustomerDetail>? list;
  var isLoaded = false;
  late List<Note> notes = [];
  var location = " Not Location " ;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCustomerID() async{
    customerIDDetails = await CustomerIdDetailsService().getCustomerIdDetails();
    if(customerIDDetails != null){
      list = customerIDDetails!.customerDetails;
      LocalPreferences.setCustIdDetails(list, "UnoPointTest1");
      setState(() {
        isLoaded = true;
      });
    }
  }

  printData(){
    //print( LocalPreferences.getCustIdDetails().toString() );
    addNote();

  }
  Future addNote() async {
    final note = Note(
      isImportant: true,
      number: 9858394839,
      title: "Watch List",
      description: "why im doing this",
      createdTime: DateTime.now(),
    );

    await AppDatabase.instance.create(note);
    this.notes = await AppDatabase.instance.readAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/uno_point_logo.png"),
              ],
            ),
            Card(
              child: Column(
                children:<Widget> [
                  const ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text("App Permission"),
                    subtitle: Text(
                        '\nPlease click Go to setting or approve all from'
                            '\nSetting->App->UnoPoint->Permission'
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('Geo'),
                        onPressed: () {
                          getLatLong();
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Go To Setting'),
                        onPressed: () { getCustomerID(); },
                      ),
                      const SizedBox(width: 8),


                    ],
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                        child: const Text('Check Permission'),
                        onPressed: () { printData(); },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  Text(location,style: TextStyle(color: Colors.black,fontSize: 16),),
                  const SizedBox(width: 8),
                  Text(S.of(context).Please_click_Go_to_setting_or_approve_all_from,style: const TextStyle(color: Colors.black,fontSize: 12)),
                  const SizedBox(width: 8),
                  Row(
                    children: <Widget>[
                      TextButton(child: const Text('Hindi'), onPressed: () {
                        context.read<LanguageChangeProvider>().changeLocale("hi");
                      }, ),
                      const SizedBox(width: 8),
                      TextButton(child: const Text('English'), onPressed: () {
                        context.read<LanguageChangeProvider>().changeLocale("en");
                      }, ),
                      const SizedBox(width: 8),

                    ],
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(child: const Text('Camera'), onPressed: () async {
                        await availableCameras().then((value) => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
                      }, ),
                      const SizedBox(width: 8),
                      TextButton(child: const Text('Image Picker'), onPressed: ()  {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  AppPicker()),);
                      }, ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],

              ),
            ),
            Visibility(
                visible: isLoaded,
                child: SizedBox(
                  height: 150,
                  child: ListView.builder(
                      //itemCount: list?.length,
                    itemCount: notes.length,
                      itemBuilder: (context,index){
                        return  Container(
                          //child: Text(list![index].custName as String),
                          child: Text(notes[index].title as String),
                        );
                      }
                      )
                ),
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              Text(CommonUtils.ver),
              Text(CommonUtils.copyRight),
              Text(CommonUtils.copyRightUrl)
            ])
          ],
        ),
      ),
    );
  }

  Future getLatLong() async{
    Position position = await _getGeoLocationPosition();
    setState(() {
      location ='Lat: ${position.latitude} , Long: ${position.longitude}';
    });
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    if (Platform.isAndroid) {
      GeolocatorAndroid.registerWith();
    } else if (Platform.isIOS) {
      GeolocatorApple.registerWith();
    }

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Location permissions are denied"),
        ));
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: const Text("Location permissions are permanently denied, we cannot request permissions."),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Setting',
          onPressed: () {
            openSetting();
          },
        ),
      ));
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future openSetting() async{
    openAppSettings();
  }
}
