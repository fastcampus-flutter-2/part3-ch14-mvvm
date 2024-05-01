import 'package:ch14_mvvm_riverpod/model/post_model.dart';
import 'package:ch14_mvvm_riverpod/service/post_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_view_model.g.dart';

final postViewModelProvider = Provider((ref) {
  final service = ref.read(postServiceProvider);
  return PostViewModel(service);
});

final fetchPostsProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(postViewModelProvider).getPosts();
});

final fetchPostsProvider2 = FutureProvider.autoDispose((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get("https://jsonplaceholder.typicode.com/posts");
  if (response.statusCode == 200) {
    List<dynamic> jsonList = response.data;
    List<PostModel> posts =
        jsonList.map((json) => PostModel.fromJson(json)).toList();
    return posts;
  } else {
    return [];
  }
});

class PostViewModel {
  PostServiceImpl? postServiceImpl;

  PostViewModel(this.postServiceImpl);

  Future<List<PostModel>?> getPosts() async {
    try {
      final posts = await postServiceImpl?.getPosts();
      return posts;
    } on DioException catch (e) {
      print(e.toString());
    }
  }
}

final asyncPostNotifier =
    AsyncNotifierProvider<AsyncPostNotifier, List<PostModel>>(
        AsyncPostNotifier.new);

class AsyncPostNotifier extends AsyncNotifier<List<PostModel>> {
  @override
  FutureOr<List<PostModel>> build() async {
    final dio = ref.read(dioProvider);
    final response =
        await dio.get("https://jsonplaceholder.typicode.com/posts");
    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      List<PostModel> posts =
          jsonList.map((json) => PostModel.fromJson(json)).toList();
      return posts;
    } else {
      return [];
    }
  }

  add() {}

  plus() {}

  remove() {}
}

@riverpod
class AsyncPostsGenNotifier extends _$AsyncPostsGenNotifier {
  _fetchPosts() async {
    Dio dio = Dio();
    final response =
        await dio.get("https://jsonplaceholder.typicode.com/posts");
    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      List<PostModel> posts =
          jsonList.map((json) => PostModel.fromJson(json)).toList();
      return posts;
    } else {
      return [];
    }
  }

  @override
  Future<List<PostModel>> build() async {
    return await _fetchPosts();
  }
}
