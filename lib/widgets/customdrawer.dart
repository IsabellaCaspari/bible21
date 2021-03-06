import 'package:die_bibel21/data/const.dart';
import 'package:die_bibel21/data/sharedpreferences.dart';
import 'package:die_bibel21/main.dart';
import 'package:die_bibel21/model/bibleplan.dart';
import 'package:die_bibel21/page/startdate.dart';
import 'package:die_bibel21/page/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key key, this.title, this.plan}) : super(key: key);
  final String title;
  final BiblePlan plan;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/app_icon.png'),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Text("Die BIBEL 21"),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.color,
          ),
        ),
        ListTile(
          leading: Icon(Icons.article_outlined, color: Colors.blue),
          title: Text('Übersetzung auswählen'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildTranslationDialog(context),
            );
          },
        ),
        ListTile(
          leading:
              Icon(Icons.swap_horizontal_circle_outlined, color: Colors.blue),
          title: Text('Leseplan wechseln'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildBibelPlanSwapDialog(context),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.remove_circle_outline, color: Colors.blue),
          title: Text('Leseplan zurücksetzen'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildBiblePlanResetDialog(context),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.verified_user_outlined, color: Colors.blue),
          title: Text('Version der App'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildVersionDialog(context),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.account_box_outlined, color: Colors.blue),
          title: Text('Über uns'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildAboutDialog(context),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBiblePlanResetDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Leseplan zurücksetzen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Möchtest Du den Leseplan "+widget.title+ "neu starten?"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            SharedPref().remove(widget.title);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StartDatePage(
                          title: widget.title,
                        )));
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Ja'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Doch nicht'),
        ),
      ],
    );
  }

  Widget _buildBibelPlanSwapDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Leseplan wechseln'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hier kannst Du den Leseplan wechseln."),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            if (widget.plan != null) {
              await SharedPref().save(widget.title, widget.plan);
            }
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WelcomePage()));
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Wechseln'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Doch nicht'),
        ),
      ],
    );
  }

  Widget _buildTranslationDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Wähle Deine Lieblingsübersetzung'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Welche Übersetzung möchtest Du für Deinen Leseplan verwenden?"),
          FutureBuilder(
              future: _getTranslation(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return CustomDropdown(text: "NLB");
                } else if (snapshot.hasData) {
                  return CustomDropdown(text: snapshot.data);
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Speichern'),
        ),
      ],
    );
  }

  Future<String> _getTranslation() async {
    var translation = await SharedPref().read("translation");

    if (translation == null) {
      return "NLB";
    } else {
      return translation;
    }
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('© Copyright 2021'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Diese App wurde für die EFG Vestnertor erstellt für das Projekt: Die BIBEL 21. \n\nEntwickelt von Isabella Caspari zusammen mit Bernhard Caspari. \n\Konzipiert auf Grundlage der Bibellesepläne von Tobias Hornung."),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Schließen'),
        ),
      ],
    );
  }

  Widget _buildVersionDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Version der App'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Diese App hat die Version: " + Constants.APP_VERSION),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Schließen'),
        ),
      ],
    );
  }
}

class CustomDropdown extends StatefulWidget {
  CustomDropdown({Key key, this.text}) : super(key: key);
  final String text;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  var _value = "";

  @override
  Widget build(BuildContext context) {
    if (_value == "") {
      _value = widget.text;
    }
    return Container(
        child: DropdownButton(
            value: _value,
            items: [
              DropdownMenuItem(
                child: Text("Lutherbibel 17"),
                value: "LUT",
              ),
              DropdownMenuItem(
                child: Text("Elberfelder Bibel"),
                value: "ELB",
              ),
              DropdownMenuItem(
                child: Text("Hoffnung für Alle"),
                value: "HFA",
              ),
              DropdownMenuItem(
                child: Text("Neues Leben"),
                value: "NLB",
              ),
              DropdownMenuItem(
                child: Text("English Standard Version"),
                value: "ESV",
              )
            ],
            onChanged: (value) {
              setState(() {
                _value = value;
                SharedPref().save("translation", value);
              });
            }));
  }
}
