all: build/libs/libRenderWindow.so build/libs/libTest.so

build/libs/libRenderWindow.so: enums platform/RenderWindow.c
	gcc -shared -o build/libs/libRenderWindow.so -I . -fPIC platform/RenderWindow.c -lSDL2


build/libs/libTest.so: enums platform/Test.c
	gcc -shared -o build/libs/libTest.so -I . -fPIC platform/Test.c

run: all
	dart run

clean:
	rm -rf build/libs
	mkdir build/libs

makefile:
	python3 ./build/generate_makefile.py

enums:
	python3 ./build/enums.py

