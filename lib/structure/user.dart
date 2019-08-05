import 'dart:async';
import 'package:ingrif_app/database/mysql.dart';
import 'package:crypt/crypt.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/lang.dart';
import 'package:ingrif_app/structure/chat/chat.dart';
import '../main.dart';
import 'characteristic.dart';

class User {
  /// number of data's user elaborated, if is equal to UserType#values (- ID and EMAIL)
  /// the system has elaborated all data of [User]
  int _dataElaborated=0;
  int _id;
  bool _vip;
  bool _verified;
  //Image _avatar;
  String _email;
  String _bio;
  /// Username must be a maximum of 24 characters, alphanumeric and "_"
  String _username;
  //TODO: LANGUAGE
  //Locale _language;
  /// Password encrypted in SHA256 of [Crypt]
  String _password;
  LangManager _lang;
  //TODO: LOCATION
  //Location _location;

  /// User's class of IngrifApp
  User(int id, String email) {
    if (id==null) {
      this._email = email;
      _getValueDatabase("id").then((result) {
        this._id = result;
      });
    } else if (email== null) {
      this._id = id;
      _getValueDatabase("email").then((result) {
        this._email = result;
      });
    } else {
      this._id = id;
      this._email = email;
    }

    for (UserType types in UserType.values) {
      if (types==UserType.ID || types==UserType.EMAIL) {
        continue;
      }
      _getValueDatabase(UserTypeManager(types).name().toLowerCase()).then((result) {
        switch (types) {
          case UserType.EMAIL:
            this._email = result;
            _dataElaborated++;
            break;
          case UserType.VIP:
            this._vip = bool.fromEnvironment(result);
            _dataElaborated++;
            break;
          case UserType.VERIFIED:
            this._verified = bool.fromEnvironment(result);
            _dataElaborated++;
            break;
          case UserType.LANG:
            this._lang = LangManager(LangManager.fromString(result));
            _dataElaborated++;
            break;
          case UserType.USERNAME:
            this._username = result;
            _dataElaborated++;
            break;
          case UserType.PASSWORD:
            this._password = result;
            _dataElaborated++;
            break;
          case UserType.BIO:
            this._bio = result;
            _dataElaborated++;
            break;
          default:
            break;
        }
      });
    }
  }

  /// Create new user with [email], or get user that already exist
  ///
  /// return the [User] created
  static Future<User> newUser(String email, String username, String password, LangManager lang) async {
    User user;
    await exist(email: email).then((result) async {
      if (result) {
        await User.fromEmail(email).then((resultUser) async {
          user = resultUser;
        });
      }
    });

    if (user!=null) {
      return user;
    }


      int id;
      await _getUsersRegistered().then((number) {
        id = number+1;
      });
      await getDatabase().query(
          'insert into `users` (id, vip, verified, email, bio, username, password, lang) values (?, ?, ?, ?, ?, ?, ?, ?)',
          [
            id,
            'false',
            'false',
            email,
            'Hey!',
            username,
            Crypt.sha256(password),
            lang.name()
          ]).whenComplete(() async {
        //TODO: SISTEMA DI ID
        await _getUsersRegistered().then((usersNumber) async {
          User tempUser = new User(usersNumber+1, email);
          while (tempUser._dataElaborated<UserType.values.length-3) {
            await new Future.delayed(const Duration(milliseconds: 250), () => "1").then((e) {
              user=tempUser;
            });
          }
        });
      });

    return user;
  }

  /// Get value with column [string] on database
  /// check if [User] was instanced with email or/and id
  /// and with email/id get the row
  ///
  /// return [Object] that requested
  Future<Object> _getValueDatabase(String string) async {
    var choose;
    Object theReturn;
    bool isEmail = false;
    if (_email == null) {
      choose = _id;
    } else {
      choose = _email;
      isEmail = true;
    }

    if (isEmail) {
      await exist(email: choose).then((exist) async {
        if (exist) {

            await getDatabase().query("SELECT " + string.toLowerCase() + " FROM users WHERE "
                +  "email='" + choose.toString() + "'").then((result) async {
              for (var user in result) {
                theReturn = user[0];
              }
            });
        }
      });
    } else {
      await exist(id: choose).then((exist) async {
        if (exist) {
            await getDatabase().query("SELECT " + string.toLowerCase() + " FROM users WHERE "
                +  "id=" + choose.toString()).then((result) async {
              for (var user in result) {
                theReturn = user[0];
              }
            });
        }
      });
    }
    return theReturn;
  }

  static Future<int> _getUsersRegistered() async {
    int number;

      await getDatabase().query("SELECT COUNT(*) FROM users").then((result) async {
        for (var numbers in result) {
          number = numbers[0];
        }
      });
    return number;
  }

  //TODO: LISTA CHAT
  List<Chat> getChats(Section section) {
    return List();
  }

  /// Get [User] from id
  /// (system doesn't check if [id] has a [User] associated)
  ///
  /// return [User] requested;
  static Future<User> fromID(int id) async {
    User user;
    await exist(id: id).then((result) async {
      if (!result) {
        new Exception("User not found");
      }
    });

      await getDatabase().query("SELECT * FROM users WHERE id=" + id.toString()).then((result) async {
        for (var userData in result) {
          User tempUser = new User(id, userData[3]);
          while (tempUser._dataElaborated<UserType.values.length-3) {
            await new Future.delayed(const Duration(milliseconds: 250), () => "1").then((e) {
              user=tempUser;
            });
          }
        }
      });

    return user;
  }

  /// Get [User] from email
  /// (system doesn't check if [email] has a [User] associated)
  ///
  /// return [User] requested;
  static Future<User> fromEmail(String email) async {
    User user;
    await exist(email: email).then((result) async {
      if (!result) {
        new Exception("User not found");
      }
    });

      await getDatabase().query("SELECT * FROM users WHERE email='" + email + "'").then((result) async {
        for (var userData in result) {
          User tempUser = new User(userData[0], email);
          while (tempUser._dataElaborated<UserType.values.length-3) {
            await new Future.delayed(const Duration(milliseconds: 250), () => "1").then((e) {
              user=tempUser;
            });
          }
        }
      });

    return user;
  }

  /// Check if user's database contains
  /// row with [email] or [id] declared
  ///
  /// return [bool] true if exist
  static Future<bool> exist({String email, int id}) async {
    bool exist=false;

    await getDatabase().query(
        "SELECT * FROM users WHERE " + (email == null ? "id" : "email") +
            "="+(email == null ? "" : "'") + (email == null ? id.toString() : email) + (email == null ? "" : "'")).then((result) {
              if (result.length > 0) {
                exist=true;
              }
            });

    return exist;
  }

  int getID() {
    return _id;
  }

  String getEmail() {
    return _email;
  }

  bool isVip() {
    return _vip;
  }

  bool isVerified() {
    return _verified;
  }

  String getBio() {
    return _bio;
  }

  String getPassword() {
    return _password;
  }

  String getUsername()  {
    return _username;
  }

  //TODO: CHAR
  Characteristic get characteristic {
    return new Characteristic(this);
  }

  Lang getLang() {
    return _lang.getEnum();
  }
}

enum UserType {
  EMAIL, VIP, VERIFIED, ID, LANG, USERNAME, PASSWORD, BIO
}

class UserTypeManager {
  UserType _userType;

  UserTypeManager(UserType userType) {
    this._userType = userType;
  }

  String name() {
    return _userType.toString().substring(_userType.toString().indexOf('.')+1);
  }

  UserType getEnum() {
    return _userType;
  }

  static UserType fromString(String string) {
    for(UserType types in UserType.values) {
      if (string.toUpperCase() == new UserTypeManager(types).name()) {
        return new UserTypeManager(types).getEnum();
      }
    }
    return null;
  }
}