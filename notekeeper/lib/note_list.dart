
import 'package:flutter/material.dart';
import 'package:notekeeper/note_details.dart';
import 'dart:async';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<Note> noteList = [];
  int count = 0;
  @override
  Widget build(BuildContext context) {
     // if(noteList == null){
     //   noteList = List<Note>[];
     //   updateListView();
     //  }
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 20.0),
        title: Text('Notes'),

        backgroundColor: Colors.deepPurple,
      ),
      body:getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){

          // Navigator.push(context, MaterialPageRoute(builder: (context){
          //   return NoteDetail(Note(0,'','',0,''),'Add note');
          // }));
          navigatetodetails(Note(10, '', '', 0, ''), 'Add Note',);
          TextStyle(color:Colors.white);

        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),


    );
  }
  ListView getNoteListView(){
    TextStyle? titleStyle = Theme.of(context as BuildContext).textTheme.subtitle1;
    return ListView.builder(
      itemCount:count,
      itemBuilder: (BuildContext context, int position){
          return Card(
               color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(this.noteList[position].title,style: titleStyle,),
              subtitle: Text(this.noteList[position].date),
              trailing:GestureDetector(
                child:Icon(Icons.delete,color:Colors.grey,),
              onTap:(){
                  _delete(context, noteList[position]);
              }),
              onTap: (){
                debugPrint('Fab clicked');
                navigatetodetails(this.noteList[position],'Edit Note');
              },
            ),
          );
      },
    );
  }
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;

    }
  }
  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }
  void _delete(BuildContext context, Note note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if (result !=0){
      _showSnackBar(context,'Note Deleted Successfully');
      updateListView();
    }
  }
  void _showSnackBar(BuildContext context, String message){
    final snackbar = SnackBar(content: Text(message),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  void navigatetodetails(Note note, String title) async {

    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
