
import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/models/archived_tasks.dart';
import 'package:to_do/models/done_tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/widgets/custom_defaultFormField.dart';
import 'package:to_do/widgets/custom_text_field.dart';
import '../models/new_tasks.dart';
class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar
              (
              title: Text(
                cubit.title[cubit.current],
              ),
            ),
            body:cubit.screens[cubit.current],

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                  }
                }
                else {
                  scaffoldKey.currentState?.showBottomSheet((context) =>
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFromField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return '=title must not be empty';
                                  }
                                },
                                label: 'Task Title',
                                perfix: Icons.title,),
                              SizedBox(height: 15,),
                              defaultFromField(
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                    print(value);
                                  });
                                },
                                controller: timeController,
                                type: TextInputType.number,
                                validate: (value) {
                                  if (value.isEmpty)
                                    return 'Time must not be empty';
                                },
                                label: 'task Time',
                                perfix: Icons.watch_later_outlined,
                              ),
                              SizedBox(height: 15,),
                              defaultFromField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-10-21'),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                    print(dateController);
                                  });
                                },
                                validate: (value) {
                                  if (value.isEmpty)
                                    return 'date must not be empty';
                                },
                                label: 'Task date',
                                perfix: Icons.calendar_today,
                              ),
                            ],
                          ),
                        ),
                      ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(isShow: false , icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true,icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: SingleChildScrollView(
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.current,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items:
                [
                  BottomNavigationBarItem(
                    icon: Icon(
                        Icons.menu
                    ),
                    label: 'Tasks',


                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                        Icons.check_circle_outline
                    ),
                    label: 'Done',


                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                        Icons.archive_outlined
                    ),
                    label: 'Archive',


                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}
