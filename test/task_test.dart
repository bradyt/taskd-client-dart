import 'dart:convert';
import 'dart:math';

import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:taskc/taskc.dart';

void main() {
  group('Test task objects', () {
    var unixEpoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    test('test parsing simple json task', () {
      var simpleTask = Task(
        status: 'pending',
        uuid: Uuid().v1(),
        entry: unixEpoch,
        description: 'test',
        tags: const [],
        annotations: const [],
        udas: const {},
      );

      expect(
        Task.fromJson(json.decode(json.encode(simpleTask.toJson()))),
        simpleTask,
      );
    });

    test('test parsing complex json task', () {
      var complexTask = Task(
        status: 'pending',
        uuid: Uuid().v1(),
        entry: unixEpoch,
        description: 'test',
        start: unixEpoch,
        end: unixEpoch,
        due: unixEpoch,
        until: unixEpoch,
        wait: unixEpoch,
        modified: unixEpoch,
        scheduled: unixEpoch,
        recur: 'yearly',
        mask: '--',
        // ignore: avoid_as
        imask: Random().nextInt(pow(2, 32) as int),
        parent: Uuid().v1(),
        project: 'some_project',
        priority: 'H',
        depends: Uuid().v1(),
        tags: const ['+some_tag'],
        annotations: [
          Annotation(
            entry: unixEpoch,
            description: 'some annotation',
          ),
        ],
        udas: const {'estimate': 5},
      );

      expect(
        Task.fromJson(json.decode(json.encode(complexTask.toJson()))),
        complexTask,
      );
    });

    test('test parsing task with uda', () {
      var udaTask = Task(
        status: 'pending',
        uuid: Uuid().v1(),
        entry: unixEpoch,
        description: 'test',
        tags: const [],
        annotations: const [],
        udas: const {'estimate': 4},
      );

      expect(
        Task.fromJson(json.decode(json.encode(udaTask.toJson()))),
        udaTask,
      );
    });
    test('test parsing json string task with tags', () {
        var uuid = Uuid().v1();
      var fromJson = Task.fromJson(json.decode('{'
          '"status":"pending",'
          '"uuid":"$uuid",'
          '"entry":"19700101T000000Z",'
          '"description":"test",'
          '"annotations":[],'
          '"tags":["+foo"]'
          '}'));
      var fromConstructor = Task(
        status: 'pending',
        uuid: uuid,
        entry: unixEpoch,
        description: 'test',
        tags: const ['+foo'],
        annotations: const [],
        udas: const {},
      );
      expect(fromJson, fromConstructor);
    });
  });
}
