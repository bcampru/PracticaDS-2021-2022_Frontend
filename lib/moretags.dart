import 'package:flutter/material.dart';
import 'package:time_tracker/form.dart';

class moreTags extends StatefulWidget {
  List<dynamic> tagspassed = [];
  moreTags(List<dynamic> taggs, {Key? key}) : super(key: key) {
    tagspassed = taggs;
  }
  @override
  moreTagsState createState() => moreTagsState(tagspassed);
}

class moreTagsState extends State<moreTags> {
  int _count = 0;
  List<dynamic> _tags = [];
  late String _result;
  moreTagsState(List<dynamic> taggs) {
    _count = taggs.length;
    _tags = taggs;
  }
  @override
  void initState() {
    super.initState();

    _result = "";
  }

  _row(int key) {
    return Row(
      children: [
        Text('Tag: ' + (key + 1).toString()),
        SizedBox(width: 30.0),
        Expanded(
            child: TextFormField(
                initialValue: _tags[key],
                onChanged: (val) {
                  _tags[key] = val;
                })),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Insert Tags:'), actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            setState(() {
              _tags.add("");
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            setState(() {
              _count = 0;
              _tags = [];
            });
          },
        ),
      ]),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _tags.length,
                  itemBuilder: (context, index) {
                    return _row(index);
                  })),
          SizedBox(height: 10.0),
          SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {
              for (var i = 0; i < _tags.length; i++) {
                if (_tags[i] == "") {
                  _tags.removeAt(i);
                }
              }

              if (_tags.isNotEmpty) {
                Navigator.pop(context, _tags);
              } else {
                const snackBar1 =
                    SnackBar(content: Text("You need to add a tag first!!!"));
              }
            },
            child: const Text('Save tags'),
          )
        ]),
      ),
    );
  }
}
