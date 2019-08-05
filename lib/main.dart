import 'package:ingrif_app/structure/chat/chat.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/user.dart';
import 'package:ingrif_app/structure/lang.dart';
import 'package:mysql1/mysql1.dart';

import 'database/mysql.dart';

MySqlConnection database;

void main() async  {
  await new MySQL().connect().then((conn) {
    database = conn;
  });
  List list = List<User>();
  User.newUser("cioescoi", "Djkfw", "a", LangManager(Lang.ITALIAN)).then((user) {
    list.add(user);
    User.newUser("rgreg", "Drvs", "a", LangManager(Lang.ENGLISH)).then((user1) {
      list.add(user1);
      Chat.createChat(list, Section.INCONTRI);
    });
  });
}

MySqlConnection getDatabase() {
  return database;
}
