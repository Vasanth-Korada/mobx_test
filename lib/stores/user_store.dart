import 'package:mobx/mobx.dart';
import 'package:mobx_learn/models/user_model.dart';
import 'package:mobx_learn/network/network_service.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final NetworkService httpClient = NetworkService();

  @observable
  ObservableFuture<List<User>>? userListFuture;

  @action
  Future fetchUsers() => userListFuture = ObservableFuture(httpClient
      .getData('https://reqres.in/api/users?page=1')
      .then((users) => users));

  void getTheUsers() {
    fetchUsers();
  }
}
