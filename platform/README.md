# mainstage platform apis

The idea of these platform APIs is to present as simple an interface as possible. They should "just work". The build system has some tools help with this:
- All compiled C libraries are placed in build/libs, and have a filename corresponding to their own.
- Enum communication between C and Dart is difficult, so the system can codegen enums. These can be passed around as integers. Write your enum values in a .enum file in the platform/ dir. Generated code is stored in build/codegen. The Dart file also includes functions to convert the int back into the corresponding enum value.
- Dart FFI code for function lookup tends to be fairly repetitive, so we codegen that too. If you want your C functions to be accessible from Dart, create a .defs file. This should contain the signatures of your functions, each on a newline. Currently this only supports basic types (use void* for storing structs in Dart variables). TODO In the future this will be auto-generated from your C code.

Ideally, this means that Dart code wanting to use a C library should only have to:
- Load the library using getLibrary()
- Call the generated lookup functions on the library
- Create classes to wrap the C structs & procedural way of programming

This is still too much boilerplate for my liking - at some point I'm planning to rewrite the build system from the ground up in Dart.