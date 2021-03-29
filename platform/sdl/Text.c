// LINKWITHLIB SDL2
// LINKWITHLIB SDL2_ttf

#include "SDL2/SDL_ttf.h"
#include "c_codegen.h"

typedef struct {
    TTF_Font *font;
    SDL_Texture *textTexture;
    SDL_Renderer *renderer;
    int errorCode;
} TextRenderer;

TextRenderer *InitTextRenderer(const char *fontFile, int fontSize, SDL_Renderer *renderer) {
    if (!TTF_WasInit()) { TTF_Init(); }
    TextRenderer *out = malloc(sizeof(TextRenderer));
    out->font = TTF_OpenFont(fontFile, fontSize);
    if (out->font == NULL) {
        out->errorCode = TextInitErrorCode_FontInitFailed;
        return out;
    }

    out->errorCode = TextInitErrorCode_Success;

    return out;
}

void Destroy(TextRenderer *renderer) {
    TTF_Quit();
    free(renderer);
}

int GetErrorCode(TextRenderer *renderer) {
    return renderer->errorCode;
}

void DrawText(TextRenderer *renderer, const char *text, int x, int y, int r, int g, int b, int alpha) {
    SDL_Color textCol = {r, g, b, alpha};
    SDL_Surface *textSurface = TTF_RenderText_Solid(renderer->font, text, textCol);
    renderer->textTexture = SDL_CreateTextureFromSurface(renderer->renderer, textSurface);

    SDL_Rect textRect;
    textRect.x = x;
    textRect.y = y;
    textRect.w = textSurface->w;
    textRect.h = textSurface->h;

    SDL_FreeSurface(textSurface);
    
    SDL_RenderCopy(renderer->renderer, renderer->textTexture, NULL, &textRect);
    
    SDL_DestroyTexture(renderer->textTexture);
}