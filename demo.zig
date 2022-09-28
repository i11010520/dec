const std = @import("std");
const dec = @import("dec");

pub fn main() !void {
    var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

    var css = ctx.statusToString();
    std.debug.print("{s}\n", .{css});

    const sn = "52223339999933";
    var num = dec.DecNumber.fromString(sn, ctx);
    // var ui = num.toUInt32(ctx);
    var str = num.toString();
    var str_eng = num.toEngString();
    std.debug.print("{s}: {s}\t{s}\n", .{sn, str, str_eng});
    // std.debug.print("{s}: {} {s}\t{s}\n", .{sn, ui, str, str_eng});

}