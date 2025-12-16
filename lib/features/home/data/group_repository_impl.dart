import 'dart:async';
import 'group_repository.dart';
import '../domain/entities/group.dart';
import '../domain/entities/member.dart';

/// Dummy implementation — replace with real network/backend calls later.
class GroupRepositoryImpl implements GroupRepository {
  @override
  Future<Group> fetchGroupById(String id) async {
    // In real implementation, use an HTTP client (dio/http) to fetch by id.
    await Future.delayed(const Duration(milliseconds: 300));
    return Group.dummy(id);
  }

  @override
  Future<Group> fetchGroupByName(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Group.dummy(name);
  }
}
