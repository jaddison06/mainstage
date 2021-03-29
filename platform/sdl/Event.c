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
        case SDL_WINDOWEVENT: if (event->window.event == SDL_WINDOWEVENT_SIZE_CHANGED) { return WindowResize; }
        
        default: return NotImplemented;
    }
}

void Destroy(SDL_Event *event) {
    free(event);
}

// getters for specific event types

void GetResizeData(SDL_Event *event, int *newWidth, int *newHeight) {
    *newWidth = event->window.data1;
    *newHeight = event->window.data2;
}

void GetMouseMoveData(SDL_Event *event, int *x, int *y) {
    *x = event->motion.x;
    *y = event->motion.y;
}

int GetMousePressReleaseData(SDL_Event *event, int *x, int *y) {
    *x = event->button.x;
    *y = event->button.y;
    switch (event->button.button) {
        case SDL_BUTTON_LEFT: return Left;
        case SDL_BUTTON_MIDDLE: return Middle;
        case SDL_BUTTON_RIGHT: return Right;

        default: return Unknown;
    }
}