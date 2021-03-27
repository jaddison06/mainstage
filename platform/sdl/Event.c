// LINKWITHLIB SDL2

#include "c_codegen.h"
#include "SDL2/SDL.h"

SDL_Event *CreateEvent() {
    return malloc(sizeof(SDL_Event));
}

void Poll(SDL_Event *event) {
    SDL_PollEvent(event);
}

int GetType(SDL_Event *event) {
    switch (event->type) {
        case SDL_QUIT: return Quit;
        case SDL_APP_LOWMEMORY: return LowMemory;
        case SDL_KEYDOWN: return KeyDown;
        case SDL_KEYUP: return KeyUp;
        case SDL_MOUSEMOTION: return MouseMove;
        case SDL_MOUSEBUTTONDOWN: return MouseDown;
        case SDL_MOUSEBUTTONUP: return MouseUp;
        case SDL_MOUSEWHEEL: return MouseScroll;
        case SDL_FINGERDOWN: return FingerDown;
        case SDL_FINGERUP: return FingerUp;
        case SDL_FINGERMOTION: return FingerDrag;
        
        default: return NotImplemented;
    }
}

void Destroy(SDL_Event *event) {
    free(event);
}