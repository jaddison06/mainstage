// LINKWITHLIB SDL2

#include "SDL2/SDL.h"
#include "c_codegen.h"
#include <stdio.h>

typedef struct {
    SDL_Window *win;
    SDL_Renderer *ren;
    int errorCode;

    int backgroundRed, backgroundGreen, backgroundBlue;
    
    int frameCount;

    int width, height;
} RenderWindow;

RenderWindow *LogSDLError(RenderWindow *win, int exitCode) {
    printf("SDL error: %s\n", SDL_GetError());
    if (win->win != NULL) {
        SDL_DestroyWindow(win->win);
    }
    if (win->ren != NULL) {
        SDL_DestroyRenderer(win->ren);
    }
    SDL_Quit();

    win->errorCode = exitCode;
    return win;
}

RenderWindow* InitRenderWindow(const char *title, int width, int height, int backgroundRed, int backgroundGreen, int backgroundBlue) {
    RenderWindow* out = (RenderWindow *) malloc(sizeof(RenderWindow));
    
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        return LogSDLError(out, SDLInitErrorCode_SDL_InitVideo_Fail);
    }
    out->win = SDL_CreateWindow(title, 100, 100, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
    if (out->win == NULL) {
        return LogSDLError(out, SDLInitErrorCode_SDL_CreateWindow_Fail);
    }
    out->ren = SDL_CreateRenderer(out->win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (out->ren == NULL) {
        return LogSDLError(out, SDLInitErrorCode_SDL_CreateRenderer_Fail);
    }
    
    out->backgroundRed = backgroundRed;
    out->backgroundGreen = backgroundGreen;
    out->backgroundBlue = backgroundBlue;

    out->errorCode = SDLInitErrorCode_Success;
    out->frameCount = 0;

    out->width = width;
    out->height = height;

    return out;
}

void Destroy(RenderWindow *win) {
    SDL_DestroyRenderer(win->ren);
    SDL_DestroyWindow(win->win);
    SDL_Quit();
    free(win);
}

void *GetRenderer(RenderWindow *win) {
    return win->ren;
}

int GetErrorCode(RenderWindow *win) {
    return win->errorCode;
}

// this does NOT actually change the window - it just stores the dimensions. 
void UpdateDimensions(RenderWindow *win, int width, int height) {
    win->width = width;
    win->height = height;
}

int GetWidth(RenderWindow *win) {
    return win->width;
}

int GetHeight(RenderWindow *win) {
    return win->height;
}

// "c" so we can define a separate SetColour which uses a Dart Colour class
void cSetColour(RenderWindow *win, int r, int g, int b, int alpha) {
    SDL_SetRenderDrawColor(win->ren, r, g, b, alpha);
}

void Flush(RenderWindow *win) {
    SDL_RenderPresent(win->ren);
    cSetColour(win, win->backgroundRed, win->backgroundGreen, win->backgroundBlue, SDL_ALPHA_OPAQUE);
    SDL_RenderClear(win->ren);

    win->frameCount++;
}

int GetFrameCount(RenderWindow *win) {
    return win->frameCount;
}

void SetFullscreen(RenderWindow *win, int enable) {
    if (enable == 1) {
        SDL_SetWindowFullscreen(win->win, SDL_WINDOW_FULLSCREEN);
    } else {
        SDL_SetWindowFullscreen(win->win, 0);
    }
}

void cDrawPoint(RenderWindow *win, int x, int y) {
    SDL_RenderDrawPoint(win->ren, x, y);
}

void DrawLine(RenderWindow *win, int x1, int y1, int x2, int y2) {
    SDL_RenderDrawLine(win->ren, x1, y1, x2, y2);
}

void DrawRect(RenderWindow *win, int x, int y, int w, int h) {
    SDL_Rect rect = {
        x: x,
        y: y,
        w: w,
        h: h
    };
    SDL_RenderDrawRect(win->ren, &rect);
}

void FillRect(RenderWindow *win, int x, int y, int w, int h) {
    SDL_Rect rect = {
        x: x,
        y: y,
        w: w,
        h: h
    };
    SDL_RenderFillRect(win->ren, &rect);
}