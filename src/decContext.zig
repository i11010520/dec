const std = @import("std");
const c = @import("env.zig").c;

pub const DEC_Rounding = enum(c.rounding) {
    CEILING = c.DEC_ROUND_CEILING,
    UP = c.DEC_ROUND_UP,
    HALF_UP = c.DEC_ROUND_HALF_UP,
    HALF_EVEN = c.DEC_ROUND_HALF_EVEN,
    HALF_DOWN = c.DEC_ROUND_HALF_DOWN,
    DOWN = c.DEC_ROUND_DOWN,
    FLOOR = c.DEC_ROUND_FLOOR,
    @"05UP" = c.DEC_ROUND_05UP,
    MAX = c.DEC_ROUND_MAX,
};

pub const DEC_INIT_KIND = enum(c_int) {
    BASE = c.DEC_INIT_BASE,
    DECIMAL32 = c.DEC_INIT_DECIMAL32,
    DECIMAL64 = c.DEC_INIT_DECIMAL64,
    DECIMAL128 = c.DEC_INIT_DECIMAL128,
};

pub const DEC_Status = .{
    .CS = c.DEC_Condition_CS,
    .DZ = c.DEC_Condition_DZ,
    .DI = c.DEC_Condition_DI,
    .DU = c.DEC_Condition_DU,
    .IE = c.DEC_Condition_IE,
    .IS = c.DEC_Condition_IS,
    .IC = c.DEC_Condition_IC,
    .IO = c.DEC_Condition_IO,
    .OV = c.DEC_Condition_OV,
    .PA = c.DEC_Condition_PA,
    .RO = c.DEC_Condition_RO,
    .SU = c.DEC_Condition_SU,
    .UN = c.DEC_Condition_UN,
    .ZE = c.DEC_Condition_ZE,
    .MU = c.DEC_Condition_MU,
};

pub const DecContext = struct {
    ctx: c.decContext = undefined,

    const Self = @This();

    pub fn default(kind: DEC_INIT_KIND) Self {
        var dec_ctx: Self = .{};

        _ = c.decContextDefault(
            @ptrCast([*c]c.decContext, &dec_ctx.ctx), 
            @enumToInt(kind)
        );
        dec_ctx.ctx.traps = 0;

        return dec_ctx;
    }

    pub fn clearStatus(self: *Self, mask: u32) *Self {
        _ = c.decContextClearStatus(
            &self.ctx,
            mask
        );

        return self;
    }

    // Trick: set self as pointer, orelse 'cast discards const qualifier' error thrown
    pub fn getRounding(self: *Self) DEC_Rounding {
        var round_int = c.decContextGetRounding(
            &self.ctx
        );

        return @intToEnum(DEC_Rounding, round_int);
    }

    pub fn getStatus(self: Self) u32 {
        return self.ctx.status;
    }

    pub fn restoreStatus(self: *Self, new_sts: u32, mask: u32) *Self {
        _ = c.decContextRestoreStatus(
            &self.ctx,
            new_sts,
            mask
        );
        
        return self;
    }

    pub fn saveStatus(self: *Self, mask: u32) u32 {
        var sts = c.decContextSaveStatus(
            &self.ctx,
            mask
        );

        return sts;
    }

    pub fn setRounding(self: *Self, round: DEC_Rounding) *Self {
        _ = c.decContextSetRounding(
            &self.ctx,
            @enumToInt(round)
        );

        return self;
    }

    pub fn setStatusFromStringQuiet(self: *Self, str: []const u8) *Self {
        _ = c.decContextSetStatusFromStringQuiet(
            &self.ctx,
            @ptrCast([*c]const u8, str)
        );

        return self;
    }

    pub fn setStatusQuiet(self: *Self, sts: u32) *Self {
        _ = c.decContextSetStatusQuiet(
            &self.ctx,
            sts
        );

        return self;
    }

    pub fn statusToString(self: Self) []const u8 {
        const str: [*c]const u8 = c.decContextStatusToString(
            &self.ctx,
        );

        return std.mem.sliceTo(str, 0);
    }

    pub fn testEndian(flag: u8) i32 {
        return c.decContextTestEndian(flag);
    }

    pub fn testSavedStatus(sts: u32, mask: u32) u32 {
        return c.decContextTestSavedStatus(sts, mask);
    }

    pub fn testStatus(self: Self, mask: u32) u32 {
        return c.decContextTestStatus(
            &self.ctx,
            mask
        );
    }

    pub fn zeroStatus(self: *Self) *Self {
        _ = c.decContextZeroStatus(
            &self.ctx
        );

        return self;
    }

};