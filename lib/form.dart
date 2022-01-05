import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:time_tracker/tree.dart' as Tree hide getTree;
import 'package:time_tracker/requests.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  late int _parentId2;
  late List _tags2;
  MyCustomForm(int id, {Key? key}) : super(key: key) {
    _parentId2 = id;
  }
  int getParentID() {
    return _parentId2;
  }

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(_parentId2);
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  MyCustomFormState(int id) {
    _parentId = id;
  }
  final _formKey = GlobalKey<FormState>();
  String _Name = "";
  bool _project = true;
  late List _tags;
  String _Tag = "";
  int _parentId = -1;

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
                child: Container(
                  child: const Text('Which activity do you  want to create ?'),
                ),
              ),
              SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  initialValue: 'Project',
                  labelText: "Activity:",
                  items: _items,
                  onChanged: (val) => {_project = !_project, print(_project)}
                  //onSaved: (val) => {}
                  ),
              SizedBox(height: 60.0),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text('Write the name of the activity:'),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Name...',
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
              Align(
                alignment: const Alignment(-0.0355, -1),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 100),
                  ),
                  onPressed: () {
                    if (_Name == "") {
                      const snackBar = SnackBar(
                        content: Text("Name can't be empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if (_Tag == "") {
                        _Tag = "f";
                        if (_project == true) {
                          createProject(_Name, _Tag, _parentId, 0);
                        } else {
                          createTask(_Name, _Tag, _parentId, 0);
                        }
                      } else {
                        if (_project == true) {
                          createProject(_Name, _Tag, _parentId, 1);
                        } else {
                          createTask(_Name, _Tag, _parentId, 1);
                        }
                      }
                      Navigator.of(context).pop();
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
