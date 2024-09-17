import 'package:hive/hive.dart';

part 'parent_group.g.dart';

@HiveType(typeId: 7)
class ParentGroup extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String schoolName;

  ParentGroup({required this.name, required this.schoolName});
}
