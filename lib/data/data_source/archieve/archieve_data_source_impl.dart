import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/data_source/archieve/archieve_data_source.dart';
import 'package:todo/data/database/db_sheme.dart';
import 'package:todo/data/model/archieve/archieve_db.dart';

class ArchieveDataSourceImpl implements ArchieveDataSource {
  @override
  Box<ArchieveModel> getDatabase() =>
      Hive.box<ArchieveModel>(DbScheme.archieve);

  @override
  Future<void> save(ArchieveModel model) async =>
      await Hive.box<ArchieveModel>(DbScheme.archieve).add(model);

  @override
  Future<void> delete(int index) async =>
      await Hive.box<ArchieveModel>(DbScheme.archieve).deleteAt(index);
}
