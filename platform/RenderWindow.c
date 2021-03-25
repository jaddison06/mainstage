#include "SDL2/SDL.h"
#include "PlatformErrorCodes.h"
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    int r, g, b;
} Colour;

typedef struct {
    SDL_Window *win;
    SDL_Renderer *ren;
    Colour backgroundColour;
    int errorCode;
} RenderWindow;

typedef struct {
    int x, y;
} Coord2d;

RenderWindow LogSDLError(RenderWindow *win, int exitCode) {
    printf("SDL error: %s\n", SDL_GetError());
    if (win->win != NULL) {
        SDL_DestroyWindow(win->win);
    }
    if (win->ren != NULL) {
        SDL_DestroyRenderer(win->ren);
    }
    SDL_Quit();
    RenderWindow out = {
        errorCode: exitCode
    };
    return out;
}

RenderWindow InitRenderWindow(const char *title, int width, int height, Colour backgroundColour) {
    RenderWindow out;
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        return LogSDLError(&out, SDL_InitVideo_Fail);
    }
    out.win = SDL_CreateWindow(title, 100, 100, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
    if (out.win == NULL) {
        return LogSDLError(&out, SDL_CreateWindow_Fail);
    }
    out.ren = SDL_CreateRenderer(out.win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (out.ren == NULL) {
        return LogSDLError(&out, SDL_CreateRenderer_Fail);
    }

    out.backgroundColour = backgroundColour;

    return out;
}

void DestroyRenderWindow(RenderWindow win) {
    SDL_DestroyRenderer(win.ren);
    SDL_DestroyWindow(win.win);
    SDL_Quit();
}

void SetColour(RenderWindow win, Colour colour) {
    SDL_SetRenderDrawColor(win.ren, colour.r, colour.g, colour.b, SDL_ALPHA_OPAQUE);
}

void Flush(RenderWindow win) {
    SDL_RenderPresent(win.ren);
    SetColour(win, win.backgroundColour);
    SDL_RenderClear(win.ren);
}

void SetFullscreen(RenderWindow win, bool enable) {
    if (enable) {
        SDL_SetWindowFullscreen(win.win, SDL_WINDOW_FULLSCREEN);
    } else {
        SDL_SetWindowFullscreen(win.win, 0);
    }
}

void DrawPoint(RenderWindow win, Coord2d location) {
    SDL_RenderDrawPoint(win.ren, location.x, location.y);
}

void DrawLine(RenderWindow win, Coord2d start, Coord2d end) {
    SDL_RenderDrawLine(win.ren, start.x, start.y, end.x, end.y);
}

SDL_Rect GetSDLRect(Coord2d topLeft, Coord2d bottomRight) {
    SDL_Rect out = {
        x: topLeft.x,
        y: topLeft.y,
        w: bottomRight.x - topLeft.x,
        h: bottomRight.y - topLeft.y
    };
    return out;
}

void DrawRect(RenderWindow win, int x, int y, int w, int h) {
    SDL_Rect rect = {
        x: x,
        y: y,
        w: w,
        h: h
    };
    SDL_RenderDrawRect(win.ren, &rect);
}

void FillRect(RenderWindow win, int x, int y, int w, int h) {
    SDL_Rect rect = {
        x: x,
        y: y,
        w: w,
        h: h
    };
    SDL_RenderFillRect(win.ren, &rect);
}