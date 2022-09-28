
pub const Rounding = enum(c_int) {
    DEC_ROUND_CEILING,
    DEC_ROUND_UP,
    DEC_ROUND_HALF_UP,
    DEC_ROUND_HALF_EVEN,
    DEC_ROUND_HALF_DOWN,
    DEC_ROUND_DOWN,
    DEC_ROUND_FLOOR,
    DEC_ROUND_05UP,
    DEC_ROUND_MAX,
};

pub const DecContext = extern struct {
    digits: i32,
    emax: i32,
    emin: i32,
    round: Rounding,
    traps: u32,
    status: u32,
    clamp: u8,
};

pub const DEC_MAX_DIGITS = 999999999;
pub const DEC_MIN_DIGITS = 1;
pub const DEC_MAX_EMAX = 999999999;
pub const DEC_MIN_EMAX = 0;
pub const DEC_MAX_EMIN = 0;
pub const DEC_MIN_EMIN = -999999999;
pub const DEC_MAX_MATH = 999999;

pub const DecClass = enum {
    DEC_CLASS_SNAN,
    DEC_CLASS_QNAN,
    DEC_CLASS_NEG_INF,
    DEC_CLASS_NEG_NORMAL,
    DEC_CLASS_NEG_SUBNORMAL,
    DEC_CLASS_NEG_ZERO,
    DEC_CLASS_POS_ZERO,
    DEC_CLASS_POS_SUBNORMAL,
    DEC_CLASS_POS_NORMAL,
    DEC_CLASS_POS_INF,
};

pub const DEC_ClassString_SN = "sNaN";
pub const DEC_ClassString_QN = "NaN";
pub const DEC_ClassString_NI = "-Infinity";
pub const DEC_ClassString_NN = "-Normal";
pub const DEC_ClassString_NS = "-Subnormal";
pub const DEC_ClassString_NZ = "-Zero";
pub const DEC_ClassString_PZ = "+Zero";
pub const DEC_ClassString_PS = "+Subnormal";
pub const DEC_ClassString_PN = "+Normal";
pub const DEC_ClassString_PI = "+Infinity";
pub const DEC_ClassString_UN = "Invalid";

pub const DEC_Conversion_syntax = 0x00000001;
pub const DEC_Division_by_zero = 0x00000002;
pub const DEC_Division_impossible = 0x00000004;
pub const DEC_Division_undefined = 0x00000008;
pub const DEC_Insufficient_storage = 0x00000010;
pub const DEC_Inexact = 0x00000020;
pub const DEC_Invalid_context = 0x00000040;
pub const DEC_Invalid_operation = 0x00000080;
pub const DEC_Overflow = 0x00000200;
pub const DEC_Clamped = 0x00000400;
pub const DEC_Rounded = 0x00000800;
pub const DEC_Subnormal = 0x00001000;
pub const DEC_Underflow = 0x00002000;

const DEC_IEEE_754_Invalid_operation = 
            (DEC_Conversion_syntax 
            | DEC_Division_impossible 
            | DEC_Division_undefined 
            | DEC_Insufficient_storage 
            | DEC_Invalid_context 
            | DEC_Invalid_operation);
pub const DEC_Errors = (DEC_Division_by_zero |  DEC_IEEE_754_Invalid_operation | DEC_Overflow | DEC_Underflow);
pub const DEC_NaNs = DEC_IEEE_754_Invalid_operation;

pub const DEC_Information = (DEC_Clamped | DEC_Rounded | DEC_Inexact);

// Name strings for the exceptional conditions                      */
pub const DEC_Condition_CS = "Conversion syntax";
pub const DEC_Condition_DZ = "Division by zero";
pub const DEC_Condition_DI = "Division impossible";
pub const DEC_Condition_DU = "Division undefined";
pub const DEC_Condition_IE = "Inexact";
pub const DEC_Condition_IS = "Insufficient storage";
pub const DEC_Condition_IC = "Invalid context";
pub const DEC_Condition_IO = "Invalid operation";
pub const DEC_Condition_OV = "Overflow";
pub const DEC_Condition_PA = "Clamped";
pub const DEC_Condition_RO = "Rounded";
pub const DEC_Condition_SU = "Subnormal";
pub const DEC_Condition_UN = "Underflow";
pub const DEC_Condition_ZE = "No status";
pub const DEC_Condition_MU = "Multiple status";
pub const DEC_Condition_Length = 21;

pub const DEC_INIT_BASE = 0;
pub const DEC_INIT_DECIMAL32 = 32;
pub const DEC_INIT_DECIMAL64 = 64;
pub const DEC_INIT_DECIMAL128 = 128;
pub const DEC_INIT_DECSINGLE = DEC_INIT_DECIMAL32;
pub const DEC_INIT_DECDOUBLE = DEC_INIT_DECIMAL64;
pub const DEC_INIT_DECQUAD = DEC_INIT_DECIMAL128;

//   extern decContext  * decContextClearStatus(decContext *, uint32_t);
pub extern fn decContextClearStatus(ctx: [*c]DecContext, mask: u32) [*c]DecContext;
//   extern decContext  * decContextDefault(decContext *, int32_t);
pub extern fn decContextDefault(ctx: [*c]DecContext, kind: i32) [*c]DecContext;
//   extern enum rounding decContextGetRounding(decContext *);
pub extern fn decContextGetRounding(ctx: [*c]DecContext) Rounding;
//   extern uint32_t      decContextGetStatus(decContext *);
pub extern fn decContextGetStatus(ctx: [*c]DecContext) u32;
//   extern decContext  * decContextRestoreStatus(decContext *, uint32_t, uint32_t);
pub extern fn decContextRestoreStatus(ctx: [*c]DecContext, new_sts: u32, mask: u32) [*c]DecContext;
//   extern uint32_t      decContextSaveStatus(decContext *, uint32_t);
pub extern fn decContextSaveStatus(ctx: [*c]DecContext, mask: u32) u32;
//   extern decContext  * decContextSetRounding(decContext *, enum rounding);
pub extern fn decContextSetRounding(ctx: [*c]DecContext, round: Rounding) [*c]DecContext;
//   extern decContext  * decContextSetStatus(decContext *, uint32_t);
pub extern fn decContextSetStatus(ctx: [*c]DecContext, sts: u32) [*c]DecContext;
//   extern decContext  * decContextSetStatusFromString(decContext *, const char *);
pub extern fn decContextSetStatusFromString(ctx: [*c]DecContext, str: [*c]const u8) [*c]DecContext;
//   extern decContext  * decContextSetStatusFromStringQuiet(decContext *, const char *);
pub extern fn decContextSetStatusFromStringQuiet(ctx: [*c]DecContext, str: [*c]const u8) [*c]DecContext;
//   extern decContext  * decContextSetStatusQuiet(decContext *, uint32_t);
pub extern fn decContextSetStatusQuiet(ctx: [*c]DecContext, sts: u32) [*c]DecContext;
//   extern const char  * decContextStatusToString(const decContext *);
// str, input parameter no need allocated, cause is global string returned
pub extern fn patchDecContextStatusToString(ctx: [*c]const DecContext, str: [*c][*c]const u8) usize;
//   extern int32_t       decContextTestEndian(uint8_t);
pub extern fn decContextTestEndian(flag: u8) i32;
//   extern uint32_t      decContextTestSavedStatus(uint32_t, uint32_t);
pub extern fn decContextTestSavedStatus(sts: u32, mask: u32) u32;
//   extern uint32_t      decContextTestStatus(decContext *, uint32_t);
pub extern fn decContextTestStatus(ctx: [*c]DecContext, sts: u32) u32;
//   extern decContext  * decContextZeroStatus(decContext *);
pub extern fn decContextZeroStatus(ctx: [*c]DecContext) [*c]DecContext;
