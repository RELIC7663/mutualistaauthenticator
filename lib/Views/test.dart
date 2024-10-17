import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late DatabaseHelper _databaseHelper;
  List<Dbenty> _dbentyList = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _getDbentyList();
  }

  Future<void> _getDbentyList() async {
    _dbentyList = await _databaseHelper.getDbenty();
    setState(() {}); // Actualiza la interfaz gráfica
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Añadido para permitir el scroll horizontal en la tabla si es necesario
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Keys'),
            ),
            DataColumn(
              label: Text('Value'),
            ),
            DataColumn(
              label: Text('Crud'),
            ),
          ],
          rows: _dbentyList.map<DataRow>((Dbenty db) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(db.keys)),
                DataCell(Text(db.value)),
                DataCell(
                  Container(
                    width: 100, // Establecer un ancho fijo para el contenedor de los botones
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espacio entre los botones
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editUser(db);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteUser(db.keys);
                          },
                        ),
                      ],
                    ),
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
                Dbenty newUser =
                    Dbenty(keys: idController.text, value: pinController.text);
                await _databaseHelper.insertDbenty(newUser);
                _getDbentyList();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUser(Dbenty user) async {
    // Mostrar un diálogo para editar un usuario existente
    TextEditingController pinController =
        TextEditingController(text: user.value);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ${user.keys}'),
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
                Dbenty updatedUser =
                    Dbenty(keys: user.keys, value: pinController.text);
                await _databaseHelper.updateDbenty(updatedUser);
                _getDbentyList();
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
      await _databaseHelper.deleteEnty(userId);
      _getDbentyList();
    }
  }
}
