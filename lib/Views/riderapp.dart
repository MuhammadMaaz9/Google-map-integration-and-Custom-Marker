import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_app/Controllers/riderapp_controller.dart';
import 'package:tracking_app/Views/map_screen.dart';

class RiderApp extends StatelessWidget {
  const RiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseReference database = FirebaseDatabase.instance.ref('post');

    riderapp rp = Get.put(riderapp());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 0.08 * rp.height),
                  child: Text(
                    'Rider Login',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.2 * rp.height,
              ),
              TextField(
                controller: rp.name,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(top: 55.0, left: 15),
                  hintText: 'Enter Name',
                  // suffixIcon: val == true ? Icon(Icons.check) : null,
                  fillColor: Color(0xffF2F3F7),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 0.02 * rp.height,
              ),
              TextField(
                controller: rp.email,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(top: 55.0, left: 15),
                  hintText: 'Enter Email!',
                  // suffixIcon: val == true ? Icon(Icons.check) : null,
                  fillColor: Color(0xffF2F3F7),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    database
                        .child(DateTime.now().millisecondsSinceEpoch.toString())
                        .set({
                          'id':
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          'Name': rp.name.text.toString(),
                          'Email': rp.email.text.toString(),
                        })
                        .then((value) =>
                            Get.snackbar('Congratulations', 'Data Added'))
                        .onError((error, stackTrace) =>
                            Get.snackbar('Note', '${error.toString()}'));
                    rp.name.clear();
                    rp.email.clear();
                    Get.to(MapScreen());
                  },
                  child: Text('Add Data'))
            ],
          ),
        ),
      ),
    );
  }
}
