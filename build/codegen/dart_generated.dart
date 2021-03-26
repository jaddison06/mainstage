import 'dart:ffi';
import 'package:ffi/ffi.dart';

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
    if (val == 11) { return SDLEventType.NotImplemented; }
    throw Exception('SDLEventType cannot be converted from int $val: Out of range.');
}

// ----- FFI UTILS -----

const LIB_DIR = 'build/libs';


typedef LogSDLErrorNativeSig = Pointer<Void> Function(Pointer<Void>, Int32);

typedef LogSDLErrorSig = Pointer<Void> Function(Pointer<Void>, int);

LogSDLErrorSig lookupLogSDLError(DynamicLibrary lib) {
    return lib.lookupFunction<LogSDLErrorNativeSig, LogSDLErrorSig>('LogSDLError');
}


typedef InitRenderWindowNativeSig = Pointer<Void> Function(Pointer<Utf8>, Int32, Int32, Int32, Int32, Int32);

typedef InitRenderWindowSig = Pointer<Void> Function(Pointer<Utf8>, int, int, int, int, int);

InitRenderWindowSig lookupInitRenderWindow(DynamicLibrary lib) {
    return lib.lookupFunction<InitRenderWindowNativeSig, InitRenderWindowSig>('InitRenderWindow');
}


typedef DestroyRenderWindowNativeSig = Void Function(Pointer<Void>);

typedef DestroyRenderWindowSig = void Function(Pointer<Void>);

DestroyRenderWindowSig lookupDestroyRenderWindow(DynamicLibrary lib) {
    return lib.lookupFunction<DestroyRenderWindowNativeSig, DestroyRenderWindowSig>('DestroyRenderWindow');
}


typedef GetErrorCodeNativeSig = Int32 Function(Pointer<Void>);

typedef GetErrorCodeSig = int Function(Pointer<Void>);

GetErrorCodeSig lookupGetErrorCode(DynamicLibrary lib) {
    return lib.lookupFunction<GetErrorCodeNativeSig, GetErrorCodeSig>('GetErrorCode');
}


typedef SetColourNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32);

typedef SetColourSig = void Function(Pointer<Void>, int, int, int);

SetColourSig lookupSetColour(DynamicLibrary lib) {
    return lib.lookupFunction<SetColourNativeSig, SetColourSig>('SetColour');
}


typedef FlushNativeSig = Void Function(Pointer<Void>);

typedef FlushSig = void Function(Pointer<Void>);

FlushSig lookupFlush(DynamicLibrary lib) {
    return lib.lookupFunction<FlushNativeSig, FlushSig>('Flush');
}


typedef SetFullscreenNativeSig = Void Function(Pointer<Void>, Int32);

typedef SetFullscreenSig = void Function(Pointer<Void>, int);

SetFullscreenSig lookupSetFullscreen(DynamicLibrary lib) {
    return lib.lookupFunction<SetFullscreenNativeSig, SetFullscreenSig>('SetFullscreen');
}


typedef DrawPointNativeSig = Void Function(Pointer<Void>, Int32, Int32);

typedef DrawPointSig = void Function(Pointer<Void>, int, int);

DrawPointSig lookupDrawPoint(DynamicLibrary lib) {
    return lib.lookupFunction<DrawPointNativeSig, DrawPointSig>('DrawPoint');
}


typedef DrawLineNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef DrawLineSig = void Function(Pointer<Void>, int, int, int, int);

DrawLineSig lookupDrawLine(DynamicLibrary lib) {
    return lib.lookupFunction<DrawLineNativeSig, DrawLineSig>('DrawLine');
}


typedef DrawRectNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef DrawRectSig = void Function(Pointer<Void>, int, int, int, int);

DrawRectSig lookupDrawRect(DynamicLibrary lib) {
    return lib.lookupFunction<DrawRectNativeSig, DrawRectSig>('DrawRect');
}


typedef FillRectNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef FillRectSig = void Function(Pointer<Void>, int, int, int, int);

FillRectSig lookupFillRect(DynamicLibrary lib) {
    return lib.lookupFunction<FillRectNativeSig, FillRectSig>('FillRect');
}


typedef CreateEventNativeSig = Pointer<Void> Function();

typedef CreateEventSig = Pointer<Void> Function();

CreateEventSig lookupCreateEvent(DynamicLibrary lib) {
    return lib.lookupFunction<CreateEventNativeSig, CreateEventSig>('CreateEvent');
}


typedef PollEventNativeSig = Void Function(Pointer<Void>);

typedef PollEventSig = void Function(Pointer<Void>);

PollEventSig lookupPollEvent(DynamicLibrary lib) {
    return lib.lookupFunction<PollEventNativeSig, PollEventSig>('PollEvent');
}


typedef GetEventTypeNativeSig = Int32 Function(Pointer<Void>);

typedef GetEventTypeSig = int Function(Pointer<Void>);

GetEventTypeSig lookupGetEventType(DynamicLibrary lib) {
    return lib.lookupFunction<GetEventTypeNativeSig, GetEventTypeSig>('GetEventType');
}


typedef DestroyEventNativeSig = Void Function(Pointer<Void>);

typedef DestroyEventSig = void Function(Pointer<Void>);

DestroyEventSig lookupDestroyEvent(DynamicLibrary lib) {
    return lib.lookupFunction<DestroyEventNativeSig, DestroyEventSig>('DestroyEvent');
}

