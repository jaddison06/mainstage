# mainstage platform apis

The idea of these platform APIs is to present as simple an interface as possible. They should "just work". The build system has some tools help with this:
- All compiled C libraries are placed in build/libs, and have a filename corresponding to their own.
- Enums can be described in a .enum file - they'll be turned into C enums with guaranteed int values, and Dart enums with corresponding functions to convert them from ints & to strings.
- Functions can be described in a .defs file corresponding to the C filename containing their implementation - Dart signatures & loaders will automatically be generated.
- A struct with functions that you can call on it - passing the pointer to the struct in as the first argument - can be automatically converted to Dart classes. Create a .cclass file corresponding to the C filename & add methods there. You can omit the struct pointer argument. See RenderWindow.cclass as an example.