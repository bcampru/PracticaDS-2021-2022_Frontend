import 'package:time_tracker/tree.dart' hide search;
import 'package:flutter/material.dart';
import 'package:time_tracker/PageIntervals.dart';
import 'package:time_tracker/requests.dart';
import 'dart:async';
import 'package:time_tracker/form.dart';
import 'package:time_tracker/edit.dart';

class PageSearch extends StatefulWidget {
  final int tags;
  @override
  _PageSearchState createState() => _PageSearchState();
  PageSearch(this.tags);
}

class _PageSearchState extends State<PageSearch> {
  late String tags;
  late Future<Tree> futureTree;
  late Timer _timer;
  static const int periodeRefresh = 1;
  void _refresh() async {
    futureTree = search(tags); // to be used in build()
    setState(() {});
  }

  void _activateTimer() {
    _timer = Timer.periodic(Duration(seconds: periodeRefresh), (Timer t) {
      futureTree = search(tags);
      setState(() {});
    });
  }

  void _doForm(int id) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MyCustomForm(id),
    ))
        .then((var value) {
      _activateTimer();
      _refresh();
    });
  }

  Future<void> _doedit(Activity act) async {
    Activity result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyCustomEdit(act),
        ));
    if (result != null) {
      updateActivity(result.id, result.name, result.tags.toString());
      setState(() {});
    }
    ;
  }

  void _navigateDownIntervals(int childId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageIntervals(childId),
    ))
        .then((var value) {
      _activateTimer();
      _refresh();
    });
  }

  @override
  void dispose() {
    // "The framework calls this method when this State object will never build again"
    // therefore when going up
    _timer.cancel();
    super.dispose();
  }

  void _navigateDownActivities(int childId) {
    _timer.cancel();
    // we can not do just _refresh() because then the up arrow doesn't appear in the appbar
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageSearch(childId),
    ))
        .then((var value) {
      _activateTimer();
      _refresh();
    });
    //https://stackoverflow.com/questions/49830553/how-to-go-back-and-refresh-the-previous-page-in-flutter?noredirect=1&lq=1
  }

  String tags_text(Activity act) {
    if (act.tags.length == 0) {
      return "Aun no has a??adido ning??n tag!";
    }
    String result = "";
    act.tags.forEach((element) {
      result += (' ' + element);
    });
    return result;
  }

  @override
  void initState() {
    super.initState();
    tags = "";
    futureTree = search(tags);
    _activateTimer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tree>(
      future: futureTree,
      // this makes the tree of children, when available, go into snapshot.data
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.root.name),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _doedit(snapshot.data!.root)),
                IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      while (Navigator.of(context).canPop()) {
                        print("pop");
                        Navigator.of(context).pop();
                      }
                      /* this works also:
    Navigator.popUntil(context, ModalRoute.withName('/'));
  */
                      PageSearch(0);
                    }),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {} // TODO search by tag
                    ),
                //TODO other actions
              ],
            ),
            body: ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.root.children.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildRow(snapshot.data!.root.children[index], index),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                onPressed: () => _doForm(snapshot.data!.root.id)
                //TODO ADD task or project
                ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(Activity activity, int index) {
    String strDuration =
        Duration(seconds: activity.duration).toString().split('.').first;
    // split by '.' and taking first element of resulting list removes the microseconds part
    if (activity is Project) {
      return ListTile(
        trailing: Text('$strDuration'),
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Project:   ',
              style: TextStyle(color: Colors.teal[300], fontSize: 23.0),
            ),
            TextSpan(
              text: '${activity.name}',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            TextSpan(
              text: '\n Tags : ${tags_text(activity)} ',
            ),
          ]),
        ),
        onTap: () => _navigateDownActivities(activity.id),
      );
    } else if (activity is Task) {
      Task task = activity as Task;
      // at the moment is the same, maybe changes in the future
      Widget trailing;
      trailing = Text('$strDuration');
      return ListTile(
        //title: Text('Task: ${activity.name}', style: TextStyle(fontSize: 50.0)),
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Task:   ',
              style: TextStyle(color: Colors.teal[300], fontSize: 23.0),
            ),
            TextSpan(
              text: '${activity.name}',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            TextSpan(
              text: '\n Tags : ${tags_text(activity)} ',
            ),
          ]),
        ),

        trailing: trailing,
        onTap: () => _navigateDownIntervals(activity.id),
        onLongPress: () {
          if ((activity as Task).active) {
            stop(activity.id);
            _refresh(); // to show immediately that task has started
          } else {
            start(activity.id);
            _refresh(); // to show immediately that task has stopped
          }
        },
      );
    } else {
      throw (Exception("Activity that is neither a Task or a Project"));
      // this solves the problem of return Widget is not nullable because an
      // Exception is also a Widget?
    }
  }
}
