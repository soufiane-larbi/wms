import 'package:mysql1/mysql1.dart';

class UserType {
  String? firstname, lastname, username, password;
  DateTime? creationDate, modifiedDate;
  Blob? profile;
  bool? admin;

  UserType({
    this.firstname,
    this.lastname,
    this.username,
    this.password,
    this.profile,
    this.creationDate,
    this.modifiedDate,
    this.admin,
  });
}
