import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'getLibrary.dart';

const LIB_DIR = 'build/libs';

// ----- ENUMS -----

enum MouseButton {
    Left,
    Middle,
    Right,
    Unknown,
}

MouseButton MouseButtonFromInt(int val) {
    if (val == 0) { return MouseButton.Left; }
    if (val == 1) { return MouseButton.Middle; }
    if (val == 2) { return MouseButton.Right; }
    if (val == 3) { return MouseButton.Unknown; }
    throw Exception('MouseButton cannot be converted from int $val: Out of range.');
}

String MouseButtonToString(MouseButton val) {
    if (val == MouseButton.Left) { return 'Left'; }
    if (val == MouseButton.Middle) { return 'Middle'; }
    if (val == MouseButton.Right) { return 'Right'; }
    if (val == MouseButton.Unknown) { return 'Unknown'; }
    // to please the compiler - a human would use a switch statement
    return '';
}

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

String PlatformErrorCodeToString(PlatformErrorCode val) {
    if (val == PlatformErrorCode.Success) { return 'Success'; }
    if (val == PlatformErrorCode.SDL_InitVideo_Fail) { return 'SDL_InitVideo_Fail'; }
    if (val == PlatformErrorCode.SDL_CreateWindow_Fail) { return 'SDL_CreateWindow_Fail'; }
    if (val == PlatformErrorCode.SDL_CreateRenderer_Fail) { return 'SDL_CreateRenderer_Fail'; }
    // to please the compiler - a human would use a switch statement
    return '';
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

String SDLEventTypeToString(SDLEventType val) {
    if (val == SDLEventType.Quit) { return 'Quit'; }
    if (val == SDLEventType.LowMemory) { return 'LowMemory'; }
    if (val == SDLEventType.KeyDown) { return 'KeyDown'; }
    if (val == SDLEventType.KeyUp) { return 'KeyUp'; }
    if (val == SDLEventType.MouseMove) { return 'MouseMove'; }
    if (val == SDLEventType.MouseDown) { return 'MouseDown'; }
    if (val == SDLEventType.MouseUp) { return 'MouseUp'; }
    if (val == SDLEventType.MouseScroll) { return 'MouseScroll'; }
    if (val == SDLEventType.FingerDown) { return 'FingerDown'; }
    if (val == SDLEventType.FingerUp) { return 'FingerUp'; }
    if (val == SDLEventType.FingerDrag) { return 'FingerDrag'; }
    if (val == SDLEventType.WindowResize) { return 'WindowResize'; }
    if (val == SDLEventType.NotImplemented) { return 'NotImplemented'; }
    // to please the compiler - a human would use a switch statement
    return '';
}

// ----- FFI: GENERATED FUNCTIONS -----


typedef _CreateEventNativeSig = Pointer<Void> Function();

typedef CreateEventSig = Pointer<Void> Function();

CreateEventSig lookupCreateEvent(DynamicLibrary lib) {
    return lib.lookupFunction<_CreateEventNativeSig, CreateEventSig>('CreateEvent');
}


typedef _InitRenderWindowNativeSig = Pointer<Void> Function(Pointer<Utf8>, Int32, Int32, Int32, Int32, Int32);

typedef InitRenderWindowSig = Pointer<Void> Function(Pointer<Utf8>, int, int, int, int, int);

InitRenderWindowSig lookupInitRenderWindow(DynamicLibrary lib) {
    return lib.lookupFunction<_InitRenderWindowNativeSig, InitRenderWindowSig>('InitRenderWindow');
}

// ----- FFI: GENERATED CLASSES -----


typedef __classcEventPollNativeSig = Void Function(Pointer<Void>);

typedef _classcEventPollSig = void Function(Pointer<Void>);


typedef __classcEventGetTypeNativeSig = Int32 Function(Pointer<Void>);

typedef _classcEventGetTypeSig = int Function(Pointer<Void>);


typedef __classcEventDestroyNativeSig = Void Function(Pointer<Void>);

typedef _classcEventDestroySig = void Function(Pointer<Void>);


typedef __classcEventGetResizeDataNativeSig = Void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);

typedef _classcEventGetResizeDataSig = void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);


typedef __classcEventGetMouseMoveDataNativeSig = Void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);

typedef _classcEventGetMouseMoveDataSig = void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);


typedef __classcEventGetMousePressReleaseDataNativeSig = Int32 Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);

typedef _classcEventGetMousePressReleaseDataSig = int Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>);



class cEvent {
    Pointer<Void> structPointer = Pointer.fromAddress(0);

    void validatePointer(String methodName) {
        if (structPointer.address == 0) {
            throw Exception('cEvent.$methodName was called, but structPointer is a nullptr.');
        }
    }

    late _classcEventPollSig _Poll;
    late _classcEventGetTypeSig _GetType;
    late _classcEventDestroySig _Destroy;
    late _classcEventGetResizeDataSig _GetResizeData;
    late _classcEventGetMouseMoveDataSig _GetMouseMoveData;
    late _classcEventGetMousePressReleaseDataSig _GetMousePressReleaseData;

    cEvent() {
        final lib = getLibrary('Event.c');

        _Poll = lib.lookupFunction<__classcEventPollNativeSig, _classcEventPollSig>('Poll');
        _GetType = lib.lookupFunction<__classcEventGetTypeNativeSig, _classcEventGetTypeSig>('GetType');
        _Destroy = lib.lookupFunction<__classcEventDestroyNativeSig, _classcEventDestroySig>('Destroy');
        _GetResizeData = lib.lookupFunction<__classcEventGetResizeDataNativeSig, _classcEventGetResizeDataSig>('GetResizeData');
        _GetMouseMoveData = lib.lookupFunction<__classcEventGetMouseMoveDataNativeSig, _classcEventGetMouseMoveDataSig>('GetMouseMoveData');
        _GetMousePressReleaseData = lib.lookupFunction<__classcEventGetMousePressReleaseDataNativeSig, _classcEventGetMousePressReleaseDataSig>('GetMousePressReleaseData');
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

     void GetMouseMoveData(Pointer<Int32> x, Pointer<Int32> y) {
        validatePointer('GetMouseMoveData');
        return _GetMouseMoveData(structPointer, x, y);
    }

     int GetMousePressReleaseData(Pointer<Int32> x, Pointer<Int32> y) {
        validatePointer('GetMousePressReleaseData');
        return _GetMousePressReleaseData(structPointer, x, y);
    }

}


typedef __classcRenderWindowLogSDLErrorNativeSig = Void Function(Pointer<Void>, Int32);

typedef _classcRenderWindowLogSDLErrorSig = void Function(Pointer<Void>, int);


typedef __classcRenderWindowDestroyNativeSig = Void Function(Pointer<Void>);

typedef _classcRenderWindowDestroySig = void Function(Pointer<Void>);


typedef __classcRenderWindowGetErrorCodeNativeSig = Int32 Function(Pointer<Void>);

typedef _classcRenderWindowGetErrorCodeSig = int Function(Pointer<Void>);


typedef __classcRenderWindowUpdateDimensionsNativeSig = Void Function(Pointer<Void>, Int32, Int32);

typedef _classcRenderWindowUpdateDimensionsSig = void Function(Pointer<Void>, int, int);


typedef __classcRenderWindowGetWidthNativeSig = Int32 Function(Pointer<Void>);

typedef _classcRenderWindowGetWidthSig = int Function(Pointer<Void>);


typedef __classcRenderWindowGetHeightNativeSig = Int32 Function(Pointer<Void>);

typedef _classcRenderWindowGetHeightSig = int Function(Pointer<Void>);


typedef __classcRenderWindowSetColourNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32);

typedef _classcRenderWindowSetColourSig = void Function(Pointer<Void>, int, int, int);


typedef __classcRenderWindowFlushNativeSig = Void Function(Pointer<Void>);

typedef _classcRenderWindowFlushSig = void Function(Pointer<Void>);


typedef __classcRenderWindowGetFrameCountNativeSig = Int32 Function(Pointer<Void>);

typedef _classcRenderWindowGetFrameCountSig = int Function(Pointer<Void>);


typedef __classcRenderWindowSetFullscreenNativeSig = Void Function(Pointer<Void>, Int32);

typedef _classcRenderWindowSetFullscreenSig = void Function(Pointer<Void>, int);


typedef __classcRenderWindowDrawPointNativeSig = Void Function(Pointer<Void>, Int32, Int32);

typedef _classcRenderWindowDrawPointSig = void Function(Pointer<Void>, int, int);


typedef __classcRenderWindowDrawLineNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef _classcRenderWindowDrawLineSig = void Function(Pointer<Void>, int, int, int, int);


typedef __classcRenderWindowDrawRectNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef _classcRenderWindowDrawRectSig = void Function(Pointer<Void>, int, int, int, int);


typedef __classcRenderWindowFillRectNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef _classcRenderWindowFillRectSig = void Function(Pointer<Void>, int, int, int, int);



class cRenderWindow {
    Pointer<Void> structPointer = Pointer.fromAddress(0);

    void validatePointer(String methodName) {
        if (structPointer.address == 0) {
            throw Exception('cRenderWindow.$methodName was called, but structPointer is a nullptr.');
        }
    }

    late _classcRenderWindowLogSDLErrorSig _LogSDLError;
    late _classcRenderWindowDestroySig _Destroy;
    late _classcRenderWindowGetErrorCodeSig _GetErrorCode;
    late _classcRenderWindowUpdateDimensionsSig _UpdateDimensions;
    late _classcRenderWindowGetWidthSig _GetWidth;
    late _classcRenderWindowGetHeightSig _GetHeight;
    late _classcRenderWindowSetColourSig _SetColour;
    late _classcRenderWindowFlushSig _Flush;
    late _classcRenderWindowGetFrameCountSig _GetFrameCount;
    late _classcRenderWindowSetFullscreenSig _SetFullscreen;
    late _classcRenderWindowDrawPointSig _DrawPoint;
    late _classcRenderWindowDrawLineSig _DrawLine;
    late _classcRenderWindowDrawRectSig _DrawRect;
    late _classcRenderWindowFillRectSig _FillRect;

    cRenderWindow() {
        final lib = getLibrary('RenderWindow.c');

        _LogSDLError = lib.lookupFunction<__classcRenderWindowLogSDLErrorNativeSig, _classcRenderWindowLogSDLErrorSig>('LogSDLError');
        _Destroy = lib.lookupFunction<__classcRenderWindowDestroyNativeSig, _classcRenderWindowDestroySig>('Destroy');
        _GetErrorCode = lib.lookupFunction<__classcRenderWindowGetErrorCodeNativeSig, _classcRenderWindowGetErrorCodeSig>('GetErrorCode');
        _UpdateDimensions = lib.lookupFunction<__classcRenderWindowUpdateDimensionsNativeSig, _classcRenderWindowUpdateDimensionsSig>('UpdateDimensions');
        _GetWidth = lib.lookupFunction<__classcRenderWindowGetWidthNativeSig, _classcRenderWindowGetWidthSig>('GetWidth');
        _GetHeight = lib.lookupFunction<__classcRenderWindowGetHeightNativeSig, _classcRenderWindowGetHeightSig>('GetHeight');
        _SetColour = lib.lookupFunction<__classcRenderWindowSetColourNativeSig, _classcRenderWindowSetColourSig>('SetColour');
        _Flush = lib.lookupFunction<__classcRenderWindowFlushNativeSig, _classcRenderWindowFlushSig>('Flush');
        _GetFrameCount = lib.lookupFunction<__classcRenderWindowGetFrameCountNativeSig, _classcRenderWindowGetFrameCountSig>('GetFrameCount');
        _SetFullscreen = lib.lookupFunction<__classcRenderWindowSetFullscreenNativeSig, _classcRenderWindowSetFullscreenSig>('SetFullscreen');
        _DrawPoint = lib.lookupFunction<__classcRenderWindowDrawPointNativeSig, _classcRenderWindowDrawPointSig>('DrawPoint');
        _DrawLine = lib.lookupFunction<__classcRenderWindowDrawLineNativeSig, _classcRenderWindowDrawLineSig>('DrawLine');
        _DrawRect = lib.lookupFunction<__classcRenderWindowDrawRectNativeSig, _classcRenderWindowDrawRectSig>('DrawRect');
        _FillRect = lib.lookupFunction<__classcRenderWindowFillRectNativeSig, _classcRenderWindowFillRectSig>('FillRect');
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

