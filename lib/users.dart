
library users;

import 'db.dart';

import 'webframe.dart';
import 'package:principal/principal.dart';
import 'package:signals/signals.dart';


class Requirements {
  static final ADMIN = new Requirement('admin');
  static final USER = new Requirement('user');
  static final NOBODY = new Requirement('nobody');
}


class Permissions {
  static final ADMIN = new Permission(Requirements.ADMIN);
  static final USER = new Permission(Requirements.USER);
}

class User {
}



class AnonymousUser extends Identity {
  AnonymousUser() : super('nobody');
}

class AdminUser extends Identity {
  AdminUser() : super('admin');
}





class UsersExtension {


  setup(Webframe app) {
    app.onRoundTrip.on(whoIs);
  }

  whoIs(RoundTrip r) {
    print(r.request.session());
  }

}
