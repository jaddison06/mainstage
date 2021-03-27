# mainstage platform apis

The idea of these platform APIs is to present as simple an interface as possible. They should "just work". The build system has some tools help with this:
- All compiled C libraries are placed in build/libs, and have a filename corresponding to their own.
- Enums can be described in a .enum file - 