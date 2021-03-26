import 'dart:ffi';
import 'libraryTools.dart';
import 'package:meta/meta.dart';

class FuncSignature {
  final dynamic Function() cSignature;
  final dynamic Function() dartSignature;
  final String name;
  FuncSignature(this.cSignature, this.dartSignature, this.name);
}

class cClass {
  @protected
  Map<String, dynamic> funcs;
  
  DynamicLibrary lib;

  cClass(String fname, List<FuncSignature> sigs) {
    lib = getLibrary(fname);
    funcs = <String, dynamic>{};
    for (var sig in sigs) {
      funcs[sig.name] = lib.lookupFunction<sig.cSignature, sig.dartSignature>(sig.name);
    }
  }
}