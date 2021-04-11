import 'package:ask_list_app/model.dart';
import 'package:flutter/material.dart';

import 'database.dart';

class ListDetail extends StatefulWidget {

  final String appBarTitle;
  final Model model;

  ListDetail(this.model, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return ListDetailState(this.model, this.appBarTitle);
  }
}

class ListDetailState extends State<ListDetail> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Model model;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ListDetailState(this.model, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = model.title;
    descriptionController.text = model.description;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
          return null;
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text("ADD TASK"),
            backgroundColor: Colors.black,
            centerTitle: true,
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.green,
                          textColor: Colors.black,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle(){
    model.title = titleController.text;
  }

  void updateDescription() {
    model.description = descriptionController.text;
  }

  void _save() async {

    moveToLastScreen();

    int result;
    if (model.id != null) {
      result = await helper.updateModel(model);
    } else {
      result = await helper.insertModel(model);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Task Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem In Saving Task');
    }

  }


  void _delete() async {

    moveToLastScreen();

    if (model.id == null) {
      _showAlertDialog('Status', 'None Of The Task Was Deleted');
      return;
    }

    int result = await helper.deleteModel(model.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Task Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Task');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}










