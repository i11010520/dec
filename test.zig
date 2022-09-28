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
        _ = ctx.setRounding(dec.Rounding.DEC_ROUND_UP);
        std.debug.print("after set: {}\n", .{ctx.getRounding()});
    }

    test "set status from string quiet" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        std.debug.print("before set: {}\t", .{ctx.getStatus()});
        _ = ctx.setStatusFromStringQuiet(dec.DEC_Condition.CS);
        std.debug.print("after set: {}\n", .{ctx.getStatus()});
    }

    test "status to string" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        var str = ctx.statusToString();
        std.debug.print("{s}({})\n", .{str, str.len});
    }

    test "test saved status" {
        var res = dec.DecContext.testSavedStatus(1, 0xff);
        std.debug.print("{}\n", .{res});
    }

    test "zero status" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);
        _ = ctx.setStatusFromStringQuiet(dec.DEC_Condition.CS);
        std.debug.print("before zero: {s}\t", .{ctx.statusToString()});
        _ = ctx.zeroStatus();
        std.debug.print("after zero: {}\n", .{ctx.getStatus()});
    }
};

// decNumber
const NUMBER = struct {
    test "from/to int32" {
        const ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        var num = dec.DecNumber.fromInt32(-5);
        var i = num.toInt32(ctx);
        std.debug.print("{}\n", .{i});
    }

    test "from/to uint32" {
        const ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        var num = dec.DecNumber.fromUInt32(5);
        var ui = num.toUInt32(ctx);
        std.debug.print("{}\n", .{ui});
    }

    test "from/to string: int" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        const str = "3000";
        var num = dec.DecNumber.fromString(str, ctx);
        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }

    test "from/to string: bigint" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        const str = "52223339999933";
        var num = dec.DecNumber.fromString(str, ctx);
        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }

    test "from/to string: decimal" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        const str = "0.001";
        var num = dec.DecNumber.fromString(str, ctx);
        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }

    test "from/to string: negative" {
        var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

        const str = "-0.2";
        var num = dec.DecNumber.fromString(str, ctx);
        var str2 = num.toString();
        var str3 = num.toEngString();
        std.debug.print("{s}\t{s}\n", .{str2, str3});
    }
};

test {
    _ = CONTEXT;
    _ = NUMBER;
}