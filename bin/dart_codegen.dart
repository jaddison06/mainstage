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

enum TextInitErrorCode {
    Success,
    FontInitFailed,
}

TextInitErrorCode TextInitErrorCodeFromInt(int val) {
    if (val == 0) { return TextInitErrorCode.Success; }
    if (val == 1) { return TextInitErrorCode.FontInitFailed; }
    throw Exception('TextInitErrorCode cannot be converted from int $val: Out of range.');
}

String TextInitErrorCodeToString(TextInitErrorCode val) {
    if (val == TextInitErrorCode.Success) { return 'Success'; }
    if (val == TextInitErrorCode.FontInitFailed) { return 'FontInitFailed'; }
    // to please the compiler - a human would use a switch statement
    return '';
}

enum KeyCode {
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
    X,
    Y,
    Z,
    One,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Zero,
    Exclamation,
    Question,
    DoubleQuote,
    SingleQuote,
    Pound,
    Dollar,
    Percent,
    Caret,
    Ampersand,
    Asterisk,
    Hyphen,
    Underscore,
    Equals,
    Plus,
    Pipe,
    Semicolon,
    Colon,
    At,
    Tilde,
    Hash,
    Backtick,
    ForwardSlash,
    BackSlash,
    NormalBracketL,
    NormalBracketR,
    SquareBracketL,
    SquareBracketR,
    CurlyBraceL,
    CurlyBraceR,
    SmallerThan,
    GreaterThan,
    Return,
    Escape,
    Backspace,
    Delete,
    Tab,
    Space,
    Insert,
    Home,
    End,
    PageUp,
    PageDown,
    ArrowRight,
    ArrowLeft,
    ArrowDown,
    ArrowUp,
    NumpadDivide,
    NumpadMultiply,
    NumpadSubtract,
    NumpadAdd,
    NumpadEquals,
    NumpadEnter,
    NumpadDecimalPoint,
    NumpadOne,
    NumpadTwo,
    NumpadThree,
    NumpadFour,
    NumpadFive,
    NumpadSix,
    NumpadSeven,
    NumpadEight,
    NumpadNine,
    NumpadZero,
    Function_F1,
    Function_F2,
    Function_F3,
    Function_F4,
    Function_F5,
    Function_F6,
    Function_F7,
    Function_F8,
    Function_F9,
    Function_F10,
    Function_F11,
    Function_F12,
    LControl,
    RControl,
    LShift,
    RShift,
    LAlt,
    RAlt,
    AudioNext,
    AudioPrev,
    AudioStop,
    AudioPlay,
    Unknown,
}

KeyCode KeyCodeFromInt(int val) {
    if (val == 0) { return KeyCode.A; }
    if (val == 1) { return KeyCode.B; }
    if (val == 2) { return KeyCode.C; }
    if (val == 3) { return KeyCode.D; }
    if (val == 4) { return KeyCode.E; }
    if (val == 5) { return KeyCode.F; }
    if (val == 6) { return KeyCode.G; }
    if (val == 7) { return KeyCode.H; }
    if (val == 8) { return KeyCode.I; }
    if (val == 9) { return KeyCode.J; }
    if (val == 10) { return KeyCode.K; }
    if (val == 11) { return KeyCode.L; }
    if (val == 12) { return KeyCode.M; }
    if (val == 13) { return KeyCode.N; }
    if (val == 14) { return KeyCode.O; }
    if (val == 15) { return KeyCode.P; }
    if (val == 16) { return KeyCode.Q; }
    if (val == 17) { return KeyCode.R; }
    if (val == 18) { return KeyCode.S; }
    if (val == 19) { return KeyCode.T; }
    if (val == 20) { return KeyCode.U; }
    if (val == 21) { return KeyCode.V; }
    if (val == 22) { return KeyCode.W; }
    if (val == 23) { return KeyCode.X; }
    if (val == 24) { return KeyCode.Y; }
    if (val == 25) { return KeyCode.Z; }
    if (val == 27) { return KeyCode.One; }
    if (val == 28) { return KeyCode.Two; }
    if (val == 29) { return KeyCode.Three; }
    if (val == 30) { return KeyCode.Four; }
    if (val == 31) { return KeyCode.Five; }
    if (val == 32) { return KeyCode.Six; }
    if (val == 33) { return KeyCode.Seven; }
    if (val == 34) { return KeyCode.Eight; }
    if (val == 35) { return KeyCode.Nine; }
    if (val == 36) { return KeyCode.Zero; }
    if (val == 38) { return KeyCode.Exclamation; }
    if (val == 39) { return KeyCode.Question; }
    if (val == 40) { return KeyCode.DoubleQuote; }
    if (val == 41) { return KeyCode.SingleQuote; }
    if (val == 42) { return KeyCode.Pound; }
    if (val == 43) { return KeyCode.Dollar; }
    if (val == 44) { return KeyCode.Percent; }
    if (val == 45) { return KeyCode.Caret; }
    if (val == 46) { return KeyCode.Ampersand; }
    if (val == 47) { return KeyCode.Asterisk; }
    if (val == 48) { return KeyCode.Hyphen; }
    if (val == 49) { return KeyCode.Underscore; }
    if (val == 50) { return KeyCode.Equals; }
    if (val == 51) { return KeyCode.Plus; }
    if (val == 52) { return KeyCode.Pipe; }
    if (val == 53) { return KeyCode.Semicolon; }
    if (val == 54) { return KeyCode.Colon; }
    if (val == 55) { return KeyCode.At; }
    if (val == 56) { return KeyCode.Tilde; }
    if (val == 57) { return KeyCode.Hash; }
    if (val == 58) { return KeyCode.Backtick; }
    if (val == 60) { return KeyCode.ForwardSlash; }
    if (val == 61) { return KeyCode.BackSlash; }
    if (val == 63) { return KeyCode.NormalBracketL; }
    if (val == 64) { return KeyCode.NormalBracketR; }
    if (val == 65) { return KeyCode.SquareBracketL; }
    if (val == 66) { return KeyCode.SquareBracketR; }
    if (val == 67) { return KeyCode.CurlyBraceL; }
    if (val == 68) { return KeyCode.CurlyBraceR; }
    if (val == 69) { return KeyCode.SmallerThan; }
    if (val == 70) { return KeyCode.GreaterThan; }
    if (val == 72) { return KeyCode.Return; }
    if (val == 73) { return KeyCode.Escape; }
    if (val == 74) { return KeyCode.Backspace; }
    if (val == 75) { return KeyCode.Delete; }
    if (val == 76) { return KeyCode.Tab; }
    if (val == 77) { return KeyCode.Space; }
    if (val == 79) { return KeyCode.Insert; }
    if (val == 80) { return KeyCode.Home; }
    if (val == 81) { return KeyCode.End; }
    if (val == 82) { return KeyCode.PageUp; }
    if (val == 83) { return KeyCode.PageDown; }
    if (val == 85) { return KeyCode.ArrowRight; }
    if (val == 86) { return KeyCode.ArrowLeft; }
    if (val == 87) { return KeyCode.ArrowDown; }
    if (val == 88) { return KeyCode.ArrowUp; }
    if (val == 90) { return KeyCode.NumpadDivide; }
    if (val == 91) { return KeyCode.NumpadMultiply; }
    if (val == 92) { return KeyCode.NumpadSubtract; }
    if (val == 93) { return KeyCode.NumpadAdd; }
    if (val == 94) { return KeyCode.NumpadEquals; }
    if (val == 95) { return KeyCode.NumpadEnter; }
    if (val == 96) { return KeyCode.NumpadDecimalPoint; }
    if (val == 98) { return KeyCode.NumpadOne; }
    if (val == 99) { return KeyCode.NumpadTwo; }
    if (val == 100) { return KeyCode.NumpadThree; }
    if (val == 101) { return KeyCode.NumpadFour; }
    if (val == 102) { return KeyCode.NumpadFive; }
    if (val == 103) { return KeyCode.NumpadSix; }
    if (val == 104) { return KeyCode.NumpadSeven; }
    if (val == 105) { return KeyCode.NumpadEight; }
    if (val == 106) { return KeyCode.NumpadNine; }
    if (val == 107) { return KeyCode.NumpadZero; }
    if (val == 109) { return KeyCode.Function_F1; }
    if (val == 110) { return KeyCode.Function_F2; }
    if (val == 111) { return KeyCode.Function_F3; }
    if (val == 112) { return KeyCode.Function_F4; }
    if (val == 113) { return KeyCode.Function_F5; }
    if (val == 114) { return KeyCode.Function_F6; }
    if (val == 115) { return KeyCode.Function_F7; }
    if (val == 116) { return KeyCode.Function_F8; }
    if (val == 117) { return KeyCode.Function_F9; }
    if (val == 118) { return KeyCode.Function_F10; }
    if (val == 119) { return KeyCode.Function_F11; }
    if (val == 120) { return KeyCode.Function_F12; }
    if (val == 122) { return KeyCode.LControl; }
    if (val == 123) { return KeyCode.RControl; }
    if (val == 124) { return KeyCode.LShift; }
    if (val == 125) { return KeyCode.RShift; }
    if (val == 126) { return KeyCode.LAlt; }
    if (val == 127) { return KeyCode.RAlt; }
    if (val == 129) { return KeyCode.AudioNext; }
    if (val == 130) { return KeyCode.AudioPrev; }
    if (val == 131) { return KeyCode.AudioStop; }
    if (val == 132) { return KeyCode.AudioPlay; }
    if (val == 134) { return KeyCode.Unknown; }
    throw Exception('KeyCode cannot be converted from int $val: Out of range.');
}

String KeyCodeToString(KeyCode val) {
    if (val == KeyCode.A) { return 'A'; }
    if (val == KeyCode.B) { return 'B'; }
    if (val == KeyCode.C) { return 'C'; }
    if (val == KeyCode.D) { return 'D'; }
    if (val == KeyCode.E) { return 'E'; }
    if (val == KeyCode.F) { return 'F'; }
    if (val == KeyCode.G) { return 'G'; }
    if (val == KeyCode.H) { return 'H'; }
    if (val == KeyCode.I) { return 'I'; }
    if (val == KeyCode.J) { return 'J'; }
    if (val == KeyCode.K) { return 'K'; }
    if (val == KeyCode.L) { return 'L'; }
    if (val == KeyCode.M) { return 'M'; }
    if (val == KeyCode.N) { return 'N'; }
    if (val == KeyCode.O) { return 'O'; }
    if (val == KeyCode.P) { return 'P'; }
    if (val == KeyCode.Q) { return 'Q'; }
    if (val == KeyCode.R) { return 'R'; }
    if (val == KeyCode.S) { return 'S'; }
    if (val == KeyCode.T) { return 'T'; }
    if (val == KeyCode.U) { return 'U'; }
    if (val == KeyCode.V) { return 'V'; }
    if (val == KeyCode.W) { return 'W'; }
    if (val == KeyCode.X) { return 'X'; }
    if (val == KeyCode.Y) { return 'Y'; }
    if (val == KeyCode.Z) { return 'Z'; }
    if (val == KeyCode.One) { return '1'; }
    if (val == KeyCode.Two) { return '2'; }
    if (val == KeyCode.Three) { return '3'; }
    if (val == KeyCode.Four) { return '4'; }
    if (val == KeyCode.Five) { return '5'; }
    if (val == KeyCode.Six) { return '6'; }
    if (val == KeyCode.Seven) { return '7'; }
    if (val == KeyCode.Eight) { return '8'; }
    if (val == KeyCode.Nine) { return '9'; }
    if (val == KeyCode.Zero) { return '0'; }
    if (val == KeyCode.Exclamation) { return '!'; }
    if (val == KeyCode.Question) { return '?'; }
    if (val == KeyCode.DoubleQuote) { return '"'; }
    if (val == KeyCode.SingleQuote) { return '\''; }
    if (val == KeyCode.Pound) { return '£'; }
    if (val == KeyCode.Dollar) { return '\$'; }
    if (val == KeyCode.Percent) { return '%'; }
    if (val == KeyCode.Caret) { return '^'; }
    if (val == KeyCode.Ampersand) { return '&'; }
    if (val == KeyCode.Asterisk) { return '*'; }
    if (val == KeyCode.Hyphen) { return '-'; }
    if (val == KeyCode.Underscore) { return '_'; }
    if (val == KeyCode.Equals) { return '='; }
    if (val == KeyCode.Plus) { return '+'; }
    if (val == KeyCode.Pipe) { return '|'; }
    if (val == KeyCode.Semicolon) { return ';'; }
    if (val == KeyCode.Colon) { return ':'; }
    if (val == KeyCode.At) { return '@'; }
    if (val == KeyCode.Tilde) { return '~'; }
    if (val == KeyCode.Hash) { return '#'; }
    if (val == KeyCode.Backtick) { return '`'; }
    if (val == KeyCode.ForwardSlash) { return '/'; }
    if (val == KeyCode.BackSlash) { return '\\'; }
    if (val == KeyCode.NormalBracketL) { return '('; }
    if (val == KeyCode.NormalBracketR) { return ')'; }
    if (val == KeyCode.SquareBracketL) { return '['; }
    if (val == KeyCode.SquareBracketR) { return ']'; }
    if (val == KeyCode.CurlyBraceL) { return '{'; }
    if (val == KeyCode.CurlyBraceR) { return '}'; }
    if (val == KeyCode.SmallerThan) { return '<'; }
    if (val == KeyCode.GreaterThan) { return '>'; }
    if (val == KeyCode.Return) { return 'Return'; }
    if (val == KeyCode.Escape) { return 'Escape'; }
    if (val == KeyCode.Backspace) { return 'Backspace'; }
    if (val == KeyCode.Delete) { return 'Delete'; }
    if (val == KeyCode.Tab) { return 'Tab'; }
    if (val == KeyCode.Space) { return 'Space'; }
    if (val == KeyCode.Insert) { return 'Insert'; }
    if (val == KeyCode.Home) { return 'Home'; }
    if (val == KeyCode.End) { return 'End'; }
    if (val == KeyCode.PageUp) { return 'PageUp'; }
    if (val == KeyCode.PageDown) { return 'PageDown'; }
    if (val == KeyCode.ArrowRight) { return 'ArrowRight'; }
    if (val == KeyCode.ArrowLeft) { return 'ArrowLeft'; }
    if (val == KeyCode.ArrowDown) { return 'ArrowDown'; }
    if (val == KeyCode.ArrowUp) { return 'ArrowUp'; }
    if (val == KeyCode.NumpadDivide) { return 'NumpadDivide'; }
    if (val == KeyCode.NumpadMultiply) { return 'NumpadMultiply'; }
    if (val == KeyCode.NumpadSubtract) { return 'NumpadSubtract'; }
    if (val == KeyCode.NumpadAdd) { return 'NumpadAdd'; }
    if (val == KeyCode.NumpadEquals) { return 'NumpadEquals'; }
    if (val == KeyCode.NumpadEnter) { return 'NumpadEnter'; }
    if (val == KeyCode.NumpadDecimalPoint) { return 'NumpadDecimalPoint'; }
    if (val == KeyCode.NumpadOne) { return '1'; }
    if (val == KeyCode.NumpadTwo) { return '2'; }
    if (val == KeyCode.NumpadThree) { return '3'; }
    if (val == KeyCode.NumpadFour) { return '4'; }
    if (val == KeyCode.NumpadFive) { return '5'; }
    if (val == KeyCode.NumpadSix) { return '6'; }
    if (val == KeyCode.NumpadSeven) { return '7'; }
    if (val == KeyCode.NumpadEight) { return '8'; }
    if (val == KeyCode.NumpadNine) { return '9'; }
    if (val == KeyCode.NumpadZero) { return '0'; }
    if (val == KeyCode.Function_F1) { return 'F1'; }
    if (val == KeyCode.Function_F2) { return 'F2'; }
    if (val == KeyCode.Function_F3) { return 'F3'; }
    if (val == KeyCode.Function_F4) { return 'F4'; }
    if (val == KeyCode.Function_F5) { return 'F5'; }
    if (val == KeyCode.Function_F6) { return 'F6'; }
    if (val == KeyCode.Function_F7) { return 'F7'; }
    if (val == KeyCode.Function_F8) { return 'F8'; }
    if (val == KeyCode.Function_F9) { return 'F9'; }
    if (val == KeyCode.Function_F10) { return 'F10'; }
    if (val == KeyCode.Function_F11) { return 'F11'; }
    if (val == KeyCode.Function_F12) { return 'F12'; }
    if (val == KeyCode.LControl) { return 'LControl'; }
    if (val == KeyCode.RControl) { return 'RControl'; }
    if (val == KeyCode.LShift) { return 'LShift'; }
    if (val == KeyCode.RShift) { return 'RShift'; }
    if (val == KeyCode.LAlt) { return 'LAlt'; }
    if (val == KeyCode.RAlt) { return 'RAlt'; }
    if (val == KeyCode.AudioNext) { return 'AudioNext'; }
    if (val == KeyCode.AudioPrev) { return 'AudioPrev'; }
    if (val == KeyCode.AudioStop) { return 'AudioStop'; }
    if (val == KeyCode.AudioPlay) { return 'AudioPlay'; }
    if (val == KeyCode.Unknown) { return 'Unknown'; }
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

enum SDLInitErrorCode {
    Success,
    SDL_InitVideo_Fail,
    SDL_CreateWindow_Fail,
    SDL_CreateRenderer_Fail,
}

SDLInitErrorCode SDLInitErrorCodeFromInt(int val) {
    if (val == 0) { return SDLInitErrorCode.Success; }
    if (val == 1) { return SDLInitErrorCode.SDL_InitVideo_Fail; }
    if (val == 2) { return SDLInitErrorCode.SDL_CreateWindow_Fail; }
    if (val == 3) { return SDLInitErrorCode.SDL_CreateRenderer_Fail; }
    throw Exception('SDLInitErrorCode cannot be converted from int $val: Out of range.');
}

String SDLInitErrorCodeToString(SDLInitErrorCode val) {
    if (val == SDLInitErrorCode.Success) { return 'Success'; }
    if (val == SDLInitErrorCode.SDL_InitVideo_Fail) { return 'SDL_InitVideo_Fail'; }
    if (val == SDLInitErrorCode.SDL_CreateWindow_Fail) { return 'SDL_CreateWindow_Fail'; }
    if (val == SDLInitErrorCode.SDL_CreateRenderer_Fail) { return 'SDL_CreateRenderer_Fail'; }
    // to please the compiler - a human would use a switch statement
    return '';
}

// ----- FFI: GENERATED FUNCTIONS -----


typedef _CreateEventNativeSig = Pointer<Void> Function();

typedef CreateEventSig = Pointer<Void> Function();

CreateEventSig lookupCreateEvent(DynamicLibrary lib) {
    return lib.lookupFunction<_CreateEventNativeSig, CreateEventSig>('CreateEvent');
}


typedef _InitTextRendererNativeSig = Pointer<Void> Function(Pointer<Utf8>, Int32, Pointer<Void>);

typedef InitTextRendererSig = Pointer<Void> Function(Pointer<Utf8>, int, Pointer<Void>);

InitTextRendererSig lookupInitTextRenderer(DynamicLibrary lib) {
    return lib.lookupFunction<_InitTextRendererNativeSig, InitTextRendererSig>('InitTextRenderer');
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


typedef __classcEventGetKeyPressReleaseDataNativeSig = Int32 Function(Pointer<Void>);

typedef _classcEventGetKeyPressReleaseDataSig = int Function(Pointer<Void>);



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
    late _classcEventGetKeyPressReleaseDataSig _GetKeyPressReleaseData;

    cEvent() {
        final lib = getLibrary('Event.c');

        _Poll = lib.lookupFunction<__classcEventPollNativeSig, _classcEventPollSig>('Poll');
        _GetType = lib.lookupFunction<__classcEventGetTypeNativeSig, _classcEventGetTypeSig>('GetType');
        _Destroy = lib.lookupFunction<__classcEventDestroyNativeSig, _classcEventDestroySig>('Destroy');
        _GetResizeData = lib.lookupFunction<__classcEventGetResizeDataNativeSig, _classcEventGetResizeDataSig>('GetResizeData');
        _GetMouseMoveData = lib.lookupFunction<__classcEventGetMouseMoveDataNativeSig, _classcEventGetMouseMoveDataSig>('GetMouseMoveData');
        _GetMousePressReleaseData = lib.lookupFunction<__classcEventGetMousePressReleaseDataNativeSig, _classcEventGetMousePressReleaseDataSig>('GetMousePressReleaseData');
        _GetKeyPressReleaseData = lib.lookupFunction<__classcEventGetKeyPressReleaseDataNativeSig, _classcEventGetKeyPressReleaseDataSig>('GetKeyPressReleaseData');
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

     int GetKeyPressReleaseData() {
        validatePointer('GetKeyPressReleaseData');
        return _GetKeyPressReleaseData(structPointer, );
    }

}


typedef __classcTextDestroyNativeSig = Void Function(Pointer<Void>);

typedef _classcTextDestroySig = void Function(Pointer<Void>);


typedef __classcTextGetErrorCodeNativeSig = Int32 Function(Pointer<Void>);

typedef _classcTextGetErrorCodeSig = int Function(Pointer<Void>);


typedef __classcTextDrawTextNativeSig = Void Function(Pointer<Void>, Pointer<Utf8>, Int32, Int32, Int32, Int32, Int32, Int32);

typedef _classcTextDrawTextSig = void Function(Pointer<Void>, Pointer<Utf8>, int, int, int, int, int, int);



class cText {
    Pointer<Void> structPointer = Pointer.fromAddress(0);

    void validatePointer(String methodName) {
        if (structPointer.address == 0) {
            throw Exception('cText.$methodName was called, but structPointer is a nullptr.');
        }
    }

    late _classcTextDestroySig _Destroy;
    late _classcTextGetErrorCodeSig _GetErrorCode;
    late _classcTextDrawTextSig _DrawText;

    cText() {
        final lib = getLibrary('Text.c');

        _Destroy = lib.lookupFunction<__classcTextDestroyNativeSig, _classcTextDestroySig>('Destroy');
        _GetErrorCode = lib.lookupFunction<__classcTextGetErrorCodeNativeSig, _classcTextGetErrorCodeSig>('GetErrorCode');
        _DrawText = lib.lookupFunction<__classcTextDrawTextNativeSig, _classcTextDrawTextSig>('DrawText');
    }
     void Destroy() {
        validatePointer('Destroy');
        return _Destroy(structPointer, );
    }

     int GetErrorCode() {
        validatePointer('GetErrorCode');
        return _GetErrorCode(structPointer, );
    }

     void DrawText(Pointer<Utf8> text, int x, int y, int r, int g, int b, int alpha) {
        validatePointer('DrawText');
        return _DrawText(structPointer, text, x, y, r, g, b, alpha);
    }

}


typedef __classcRenderWindowLogSDLErrorNativeSig = Void Function(Pointer<Void>, Int32);

typedef _classcRenderWindowLogSDLErrorSig = void Function(Pointer<Void>, int);


typedef __classcRenderWindowDestroyNativeSig = Void Function(Pointer<Void>);

typedef _classcRenderWindowDestroySig = void Function(Pointer<Void>);


typedef __classcRenderWindowGetRendererNativeSig = Pointer<Void> Function(Pointer<Void>);

typedef _classcRenderWindowGetRendererSig = Pointer<Void> Function(Pointer<Void>);


typedef __classcRenderWindowGetErrorCodeNativeSig = Int32 Function(Pointer<Void>);

typedef _classcRenderWindowGetErrorCodeSig = int Function(Pointer<Void>);


typedef __classcRenderWindowUpdateDimensionsNativeSig = Void Function(Pointer<Void>, Int32, Int32);

typedef _classcRenderWindowUpdateDimensionsSig = void Function(Pointer<Void>, int, int);


typedef __classcRenderWindowGetWidthNativeSig = Int32 Function(Pointer<Void>);

typedef _classcRenderWindowGetWidthSig = int Function(Pointer<Void>);


typedef __classcRenderWindowGetHeightNativeSig = Int32 Function(Pointer<Void>);

typedef _classcRenderWindowGetHeightSig = int Function(Pointer<Void>);


typedef __classcRenderWindowSetColourNativeSig = Void Function(Pointer<Void>, Int32, Int32, Int32, Int32);

typedef _classcRenderWindowSetColourSig = void Function(Pointer<Void>, int, int, int, int);


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
    late _classcRenderWindowGetRendererSig _GetRenderer;
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
        _GetRenderer = lib.lookupFunction<__classcRenderWindowGetRendererNativeSig, _classcRenderWindowGetRendererSig>('GetRenderer');
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

     Pointer<Void> GetRenderer() {
        validatePointer('GetRenderer');
        return _GetRenderer(structPointer, );
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

     void SetColour(int r, int g, int b, int alpha) {
        validatePointer('SetColour');
        return _SetColour(structPointer, r, g, b, alpha);
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

