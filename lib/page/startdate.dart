import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class StartDatePage extends StatelessWidget {
  StartDatePage({Key key, this.title}) : super(key: key);
  final String title;
  final format = DateFormat("dd.MM.yyyy");
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            children: [
              Text(
                'Startdatum eingeben',
                style: Theme.of(context).textTheme.headline3,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: Text(
                  "Wann möchstest Du mit dem Leseplan beginnen?",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              DateTimeField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                  ),
                  labelText: "Startdatum",
                ),
                initialValue: DateTime(2021, 1, 1),
                format: format,
                controller: _dateController,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(2021),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2025));
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
                      "Weiter gehts!",
                    ),
                    onPressed: () => _onNextClicked(context),
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

  _onNextClicked(context) {
    if (_dateController.text != null && _dateController.text != "") {
      DateTime date = format.parse(_dateController.text);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: title, startDate: date),
          ));
    }
  }
}
