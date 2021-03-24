#ifndef PLATFORM_ERROR_CODES_H
#define PLATFORM_ERROR_CODES_H

enum PlatformErrorCodes {
    Success = 0,
    SDL_InitVideo_Fail = 1,
    SDL_CreateWindow_Fail = 2,
    SDL_CreateRenderer_Fail = 3
};

#endif // PLATFORM_ERROR_CODES_H