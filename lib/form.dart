import 'package:codelab_timetraker/moretags.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:codelab_timetraker/tree.dart' as Tree hide getTree;
import 'package:codelab_timetraker/requests.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  late int _parentId2;
  MyCustomForm(int id, {Key? key}) : super(key: key){
    _parentId2 = id;
  }
  int getParentID(){
    return _parentId2;
  }
  void returnFromMoreTags(BuildContext context){

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
  String _Name="";
  bool _project = true;
  int _longtags = 0;
  int _parentId = -1;
  Map<int,String> _tags = <int, String>{};
  String _Tagstoshow="";
  String _TagstoSend="";

  Future<void> _doMoreTags(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) =>  moreTags(_tags),
    ));
    setState(() {
      print("NO WAYYYY");
      print(result);
      _tags = result;
      _longtags = _tags.length;
      _Tagstoshow = _tags[0]!;
      _TagstoSend = _Tagstoshow;
      for (int i = 1; i <_longtags;i++){
        String actualTag = _tags[i]!;
        _Tagstoshow=(_Tagstoshow +",$actualTag");
        _TagstoSend=(_TagstoSend +"?$actualTag");
      }
    });
  }
  _row(int key,int form) {
    return Row(
      children: [
        Text('Tag: $form'),
        SizedBox(width: 30.0),
        Expanded(child: TextFormField()),
      ],
    );
  }

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
          title:  Align(
            alignment: const Alignment(-0.075,-1),
            child: Container(
              child:Text('Fill the form'),
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
                    child:const Text('Which activity do you  want to create ?'),
                  ),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  initialValue: 'Project',
                  labelText: "Activity:",
                  items: _items,
                  onChanged: (val) =>
                  {
                    _project = !_project,
                    print(_project)
                  }
                  //onSaved: (val) => {}
                ),
                SizedBox(height: 60.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child:Text('Write the name of the activity:'),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Name...',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 32.0),
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                  onChanged: (value) {
                    _Name = value;
                    print(_Name);
                  },
                ),
                SizedBox(height: 60.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child:_longtags==0? Text('No Tags Setted !!!'):Text(
                        'Tags: '
                        '$_Tagstoshow'),
                  ),
                ),
                SizedBox(height: 40.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () =>_doMoreTags(context),
                    child: (_longtags== 0)? Text("Tap me to add tags"):Text("Tap me to modify tags")),
                ),
                SizedBox(height: 10.0),
                /*TextFormField(
                  onTap: () =>_doMoreTags(context),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Tag...',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 32.0),
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                  onChanged: (value) {
                    _Tag = value;
                    print(_Tag);
                  },
                ),
                */
                SizedBox(height: 150.0),
                Align(
                  alignment: const Alignment(-0.0355,-1),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300,100),
                    ),
                    onPressed: () {
                      if (_Name == ""){
                        const snackBar = SnackBar(
                          content: Text("Name can't be empty"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else{
                        if (_longtags == 0){
                          if (_project==true){
                            createProject(_Name,0,_parentId,"f");
                          }
                          else{
                            createTask(_Name,0,_parentId,"f");
                          }
                        }
                        else{
                          if (_project==true){
                            createProject(_Name,1,_parentId,_TagstoSend);
                          }
                          else{
                            createTask(_Name,1,_parentId,_TagstoSend);
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
        )
    );
  }
}
