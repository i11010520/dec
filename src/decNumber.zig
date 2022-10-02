const std = @import("std");

const c = @import("decNumber.map.zig");
const DecContext = @import("decContext.zig").DecContext;
const C_DecContext = @import("decContext.map.zig").DecContext;

pub const DecNumber = struct {
    num: c.DecNumber = undefined,

    buf_str: ?[]u8 = null,
    buf_engstr: ?[]u8 = null,
    buf_len: u32 = 0,

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
    }

    pub fn fromInt32(i: i32) Self {
        const digits = 10;
        const buf_len = digits + 14;

        var dec_num: DecNumber = .{
            .buf_len = buf_len
        };
        _ = c.decNumberFromInt32(
            @ptrCast([*c]c.DecNumber, &dec_num.num),
            i
        );

        return dec_num;
    }

    pub fn fromUInt32(ui: u32) Self {
        const digits = 10;
        const buf_len = digits + 14;

        var dec_num: DecNumber = .{
            .buf_len = buf_len
        };
        _ = c.decNumberFromUInt32(
            @ptrCast([*c]c.DecNumber, &dec_num.num),
            ui
        );

        return dec_num;
    }

    pub fn fromString(str: []const u8, ctx: DecContext) Self {
        const digits = @intCast(u32, str.len);
        const buf_len = digits + 14;

        var dec_num: DecNumber = .{
            .buf_len = buf_len
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
            self.buf_str = allocator.alloc(u8, self.buf_len) catch |err| {
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
            self.buf_engstr = allocator.alloc(u8, self.buf_len) catch |err| {
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


};