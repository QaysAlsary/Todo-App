

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

import '../archived_tasks/archived_tasks_screen.dart';
import '../done_tasks/done_tasks_screen.dart';
import '../new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{
   AppCubit() : super(AppInitialState());
  static AppCubit get(context)=> BlocProvider.of(context);
   int currentIndex = 0;
   Database? database;
   List<Map> newTasks=[];
   List<Map> doneTasks=[];
   List<Map> archivedTasks=[];
   List<Widget> screen = [
     const NewTasksScreen(),
     const DoneTasksScreen(),
     const ArchivedTasksScreen(),
   ];
   List<String> title = [
     'New Tasks',
     'Done Tasks',
     'Archived Tasks',
   ];
   bool isBottomSheetDisplayed = false;
   IconData fabIcon = Icons.edit;
   void changeIndex(int index){
     currentIndex=index;
     emit(AppChangeBottomNavBarState());
   }
   void creatDatabase()  {
      openDatabase('todo.db', version: 1,
         onCreate: (database, version) {

           database
               .execute(
               ' CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
               .then((value) {

           }).catchError((error) {

             SnackBar(content: Text('Error when creating table ${error.toString()}'));
           });
         }, onOpen: (database) {
           getFromDatabase(database);

         }).then((value) {
           database = value;
           emit(AppCreatDatabaseState());
      });
   }

    insertToDatabase({
     @required String? title,
     @required String? time,
     @required String? date,
   }) async {
      await database!.transaction((txn) async {
       txn
           .rawInsert(
           'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
           .then((value) {

         emit(AppInsertDatabaseState());
         getFromDatabase(database);
       }).catchError((error) {

         SnackBar(content: Text('Error when inserting into table ${error.toString()}'));
       });
     });
   }

   void getFromDatabase(database)  {

     newTasks=[];
     doneTasks=[];
     archivedTasks=[];
     emit(AppGetDatabaseLoadingState());
       database.rawQuery('SELECT * FROM tasks').then((value) {
       value.forEach((element){

         if(element['status']=='new') {
           newTasks.add(element);
         } else if(element['status']=='done') {
           doneTasks.add(element);
         } else {
           archivedTasks.add(element);
         }
       });
         emit(AppGetFromDatabaseState());
       });


   }
   void changeBottomSheetState({
  required bool isShow,
     required IconData icon,
}){
     isBottomSheetDisplayed=isShow;
     fabIcon = icon;
     emit(AppChangeBottomSheetState());
   }

   void updateData({
  required String status,
     required int id,
})async{
      database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
         [status, id]).then((value) {
           getFromDatabase(database);
           emit(AppUpdateDatabaseState());
      });
   }
   void deleteData({
  required int id,
})async{
     database!.rawDelete('DELETE FROM tasks WHERE id = ?',[id]).then((value) {
      getFromDatabase(database);
      emit(AppDeleteDatabaseState());
     });
   }
   void slider({
  required var direction,
     required int id,
}){
     if(direction == DismissDirection.endToStart){
       deleteData(id: id);
     }else{
       updateData(status: 'archived', id: id);
     }

   }
}