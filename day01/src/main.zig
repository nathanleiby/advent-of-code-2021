const std = @import("std");

const inputPath = "src/input.txt";
const MAX_LINE_LENGTH = 1024;

pub fn main() anyerror!void {
    var file = try std.fs.cwd().openFile(inputPath, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [MAX_LINE_LENGTH]u8 = undefined;

    var numIncreased: i32 = 0;

    // we use -1 as a sentinel value
    // assumption: values in the text input are not == -1
    // TODO: Could try using undefined in zig
    var prev2: i32 = -1;
    var prev1: i32 = -1;
    var cur: i32 = -1;

    var prevWindowSum: i32 = -1;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const val = try std.fmt.parseInt(i32, line, 10);

        // move the window
        prev2 = prev1;
        prev1 = cur;
        cur = val;

        // compute window sum
        var curWindowSum: i32 = -1;
        if (prev2 != -1 and prev1 != -1 and cur != -1) {
            curWindowSum = prev2 + prev1 + cur;
        }

        if (prevWindowSum != -1) {
            if (curWindowSum > prevWindowSum) {
                numIncreased += 1;
            }
        }

        prevWindowSum = curWindowSum;
    }

    std.log.info("num increased: {d}", .{numIncreased});
}
