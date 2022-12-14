import 'package:mobx/mobx.dart';
import 'package:mobx_learn/models/post_model.dart';
import 'package:mobx_learn/network/network_service.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  final NetworkService httpClient = NetworkService();

  @observable
  ObservableFuture<List<Post>>? postsListFuture;

  @action
  Future fetchPosts() => postsListFuture = ObservableFuture(httpClient
      .getPosts('https://jsonplaceholder.typicode.com/posts')
      .then((posts) => posts));

  void getThePosts() {
    fetchPosts();
  }
}
