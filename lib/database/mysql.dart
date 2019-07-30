import 'dart:async';
import 'package:mysql1/mysql1.dart';

final String host = "10.0.2.2";
final String password = "root";
final int port = 3306;
final String user = "root";
final String database = "ingrif_app";

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

Future<MySqlConnection> usersDatabase() async {
  return MySqlConnection.connect(getDatabaseSettings(false)).then((conn) {
    return conn.query("CREATE TABLE IF NOT EXISTS `"+"users"+"` ("
        "`id` INT, "
        "`vip` varchar(5), "
        "`verified` varchar(5), "
        "`email` varchar(100), "
        "`bio` varchar(200), "
        "`username` varchar(24), "
        "`password` varchar(512), "
        "`lang` varchar(25))").then((ignored) {
      return conn;
    });
  });
}

Future<MySqlConnection> chatDatabase() async {
  return MySqlConnection.connect(getDatabaseSettings(false)).then((conn) {
    return conn.query("CREATE TABLE IF NOT EXISTS `"+"chats"+"` ("
        "`id` INT, "
        "`users` TEXT, "
        "`messages` LONGTEXT").then((ignored) {
      return conn;
    });
  });
}
