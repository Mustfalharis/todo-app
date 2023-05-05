import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';
import '../widgets/cutom_buitld_tasks_Item.dart';


class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context,state)
      {
        var tasks=AppCubit.get(context).doneTasks;
        return ListView.separated(
          itemBuilder: (context , index)=>buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index)=>Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[30],
            ),
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
