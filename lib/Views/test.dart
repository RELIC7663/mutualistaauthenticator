import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Model/user.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late DatabaseHelper _databaseHelper;
  List<User> _userList = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _getUserList();
  }

  Future<void> _getUserList() async {
    _userList = await _databaseHelper.getUsers();
    setState(() {}); // Actualiza la interfaz gráfica
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('PIN'),
            ),
            DataColumn(
              label: Text('Acciones'),
            ),
          ],
          rows: _userList.map<DataRow>((User user) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(user.id)),
                DataCell(Text(user.pin)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editUser(user);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteUser(user.id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addUser() async {
    // Mostrar un diálogo para agregar un nuevo usuario
    TextEditingController idController = TextEditingController();
    TextEditingController pinController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: pinController,
                  decoration: InputDecoration(labelText: 'PIN'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                User newUser =
                    User(id: idController.text, pin: pinController.text);
                await _databaseHelper.insertUser(newUser);
                _getUserList();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUser(User user) async {
    // Mostrar un diálogo para editar un usuario existente
    TextEditingController pinController = TextEditingController(text: user.pin);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ${user.id}'),
                TextField(
                  controller: pinController,
                  decoration: InputDecoration(labelText: 'PIN'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                User updatedUser = User(id: user.id, pin: pinController.text);
                await _databaseHelper.updateUserPin(updatedUser);
                _getUserList();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    // Mostrar un cuadro de diálogo de confirmación antes de eliminar el usuario
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Usuario'),
          content: Text('¿Estás seguro de que quieres eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No confirmar la eliminación
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar la eliminación
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _databaseHelper.deleteUser(userId);
      _getUserList();
    }
  }
}
