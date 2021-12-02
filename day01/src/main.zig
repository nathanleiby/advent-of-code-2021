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
    var prev: i32 = -1;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // do something with line...

        const val = try std.fmt.parseInt(i32, line, 10);
        if (prev != -1 and val > prev) {
            numIncreased = numIncreased + 1;
        }
        prev = val;
    }

    std.log.info("num increased: {d}", .{numIncreased});
}
