import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 1)
class Project extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Project({required this.id, required this.name});
}
