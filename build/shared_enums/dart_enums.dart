enum PlatformErrorCodes {
    Success,
    SDL_InitVideo_Fail,
    SDL_CreateWindow_Fail,
    SDL_CreateRenderer_Fail,
}

PlatformErrorCodes PlatformErrorCodesFromInt(int val) {
    if (val == 0) { return PlatformErrorCodes.Success; }
    if (val == 1) { return PlatformErrorCodes.SDL_InitVideo_Fail; }
    if (val == 2) { return PlatformErrorCodes.SDL_CreateWindow_Fail; }
    if (val == 3) { return PlatformErrorCodes.SDL_CreateRenderer_Fail; }
    throw Exception('PlatformErrorCodes cannot be converted from int $val: Out of range.');
}

