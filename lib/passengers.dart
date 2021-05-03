import 'package:flutter/material.dart';
import 'dart:math';

class PassengersPage extends StatefulWidget {
  @override
  _PassengersPageState createState() => _PassengersPageState();
}

class _PassengersPageState extends State<PassengersPage> {

  List<String> passengers;
  Random r;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    r = Random();
    passengers = List();
    addPassengers();
  }

  addPassengers() {
    passengers.add("Johnny Ashley");
    passengers.add("Edward Brown");
    passengers.add("George Mooney");
    passengers.add("Ian Castle");
    passengers.add("Bryan Howl");
  }

  Widget showList() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: passengers.length,
        itemBuilder: (BuildContext context, int index) {
          return rowItem(context, index);
        }
    );
  }

  Widget rowItem(context, index) {
    return Dismissible(
      key: Key(passengers[index]),
      onDismissed: (direction) {
        var passenger = passengers[index];
        showSnackBar(context, passenger, index);
        removePassenger(index);
      },
      background: deleteBgItem(),
      child: Card(
        child: ListTile(
          title: Text(passengers[index]),
        ),
      ),
    );
  }

  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(Icons.delete, color:Colors.white),
    );
  }

  showSnackBar(context, passenger, index) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$passenger deleted'),
      action: SnackBarAction(
        label: "UNDO ITEM",
        onPressed: () {
          undoDelete(index, passenger);
        },
      ),
    ));
  }

  undoDelete(index, passenger) {
    setState(() {
      passengers.insert(index, passenger);
    });
  }

  removePassenger(index) {
    setState(() {
      passengers.removeAt(index);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    addRandomPassenger();
    return null;
  }

  addRandomPassenger() {
    int nextItem = r.nextInt(200);
    setState(() {
      passengers.add("Passenger $nextItem");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Passengers'),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: showList(),
        onRefresh: () async {
          await refreshList();
        },
      ),
    );
  }
}