import 'package:minhas_financas/Models/Models.dart';
import 'package:minhas_financas/Screens/Financas.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "Minhas_Financas.db";
  static final _databaseVersion = 3;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE usuario (
        usuarioId INTEGER PRIMARY KEY,
        usuario TEXT NOT NULL,
        senha TEXT NOT NULL,
        email TEXT NOT NULL

      )
    """);
    await db.execute("""
        CREATE TABLE carteira (
        carteiraId INTEGER PRIMARY KEY,
        usuarioId INTEGER NOT NULL,
        senha TEXT NOT NULL,
        total TEXT NOT NULL

      )
    """);
    await db.execute("""
        CREATE TABLE item (
        itemId INTEGER PRIMARY KEY,
        mes TEXT NOT NULL,
        descricao TEXT NOT NULL,
        valor TEXT NOT NULL,
        usuarioId INTEGER NOT NULL,
        carteiraId INTEGER ,
        subtotal TEXT NOT NULL,
        data TEXT NOT NULL,
        parcela INTEGER NOT NULL,
        origem TEXT NOT NULL

      )
    """);
  }

  // Adicione métodos para inserir, consultar e atualizar registros aqui.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(model_usuario.table, row);
  }

  Future<int> insertItem(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(model_Item.table, row);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(model_Item.table, where: 'itemId = ?', whereArgs: [id]);
  }
  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   Database db = await instance.database;
  //   return await db.query(table);
  // }

  // Todos os métodos : inserir, consultar, atualizar e excluir,
  // também podem ser feitos usando  comandos SQL brutos.
  // Esse método usa uma consulta bruta para fornecer a contagem de linhas.
  // Future<int?> queryRowCount() async {
  //   Database db = await instance.database;
  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM $table'));
  // }

  // Assumimos aqui que a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   int id = row[columnId];
  //   return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Exclui a linha especificada pelo id. O número de linhas afetadas é
  // retornada. Isso deve ser igual a 1, contanto que a linha exista.
  // Future<int> delete(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  // }

  Future<int?> obterIdUsuario() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM usuario'));
  }

  Future<int?> obterIdCarteira() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM carteira'));
  }

  Future<int?> obterIdItem() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM item'));
  }

  Future<List<Map<String, dynamic>>> obterUsuario(String a_Nome) async {
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT usuario FROM usuario where usuario == $a_Nome');
  }

  // Future<model_usuario> Logar(String a_Nome, String a_Senha) async {
  //   Database db = await instance.database;
  //   model_usuario result = model_usuario.usuarioToMap(await db.rawQuery(
  //       'SELECT id FROM usuario where usuario = ? and senha = ?',
  //       [a_Nome, a_Senha]));

  //   return result;
  //   // return await db.rawQuery(
  //   //     'SELECT id FROM usuario where usuario = ? and senha = ?',
  //   //     [a_Nome, a_Senha]);
  // }

  Future<model_usuario> getUsuario(String a_Nome, String a_Senha) async {
    Database db = await instance.database;
    final maps = await db!.query('usuario',
        where: 'usuario = ? and senha = ?', whereArgs: [a_Nome, a_Senha]);
    return await model_usuario.fromMap(maps[0]);
  }

  Future<Iterable<model_usuario>> getProfile() async {
    final db = await database;
    final List<Map<String, Object?>> queryResult = await db!.query('usuario');
    return await queryResult.map((e) => model_usuario.fromMap(e));
  }

  Future<Iterable<FinancialData>> getItensPorUsuarioId(int a_UsuarioId) async {
    final db = await database;
    final List<Map<String, Object?>> queryResult = await db!
        .query('item', where: 'usuarioId = ?', whereArgs: [a_UsuarioId]);
    return await queryResult.map((e) => FinancialData.fromMap(e));
  }
}
