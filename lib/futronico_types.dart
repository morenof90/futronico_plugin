// ignore_for_file: camel_case_types

import 'dart:ffi';

typedef FTRAPIRESULT = Int32;
typedef FTR_PVOID = Pointer<Void>;
typedef FTR_BOOL = Int;
typedef FTR_FRAME_BUFFER = Pointer<Uint8>;
typedef FTR_USER_CTX = Pointer<Int32>;
typedef FTR_STATE = Int32;
typedef FTR_RESPONSE = Int32;
typedef FTR_SIGNAL = Int32;
typedef FTR_DATA_KEY = Array<Char>;
