import 'package:intl/intl.dart';

class BiblePlan {
  List<Passage> passages;

  BiblePlan({this.passages});

  BiblePlan.fromJson(Map<String, dynamic> json) {
    if (json['plan'] != null) {
      passages = new List<Passage>();
      json['plan'].forEach((v) {
        passages.add(new Passage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.passages != null) {
      data['plan'] = this.passages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Passage {
  DateTime date;
  String chapter;
  bool read;

  Passage({this.date, this.chapter, this.read});

  Passage.fromJson(Map<String, dynamic> json) {
    var dateText = json['date'];
    date = DateFormat('M/d/yyyy').parse(dateText);
    chapter = json['chapter'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final DateFormat formatter = DateFormat('M/d/yyyy');
    data['date'] = formatter.format(date);
    data['chapter'] = this.chapter;
    data['read'] = this.read;
    return data;
  }
}
