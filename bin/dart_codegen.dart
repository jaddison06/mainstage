import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'getLibrary.dart';

const LIB_DIR = 'build/libs';

// ----- ENUMS -----

enum PlatformErrorCode {
    Success,
    SDL_InitVideo_Fail,
    SDL_CreateWindow_Fail,
    SDL_CreateRenderer_Fail,
}

PlatformErrorCode PlatformErrorCodeFromInt(int val) {
    if (val == 0) { return PlatformErrorCode.Success; }
    if (val == 1) { return PlatformErrorCode.SDL_InitVideo_Fail; }
    if (val == 2) { return PlatformErrorCode.SDL_CreateWindow_Fail; }
    if (val == 3) { return PlatformErrorCode.SDL_CreateRenderer_Fail; }
    throw Exception('PlatformErrorCode cannot be converted from int $val: Out of range.');
}

enum SDLEventType {
    Quit,
    LowMemory,
    KeyDown,
    KeyUp,
    MouseMove,
    MouseDown,
    MouseUp,
    MouseScroll,
    FingerDown,
    FingerUp,
    FingerDrag,
    WindowResize,
    NotImplemented,
}

SDLEventType SDLEventTypeFromInt(int val) {
    if (val == 0) { return SDLEventType.Quit; }
    if (val == 1) { return SDLEventType.LowMemory; }
    if (val == 2) { return SDLEventType.KeyDown; }
    if (val == 3) { return SDLEventType.KeyUp; }
    if (val == 4) { return SDLEventType.MouseMove; }
    if (val == 5) { return SDLEventType.MouseDown; }
    if (val == 6) { return SDLEventType.MouseUp; }
    if (val == 7) { return SDLEventType.MouseScroll; }
    if (val == 8) { return SDLEventType.FingerDown; }
    if (val == 9) { return SDLEventType.FingerUp; }
    if (val == 10) { return SDLEventType.FingerDrag; }
    if (val == 11) { return SDLEventType.WindowResize; }
    if (val == 12) { return SDLEventType.NotImplemented; }
    throw Exception('SDLEventType cannot be converted from int $val: Out of range.');
}

// ----- FFI: GENERATED FUNCTIONS -----


typedef CreateEventNativeSig = Pointer<Void> Function();

typedef CreateEventSig = Pointer<Void> Function();

CreateEventSig lookupCreateEvent(DynamicLibrary lib) {
    return lib.lookupFunction<CreateEventNativeSig, CreateEventSig>('CreateEvent');
}


typedef InitRenderWindowNativeSig = Pointer<Void> Function(Pointer<Utf8>, Int32, Int32, Int32, Int32, Int32);

typedef InitRenderWindowSig = Pointer<Void> Function(Pointer<Utf8>, int, int, int, int, int);

InitRenderWindowSig lookupInitRenderWindow(DynamicLibrary lib) {
    return lib.lookupFunction<InitRenderWindowNativeSig, InitRenderWindowSig>('InitRenderWindow');
}

// ----- FFI: GENERATED CLASSES -----


typedef _generatedClasscEventPollNativeSig = Void Function(Pointer<Void>);

typedef _generatedClasscEventPollSig = void Function(Pointer<Void>);


typedef _generatedClasscEventGetTypeNativeSig = Int32 Function(Pointer<Void>);

typedef _generatedClasscEventGetTypeSig = int Function(Pointer<Void>);


typedef _generatedClasscEventDestroyNativeSig = Void Function(Pointer<Void>);

typedef _generatedClasscEventDestroySig = void Function(Pointer<Void>);


typedef _generatedClasscEventGetResizeDataNativeSig = Void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);

typedef _generatedClasscEventGetResizeDataSig = void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);



class cEvent {
    Pointer<Void> structPointer = Pointer.fromAddress(0);

    void validatePointer(String methodName) {
        if (structPointer.address == 0) {
            throw Exception('cEvent.$methodName was called, but structPointer is a nullptr.');
        }
    }

    late _generatedClasscEventPollSig _Poll;
    late _generatedClasscEventGetTypeSig _GetType;
    late _generatedClasscEventDestroySig _Destroy;
    late _generatedClasscEventGetResizeDataSig _GetResizeData;

    cEvent() {
        final lib = getLibrary('Event.c');

        _Poll = lib.lookupFunction<_generatedClasscEventPollNativeSig, _generatedClasscEventPollSig>('Poll');
        _GetType = lib.lookupFunction<_generatedClasscEventGetTypeNativeSig, _generatedClasscEventGetTypeSig>('GetType');
        _Destroy = lib.lookupFunction<_generatedClasscEventDestroyNativeSig, _generatedClasscEventDestroySig>('Destroy');
        _GetResizeData = lib.lookupFunction<_generatedClasscEventGetResizeDataNativeSig, _generatedClasscEventGetResizeDataSig>('GetResizeData');
    }
     void Poll() {
        validatePointer('Poll');
        return _Poll(structPointer, );
    }

     int GetType() {
        validatePointer('GetType');
        return _GetType(structPointer, );
    }

     void Destroy() {
        validatePointer('Destroy');
        return _Destroy(structPointer, );
    }

     void GetResizeData(Pointer<Int32> newWidth, Pointer<Int32> newHeight) {
        validatePointer('GetResizeData');
        return _GetResizeData(structPointer, newWidth, newHeight);
    }

}


typedef _generatedClasscRenderWindowLogSDLErrorNativeSig = Void Function(Pointer<Void>, Int32);

typedef _generatedClasscRenderWindowLogSDLErrorSig = void Function(Pointer<Void>, int);


typedef _generatedClasscRenderWindowDestroyNativeSig = Void Function(Pointer<Void>);

typedef _generatedClasscRenderWindowDestroySig = void Function(Pointer<Void>);


typedef _generatedClasscRenderWindowGetErrorCodeNativeSig = Int32 Function(Pointer<Void>);

typedef _generatedClasscRenderWindowGetErrorCodeSig = int Function(Pointer<Void>);


typedef _generatedClasscRenderWindowUpdateDimensionsNativeSig = Void Function(Pointer<Void>, Int32, Int32);

typedef _generatedClasscRenderWindowUpdateDimensionsSig = void Function(Pointer<Void>, int, int);


typedef _generatedClasscRenderWindowGetWidthNativeSig = Int32 Function(Pointer<Void>);

typedef _generatedClasscRenderWindowGetWidthSig = int Function(Pointer<Void>);


typedef _generatedClasscRenderWindowGetHeightNativeSig = Int32 Function(Pointer<Void>);

typedef _generatedClasscRenderWindowGetHeightSig = int Function(Pointer<Void>);


typedef _generatedClasscRenderWindowSetColourNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32);

typedef _generatedClasscRenderWindowSetColourSig = void Function(Pointer<Void>, int, int, int);


typedef _generatedClasscRenderWindowFlushNativeSig = Void Function(Pointer<Void>);

typedef _generatedClasscRenderWindowFlushSig = void Function(Pointer<Void>);


typedef _generatedClasscRenderWindowGetFrameCountNativeSig = Int32 Function(Pointer<Void>);

typedef _generatedClasscRenderWindowGetFrameCountSig = int Function(Pointer<Void>);


typedef _generatedClasscRenderWindowSetFullscreenNativeSig = Void Function(Pointer<Void>, Int32);

typedef _generatedClasscRenderWindowSetFullscreenSig = void Function(Pointer<Void>, int);


typedef _generatedClasscRenderWindowDrawPointNativeSig = Void Function(Pointer<Void>, Int32, Int32);

typedef _generatedClasscRenderWindowDrawPointSig = void Function(Pointer<Void>, int, int);


typedef _generatedClasscRenderWindowDrawLineNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef _generatedClasscRenderWindowDrawLineSig = void Function(Pointer<Void>, int, int, int, int);


typedef _generatedClasscRenderWindowDrawRectNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef _generatedClasscRenderWindowDrawRectSig = void Function(Pointer<Void>, int, int, int, int);


typedef _generatedClasscRenderWindowFillRectNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef _generatedClasscRenderWindowFillRectSig = void Function(Pointer<Void>, int, int, int, int);



class cRenderWindow {
    Pointer<Void> structPointer = Pointer.fromAddress(0);

    void validatePointer(String methodName) {
        if (structPointer.address == 0) {
            throw Exception('cRenderWindow.$methodName was called, but structPointer is a nullptr.');
        }
    }

    late _generatedClasscRenderWindowLogSDLErrorSig _LogSDLError;
    late _generatedClasscRenderWindowDestroySig _Destroy;
    late _generatedClasscRenderWindowGetErrorCodeSig _GetErrorCode;
    late _generatedClasscRenderWindowUpdateDimensionsSig _UpdateDimensions;
    late _generatedClasscRenderWindowGetWidthSig _GetWidth;
    late _generatedClasscRenderWindowGetHeightSig _GetHeight;
    late _generatedClasscRenderWindowSetColourSig _SetColour;
    late _generatedClasscRenderWindowFlushSig _Flush;
    late _generatedClasscRenderWindowGetFrameCountSig _GetFrameCount;
    late _generatedClasscRenderWindowSetFullscreenSig _SetFullscreen;
    late _generatedClasscRenderWindowDrawPointSig _DrawPoint;
    late _generatedClasscRenderWindowDrawLineSig _DrawLine;
    late _generatedClasscRenderWindowDrawRectSig _DrawRect;
    late _generatedClasscRenderWindowFillRectSig _FillRect;

    cRenderWindow() {
        final lib = getLibrary('RenderWindow.c');

        _LogSDLError = lib.lookupFunction<_generatedClasscRenderWindowLogSDLErrorNativeSig, _generatedClasscRenderWindowLogSDLErrorSig>('LogSDLError');
        _Destroy = lib.lookupFunction<_generatedClasscRenderWindowDestroyNativeSig, _generatedClasscRenderWindowDestroySig>('Destroy');
        _GetErrorCode = lib.lookupFunction<_generatedClasscRenderWindowGetErrorCodeNativeSig, _generatedClasscRenderWindowGetErrorCodeSig>('GetErrorCode');
        _UpdateDimensions = lib.lookupFunction<_generatedClasscRenderWindowUpdateDimensionsNativeSig, _generatedClasscRenderWindowUpdateDimensionsSig>('UpdateDimensions');
        _GetWidth = lib.lookupFunction<_generatedClasscRenderWindowGetWidthNativeSig, _generatedClasscRenderWindowGetWidthSig>('GetWidth');
        _GetHeight = lib.lookupFunction<_generatedClasscRenderWindowGetHeightNativeSig, _generatedClasscRenderWindowGetHeightSig>('GetHeight');
        _SetColour = lib.lookupFunction<_generatedClasscRenderWindowSetColourNativeSig, _generatedClasscRenderWindowSetColourSig>('SetColour');
        _Flush = lib.lookupFunction<_generatedClasscRenderWindowFlushNativeSig, _generatedClasscRenderWindowFlushSig>('Flush');
        _GetFrameCount = lib.lookupFunction<_generatedClasscRenderWindowGetFrameCountNativeSig, _generatedClasscRenderWindowGetFrameCountSig>('GetFrameCount');
        _SetFullscreen = lib.lookupFunction<_generatedClasscRenderWindowSetFullscreenNativeSig, _generatedClasscRenderWindowSetFullscreenSig>('SetFullscreen');
        _DrawPoint = lib.lookupFunction<_generatedClasscRenderWindowDrawPointNativeSig, _generatedClasscRenderWindowDrawPointSig>('DrawPoint');
        _DrawLine = lib.lookupFunction<_generatedClasscRenderWindowDrawLineNativeSig, _generatedClasscRenderWindowDrawLineSig>('DrawLine');
        _DrawRect = lib.lookupFunction<_generatedClasscRenderWindowDrawRectNativeSig, _generatedClasscRenderWindowDrawRectSig>('DrawRect');
        _FillRect = lib.lookupFunction<_generatedClasscRenderWindowFillRectNativeSig, _generatedClasscRenderWindowFillRectSig>('FillRect');
    }
     void LogSDLError(int exitCode) {
        validatePointer('LogSDLError');
        return _LogSDLError(structPointer, exitCode);
    }

     void Destroy() {
        validatePointer('Destroy');
        return _Destroy(structPointer, );
    }

     int GetErrorCode() {
        validatePointer('GetErrorCode');
        return _GetErrorCode(structPointer, );
    }

     void UpdateDimensions(int width, int height) {
        validatePointer('UpdateDimensions');
        return _UpdateDimensions(structPointer, width, height);
    }

     int GetWidth() {
        validatePointer('GetWidth');
        return _GetWidth(structPointer, );
    }

     int GetHeight() {
        validatePointer('GetHeight');
        return _GetHeight(structPointer, );
    }

     void SetColour(int r, int g, int b) {
        validatePointer('SetColour');
        return _SetColour(structPointer, r, g, b);
    }

     void Flush() {
        validatePointer('Flush');
        return _Flush(structPointer, );
    }

     int GetFrameCount() {
        validatePointer('GetFrameCount');
        return _GetFrameCount(structPointer, );
    }

     void SetFullscreen(int enable) {
        validatePointer('SetFullscreen');
        return _SetFullscreen(structPointer, enable);
    }

     void DrawPoint(int x, int y) {
        validatePointer('DrawPoint');
        return _DrawPoint(structPointer, x, y);
    }

     void DrawLine(int x1, int y1, int x2, int y2) {
        validatePointer('DrawLine');
        return _DrawLine(structPointer, x1, y1, x2, y2);
    }

     void DrawRect(int x1, int y1, int width, int height) {
        validatePointer('DrawRect');
        return _DrawRect(structPointer, x1, y1, width, height);
    }

     void FillRect(int x1, int y1, int width, int height) {
        validatePointer('FillRect');
        return _FillRect(structPointer, x1, y1, width, height);
    }

}

