
library users;

import 'db.dart';

import 'webframe.dart';
import 'package:principal/principal.dart';
import 'package:signals/signals.dart';


class Requirements {
  static final ADMIN = new Requirement('admin');
}


class User {
}


class AnonymousUser extends Identity {
  AnonymousUser() : super('nobody');
}





class UsersExtension {


  setup(Webframe app) {

  }

  verify(RoundTrip r) {

  }

}
