import 'package:ask_list_app/list_detail.dart';
import 'package:ask_list_app/model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Model> modelList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (modelList == null) {
      modelList = List<Model>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List App'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              accountName: Text("GAURAV JHA"),
              accountEmail: Text("jhagaurav268@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("G"),
              ),
            ),
            ListTile(
              title: Text("Home Page"),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext) => HomeScreen()));
              },
            ),
            Divider(),
          ],
        ),
      ),

      body: getModelListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Model('', ''), 'Add Task');
        },
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add,color: Colors.black),
      ),
    );
  }

  ListView getModelListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(getFirstLetter(this.modelList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.modelList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.modelList[position].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, modelList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              navigateToDetail(this.modelList[position], 'Edit Task');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Model model) async {
    int result = await databaseHelper.deleteModel(model.id);
    if (result != 0) {
      _showSnackBar(context, 'Task Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Model model, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListDetail(model, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Model>> modelListFuture = databaseHelper.getModelList();
      modelListFuture.then((modelList) {
        setState(() {
          this.modelList = modelList;
          this.count = modelList.length;
        });
      });
    });
  }
}
