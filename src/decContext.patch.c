#include "decNumber/decNumber-icu-368/decContext.h"
#include <string.h>


size_t patchDecContextStatusToString(const decContext *context, const char **str) {
    const char *res = decContextStatusToString(context);
    *str = res;

    return strlen(res);
  }
