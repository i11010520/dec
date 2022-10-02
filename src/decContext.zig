const std = @import("std");
const c = @import("decContext.map.zig");

pub const C_DecContext = c.DecContext;
pub const Rounding = c.Rounding;

pub const DEC_INIT_KIND = enum(i32) {
    BASE = 0,
    DECIMAL32 = 32,
    DECIMAL64 = 64,
    DECIMAL128 = 128,
};

pub const DEC_Condition = .{
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
    ctx: c.DecContext,

    const Self = @This();

    pub fn default(kind: DEC_INIT_KIND) Self {
        var dec_ctx: DecContext = .{
            .ctx = undefined,
        };

        _ = c.decContextDefault(
            @ptrCast([*c]c.DecContext, &dec_ctx.ctx), 
            @enumToInt(kind)
        );
        dec_ctx.ctx.traps = 0;

        return dec_ctx;
    }

    pub fn clearStatus(self: *DecContext, mask: u32) *DecContext {
        _ = c.decContextClearStatus(
            @ptrCast([*c]c.DecContext, &self.ctx),
            mask
        );

        return self;
    }

    pub fn getRounding(self: DecContext) Rounding {
        var res = c.decContextGetRounding(
            @ptrCast([*c]c.DecContext, &self.ctx)
        );

        return res;
    }

    pub fn getStatus(self: DecContext) u32 {
        return self.ctx.status;
    }

    pub fn restoreStatus(self: *DecContext, new_sts: u32, mask: u32) *DecContext {
        _ = c.decContextRestoreStatus(
            @ptrCast([*c]c.DecContext, &self.ctx),
            new_sts,
            mask
        );
        
        return self;
    }

    pub fn saveStatus(self: *DecContext, mask: u32) u32 {
        var sts = c.decContextSaveStatus(
            @ptrCast([*c]c.DecContext, &self.ctx),
            mask
        );

        return sts;
    }

    pub fn setRounding(self: *DecContext, round: Rounding) *DecContext {
        _ = c.decContextSetRounding(
            @ptrCast([*c]c.DecContext, &self.ctx),
            round
        );

        return self;
    }

    pub fn setStatusFromStringQuiet(self: *DecContext, str: []const u8) *DecContext {
        _ = c.decContextSetStatusFromStringQuiet(
            @ptrCast([*c]c.DecContext, &self.ctx),
            @ptrCast([*c]const u8, str)
        );

        return self;
    }

    pub fn setStatusQuiet(self: *DecContext, sts: u32) *DecContext {
        _ = c.decContextSetStatusQuiet(
            @ptrCast([*c]c.DecContext, &self.ctx),
            sts
        );

        return self;
    }

    pub fn statusToString(self: DecContext) []const u8 {
        var str: []const u8 = undefined;

        var len = c.patchDecContextStatusToString(
            @ptrCast([*c]c.DecContext, &self.ctx),
            @ptrCast([*c][*c]const u8, &str.ptr)
        );

        return str[0..len];
    }

    pub fn testEndian(flag: u8) i32 {
        var res = c.decContextTestEndian(flag);

        return res;
    }

    pub fn testSavedStatus(sts: u32, mask: u32) u32 {
        var res = c.decContextTestSavedStatus(sts, mask);

        return res;
    }

    pub fn testStatus(self: DecContext, mask: u32) u32 {
        var res = c.decContextTestStatus(
            @ptrCast([*c]c.DecContext, &self.ctx),
            mask
        );

        return res;
    }

    pub fn zeroStatus(self: *DecContext) *DecContext {
        _ = c.decContextZeroStatus(
            @ptrCast([*c]c.DecContext, &self.ctx)
        );

        return self;
    }

};