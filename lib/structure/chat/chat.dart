import 'package:ingrif_app/structure/user.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/chat/message.dart';

class Chat {
  User _user;
  int _id;
  Section _section;
  List<User> _allUsers;
  List<Message> _allMessages;
  ChatType _type;

  Chat(User user, Section section) {
    this._user = user;
    this._section = section;
  }

  User getUser() {
    return _user;
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