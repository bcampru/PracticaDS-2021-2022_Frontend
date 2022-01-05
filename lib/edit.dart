import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:time_tracker/tree.dart' as Tree hide getTree;
import 'package:time_tracker/requests.dart';

// Define a custom Form widget.
class MyCustomEdit extends StatefulWidget {
  late Tree.Activity _node;
  MyCustomEdit(Tree.Activity node, {Key? key}) : super(key: key) {
    _node = node;
  }
  @override
  MyCustomEditState createState() {
    return MyCustomEditState(_node);
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
  MyCustomEditState(
    Tree.Activity node,
  ) {
    _Name = node.name;
    _Tags = node.tags;
  }
  final _formKey = GlobalKey<FormState>();
  String _Name = "";
  List<String> _Tags = [];
  String _Tag = "";

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Project',
      'label': 'Project',
    },
    {
      'value': 'Task',
      'label': 'Task',
    },
  ];

  String tags_text() {
    if (_Tags.length == 0) {
      return "Aun no has añadido ningún tag!";
    }
    String result = "Tags:";
    _Tags.forEach((element) {
      result += (' ' + element);
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: const Alignment(-0.075, -1),
            child: Container(
              child: Text('Fill the form'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.topLeft,
                child:
                    Container(child: Text('Write the name of the activity:')),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: _Name,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {
                  _Name = value;
                  print(_Name);
                },
              ),
              Text(tags_text()),
              SizedBox(height: 60.0),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text('Write the tag of the Activity:'),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Tag...',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {
                  _Tag = value;
                  print(_Tag);
                },
              ),
              SizedBox(height: 150.0),
            ]),
          ),
        ));
  }
}
