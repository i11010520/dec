const std = @import("std");
const dec = @import("dec");

const CONTEXT = struct {
    test "get status" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.DECIMAL64);
        std.debug.print("{}\n", .{ctx.getStatus()});
    }

    test "set status quiet" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        std.debug.print("before set: {}\t", .{ctx.getStatus()});
        _ = ctx.setStatusQuiet(1);
        std.debug.print("after set: {}\n", .{ctx.getStatus()});
    }

    test "test endian" {
        var res:i32 = 1;
        res = dec.DecContext.testEndian(13);
        std.debug.print("{}\n", .{res});
    }

    test "clear status quiet" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        _ = ctx.setStatusQuiet(1);
        std.debug.print("before clear: {}\t", .{ctx.getStatus()});
        _ = ctx.clearStatus(0xff);
        std.debug.print("after clear: {}\n", .{ctx.getStatus()});
    }

    test "get rounding" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        std.debug.print("{}\n", .{ctx.getRounding()});
    }

    test "restore status" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        std.debug.print("before restore: {}\t", .{ctx.getStatus()});
        _ = ctx.restoreStatus(1, 0xff);
        std.debug.print("after restore: {}\n", .{ctx.getStatus()});
    }

    test "save status" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        std.debug.print("before save: {}\t", .{ctx.getStatus()});
        var sts = ctx.saveStatus(0xff);
        std.debug.print("after save: {}, {}\n", .{sts, ctx.getStatus()});
    }

    test "set rounding" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        std.debug.print("before set: {}\t", .{ctx.getRounding()});
        _ = ctx.setRounding(dec.DEC_Rounding.UP);
        std.debug.print("after set: {}\n", .{ctx.getRounding()});
    }

    test "set status from string quiet" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        std.debug.print("before set: {}\t", .{ctx.getStatus()});
        _ = ctx.setStatusFromStringQuiet(dec.DEC_Status.CS);
        std.debug.print("after set: {}\n", .{ctx.getStatus()});
    }

    test "status to string" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        var str = ctx.statusToString();
        std.debug.print("{s} ({})\n", .{str, str.len});
    }

    test "test saved status" {
        var res = dec.DecContext.testSavedStatus(1, 0xff);
        std.debug.print("{}\n", .{res});
    }

    test "zero status" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        _ = ctx.setStatusFromStringQuiet(dec.DEC_Status.CS);
        std.debug.print("before zero: {s}\t", .{ctx.statusToString()});
        _ = ctx.zeroStatus();
        std.debug.print("after zero: {}\n", .{ctx.getStatus()});
    }
};

const NUMBER = struct {
    test "from/to int32" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        var num = dec.DecNumber.fromInt32(-5);
        defer num.deinit();

        var i = num.toInt32(&ctx);
        std.debug.print("{}\n", .{i});
    }

    test "from/to uint32" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        var num = dec.DecNumber.fromUInt32(5);
        defer num.deinit();

        var ui = num.toUInt32(&ctx);
        std.debug.print("{}\n", .{ui});
    }

    test "from/to string: int" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        const str = "3000";
        var num = dec.DecNumber.fromString(str, ctx);
        defer num.deinit();

        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }

    test "from/to string: bigint" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        const str = "52223339999933";
        var num = dec.DecNumber.fromString(str, ctx);
        defer num.deinit();

        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }

    test "from/to string: decimal" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        const str = "0.001";
        var num = dec.DecNumber.fromString(str, ctx);
        defer num.deinit();

        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }

    test "from/to string: negative" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        var num = dec.DecNumber.fromString("-1.21209875677777777777777777777777777777777777777777777777777771", ctx);
        defer num.deinit();

        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }

    test "abs" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        var num = dec.DecNumber.fromString("-1.21209875677777777777777777777777777777777777777777777777777771", ctx);
        defer num.deinit();

        var num2 = num.abs(&ctx);
        var str2 = num2.toString();
        std.debug.print("{s}\n", .{str2});
    }

    test "add/compare" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        var num1 = dec.DecNumber.fromString("0.1", ctx);
        defer num1.deinit();
        var num2 = dec.DecNumber.fromString("0.2", ctx);
        defer num2.deinit();
        var num3 = dec.DecNumber.fromString("0.3", ctx);
        defer num3.deinit();

        var num12 = num1.add(num2, &ctx);
        std.debug.print("num12: {any}\n", .{num12});
        var cmp = num12.compare(num3, &ctx);
        std.debug.print("num12 == num3: {any}\n", .{cmp.isZero()});
    }

    test "try zig stdlib's bigint" {
        const managed = std.math.big.int.Managed;
        const allocator = std.heap.c_allocator;

        var a = try managed.initSet(allocator, 1);
        defer a.deinit();
        var b = try managed.initSet(allocator, 2);
        defer b.deinit();
        var c = try managed.initSet(allocator, 6);
        defer c.deinit();
        var s = try managed.initSet(allocator, 0);
        defer s.deinit();

        try managed.add(&s, @ptrCast(*const managed, &a), @ptrCast(*const managed, &b));
        var iseq = managed.eq(s, c);

        const as = try s.toString(allocator, 10, .lower);
        defer allocator.free(as);

        std.debug.print("{}\t{s}\n", .{iseq, as});
    }
};

test {
    _ = CONTEXT;
    _ = NUMBER;
}
