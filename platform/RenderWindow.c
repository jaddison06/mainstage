#include "SDL2/SDL.h"
#include "PlatformErrorCodes.h"
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    SDL_Window *win;
    SDL_Renderer *ren;
    Colour backroundColour;
} RenderWindow;

typedef struct {
    int r, g, b;
} Colour;

typedef struct {
    int x, y;
} Coord2d;

void LogSDLError(RenderWindow *win, int exitCode) {
    printf("SDL error: %s", SDL_GetError());
    if (win->win != NULL) {
        SDL_DestroyWindow(win->win);
    }
    if (win->ren != NULL) {
        SDL_DestroyRenderer(win->ren);
    }
    SDL_Quit();
    exit(exitCode);
}

RenderWindow InitRenderWindow(const char *title, int width, int height, Colour backgroundColour) {
    RenderWindow out;
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        LogSDLError(&out, SDL_InitVideo_Fail);
    }
    out.win = SDL_CreateWindow(title, 100, 100, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
    if (out.win == NULL) {
        LogSDLError(&out, SDL_CreateWindow_Fail);
    }
    out.ren = SDL_CreateRenderer(out.win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (out.ren == NULL) {
        LogSDLError(&out, SDL_CreateRenderer_Fail);
    }

    out.backroundColour = backgroundColour;

    return out;
}

void DestroyRenderWindow(RenderWindow win) {
    SDL_DestroyRenderer(win.ren);
    SDL_DestroyWindow(win.win);
    SDL_Quit();
}

void Flush(RenderWindow win) {
    SDL_RenderPresent(win.ren);
    SetColour(win, win.backroundColour);
    SDL_RenderClear(win.ren);
}

void SetColour(RenderWindow win, Colour colour) {
    SDL_SetRenderDrawColor(win.ren, colour.r, colour.g, colour.b, SDL_ALPHA_OPAQUE);
}

void SetFullscreen(RenderWindow win, bool enable) {
    if (enable) {
        SDL_SetWindowFullscreen(win.win, SDL_WINDOW_FULLSCREEN);
    } else {
        SDL_SetWindowFullscreen(win.win, 0);
    }
}

// todo (jaddison): drawing functions