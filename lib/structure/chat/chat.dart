import 'dart:collection';

import 'package:ingrif_app/structure/user.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/chat/message.dart';
import 'package:ingrif_app/database/mysql.dart';

import '../../main.dart';

class Chat {
  List<User> _users;
  int _id;
  Section _section;
  HashMap _messages = new HashMap<int, Message>();

  Chat();

  List<User> getChatUsers() {
    return _users;
  }

  Section getSection() {
    return _section;
  }

  int getChatID() {
    return _id;
  }

  Chat getChat() {
    return this;
  }

  static void createChat(List<User> users, Section section) async {
      List listID = new List<int>();
      await users.forEach((allUser) => listID.add(allUser.getID()));

      int id;
      await _getChats().then((value) => id = value);
      await getDatabase().query('insert into `chats` (id, users, section, messages) values (?, ?, ?, ?)',
          [
            id,
            listID.toString(),
            section.toString(),
            new HashMap<int, Message>().toString()
          ]);
  }

  static Future<int> _getChats() async {
    int number;
      await getDatabase().query("SELECT COUNT(*) FROM chats").then((result) async {
        for (var numbers in result) {
          number = numbers[0];
        }
      });
    return number;
  }
}