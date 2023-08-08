// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContactStruct extends BaseStruct {
  ContactStruct({
    String? name,
    String? phoneNumber,
  })  : _name = name,
        _phoneNumber = phoneNumber;

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;
  bool hasName() => _name != null;

  // "PhoneNumber" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  set phoneNumber(String? val) => _phoneNumber = val;
  bool hasPhoneNumber() => _phoneNumber != null;

  static ContactStruct fromMap(Map<String, dynamic> data) => ContactStruct(
        name: data['Name'] as String?,
        phoneNumber: data['PhoneNumber'] as String?,
      );

  static ContactStruct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic> ? ContactStruct.fromMap(data) : null;

  Map<String, dynamic> toMap() => {
        'Name': _name,
        'PhoneNumber': _phoneNumber,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Name': serializeParam(
          _name,
          ParamType.String,
        ),
        'PhoneNumber': serializeParam(
          _phoneNumber,
          ParamType.String,
        ),
      }.withoutNulls;

  static ContactStruct fromSerializableMap(Map<String, dynamic> data) =>
      ContactStruct(
        name: deserializeParam(
          data['Name'],
          ParamType.String,
          false,
        ),
        phoneNumber: deserializeParam(
          data['PhoneNumber'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ContactStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ContactStruct &&
        name == other.name &&
        phoneNumber == other.phoneNumber;
  }

  @override
  int get hashCode => const ListEquality().hash([name, phoneNumber]);
}

ContactStruct createContactStruct({
  String? name,
  String? phoneNumber,
}) =>
    ContactStruct(
      name: name,
      phoneNumber: phoneNumber,
    );
