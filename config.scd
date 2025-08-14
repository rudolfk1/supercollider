(

Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;


s.options.numBuffers = 1024* 16;
s.options.memSize = 8192* 128;


p = ProxySpace.push(s);
p.makeTempoClock;
p.clock.tempo_(120/60);
p.fadeTime_(2.5);
p.quant_(2.5);

/*
MDDIClient.init;
MDDIn.connectAll;
*/


s.waitForBoot({
d = Dictionary.new; 
d.add(\folders -> PathName(thisProcess.nowExecutingPath.dirname ++ "/samples").entries);
(
for(0, d[\folders].size -1,
    { |i| d.add(d[\folders][i].folderName -> d[\folders][i].entries.collect({
    |sf| 
    Buffer.read(s, sf.fullPath);
});
)});
);

s.sync;
("synths.scd").loadRelative;
s.sync;
("mySnippets.scd").loadRelative;
s.sync;
StageLimiter.activate;
s.sync;
s.freeAll;
})
)
