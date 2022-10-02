const C_DecContext = @import("decContext.map.zig").DecContext;

pub const DECNEG = 0x80;
pub const DECINF = 0x40;
pub const DECNAN = 0x20;
pub const DECSNAN = 0x10;
pub const DECSPECIAL = (DECINF | DECNAN | DECSNAN);

// just support DECDPUN=3, no conditional compilation
pub const DECDPUN = 3;
pub const decNumerUnit = u16;

// 2^32: ~10^10
// 2^128: ~10^39
// pub const DECNUMDIGITS = 15;
// pub const DECNUMUNITS = ((DECNUMDIGITS + DECDPUN - 1)/DECDPUN);

// pub fn calNUMUNITS(digits: u32) u32 {
//     return (digits + DECDPUN - 1)/DECDPUN;
// }

pub const DecNumber = extern struct {
    // length of coefficient, 1 through 999,999,999
    digits: i32,
    // exponent, -999,999,999 to 999,999,999 in general
    exponent: i32,
    // 1 bit for sign, 3 bits for special values, 4 bits reserved
    bits: u8,
    // least significant unit(lsu) first,
    // eash unit is through 0 and 10^DECDPUN-1
    lsu: []decNumerUnit,
};

// Conversions
//   decNumber * decNumberFromInt32(decNumber *, int32_t);
pub extern fn decNumberFromInt32(num: [*c]DecNumber, i: i32) [*c]DecNumber;
//   decNumber * decNumberFromUInt32(decNumber *, uint32_t);
pub extern fn decNumberFromUInt32(num: [*c]DecNumber, ui: u32) [*c]DecNumber;
//   decNumber * decNumberFromString(decNumber *, const char *, decContext *);
pub extern fn decNumberFromString(num: [*c]DecNumber, str: [*c]const u8, ctx: [*c]C_DecContext) [*c]DecNumber;
//   char      * decNumberToString(const decNumber *, char *);
// str, input parameter need allocated
pub extern fn patchDecNumberToString(num: [*c]const DecNumber, str: [*c][*c]const u8) usize;
// pub extern fn decNumberToString(num: [*c]const DecNumber, str: [*c]u8) [*c]u8;
//   char      * decNumberToEngString(const decNumber *, char *);
pub extern fn patchDecNumberToEngString(num: [*c]const DecNumber, str: [*c][*c]const u8) usize;
//   uint32_t    decNumberToUInt32(const decNumber *, decContext *);
pub extern fn decNumberToUInt32(num: [*c]const DecNumber, ctx: [*c]C_DecContext) u32;
//   int32_t     decNumberToInt32(const decNumber *, decContext *);
pub extern fn decNumberToInt32(num: [*c]const DecNumber, ctx: [*c]C_DecContext) i32;
//   uint8_t   * decNumberGetBCD(const decNumber *, uint8_t *);
pub extern fn decNumberGetBCD(num: [*c]const DecNumber, bcd: [*c]u8) [*c]u8;
//   decNumber * decNumberSetBCD(decNumber *, const uint8_t *, uint32_t);
pub extern fn decNumberSetBCD(num: [*c]DecNumber, bcd: [*c]const u8, n: u32) [*c]DecNumber;

// // Operators and elementary functions
//   decNumber * decNumberAbs(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberAdd(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberAnd(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberCompare(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberCompareSignal(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberCompareTotal(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberCompareTotalMag(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberDivide(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberDivideInteger(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberExp(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberFMA(decNumber *, const decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberInvert(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberLn(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberLogB(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberLog10(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberMax(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberMaxMag(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberMin(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberMinMag(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberMinus(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberMultiply(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberNormalize(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberOr(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberPlus(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberPower(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberQuantize(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberReduce(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberRemainder(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberRemainderNear(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberRescale(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberRotate(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberSameQuantum(decNumber *, const decNumber *, const decNumber *);
//   decNumber * decNumberScaleB(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberShift(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberSquareRoot(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberSubtract(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberToIntegralExact(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberToIntegralValue(decNumber *, const decNumber *, decContext *);
//   decNumber * decNumberXor(decNumber *, const decNumber *, const decNumber *, decContext *);

//   /* Utilities                                                        */
//   enum decClass decNumberClass(const decNumber *, decContext *);
//   const char * decNumberClassToString(enum decClass);
//   decNumber  * decNumberCopy(decNumber *, const decNumber *);
//   decNumber  * decNumberCopyAbs(decNumber *, const decNumber *);
//   decNumber  * decNumberCopyNegate(decNumber *, const decNumber *);
//   decNumber  * decNumberCopySign(decNumber *, const decNumber *, const decNumber *);
//   decNumber  * decNumberNextMinus(decNumber *, const decNumber *, decContext *);
//   decNumber  * decNumberNextPlus(decNumber *, const decNumber *, decContext *);
//   decNumber  * decNumberNextToward(decNumber *, const decNumber *, const decNumber *, decContext *);
//   decNumber  * decNumberTrim(decNumber *);
//   const char * decNumberVersion(void);
//   decNumber  * decNumberZero(decNumber *);

//   /* Functions for testing decNumbers (normality depends on context)  */
//   int32_t decNumberIsNormal(const decNumber *, decContext *);
//   int32_t decNumberIsSubnormal(const decNumber *, decContext *);

//   /* Macros for testing decNumber *dn                                 */
//   #define decNumberIsCanonical(dn) (1)  /* All decNumbers are saintly */
//   #define decNumberIsFinite(dn)    (((dn)->bits&DECSPECIAL)==0)
//   #define decNumberIsInfinite(dn)  (((dn)->bits&DECINF)!=0)
//   #define decNumberIsNaN(dn)       (((dn)->bits&(DECNAN|DECSNAN))!=0)
//   #define decNumberIsNegative(dn)  (((dn)->bits&DECNEG)!=0)
//   #define decNumberIsQNaN(dn)      (((dn)->bits&(DECNAN))!=0)
//   #define decNumberIsSNaN(dn)      (((dn)->bits&(DECSNAN))!=0)
//   #define decNumberIsSpecial(dn)   (((dn)->bits&DECSPECIAL)!=0)
//   #define decNumberIsZero(dn)      (*(dn)->lsu==0 \
//                                     && (dn)->digits==1 \
//                                     && (((dn)->bits&DECSPECIAL)==0))
//   #define decNumberRadix(dn)       (10)
