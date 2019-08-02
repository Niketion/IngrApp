import 'package:ingrif_app/structure/chat/chat.dart';
import 'package:ingrif_app/structure/user.dart';


class Message extends Chat {
  MessageType _type;
  String _encode;
  User _whoSent;
  bool _viewed;

  Message();

  String parseToJson() {

  }

  Message parseToMessage(String string) {

  }
}

enum MessageType {
  TEXT, IMG, AUDIO, VIDEO
}