import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_learn/models/user_model.dart';
import 'package:mobx_learn/stores/user_store.dart';

class UserList extends StatelessWidget {
  UserStore store = UserStore();

  UserList() {
    store.getTheUsers();
  }

  @override
  Widget build(BuildContext context) {
    final future = store.userListFuture;
    return Observer(
      builder: (_) {
        switch (future!.status) {
          case FutureStatus.pending:
            return Center(
              child: CircularProgressIndicator(),
            );
          case FutureStatus.fulfilled:
            final List<User> users = future.result;
            print(users);
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar!),
                      radius: 25,
                    ),
                    title: Text(
                      user.name!,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      user.email!,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      user.followers.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  );
                },
              ),
            );
          case FutureStatus.rejected:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Failed to load items.',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    child: Text('Tap to retry'),
                    onPressed: _refresh,
                  )
                ],
              ),
            );
        }
      },
    );
  }

  Future _refresh() => store.fetchUsers();
}
