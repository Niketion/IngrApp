import 'dart:async';
import 'package:ingrif_app/lib/callback.dart';
import 'package:mysql1/mysql1.dart';

final String host = "10.0.2.2";
final String password = "root";
final int port = 3306;
final String user = "root";
final String database = "ingrif_app";

class MySQL {
  MySqlConnection conn;

  MySQL();

  Future<MySqlConnection> connect() async {
    MySqlConnection tempConn;
    await MySqlConnection.connect(getDatabaseSettings(false)).then((value) async {
      this.conn = value;
      tempConn = conn;
      await _createTables();
    });
    return tempConn;
  }

  Future<dynamic> _createTables() async {
    await conn.query("CREATE TABLE IF NOT EXISTS `"+"users"+"` ("
        "`id` INT, "
        "`vip` varchar(5), "
        "`verified` varchar(5), "
        "`email` varchar(100), "
        "`bio` varchar(200), "
        "`username` varchar(24), "
        "`password` varchar(512), "
        "`lang` varchar(25))");
    await conn.query("CREATE TABLE IF NOT EXISTS `chats` ("
        "`id` INT, "
        "`users` TEXT, "
        "`section` TEXT, "
        "`messages` LONGTEXT)");
  }

  MySqlConnection getConnection() {
    MySqlConnection tempConn = conn;
    while(tempConn == null){
      new Future.delayed(const Duration(milliseconds: 250), () => "1").then((e) {
        tempConn = conn;
      });
    }
    return tempConn;
  }
}

ConnectionSettings getDatabaseSettings(bool pass) {
  if (pass) {
    return new ConnectionSettings(host: host,
        port: 3306,
        user: user,
        password: password,
        db: database);
  }
  return new ConnectionSettings(
      host: host,
      port: 3306,
      user: user,
      db: database
  );
}

