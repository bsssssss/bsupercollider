(
a = NetAddr.new("localhost", 7000); //your osc port
OSCdef(\tidalplay, {
    arg msg;
    a.sendMsg(*msg);
}, '/dirt/play', n);
)