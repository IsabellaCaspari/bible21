import 'package:die_bibel21/data/const.dart';
import 'package:die_bibel21/data/sharedpreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String bibleReadingplan = Constants.BIBLE_PLAN_1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            children: [
              Text(
                'Herzlich Willkommen',
                style: Theme.of(context).textTheme.headline2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: Text(
                  "Wähle Deinen Leseplan",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              RadioListTile(
                title: const Text(Constants.BIBLE_PLAN_1),
                value: Constants.BIBLE_PLAN_1,
                groupValue: bibleReadingplan,
                onChanged: (String value) {
                  setState(() {
                    bibleReadingplan = value;
                  });
                },
              ),
              RadioListTile(
                title: const Text(Constants.BIBLE_PLAN_2),
                value: Constants.BIBLE_PLAN_2,
                groupValue: bibleReadingplan,
                onChanged: (String value) {
                  setState(() {
                    bibleReadingplan = value;
                  });
                },
              ),
              RadioListTile(
                title: const Text(Constants.BIBLE_PLAN_3 + ' 100 Tagen'),
                value: Constants.BIBLE_PLAN_3,
                groupValue: bibleReadingplan,
                onChanged: (String value) {
                  setState(() {
                    bibleReadingplan = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text(
                      "Los gehts!",
                    ),
                    onPressed: _onNextClicked,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onNextClicked() {
    SharedPref().save("bibleplan", bibleReadingplan);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: bibleReadingplan),
        ));
  }
}
