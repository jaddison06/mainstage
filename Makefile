all: build/libs/libRenderWindow.so build/libs/libTest.so

build/libs/libRenderWindow.so: platform/RenderWindow.c
	gcc -shared -o build/libs/libRenderWindow.so -fPIC platform/RenderWindow.c -lSDL2


build/libs/libTest.so: platform/Test.c
	gcc -shared -o build/libs/libTest.so -fPIC platform/Test.c

run: all
	dart run

clean:
	rm -rf build/libs
	mkdir build/libs

makefile:
	python3 ./build/generate_makefile.py

