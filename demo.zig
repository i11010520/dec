const std = @import("std");
const dec = @import("dec");

pub fn main() !void {
    var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

    var css = ctx.statusToString();
    std.debug.print("{s}\n", .{css});

    const sn = "52223339999933";
    var num = dec.DecNumber.fromString(sn, ctx);
    // var num = dec.DecNumber.fromInt32(5000);
    defer num.deinit();

    std.debug.print("before tostring: {any}\n", .{num.buf_str});
    var str = num.toString();
    std.debug.print(
        \\str: (s){s} (any){any} (*){*}
        \\&str: (any){any} (*){*}
        \\str.ptr: (any){any}
        \\
        , .{
            str, str, str, 
            &str, &str, 
            str.ptr
        });
    var str_eng = num.toEngString();
    std.debug.print("str: {s}\tstr_eng: {s}\n", .{str, str_eng});

    // ctx.traps is 0, so no error
    var ni = num.toInt32(ctx);
    std.debug.print("toint32: {}\n", .{ni});

    num.deinit();
    std.debug.print("after deinit: {any}\n", .{num.buf_str});

}