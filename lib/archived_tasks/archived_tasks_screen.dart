
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';

import '../constants.dart';
import '../cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context,state){
        var tasks = AppCubit.get(context).archivedTasks;
        return tasks.isEmpty ?  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.menu,
                size: 70,
              ),
              Text('No Tasks Yet Add Some To See Them Here',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.indigo,
                ),)
            ],
          ),
        )     : ListView.separated(itemBuilder: (context, index) => Dismissible(
          key:  Key(tasks[index]['id'].toString()),
          background: slideLeftBackground(),
          secondaryBackground: slideLeftBackground(),
          onDismissed: (direction){
           AppCubit.get(context).deleteData(id: tasks[index]['id']);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(

              children: [
                CircleAvatar(
                  radius: 35.0,
                  child: Text(tasks[index]['time']),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tasks[index]['title'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      Text(tasks[index]['date'],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                    onPressed: () {
                      AppCubit.get(context).updateData(
                          status: 'done', id: tasks[index]['id']);
                    },
                    icon: const Icon(
                      Icons.check_box,
                      color: Colors.green,
                    )),

              ],
            ),
          ),
        ),
            separatorBuilder: (context,index)=> Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount:   tasks.length);
      },

    );
  }
}
