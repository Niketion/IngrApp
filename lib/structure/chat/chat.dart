import 'dart:collection';

import 'package:ingrif_app/structure/user.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/chat/message.dart';

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

  static void createChat(List<User> users, Section section) {

  }
}