
const build_options = @import("build_options");
const di = build_options.DECNUMDIGITS;

// Trick: to avoid symbol collisions
// - use one instance of @cImport
// - @cInclude("decNumber.h") for both decNumber.h and decContext.h
pub const c = @cImport({
    @cDefine("DECNUMDIGITS", di);
    @cInclude("decNumber.h");
});