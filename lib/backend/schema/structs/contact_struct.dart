// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContactStruct extends BaseStruct {
  ContactStruct({
    String? name,
    String? phoneNumber,
    String? sOSMessage,
  })  : _name = name,
        _phoneNumber = phoneNumber,
        _sOSMessage = sOSMessage;

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

  // "SOSMessage" field.
  String? _sOSMessage;
  String get sOSMessage => _sOSMessage ?? '';
  set sOSMessage(String? val) => _sOSMessage = val;
  bool hasSOSMessage() => _sOSMessage != null;

  static ContactStruct fromMap(Map<String, dynamic> data) => ContactStruct(
        name: data['Name'] as String?,
        phoneNumber: data['PhoneNumber'] as String?,
        sOSMessage: data['SOSMessage'] as String?,
      );

  static ContactStruct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic> ? ContactStruct.fromMap(data) : null;

  Map<String, dynamic> toMap() => {
        'Name': _name,
        'PhoneNumber': _phoneNumber,
        'SOSMessage': _sOSMessage,
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
        'SOSMessage': serializeParam(
          _sOSMessage,
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
        sOSMessage: deserializeParam(
          data['SOSMessage'],
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
        phoneNumber == other.phoneNumber &&
        sOSMessage == other.sOSMessage;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, phoneNumber, sOSMessage]);
}

ContactStruct createContactStruct({
  String? name,
  String? phoneNumber,
  String? sOSMessage,
}) =>
    ContactStruct(
      name: name,
      phoneNumber: phoneNumber,
      sOSMessage: sOSMessage,
    );
