// LINKWITHLIB SDL2

#include "SDL2/SDL.h"
#include "build/shared_enums/c_enums.h"
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    SDL_Window *win;
    SDL_Renderer *ren;
    int errorCode;

    int backgroundRed, backgroundGreen, backgroundBlue;
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

void* InitRenderWindow(/*const char *title, */int width, int height, int backgroundRed, int backgroundGreen, int backgroundBlue) {
    RenderWindow* out = (RenderWindow *) malloc(sizeof(RenderWindow));
    const char *title = "test";
    
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        return LogSDLError(out, SDL_InitVideo_Fail);
    }
    out->win = SDL_CreateWindow(title, 100, 100, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
    if (out->win == NULL) {
        return LogSDLError(out, SDL_CreateWindow_Fail);
    }
    out->ren = SDL_CreateRenderer(out->win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (out->ren == NULL) {
        return LogSDLError(out, SDL_CreateRenderer_Fail);
    }

    out->backgroundRed = backgroundRed;
    out->backgroundGreen = backgroundGreen;
    out->backgroundBlue = backgroundBlue;

    out->errorCode = Success;

    return out;
}

void DestroyRenderWindow(RenderWindow *win) {
    SDL_DestroyRenderer(win->ren);
    SDL_DestroyWindow(win->win);
    SDL_Quit();
    free(win);
}

int GetErrorCode(RenderWindow *win) {
    return win->errorCode;
}

void SetColour(RenderWindow *win, int r, int g, int b) {
    SDL_SetRenderDrawColor(win->ren, r, g, b, SDL_ALPHA_OPAQUE);
}

void Flush(RenderWindow *win) {
    SDL_RenderPresent(win->ren);
    SetColour(win, win->backgroundRed, win->backgroundGreen, win->backgroundBlue);
    SDL_RenderClear(win->ren);
}

void SetFullscreen(RenderWindow *win, bool enable) {
    if (enable) {
        SDL_SetWindowFullscreen(win->win, SDL_WINDOW_FULLSCREEN);
    } else {
        SDL_SetWindowFullscreen(win->win, 0);
    }
}

void DrawPoint(RenderWindow *win, int x, int y) {
    SDL_RenderDrawPoint(win->ren, x, y);
}

void DrawLine(RenderWindow *win, int x1, int y1, int x2, int y2) {
    SDL_RenderDrawLine(win->ren, x1, y1, x2, y2);
}

SDL_Rect GetSDLRect(int x1, int y1, int x2, int y2) {
    SDL_Rect out = {
        x: x1,
        y: x2,
        w: x2 - x1,
        h: y2 - y1
    };
    return out;
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

