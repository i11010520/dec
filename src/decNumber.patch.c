#include "decNumber/decNumber-icu-368/decNumber.h"
#include "decNumber/decNumber-icu-368/decContext.h"
#include <string.h>


size_t patchDecNumberToString(const decNumber *num, const char **str) {
    const char *res = decNumberToString(num, (char *)*str);

    return strlen(res);
}

size_t patchDecNumberToEngString(const decNumber *num, const char **str) {
    const char *res = decNumberToEngString(num, (char *)*str);

    return strlen(res);
}