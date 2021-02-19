import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_managements/module/plant.dart';
import 'package:stock_managements/module/product.dart';


class ManagementDao {

  final String API_KEY = "USE YOUR KEY";
  final String BASE_URL = "https://trefle.io/api/v1/species";


  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'stock_management.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database database, int version) async {
    await database.execute("drop table Product");
    await database.execute("CREATE TABLE IF NOT EXISTS Product ("
        "id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,"
        "name TEXT,"
        "price double,"
        "image TEXT,"
        "quantity INTEGER"
        ")");
  }

      Future<int> insert(String name,double price,String image,int qt) async {
        var database=await openDatabase('stock_management.db');


        var result = await database.rawInsert(
            "INSERT INTO Product (name, price, quantity,image)"
                " VALUES ($name,$price,$qt,$image)");
        database.close();
        return result;
      }



  Future<Product> getProduct(int id) async {
    var database=await openDatabase('stock_management.db');
    List<Map> results = await database.query("Product",
        columns: ["id", "name", "price","quantity", "image"],
        where: 'id = ?',
        whereArgs: [id]);

    if (results.length > 0) {
    print(results);
      return new Product.fromMap(results.first);
    }


    return null;
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    var database=await openDatabase('stock_management.db');
      return await database.query(table);
    }
    void getAldl() async{
      var database=await openDatabase('stock_management.db');
      var records= await database.query("Product");

      List<Product> list =
      records.isNotEmpty ? records.map((c) => Product.fromMap(c)).toList() : [];



    }


    getAll() async{
      var database=await openDatabase('stock_management.db');
      var records= await database.query("Product");

      List<Product> list =
      records.isNotEmpty ? records.map((c) => Product.fromMap(c)).toList() : [];
      return list;
    }

  Future<int> updatePQty(int id) async {
    var database=await openDatabase('stock_management.db');
    return await database.rawUpdate(
        'UPDATE Product SET quantity = quantity-1 WHERE id = $id'
    );
  }

  getSavePlanetData(int pageNumber,int pageSize) async {

    final url = "${BASE_URL}?token=$API_KEY&page=$pageNumber&size=$pageSize";
    List<Plant> list;
  print(url);
    try {

      var response = await  http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        var data = json.decode(response.body);

        var rest = data["data"] as List;

        list = rest.map<Plant>((json) => Plant.fromJson(json)).toList();
        return list;

      } else {
        print("Failed http call."); // Perhaps handle it somehow
      }
    } catch (exception) {
      print(exception.toString());
    }
    return null;

  }

//
  // static final _databaseName = "stock_management.db";
  // static final _databaseVersion = 1;
  //
  // static final table = 'products';
  //
  // static final columnId = '_id';
  // static final columnName = 'name';
  // static final columnPrice = 'price';
  // static final columnQnt = 'quantity';
  //
  //
  // // make this a singleton class
  // ManagementDao._privateConstructor();
  // static final ManagementDao instance = ManagementDao._privateConstructor();
  //
  // // only have a single app-wide reference to the database
  // static Database _database;
  // Future<Database> get database async {
  //   if (_database != null) return _database;
  //   // lazily instantiate the db the first time it is accessed
  //   _database = await _initDatabase();
  //   return _database;
  // }
  //
  // // this opens the database (and creates it if it doesn't exist)
  // _initDatabase() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, _databaseName);
  //   return await openDatabase(path,
  //       version: _databaseVersion,
  //       onCreate: _onCreate);
  // }
  //
  // // SQL code to create the database table
  // Future _onCreate(Database db, int version) async {
  //   await db.execute('''
  //         CREATE TABLE $table (
  //           $columnId INTEGER PRIMARY KEY,
  //           $columnName TEXT NOT NULL,
  //           $columnPrice FLOAT NOT NULL,
  //           $columnQnt TEXT NOT NULL
  //         )
  //         ''');
  // }
  //
  // // Helper methods
  //
  // // Inserts a row in the database where each key in the Map is a column name
  // // and the value is the column value. The return value is the id of the
  // // inserted row.
  // Future<int> insert(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   return await db.insert(table, row);
  // }
  //
  // // All of the rows are returned as a list of maps, where each map is
  // // a key-value list of columns.
  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   Database db = await instance.database;
  //   return await db.query(table);
  // }
  //
  // // All of the methods (insert, query, update, delete) can also be done using
  // // raw SQL commands. This method uses a raw query to give the row count.
  // Future<int> queryRowCount() async {
  //   Database db = await instance.database;
  //   return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  // }
  //
  // // We are assuming here that the id column in the map is set. The other
  // // column values will be used to update the row.
  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   int id = row[columnId];
  //   return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  // }
  //
  // // Deletes the row specified by the id. The number of affected rows is
  // // returned. This should be 1 as long as the row exists.
  // Future<int> delete(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  // }
}