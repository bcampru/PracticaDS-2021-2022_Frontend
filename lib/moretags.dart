import 'package:flutter/material.dart';
import 'package:codelab_timetraker/form.dart';
class moreTags extends StatefulWidget {
  Map<int,String> tagspassed = <int, String>{};
  moreTags(Map<int,String>taggs, {Key? key}) : super(key: key) {
    tagspassed = taggs;
  }
  @override
  moreTagsState createState() => moreTagsState(tagspassed);
}
class moreTagsState extends State<moreTags>{
  int _count = 0;
  late List<Map<String,dynamic>> _values;
  late String _result;
  moreTagsState(Map<int,String> taggs){
    _count = taggs.length;
    _values = [];
    for (int i = 0; i < _count; i++){
      Map<String,dynamic> jsonact = {'id': i, 'value':taggs[i]};
      _values.add(jsonact);
    }

  }
  @override
  void initState() {
    super.initState();
    _values = [];
    _result ="";
  }
  _onUpdate(int key, String val) {
    int foundKey = -1;
    for (var map in _values){
      if (map.containsKey('id')){
          if (map['id'] == key){
            foundKey = key;
            break;
          }
      }
    }
    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }
    Map<String,dynamic> json = {'id': key, 'value':val};
    _values.add(json);

    setState(() {
        _result = _values.toString();
    });
  }
  _row(int key,int form) {
    return Row(
      children: [
          Text('Tag: $form'),
          SizedBox(width: 30.0),
          Expanded(child: _count!=0 ?TextFormField(
              onChanged: (val) {
    _onUpdate(key, val);
    }) : TextFormField (
      initialValue: _values[key]['value'],
    onChanged: (val) {
    _onUpdate(key, val);})),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Tags:'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed:() async {
              setState(() {
                _count++;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:() async {
              setState(() {
                _count = 0;
                _values = [];
              });
            },),
        ]
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                itemCount: _count,
                itemBuilder: (context, index) {
                    return _row(index,index+1);
              }
              )
            ),
            SizedBox(height: 10.0),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                if (_values == null){
                  return null;
                }
                int index=0;
                Map<int,String> conversionValues = <int,String>{};
                for (var i=0;i < _values.length;i++) {
                    if ((_values[i]['id']!=index)||(_values[i]['value']=="")){
                      print(_values[i]['value']);
                      break;
                    }
                    else{
                      index++;
                    }
                  }
                if (((index) == _count)&&(_count != 0)){
                  for (var i=0;i <_count;i++)
                  {
                    conversionValues[_values[i]['id']] = _values[i]['value'];
                  }
                  Navigator.pop(context,conversionValues);
                }else {
                  const snackBar1 = SnackBar(content: Text("You need to add a tag first!!!"));
                  const snackBar2 = SnackBar(content: Text ("A tag can't be empty!!!"));
                  if (_count == 0){
                      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                  }else{
                      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                  }
                }
              },
              child: const Text('Save tags'),
            )
          ]
        ),
      ),
    );

  }
}