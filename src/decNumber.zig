const std = @import("std");
const c = @import("env.zig").c;
const DecContext = @import("decContext.zig").DecContext;

const di = c.DECNUMDIGITS;
// TODO: how to determine the magic augend(10 is presumed temporarily)?
const buf_len = di + 10;
pub const DecNumber = struct {
    // Note: set zero as default, refer to decNumberZero()
    num: c.decNumber = .{
        .bits = 0,
        .exponent = 0,
        .digits = 1,
        .lsu = [_]c.decNumberUnit {0} ** c.DECNUMUNITS,
    },

    buf_str: [buf_len]u8 = [_]u8 {0} ** buf_len,
    buf_engstr: [buf_len]u8 = [_]u8 {0} ** buf_len,

    const Self = @This();
    const allocator = std.heap.c_allocator;

    // TODO: decNumberFromString() probably malloc some memory,
    // should free self.num when defering?
    pub fn deinit(_: *Self) void {
    }

    pub fn fromInt32(i: i32) Self {
        var dec_num: Self = .{};

        _ = c.decNumberFromInt32(
            @ptrCast([*c]c.decNumber, &dec_num.num),
            @as(c_int, i)
        );
        
        return dec_num;
    }

    pub fn fromUInt32(ui: u32) Self {
        var dec_num: Self = .{};

        _ = c.decNumberFromUInt32(
            @ptrCast([*c]c.decNumber, &dec_num.num),
            ui
        );

        return dec_num;
    }

    pub fn fromString(str: []const u8, ctx: DecContext) Self {
        var dec_num: Self = .{};

        _ = c.decNumberFromString(
            @ptrCast([*c]c.decNumber, &dec_num.num),
            @ptrCast([*c]const u8, str),
            &ctx.ctx
        );

        return dec_num;
    }

    pub fn toString(self: *Self) []u8 {
        _ = c.decNumberToString(
            @ptrCast([*c]c.decNumber, &self.num),
            &self.buf_str
        );

        return std.mem.sliceTo(&self.buf_str, 0);
    }

    pub fn toEngString(self: *Self) []const u8 {
        _ = c.decNumberToEngString(
            @ptrCast([*c]c.decNumber, &self.num),
            &self.buf_engstr
        );

        return std.mem.sliceTo(&self.buf_engstr, 0);
    }

    pub fn toInt32(self: Self, ctx: *DecContext) i32 {
        const i = c.decNumberToInt32(
            @ptrCast([*c]const c.decNumber, &self.num),
            &ctx.ctx
        );

        return i;
    }

    pub fn toUInt32(self: Self, ctx: *DecContext) u32 {
        const ui = c.decNumberToUInt32(
            @ptrCast([*c]const c.decNumber, &self.num),
            &ctx.ctx
        );

        return ui;
    }

    pub fn abs(self: Self, ctx: *DecContext) Self {
        var res: Self = .{};

        _ = c.decNumberAbs(
            @ptrCast([*c]c.decNumber, &res.num),
            @ptrCast([*c]const c.decNumber, &self.num),
            &ctx.ctx
        );

        return res;
    }

    pub fn add(self: Self, num2: Self, ctx: *DecContext) Self {
        var res: Self = .{};
        
        _ = c.decNumberAdd(
            @ptrCast([*c]c.decNumber, &res.num),
            @ptrCast([*c]const c.decNumber, &self.num),
            @ptrCast([*c]const c.decNumber, &num2.num),
            &ctx.ctx
        );
        
        return res;
    }


    pub fn compare(self: Self, num2: Self, ctx: *DecContext) Self {
        var res: Self = .{};

        _ = c.decNumberCompare(
            @ptrCast([*c]c.decNumber, &res.num),
            @ptrCast([*c]const c.decNumber, &self.num),
            @ptrCast([*c]const c.decNumber, &num2.num),
            &ctx.ctx
        );

        return res;
    }

    pub fn isZero(self: Self) bool {
        // Note: c.decNumberIsZero() that generated from decNumber.h macro is not 
        // so rewrite here refer to the c macro
        return (
            (self.num.lsu[0] == 0) 
            and (self.num.digits == 1)
            and (self.num.bits & c.DECSPECIAL == 0)
        );
    }
};