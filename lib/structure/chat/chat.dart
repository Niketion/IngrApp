import 'dart:async';
import 'dart:collection';

import 'package:ingrif_app/lib/callback.dart';
import 'package:ingrif_app/structure/user.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/chat/message.dart';
import 'package:ingrif_app/database/mysql.dart';

import '../../main.dart';

class Chat {
  List<User> _users;
  int _id;
  Section _section;
  HashMap _messages;

  @Deprecated("createChat")
  Chat(List<User> users, Section section) {
    this._users = users;
    this._section = section;
    this._messages = new HashMap<int, Message>();
  }

  List<User> getChatUsers() {
    return _users;
  }

  Section getSection() {
    return _section;
  }

  void setChatID(int id) {
    this._id = id;
  }

  int getChatID() {
    return _id;
  }

  Chat getChat() {
    return this;
  }

  List<User> getUsers() {
    return _users;
  }

  static Future<Chat> createChat(List<User> users, Section section) async {
      List listID = new List<int>();
      users.forEach((allUser) => listID.add(allUser.getID()));

      int id;
      await _getChats().then((value) => id = value);
      id++;
      await getDatabase().query('insert into `chats` (id, users, section, messages) values (?, ?, ?, ?)',
          [
            id,
            listID.toString(),
            section.toString(),
            ""
          ]);
      Chat chat = new Chat(users, section);
      chat.setChatID(id);
      return chat;
  }

  Message getMessage(int index) {
    return _messages[index];
  }

  void createMessage(MessageType type, User whoSent, String encode) {
    int maxIndex=0;
    _messages.keys.toList().forEach((integer) {
      if (integer>maxIndex) {
        maxIndex = integer;
      }
    });
    maxIndex++;
    _messages[maxIndex] = new Message(this, type, whoSent, encode);

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