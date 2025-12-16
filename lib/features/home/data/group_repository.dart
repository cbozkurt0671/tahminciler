import '../domain/entities/group.dart';

abstract class GroupRepository {
  /// Fetch group by its id (from backend)
  Future<Group> fetchGroupById(String id);

  /// Fetch group by name (convenience for this demo)
  Future<Group> fetchGroupByName(String name);
}
