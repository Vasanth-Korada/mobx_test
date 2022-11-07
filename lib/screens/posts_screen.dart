import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_learn/stores/post_store.dart';

import '../models/post_model.dart';

class PostsList extends StatelessWidget {
  PostStore store = PostStore();

  PostsList() {
    store.getThePosts();
  }

  @override
  Widget build(BuildContext context) {
    final future = store.postsListFuture;

    return Observer(
      builder: (_) {
        switch (future!.status) {
          case FutureStatus.pending:
            return const Center(
              child: CircularProgressIndicator(),
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
          case FutureStatus.fulfilled:
            final List<Post> posts = future.result;
            print(posts);
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ExpansionTile(
                    title: Text(
                      post.title!,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    children: <Widget>[Text(post.body!)],
                  );
                },
              ),
            );
        }
      },
    );
  }

  Future _refresh() => store.fetchPosts();
}
