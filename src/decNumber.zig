const std = @import("std");

const c = @import("decNumber.map.zig");
const DecContext = @import("decContext.zig").DecContext;
const C_DecContext = @import("decContext.map.zig").DecContext;

pub const DecNumber = struct {
    num: c.DecNumber = undefined,

    buf_str: ?[]u8 = null,
    buf_engstr: ?[]u8 = null,
    buf_bcd: ?[]u8 = null,

    const Self = @This();
    const allocator = std.heap.c_allocator;

    pub fn deinit(self: *DecNumber) void {
        if (self.buf_str) |buf| {
            allocator.free(buf);
            self.buf_str = null;
        }
        if (self.buf_engstr) |buf|{
            allocator.free(buf);
            self.buf_engstr = null;
        }
        if (self.buf_bcd) |buf| {
            allocator.free(buf);
            self.buf_bcd = null;
        }
    }

    pub fn fromInt32(i: i32) Self {
        var dec_num: DecNumber = .{
            .num = undefined,
        };
        

        _ = c.decNumberFromInt32(
            @ptrCast([*c]c.DecNumber, &dec_num.num),
            i
        );

        return dec_num;
    }

    pub fn fromUInt32(ui: u32) Self {
        var dec_num: DecNumber = .{
            .num = undefined,
        };

        _ = c.decNumberFromUInt32(
            @ptrCast([*c]c.DecNumber, &dec_num.num),
            ui
        );

        return dec_num;
    }

    pub fn fromString(str: []const u8, ctx: DecContext) Self {
        var dec_num: DecNumber = .{
            .num = undefined,
        };

        _ = c.decNumberFromString(
            @ptrCast([*c]c.DecNumber, &dec_num.num),
            @ptrCast([*c]const u8, str),
            // @ptrCast([*c]C_DecContext, &ctx.ctx)
            &ctx.ctx
        );

        return dec_num;
    }

    pub fn toString(self: *DecNumber) []const u8 {
        if (null == self.buf_str) {
            self.buf_str = allocator.create([c.DECNUMDIGITS+1]u8) catch |err| {
                std.debug.print("{}\n", .{err});
                @panic("c_allocator error\n");
            };
        }

        const len = c.patchDecNumberToString(
            @ptrCast([*c]c.DecNumber, &self.num),
            @ptrCast([*c][*c]const u8, &self.buf_str)
        );

        return self.buf_str.?[0..len];
    }

    pub fn toEngString(self: *DecNumber) []const u8 {
        if (null == self.buf_engstr) {
            self.buf_engstr = allocator.create([c.DECNUMDIGITS+1]u8) catch |err| {
                std.debug.print("{}\n", .{err});
                @panic("c_allocator error\n");
            };
        }

        const len = c.patchDecNumberToEngString(
            @ptrCast([*c]const c.DecNumber, &self.num),
            @ptrCast([*c][*c]const u8, &self.buf_engstr)
        );

        return self.buf_engstr.?[0..len];
    }

    pub fn toUInt32(self: DecNumber, ctx: DecContext) u32 {
        const ui = c.decNumberToUInt32(
            @ptrCast([*c]const c.DecNumber, &self.num),
            &ctx.ctx
        );

        return ui;
    }

    pub fn toInt32(self: DecNumber, ctx: DecContext) i32 {
        const i = c.decNumberToInt32(
            @ptrCast([*c]const c.DecNumber, &self.num),
            &ctx.ctx
        );

        return i;
    }

    pub fn getBCD(self: *DecNumber) []u8 {
        if (null == self.buf_bcd) {
            self.buf_bcd = allocator.create([c.DECNUMDIGITS]u8) catch |err| {
                std.debug.print("{}\n", .{err});
                @panic("c_allocator error\n");
            };
        }

        _ = c.decNumberGetBCD(
            @ptrCast([*c]const c.DecNumber, &self.num),
            @ptrCast([*c]u8, self.buf_bcd.?)
        );
        
        const len = @intCast(usize, self.num.digits);
        return self.buf_bcd.?[0..len];
    }


};