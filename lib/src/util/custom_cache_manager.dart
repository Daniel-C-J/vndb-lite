import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:file/local.dart';
import 'package:file/file.dart' hide FileSystem;
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart' as c;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class IOFileSystem implements c.FileSystem {
  final Future<Directory> _fileDir;
  final String _cacheKey;

  IOFileSystem(this._cacheKey) : _fileDir = createDirectory(_cacheKey);

  static Future<Directory> createDirectory(String key) async {
    // Use documents directory instead of temp directory.
    var baseDir = await getApplicationDocumentsDirectory();
    var path = p.join(baseDir.path, key);

    var fs = const LocalFileSystem();
    var directory = fs.directory((path));
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<File> createFile(String name) async {
    final directory = await _fileDir;
    if (!(await directory.exists())) {
      await createDirectory(_cacheKey);
    }
    return directory.childFile(name);
  }
}

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const String key = "vndb_lite_cache";

  CustomCacheManager()
      : super(Config(
          key,
          fileSystem: IOFileSystem(key),
        ));
}
