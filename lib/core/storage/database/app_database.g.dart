// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AssistCacheEntriesTable extends AssistCacheEntries
    with TableInfo<$AssistCacheEntriesTable, AssistCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssistCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _affKeyMeta = const VerificationMeta('affKey');
  @override
  late final GeneratedColumn<String> affKey = GeneratedColumn<String>(
    'aff_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    affKey,
    status,
    rawJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assist_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssistCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('aff_key')) {
      context.handle(
        _affKeyMeta,
        affKey.isAcceptableOrUnknown(data['aff_key']!, _affKeyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssistCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssistCacheEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      affKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aff_key'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AssistCacheEntriesTable createAlias(String alias) {
    return $AssistCacheEntriesTable(attachedDatabase, alias);
  }
}

class AssistCacheEntry extends DataClass
    implements Insertable<AssistCacheEntry> {
  final String id;
  final String? affKey;
  final String status;
  final String rawJson;
  final DateTime updatedAt;
  const AssistCacheEntry({
    required this.id,
    this.affKey,
    required this.status,
    required this.rawJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || affKey != null) {
      map['aff_key'] = Variable<String>(affKey);
    }
    map['status'] = Variable<String>(status);
    map['raw_json'] = Variable<String>(rawJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AssistCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return AssistCacheEntriesCompanion(
      id: Value(id),
      affKey: affKey == null && nullToAbsent
          ? const Value.absent()
          : Value(affKey),
      status: Value(status),
      rawJson: Value(rawJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssistCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssistCacheEntry(
      id: serializer.fromJson<String>(json['id']),
      affKey: serializer.fromJson<String?>(json['affKey']),
      status: serializer.fromJson<String>(json['status']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'affKey': serializer.toJson<String?>(affKey),
      'status': serializer.toJson<String>(status),
      'rawJson': serializer.toJson<String>(rawJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AssistCacheEntry copyWith({
    String? id,
    Value<String?> affKey = const Value.absent(),
    String? status,
    String? rawJson,
    DateTime? updatedAt,
  }) => AssistCacheEntry(
    id: id ?? this.id,
    affKey: affKey.present ? affKey.value : this.affKey,
    status: status ?? this.status,
    rawJson: rawJson ?? this.rawJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssistCacheEntry copyWithCompanion(AssistCacheEntriesCompanion data) {
    return AssistCacheEntry(
      id: data.id.present ? data.id.value : this.id,
      affKey: data.affKey.present ? data.affKey.value : this.affKey,
      status: data.status.present ? data.status.value : this.status,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssistCacheEntry(')
          ..write('id: $id, ')
          ..write('affKey: $affKey, ')
          ..write('status: $status, ')
          ..write('rawJson: $rawJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, affKey, status, rawJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssistCacheEntry &&
          other.id == this.id &&
          other.affKey == this.affKey &&
          other.status == this.status &&
          other.rawJson == this.rawJson &&
          other.updatedAt == this.updatedAt);
}

class AssistCacheEntriesCompanion extends UpdateCompanion<AssistCacheEntry> {
  final Value<String> id;
  final Value<String?> affKey;
  final Value<String> status;
  final Value<String> rawJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AssistCacheEntriesCompanion({
    this.id = const Value.absent(),
    this.affKey = const Value.absent(),
    this.status = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssistCacheEntriesCompanion.insert({
    required String id,
    this.affKey = const Value.absent(),
    this.status = const Value.absent(),
    required String rawJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawJson = Value(rawJson),
       updatedAt = Value(updatedAt);
  static Insertable<AssistCacheEntry> custom({
    Expression<String>? id,
    Expression<String>? affKey,
    Expression<String>? status,
    Expression<String>? rawJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (affKey != null) 'aff_key': affKey,
      if (status != null) 'status': status,
      if (rawJson != null) 'raw_json': rawJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssistCacheEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? affKey,
    Value<String>? status,
    Value<String>? rawJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AssistCacheEntriesCompanion(
      id: id ?? this.id,
      affKey: affKey ?? this.affKey,
      status: status ?? this.status,
      rawJson: rawJson ?? this.rawJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (affKey.present) {
      map['aff_key'] = Variable<String>(affKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssistCacheEntriesCompanion(')
          ..write('id: $id, ')
          ..write('affKey: $affKey, ')
          ..write('status: $status, ')
          ..write('rawJson: $rawJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoordinateEntriesTable extends CoordinateEntries
    with TableInfo<$CoordinateEntriesTable, CoordinateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoordinateEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _assistanceIdMeta = const VerificationMeta(
    'assistanceId',
  );
  @override
  late final GeneratedColumn<String> assistanceId = GeneratedColumn<String>(
    'assistance_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('provider'),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assistanceId,
    latitude,
    longitude,
    sender,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coordinate_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoordinateEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('assistance_id')) {
      context.handle(
        _assistanceIdMeta,
        assistanceId.isAcceptableOrUnknown(
          data['assistance_id']!,
          _assistanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assistanceIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoordinateEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoordinateEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      assistanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assistance_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $CoordinateEntriesTable createAlias(String alias) {
    return $CoordinateEntriesTable(attachedDatabase, alias);
  }
}

class CoordinateEntry extends DataClass implements Insertable<CoordinateEntry> {
  final int id;
  final String assistanceId;
  final double latitude;
  final double longitude;
  final String sender;
  final DateTime recordedAt;
  const CoordinateEntry({
    required this.id,
    required this.assistanceId,
    required this.latitude,
    required this.longitude,
    required this.sender,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['assistance_id'] = Variable<String>(assistanceId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['sender'] = Variable<String>(sender);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  CoordinateEntriesCompanion toCompanion(bool nullToAbsent) {
    return CoordinateEntriesCompanion(
      id: Value(id),
      assistanceId: Value(assistanceId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      sender: Value(sender),
      recordedAt: Value(recordedAt),
    );
  }

  factory CoordinateEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoordinateEntry(
      id: serializer.fromJson<int>(json['id']),
      assistanceId: serializer.fromJson<String>(json['assistanceId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      sender: serializer.fromJson<String>(json['sender']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assistanceId': serializer.toJson<String>(assistanceId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'sender': serializer.toJson<String>(sender),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  CoordinateEntry copyWith({
    int? id,
    String? assistanceId,
    double? latitude,
    double? longitude,
    String? sender,
    DateTime? recordedAt,
  }) => CoordinateEntry(
    id: id ?? this.id,
    assistanceId: assistanceId ?? this.assistanceId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    sender: sender ?? this.sender,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  CoordinateEntry copyWithCompanion(CoordinateEntriesCompanion data) {
    return CoordinateEntry(
      id: data.id.present ? data.id.value : this.id,
      assistanceId: data.assistanceId.present
          ? data.assistanceId.value
          : this.assistanceId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      sender: data.sender.present ? data.sender.value : this.sender,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoordinateEntry(')
          ..write('id: $id, ')
          ..write('assistanceId: $assistanceId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('sender: $sender, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, assistanceId, latitude, longitude, sender, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoordinateEntry &&
          other.id == this.id &&
          other.assistanceId == this.assistanceId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.sender == this.sender &&
          other.recordedAt == this.recordedAt);
}

class CoordinateEntriesCompanion extends UpdateCompanion<CoordinateEntry> {
  final Value<int> id;
  final Value<String> assistanceId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> sender;
  final Value<DateTime> recordedAt;
  const CoordinateEntriesCompanion({
    this.id = const Value.absent(),
    this.assistanceId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.sender = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  CoordinateEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String assistanceId,
    required double latitude,
    required double longitude,
    this.sender = const Value.absent(),
    required DateTime recordedAt,
  }) : assistanceId = Value(assistanceId),
       latitude = Value(latitude),
       longitude = Value(longitude),
       recordedAt = Value(recordedAt);
  static Insertable<CoordinateEntry> custom({
    Expression<int>? id,
    Expression<String>? assistanceId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? sender,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assistanceId != null) 'assistance_id': assistanceId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (sender != null) 'sender': sender,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  CoordinateEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? assistanceId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String>? sender,
    Value<DateTime>? recordedAt,
  }) {
    return CoordinateEntriesCompanion(
      id: id ?? this.id,
      assistanceId: assistanceId ?? this.assistanceId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      sender: sender ?? this.sender,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assistanceId.present) {
      map['assistance_id'] = Variable<String>(assistanceId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoordinateEntriesCompanion(')
          ..write('id: $id, ')
          ..write('assistanceId: $assistanceId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('sender: $sender, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatOutboxEntriesTable extends ChatOutboxEntries
    with TableInfo<$ChatOutboxEntriesTable, ChatOutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatOutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _assistanceIdMeta = const VerificationMeta(
    'assistanceId',
  );
  @override
  late final GeneratedColumn<String> assistanceId = GeneratedColumn<String>(
    'assistance_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assistanceId,
    content,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatOutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('assistance_id')) {
      context.handle(
        _assistanceIdMeta,
        assistanceId.isAcceptableOrUnknown(
          data['assistance_id']!,
          _assistanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assistanceIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatOutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatOutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      assistanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assistance_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChatOutboxEntriesTable createAlias(String alias) {
    return $ChatOutboxEntriesTable(attachedDatabase, alias);
  }
}

class ChatOutboxEntry extends DataClass implements Insertable<ChatOutboxEntry> {
  final int id;
  final String assistanceId;
  final String content;
  final String status;
  final DateTime createdAt;
  const ChatOutboxEntry({
    required this.id,
    required this.assistanceId,
    required this.content,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['assistance_id'] = Variable<String>(assistanceId);
    map['content'] = Variable<String>(content);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChatOutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return ChatOutboxEntriesCompanion(
      id: Value(id),
      assistanceId: Value(assistanceId),
      content: Value(content),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ChatOutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatOutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      assistanceId: serializer.fromJson<String>(json['assistanceId']),
      content: serializer.fromJson<String>(json['content']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assistanceId': serializer.toJson<String>(assistanceId),
      'content': serializer.toJson<String>(content),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChatOutboxEntry copyWith({
    int? id,
    String? assistanceId,
    String? content,
    String? status,
    DateTime? createdAt,
  }) => ChatOutboxEntry(
    id: id ?? this.id,
    assistanceId: assistanceId ?? this.assistanceId,
    content: content ?? this.content,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ChatOutboxEntry copyWithCompanion(ChatOutboxEntriesCompanion data) {
    return ChatOutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      assistanceId: data.assistanceId.present
          ? data.assistanceId.value
          : this.assistanceId,
      content: data.content.present ? data.content.value : this.content,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatOutboxEntry(')
          ..write('id: $id, ')
          ..write('assistanceId: $assistanceId, ')
          ..write('content: $content, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assistanceId, content, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatOutboxEntry &&
          other.id == this.id &&
          other.assistanceId == this.assistanceId &&
          other.content == this.content &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ChatOutboxEntriesCompanion extends UpdateCompanion<ChatOutboxEntry> {
  final Value<int> id;
  final Value<String> assistanceId;
  final Value<String> content;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const ChatOutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.assistanceId = const Value.absent(),
    this.content = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChatOutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String assistanceId,
    required String content,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : assistanceId = Value(assistanceId),
       content = Value(content);
  static Insertable<ChatOutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? assistanceId,
    Expression<String>? content,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assistanceId != null) 'assistance_id': assistanceId,
      if (content != null) 'content': content,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChatOutboxEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? assistanceId,
    Value<String>? content,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return ChatOutboxEntriesCompanion(
      id: id ?? this.id,
      assistanceId: assistanceId ?? this.assistanceId,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assistanceId.present) {
      map['assistance_id'] = Variable<String>(assistanceId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatOutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('assistanceId: $assistanceId, ')
          ..write('content: $content, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationCacheEntriesTable extends NotificationCacheEntries
    with TableInfo<$NotificationCacheEntriesTable, NotificationCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, rawJson, read, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationCacheEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NotificationCacheEntriesTable createAlias(String alias) {
    return $NotificationCacheEntriesTable(attachedDatabase, alias);
  }
}

class NotificationCacheEntry extends DataClass
    implements Insertable<NotificationCacheEntry> {
  final String id;
  final String type;
  final String rawJson;
  final bool read;
  final DateTime createdAt;
  const NotificationCacheEntry({
    required this.id,
    required this.type,
    required this.rawJson,
    required this.read,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['raw_json'] = Variable<String>(rawJson);
    map['read'] = Variable<bool>(read);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotificationCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return NotificationCacheEntriesCompanion(
      id: Value(id),
      type: Value(type),
      rawJson: Value(rawJson),
      read: Value(read),
      createdAt: Value(createdAt),
    );
  }

  factory NotificationCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationCacheEntry(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      read: serializer.fromJson<bool>(json['read']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'rawJson': serializer.toJson<String>(rawJson),
      'read': serializer.toJson<bool>(read),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotificationCacheEntry copyWith({
    String? id,
    String? type,
    String? rawJson,
    bool? read,
    DateTime? createdAt,
  }) => NotificationCacheEntry(
    id: id ?? this.id,
    type: type ?? this.type,
    rawJson: rawJson ?? this.rawJson,
    read: read ?? this.read,
    createdAt: createdAt ?? this.createdAt,
  );
  NotificationCacheEntry copyWithCompanion(
    NotificationCacheEntriesCompanion data,
  ) {
    return NotificationCacheEntry(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      read: data.read.present ? data.read.value : this.read,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationCacheEntry(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('rawJson: $rawJson, ')
          ..write('read: $read, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, rawJson, read, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationCacheEntry &&
          other.id == this.id &&
          other.type == this.type &&
          other.rawJson == this.rawJson &&
          other.read == this.read &&
          other.createdAt == this.createdAt);
}

class NotificationCacheEntriesCompanion
    extends UpdateCompanion<NotificationCacheEntry> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> rawJson;
  final Value<bool> read;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NotificationCacheEntriesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.read = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationCacheEntriesCompanion.insert({
    required String id,
    required String type,
    required String rawJson,
    this.read = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       rawJson = Value(rawJson),
       createdAt = Value(createdAt);
  static Insertable<NotificationCacheEntry> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? rawJson,
    Expression<bool>? read,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (rawJson != null) 'raw_json': rawJson,
      if (read != null) 'read': read,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationCacheEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? rawJson,
    Value<bool>? read,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NotificationCacheEntriesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      rawJson: rawJson ?? this.rawJson,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationCacheEntriesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('rawJson: $rawJson, ')
          ..write('read: $read, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AssistCacheEntriesTable assistCacheEntries =
      $AssistCacheEntriesTable(this);
  late final $CoordinateEntriesTable coordinateEntries =
      $CoordinateEntriesTable(this);
  late final $ChatOutboxEntriesTable chatOutboxEntries =
      $ChatOutboxEntriesTable(this);
  late final $NotificationCacheEntriesTable notificationCacheEntries =
      $NotificationCacheEntriesTable(this);
  late final ChatOutboxDao chatOutboxDao = ChatOutboxDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    assistCacheEntries,
    coordinateEntries,
    chatOutboxEntries,
    notificationCacheEntries,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$AssistCacheEntriesTableCreateCompanionBuilder =
    AssistCacheEntriesCompanion Function({
      required String id,
      Value<String?> affKey,
      Value<String> status,
      required String rawJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AssistCacheEntriesTableUpdateCompanionBuilder =
    AssistCacheEntriesCompanion Function({
      Value<String> id,
      Value<String?> affKey,
      Value<String> status,
      Value<String> rawJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AssistCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AssistCacheEntriesTable> {
  $$AssistCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get affKey => $composableBuilder(
    column: $table.affKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssistCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssistCacheEntriesTable> {
  $$AssistCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get affKey => $composableBuilder(
    column: $table.affKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssistCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssistCacheEntriesTable> {
  $$AssistCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get affKey =>
      $composableBuilder(column: $table.affKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AssistCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssistCacheEntriesTable,
          AssistCacheEntry,
          $$AssistCacheEntriesTableFilterComposer,
          $$AssistCacheEntriesTableOrderingComposer,
          $$AssistCacheEntriesTableAnnotationComposer,
          $$AssistCacheEntriesTableCreateCompanionBuilder,
          $$AssistCacheEntriesTableUpdateCompanionBuilder,
          (
            AssistCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $AssistCacheEntriesTable,
              AssistCacheEntry
            >,
          ),
          AssistCacheEntry,
          PrefetchHooks Function()
        > {
  $$AssistCacheEntriesTableTableManager(
    _$AppDatabase db,
    $AssistCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssistCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssistCacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssistCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> affKey = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssistCacheEntriesCompanion(
                id: id,
                affKey: affKey,
                status: status,
                rawJson: rawJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> affKey = const Value.absent(),
                Value<String> status = const Value.absent(),
                required String rawJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AssistCacheEntriesCompanion.insert(
                id: id,
                affKey: affKey,
                status: status,
                rawJson: rawJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssistCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssistCacheEntriesTable,
      AssistCacheEntry,
      $$AssistCacheEntriesTableFilterComposer,
      $$AssistCacheEntriesTableOrderingComposer,
      $$AssistCacheEntriesTableAnnotationComposer,
      $$AssistCacheEntriesTableCreateCompanionBuilder,
      $$AssistCacheEntriesTableUpdateCompanionBuilder,
      (
        AssistCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $AssistCacheEntriesTable,
          AssistCacheEntry
        >,
      ),
      AssistCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$CoordinateEntriesTableCreateCompanionBuilder =
    CoordinateEntriesCompanion Function({
      Value<int> id,
      required String assistanceId,
      required double latitude,
      required double longitude,
      Value<String> sender,
      required DateTime recordedAt,
    });
typedef $$CoordinateEntriesTableUpdateCompanionBuilder =
    CoordinateEntriesCompanion Function({
      Value<int> id,
      Value<String> assistanceId,
      Value<double> latitude,
      Value<double> longitude,
      Value<String> sender,
      Value<DateTime> recordedAt,
    });

class $$CoordinateEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CoordinateEntriesTable> {
  $$CoordinateEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assistanceId => $composableBuilder(
    column: $table.assistanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoordinateEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoordinateEntriesTable> {
  $$CoordinateEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assistanceId => $composableBuilder(
    column: $table.assistanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoordinateEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoordinateEntriesTable> {
  $$CoordinateEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assistanceId => $composableBuilder(
    column: $table.assistanceId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );
}

class $$CoordinateEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoordinateEntriesTable,
          CoordinateEntry,
          $$CoordinateEntriesTableFilterComposer,
          $$CoordinateEntriesTableOrderingComposer,
          $$CoordinateEntriesTableAnnotationComposer,
          $$CoordinateEntriesTableCreateCompanionBuilder,
          $$CoordinateEntriesTableUpdateCompanionBuilder,
          (
            CoordinateEntry,
            BaseReferences<
              _$AppDatabase,
              $CoordinateEntriesTable,
              CoordinateEntry
            >,
          ),
          CoordinateEntry,
          PrefetchHooks Function()
        > {
  $$CoordinateEntriesTableTableManager(
    _$AppDatabase db,
    $CoordinateEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoordinateEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoordinateEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoordinateEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> assistanceId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
              }) => CoordinateEntriesCompanion(
                id: id,
                assistanceId: assistanceId,
                latitude: latitude,
                longitude: longitude,
                sender: sender,
                recordedAt: recordedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String assistanceId,
                required double latitude,
                required double longitude,
                Value<String> sender = const Value.absent(),
                required DateTime recordedAt,
              }) => CoordinateEntriesCompanion.insert(
                id: id,
                assistanceId: assistanceId,
                latitude: latitude,
                longitude: longitude,
                sender: sender,
                recordedAt: recordedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoordinateEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoordinateEntriesTable,
      CoordinateEntry,
      $$CoordinateEntriesTableFilterComposer,
      $$CoordinateEntriesTableOrderingComposer,
      $$CoordinateEntriesTableAnnotationComposer,
      $$CoordinateEntriesTableCreateCompanionBuilder,
      $$CoordinateEntriesTableUpdateCompanionBuilder,
      (
        CoordinateEntry,
        BaseReferences<_$AppDatabase, $CoordinateEntriesTable, CoordinateEntry>,
      ),
      CoordinateEntry,
      PrefetchHooks Function()
    >;
typedef $$ChatOutboxEntriesTableCreateCompanionBuilder =
    ChatOutboxEntriesCompanion Function({
      Value<int> id,
      required String assistanceId,
      required String content,
      Value<String> status,
      Value<DateTime> createdAt,
    });
typedef $$ChatOutboxEntriesTableUpdateCompanionBuilder =
    ChatOutboxEntriesCompanion Function({
      Value<int> id,
      Value<String> assistanceId,
      Value<String> content,
      Value<String> status,
      Value<DateTime> createdAt,
    });

class $$ChatOutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatOutboxEntriesTable> {
  $$ChatOutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assistanceId => $composableBuilder(
    column: $table.assistanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatOutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatOutboxEntriesTable> {
  $$ChatOutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assistanceId => $composableBuilder(
    column: $table.assistanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatOutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatOutboxEntriesTable> {
  $$ChatOutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assistanceId => $composableBuilder(
    column: $table.assistanceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChatOutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatOutboxEntriesTable,
          ChatOutboxEntry,
          $$ChatOutboxEntriesTableFilterComposer,
          $$ChatOutboxEntriesTableOrderingComposer,
          $$ChatOutboxEntriesTableAnnotationComposer,
          $$ChatOutboxEntriesTableCreateCompanionBuilder,
          $$ChatOutboxEntriesTableUpdateCompanionBuilder,
          (
            ChatOutboxEntry,
            BaseReferences<
              _$AppDatabase,
              $ChatOutboxEntriesTable,
              ChatOutboxEntry
            >,
          ),
          ChatOutboxEntry,
          PrefetchHooks Function()
        > {
  $$ChatOutboxEntriesTableTableManager(
    _$AppDatabase db,
    $ChatOutboxEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatOutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatOutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatOutboxEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> assistanceId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ChatOutboxEntriesCompanion(
                id: id,
                assistanceId: assistanceId,
                content: content,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String assistanceId,
                required String content,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ChatOutboxEntriesCompanion.insert(
                id: id,
                assistanceId: assistanceId,
                content: content,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatOutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatOutboxEntriesTable,
      ChatOutboxEntry,
      $$ChatOutboxEntriesTableFilterComposer,
      $$ChatOutboxEntriesTableOrderingComposer,
      $$ChatOutboxEntriesTableAnnotationComposer,
      $$ChatOutboxEntriesTableCreateCompanionBuilder,
      $$ChatOutboxEntriesTableUpdateCompanionBuilder,
      (
        ChatOutboxEntry,
        BaseReferences<_$AppDatabase, $ChatOutboxEntriesTable, ChatOutboxEntry>,
      ),
      ChatOutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$NotificationCacheEntriesTableCreateCompanionBuilder =
    NotificationCacheEntriesCompanion Function({
      required String id,
      required String type,
      required String rawJson,
      Value<bool> read,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$NotificationCacheEntriesTableUpdateCompanionBuilder =
    NotificationCacheEntriesCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> rawJson,
      Value<bool> read,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$NotificationCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationCacheEntriesTable> {
  $$NotificationCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationCacheEntriesTable> {
  $$NotificationCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationCacheEntriesTable> {
  $$NotificationCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NotificationCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationCacheEntriesTable,
          NotificationCacheEntry,
          $$NotificationCacheEntriesTableFilterComposer,
          $$NotificationCacheEntriesTableOrderingComposer,
          $$NotificationCacheEntriesTableAnnotationComposer,
          $$NotificationCacheEntriesTableCreateCompanionBuilder,
          $$NotificationCacheEntriesTableUpdateCompanionBuilder,
          (
            NotificationCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $NotificationCacheEntriesTable,
              NotificationCacheEntry
            >,
          ),
          NotificationCacheEntry,
          PrefetchHooks Function()
        > {
  $$NotificationCacheEntriesTableTableManager(
    _$AppDatabase db,
    $NotificationCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationCacheEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationCacheEntriesCompanion(
                id: id,
                type: type,
                rawJson: rawJson,
                read: read,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String rawJson,
                Value<bool> read = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => NotificationCacheEntriesCompanion.insert(
                id: id,
                type: type,
                rawJson: rawJson,
                read: read,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationCacheEntriesTable,
      NotificationCacheEntry,
      $$NotificationCacheEntriesTableFilterComposer,
      $$NotificationCacheEntriesTableOrderingComposer,
      $$NotificationCacheEntriesTableAnnotationComposer,
      $$NotificationCacheEntriesTableCreateCompanionBuilder,
      $$NotificationCacheEntriesTableUpdateCompanionBuilder,
      (
        NotificationCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $NotificationCacheEntriesTable,
          NotificationCacheEntry
        >,
      ),
      NotificationCacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AssistCacheEntriesTableTableManager get assistCacheEntries =>
      $$AssistCacheEntriesTableTableManager(_db, _db.assistCacheEntries);
  $$CoordinateEntriesTableTableManager get coordinateEntries =>
      $$CoordinateEntriesTableTableManager(_db, _db.coordinateEntries);
  $$ChatOutboxEntriesTableTableManager get chatOutboxEntries =>
      $$ChatOutboxEntriesTableTableManager(_db, _db.chatOutboxEntries);
  $$NotificationCacheEntriesTableTableManager get notificationCacheEntries =>
      $$NotificationCacheEntriesTableTableManager(
        _db,
        _db.notificationCacheEntries,
      );
}
