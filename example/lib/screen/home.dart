import 'package:app_bar_auto_hide/app_bar_auto_hide.dart';
import 'package:example/controller/todos_controller.dart';
import 'package:flutter/material.dart';
import 'package:getx/getx.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAutoHide(
        notifier: TodosController.to.notifier,
        title: Text('Todos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          TodosController.to.notifier.value = notification;
          return true;
        },
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: TodosController.to.todos.isEmpty
              ? const Center(child: Text('No todos'))
              : ListView.builder(
                  itemCount: TodosController.to.todos.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('Todo $index'),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
