import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/archived_tasks.dart';
import '../../models/done_tasks.dart';
import '../../models/new_tasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(contex)=> BlocProvider.of(contex);
  Database? database;
   int current = 0;
  List<Map>newTasks = [];
  List<Map>doneTasks = [];
  List<Map>archiveTasks = [];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String>title = [
    ' New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void changeIndex(int index)
  {
    current=index;
    emit(AppChangeBottomNavBarState());
  }
  void createDatabase()
  {
       openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version) {
          print('database created');
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT )')
              .then((value) =>
              (value) {
            print('tabal created');
          }).catchError((Ererror) {
            print(';jkldsaf');
          }
          );
        },
        onOpen: (database) {
          getDataFromDatabase(database);

          print('database open');
        }
    ).then((value) {
      database=value;
      emit(AppCreatedDatabaseState());
       });
  }

    insertToDatabase({
    required String title,
    required String time ,
    required String date,
  }) async
  {
  await database?.transaction((txn)async {
       await txn.
      rawInsert('INSERT INTO tasks(title, time, date,status) VALUES("$title", "$time", "$date","new")')
          .then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((Error)
      {
        print('Error When Inserting New Record ${Error.toString()}');
      });
    });
  }


  void getDataFromDatabase(database)
  {
     newTasks=[];
     doneTasks=[];
     archiveTasks=[];
     database!.rawQuery('SELECT * FROM tasks')..then((value)
     {
       value.forEach((element)
       {
        if((element['status'])=='new')
        {
          newTasks.add(element);
        }
        else if((element['status'])=='done')
         {
           doneTasks.add(element);
         }
        else
          {
            archiveTasks.add(element);
          }
       });
       emit(AppGetDatabaseState());
     });

  }

  bool isBottomSheetShown = false;
  IconData? fabIcon = Icons.edit;

  void changeBottomSheetState({ bool? isShow, IconData? icon })
  {
    isBottomSheetShown=isShow!;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }

  void updateDate({ String? status, int? id }) async
  {
      await database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status',id],
      ).then((value)
      {
        getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
      });
  }
  void deleteDate({ int? id }) async
  {
    await database!
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

}
