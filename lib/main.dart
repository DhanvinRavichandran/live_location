import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_location/gaplive.dart';
import 'package:live_location/gaploc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:mapproj(),
    );
  }
}
class locationpage extends StatefulWidget {
  const locationpage({Key? key}) : super(key: key);

  @override
  State<locationpage> createState() => _locationpageState();
}

class _locationpageState extends State<locationpage> {

  var latitude =" ";
  var longitude = " ";
  var address =" ";

  Future<void>updatedLocation()async {
    Position pom =await _determinePosition();
    List pm =await placemarkFromCoordinates(pom.latitude,pom.longitude);
    setState(() {
      latitude =pom.latitude.toString();
      longitude =pom.longitude.toString();
      address =pm[0].toString();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("Live Location"),),
      body:Center(child: Column(children: [
        Text("latitude :"+latitude),
        Text("longitude :"+longitude),
        Text("Address"),
        Text(address),SizedBox(height: 20,),
        ElevatedButton(onPressed: (){
          updatedLocation();
        }, child: Text("Live Location"))

      ],),) ,
    );
  }
}

class mapproj extends StatefulWidget {
  const mapproj({Key? key}) : super(key: key);

  @override
  State<mapproj> createState() => _mapprojState();
}

class _mapprojState extends State<mapproj> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("location on map"),),
      body: Center(child: (Column(children: [
        ElevatedButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>MapSample()),
          );

        }, child: Text("location on Map",style: TextStyle(fontSize: 30),))
        ,ElevatedButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>gaplive()),
          );
        }, child: Text("Your Live location",style: TextStyle(fontSize: 30),))
      ],)),),
    );
  }
}





