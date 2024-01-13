import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {
  String appBarTitle;
  final Note note;
  NoteDetail(this.note,this.appBarTitle);
  @override
  State<NoteDetail> createState() => _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];
  String appBarTitle;
  Note note;
  TextEditingController titileController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  _NoteDetailState(this.note,this.appBarTitle);


  @override
  Widget build(BuildContext context) {
    titileController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        onWillPop:() async{
      // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
          return true;
    },
    child:Scaffold(
      appBar: AppBar(
        title:Text(appBarTitle),backgroundColor: Colors.deepPurple,
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringIteam){
                  return DropdownMenuItem<String>(
                      value: dropDownStringIteam,
                      child: Text(dropDownStringIteam),
                  );
                }).toList(),
                style: TextStyle(color: Colors.black),
                //value: getPriorityAsString(note.priority),
                onChanged:(valueSelectedByUser){
                  setState(() {
                    debugPrint('User selected $valueSelectedByUser');
                    //updatePriorityAsInt(valueSelectedByUser);
                    });
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
            child:TextField(
              controller: titileController,
                onChanged: (value){
                  debugPrint('Something changed in title Text field');
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),

            )
            ),
            Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child:TextField(
                  controller: descriptionController,
                  onChanged: (value){
                    debugPrint('Something changed in title Text field');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                  ),

                )
            ),
            Padding(padding:EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.white),
                        ),

                        onPressed: (){
                          setState(() {
                            _save();
                            debugPrint("Save button clicked");

                          });
                        },
                      )),
                  Container(width: 5.0,),
                  Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: (){
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                      ))
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

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }
  // String getPriorityAsString(int value) {
  //   String priority;
  //   switch (value) {
  //     case 1:
  //       priority = _priorities[0];  // 'High'
  //       break;
  //     case 2:
  //       priority = _priorities[1];  // 'Low'
  //       break;
  //   }
  //   return priority;
  // }
  void updateTitle(){
    note.title = titileController.text;
  }
  void updateDescription(){
    note.description = descriptionController.text;
  }
  void _save() async{
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null && note.id !=0){
      result = await DatabaseHelper().insertNote(note);
      //result = await DatabaseHelper().updateNote(note);
    }
    else{

      result = await DatabaseHelper().insertNote(note);
    }
    if(result != 0){
      _showAlertDialog('Status','Note saved Successfully');

    }
    else{
      _showAlertDialog('Status','Problem solving Note');
    }
  }
  void _delete() async {

   // moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await DatabaseHelper().deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }
  void _showAlertDialog(String title , String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder:(_)=> alertDialog);
  }
}
