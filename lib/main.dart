import 'package:flutter/material.dart';
import 'package:flutter_drift_with_freezed/database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart';

final dbProvider = Provider<Database>((_) => Database());

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: db.select(db.users).watch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index].name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      (db.delete(db.users)
                            ..where((tbl) => tbl.id.equals(users[index].id)))
                          .go();
                    },
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          db.into(db.users).insert(UsersCompanion.insert(
              name: Faker().internet.userName(), birthday: DateTime.now()));
        },
      ),
    );
  }
}
