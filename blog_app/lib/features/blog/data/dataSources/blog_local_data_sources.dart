import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSources {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSources {
  final Box box;
  BlogLocalDataSourceImpl(this.box);
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        final raw = box.get(i.toString());
        if (raw == null) continue;
        blogs.add(BlogModel.fromJson(Map<String, dynamic>.from(raw as Map)));
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
