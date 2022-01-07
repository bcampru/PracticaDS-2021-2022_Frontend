import 'package:time_tracker/tree.dart' hide getTree;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:time_tracker/moretags.dart';

// Define a custom Form widget.
// ignore: must_be_immutable
class MyCustomEdit extends StatefulWidget {
  late Activity act;

  MyCustomEdit(Activity a, {Key? key}) : super(key: key) {
    act = a;
  }

  void returnFromMoreTags(BuildContext context) {}

  @override
  MyCustomEditState createState() {
    // ignore: no_logic_in_create_state
    return MyCustomEditState(act);
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomEditState extends State<MyCustomEdit> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  MyCustomEditState(Activity act) {
    _act = act;
    _longtags = _act.tags.length;
  }
  late Activity _act;
  late int _longtags;

  Future<void> _doMoreTags(BuildContext context) async {
    dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => moreTags(_act.tags),
        ));
    result ??= _act.tags;
    setState(() {
      print("NO WAYYYY");
      print(result);
      _act.tags = result;
      _longtags = _act.tags.length;
    });
  }

  String tags_text() {
    if (_act.tags.length == 0) {
      return "Aun no has añadido ningún tag!";
    }
    String result = "Tags:";
    for (var element in _act.tags) {
      result += (' ' + element);
    }
    return result;
  }

  _row(int key, int form) {
    return Row(
      children: [
        Text('Tag: $form'),
        SizedBox(width: 30.0),
        Expanded(child: TextFormField()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: const Alignment(-0.075, -1),
            child: Container(
              child: Text('Edit the activity:'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              SizedBox(height: 60.0),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text('Write the new name of the activity:'),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: _act.name,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {
                  _act.name = value;
                  print(_act.name);
                },
              ),
              SizedBox(height: 60.0),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: _longtags == 0
                      ? Text('No Tags Setted !!!')
                      : Text('${tags_text()}'),
                ),
              ),
              SizedBox(height: 40.0),
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () => _doMoreTags(context),
                    child: (_longtags == 0)
                        ? Text("Tap me to add tags")
                        : Text("Tap me to modify tags")),
              ),
              SizedBox(height: 10.0),
              SizedBox(height: 150.0),
              Align(
                alignment: const Alignment(-0.0355, -1),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 100),
                  ),
                  onPressed: () {
                    if (_act.name == "") {
                      const snackBar = SnackBar(
                        content: Text("Name can't be empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.pop(context, _act);
                    }
                  },
                  child: const Text('Sumbit'),
                ),
              ),
            ]),
          ),
        ));
  }
}
