const std = @import("std");
const dec = @import("dec");

pub fn main() !void {
    var ctx = dec.DecContext.default(dec.DEC_INIT_KIND.BASE);

    var css = ctx.statusToString();
    std.debug.print("{s}\n", .{css});

    const sn = "52223339999933";
    var num = dec.DecNumber.fromString(sn, ctx);
    defer num.deinit();

    std.debug.print("before tostring: {any}\n", .{num.buf_str});
    var str = num.toString();
    std.debug.print(
        \\str: (s){s} (any){any} (*): {*}
        \\&str: (any){any} (*){*}
        \\str.ptr: (any){any}
        \\
        , .{
            str, str, str, 
            &str, &str, 
            str.ptr
        });
    var str_eng = num.toEngString();
    std.debug.print("{s}\tstr: {s}\tstr_eng: {s}\n", .{sn, str, str_eng});

    var bcd = num.getBCD();
    std.debug.print("bcd: (s){s}, (any){any}\n", .{bcd, bcd});

    num.deinit();
    std.debug.print("after deinit: {any}\n", .{num.buf_str});

}