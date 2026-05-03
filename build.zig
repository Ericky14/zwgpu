const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const translate = b.addTranslateC(.{
        .root_source_file = b.path("include/wgpu.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    translate.addSystemIncludePath(.{ .cwd_relative = "/usr/local/include" });

    const module = translate.createModule();
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/local/include" });
    module.addLibraryPath(.{ .cwd_relative = "/usr/local/lib" });
    module.linkSystemLibrary("wgpu_native", .{});
    module.linkSystemLibrary("gcc_s", .{});
    module.linkSystemLibrary("stdc++", .{});

    // Expose as the package's root module
    b.modules.put(b.allocator, "root", module) catch @panic("OOM");
}
