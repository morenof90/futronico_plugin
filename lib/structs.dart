// ignore_for_file: camel_case_types

import 'dart:ffi';

import 'package:futronic/futronico_types.dart';

@Packed(1)
class FTR_DATA extends Struct {
  @Int32()
  external int dwSize;
  external Pointer<Uint8> pData;
}

@Packed(1)
class FTR_ENROLL_DATA extends Struct {
  @Int32()
  external int dwSize;
  @Int32()
  external int dwQuality;
}

@Packed(1)
class FTR_BITMAP extends Struct {
  @Int32()
  external int dwWidth;
  @Int32()
  external int dwHeight;
  external FTR_DATA bitMap;
}

@Packed(1)
class FTR_IDENTIFY_RECORD extends Struct {
  @Array(16)
  external FTR_DATA_KEY keyValue;
  external Pointer<FTR_DATA> pData;
}

@Packed(1)
class FTR_IDENTIFY_ARRAY extends Struct {
  @Int32()
  external int totalNumber;
  external Pointer<FTR_IDENTIFY_RECORD> pMembers;
}

@Packed(1)
class FTR_MATCHED_X_RECORD extends Struct {
  @Array(16)
  external FTR_DATA_KEY keyValue;
  @Int32()
  external int nFar;
}

@Packed(1)
class FTR_MATCHED_X_ARRAY extends Struct {
  @Int32()
  external int totalNumber;
  external Pointer<FTR_MATCHED_X_RECORD> pMembers;
}
