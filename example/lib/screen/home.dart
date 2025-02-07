import 'package:example/controller/todos_controller.dart';
import 'package:flutter/material.dart';
import 'package:getx/getx.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: SizedBox(
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
    );
  }
}
