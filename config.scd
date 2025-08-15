(
postln("Starting config...");

Buffer.freeAll;
postln("Buffers freed");

ServerTree.removeAll;
postln("ServerTree cleared");

ServerQuit.removeAll;
postln("ServerQuit cleared");

Tdef.removeAll;
postln("Tdefs cleared");

s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;
postln("Server options set");

p = ProxySpace.push(s);
postln("ProxySpace pushed");

p.makeTempoClock;
p.clock.tempo_(120 / 60);
p.fadeTime_(2.5);
p.quant_(2.5);
postln("ProxySpace clock set");



s.waitForBoot({
    postln("Server booted");

    d = Dictionary.new;
    d.add(\folders -> PathName(thisProcess.nowExecutingPath.dirname ++ "/samples").entries);
    postln("Samples folder entries read");

    (
        for (0, d[\folders].size - 1,
            { |i|
                d.add(d[\folders][i].folderName -> d[\folders][i].entries.collect({
                    |sf|
                    Buffer.read(s, sf.fullPath);
                }));
            });
    );
    postln("Buffers loaded from samples");

    s.sync;
    postln("Synced after loading buffers");

    ("synths.scd").loadRelative;
    postln("synths.scd loaded");
    s.sync;

    ("mySnippets.scd").loadRelative;
    postln("mySnippets.scd loaded");
    s.sync;

    StageLimiter.activate;
    postln("StageLimiter activated");
    s.sync;

    s.freeAll;
    postln("Server freed all nodes");
});

postln("Config execution finished")  // no semicolon here
)

