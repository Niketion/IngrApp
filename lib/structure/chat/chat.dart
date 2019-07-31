import 'package:ingrif_app/structure/user.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/chat/message.dart';

class Chat {
  List<User> _users;
  int _id;
  Section _section;
  List<Message> _allMessages;
  ChatType _type;

  Chat({List<User> users, Section section, int chatID}) {
    this._users = users;
    this._section = section;
    this._id = chatID;
  }

  List<User> getChatUsers() {
    return _users;
  }

  Section getSection() {
    return _section;
  }

  ChatType getChatType() {
    return _type;
  }

  int getChatID() {
    return _id;
  }

  static void createChat(List<User> users, ChatType chatType) {

  }
}

enum ChatType {
  GROUP, PRIVATE
}