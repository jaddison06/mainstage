all: codegen build/libs/libRenderWindow.so build/libs/libText.so build/libs/libTest.so build/libs/libEvent.so

build/libs/libRenderWindow.so: platform/sdl/RenderWindow.c
	gcc -shared -o build/libs/libRenderWindow.so -I ./platform -fPIC platform/sdl/RenderWindow.c -lSDL2

build/libs/libText.so: platform/sdl/Text.c
	gcc -shared -o build/libs/libText.so -I ./platform -fPIC platform/sdl/Text.c -lSDL2 -lSDL2_ttf

build/libs/libTest.so: platform/sdl/Test.c
	gcc -shared -o build/libs/libTest.so -I ./platform -fPIC platform/sdl/Test.c

build/libs/libEvent.so: platform/sdl/Event.c
	gcc -shared -o build/libs/libEvent.so -I ./platform -fPIC platform/sdl/Event.c -lSDL2

run: all
	dart run

clean:
	rm -rf build/libs
	mkdir build/libs
	rm bin/dart_codegen.dart
	rm platform/c_codegen.h

makefile:
	python3 ./build/generate_makefile.py

codegen:
	python3 ./build/codegen.py

