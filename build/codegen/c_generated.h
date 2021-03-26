#ifndef C_GENERATED_H
#define C_GENERATED_H

// ----- ENUMS -----

enum PlatformErrorCode {
    Success = 0,
    SDL_InitVideo_Fail = 1,
    SDL_CreateWindow_Fail = 2,
    SDL_CreateRenderer_Fail = 3,
};

enum SDLEventType {
    Quit = 0,
    LowMemory = 1,
    KeyDown = 2,
    KeyUp = 3,
    MouseMove = 4,
    MouseDown = 5,
    MouseUp = 6,
    MouseScroll = 7,
    FingerDown = 8,
    FingerUp = 9,
    FingerDrag = 10,
    NotImplemented = 11,
};

#endif // C_GENERATED_H