# mainstage platform apis

The idea of these platform APIs is to present as simple an interface as possible. They should "just work". The build system has some tools help with this:
- All compiled C libraries are placed in build/libs, and have a filename corresponding to their own.
- Enum communication between C and Dart is difficult, so the system can codegen enums. These can be passed around as integers. Write your enum values in a .enum file in the platform/ dir. Generated code is stored in build/shared_enums. The Dart file also includes functions to convert the int back into the corresponding enum value.

Ideally, this means that Dart code wanting to use a C library should only have to:
- Load the library using getLibrary()
- Lookup functions in the library
- Create classes to wrap the C structs & procedural way of programming.