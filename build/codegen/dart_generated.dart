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

