// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  String txt1 = '';
  String txt2 = '';
  double diff = 0.0;

  TextEditingController t1Controller = TextEditingController();
  TextEditingController t2Controller = TextEditingController();

  @override
  void initState() {
    test();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TEST APP'),
        actions: [
          IconButton(onPressed: () => reset(), icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () => test(), child: const Text('Initiate')),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(children: [
                    SizedBox(
                        height: dh / 3,
                        child: TextField(
                          decoration:
                              const InputDecoration(hintText: 'Type here...!'),
                          maxLines: null,
                          controller: t1Controller,
                          onChanged: (value) => setBarValue(value, txt2),
                        )),
                    SizedBox(
                        height: dh / 3,
                        child: TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Type here...!'),
                          maxLines: null,
                          controller: t2Controller,
                          onChanged: (value) => setBarValue(txt1, value),
                        )),
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: dh / 5,
            ),
            SizedBox(
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(diff),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: dh / 20,
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Text(t1Controller.text.length.toString())),
                    ),
                    Container(
                      color: Colors.blue,
                      width: dw / 2,
                      height: dh / 20,
                    ),
                    SizedBox(
                      height: dh / 20,
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Text(t2Controller.text.length.toString())),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: dh / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Divider(
                    thickness: 2,
                  ),
                  Text('GROUND'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  test() async {
    return await FirebaseFirestore.instance
        .collection('test')
        .doc('testing')
        .get()
        .then((value) {
      txt1 = value.data()!['text1'];
      txt2 = value.data()!['text2'];
      t1Controller.text = value.data()!['text1'];
      t2Controller.text = value.data()!['text2'];
      diff = double.parse(value.data()!['diff'].toString());
      setState(() {});
    });
  }

  setBarValue(String t1, String t2) {
    txt1 = t1;
    txt2 = t2;

    double t1l = txt1.length.toDouble();
    double t2l = txt2.length.toDouble();

    if (t2l - t1l > 52 || t1l - t2l > 52) {
      reset();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Bar touched '),
              actions: [
                ButtonBar(
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok')),
                  ],
                )
              ],
            );
          });
      return;
    }

    diff = (t2l - t1l) / 360;

    update(t1, t2, txt1, txt2, diff.toString());
    setState(() {});
  }

  update(String t1, String t2, String text1, String text2, String diff) {
    CollectionReference collectionTesting =
        FirebaseFirestore.instance.collection('test');
    collectionTesting.doc('testing').update({
      't1': t1.length,
      't2': t2.length,
      'text1': text1,
      'text2': text2,
      'diff': diff
    }).then((value) {
      setState(() {});
      // avoid_print
    }).catchError((error) => print("Failed to add data: $error"));
  }

  reset() {
    CollectionReference collectionTesting =
        FirebaseFirestore.instance.collection('test');
    collectionTesting.doc('testing').update({
      't1': '0',
      't2': '0',
      'text1': '',
      'text2': '',
      'diff': '0'
    }).then((value) {
      setState(() {});
      test();
      // avoid_print
    }).catchError((error) => print("Failed to reset data: $error"));
  }
}
