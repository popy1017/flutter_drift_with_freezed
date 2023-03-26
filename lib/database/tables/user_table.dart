import 'package:drift/drift.dart';

import '../../models/user.dart';

@UseRowClass(User)
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get birthday => dateTime()();
}
