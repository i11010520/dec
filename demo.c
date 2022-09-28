#include <stdio.h>
#include "src/decNumber/decNumber-icu-368/decContext.h"
#include "src/decNumber/decNumber-icu-368/decNumber.h"


int main(int argc, char *argv[]) {
    decContext set;
    decContextDefault(&set, DEC_INIT_BASE);
    // set.traps = 0;

    char *sn = "5222333";
    decNumber big;
    decNumberFromString(&big, sn, &set);
    char str[100];
    decNumberToString(&big, str);
    char str_eng[100];
    decNumberToEngString(&big, str_eng);
    printf("%s: %s, %s\n", sn, str, str_eng);

    if (argc < 4) {
        printf("Please supply three numbers: a b c\n");
        printf("To compare (a + b) and c\n");
        return 1;
    }

    decNumber a, b, s, ab, res;

    decContextDefault(&set, DEC_INIT_BASE);
    set.traps = 0;

    decNumberFromString(&a, "3", &set);
    decNumberFromString(&b, "5", &set);
    decNumberFromString(&s, "6", &set);
    // decNumberFromString(&a, argv[1], &set);
    // decNumberFromString(&b, argv[2], &set);
    // decNumberFromString(&s, argv[3], &set);

    decNumberAdd(&ab, &a, &b, &set);
    decNumberCompare(&res, &ab, &s, &set);

    char *br = decNumberIsZero(&res) ? "true" : "false";
    printf("%s + %s == %s ? %s\n", argv[1], argv[2], argv[3], br);

    return 0;
}