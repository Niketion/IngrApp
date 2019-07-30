import 'package:ingrif_app/structure/user.dart';
import 'package:ingrif_app/structure/lang.dart';

void main() {
  String email="e6@9gmail.com";

  User.newUser(email, "niketion", "lol", LangManager(Lang.ITALIAN)).then((user){
    print("2."+user.getUsername());
  });
}
