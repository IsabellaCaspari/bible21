import 'package:die_bibel21/data/const.dart';
import 'package:die_bibel21/data/sharedpreferences.dart';
import 'package:die_bibel21/page/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    Key key,
  }) : super(key: key);

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
          leading: Icon(Icons.remove_circle_outlined, color: Colors.blue),
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
          leading: Icon(Icons.account_box_outlined, color: Colors.blue),
          title: Text('Über'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildAboutDialog(context),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.verified_user, color: Colors.blue),
          title: Text('Version der App'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildVersionDialog(context),
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
          Text("Möchtest Du alle bisher gespeicherten Einträge zurücksetzen?"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            SharedPref().remove("bible_shared_pref");
            SharedPref().remove("bibleplan");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WelcomePage()));
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
