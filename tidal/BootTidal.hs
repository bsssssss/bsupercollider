:set -XOverloadedStrings
:set prompt ""





import qualified Control.Concurrent.MVar as MV

import Sound.Tidal.Context

import System.IO (hSetEncoding, stdout, utf8)

hSetEncoding stdout utf8

:{
    mspTarget = Target {
        oName      = "msp",
        oAddress   = "127.0.0.1",
        oHandshake = False,
        oPort      = 7000,
        oBusPort   = Nothing,
        oLatency   = 0.02,
        oSchedule  = Pre BundleStamp,
        oWindow    = Nothing
        }
    mspFormat = OSC "/msp/play/" $ Named {requiredArgs = ["msp"]}
    msp = pS "msp"
    bus = pI "bus"

    theoTarget = Target {
        oName      = "theo",
        oAddress   = "192.168.1.165",
        oHandshake = False,
        oPort      = 9000,
        oBusPort   = Nothing,
        oLatency   = 0.1,
        oSchedule  = Pre MessageStamp,
        oWindow    = Nothing
        }
    theo = pS "theo"
    addr = pS "addr"
    touchParRoute = OSC "/td/audio/{addr}" $ Named {requiredArgs = ["theo"]}

    oscmap = [(mspTarget, [mspFormat]), (superdirtTarget, [superdirtShape])]
    -- oscmap = [(mspTarget, [mspFormat])]
    -- oscmap = [(superdirtTarget, [superdirtShape])]
:}

tidal <- startStream (defaultConfig {cCtrlAddr = "0.0.0.0"}) oscmap

-- tidal <- startTidal (superdirtTarget {oLatency = 0.1, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cFrameTimespan = 1/20})
-- total latency = oLatency + cFrameTimespan

:{
let only = (hush >>)
    p = streamReplace tidal
    hush = streamHush tidal
    panic = do hush
               once $ sound "superpanic"
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    unmuteAll = streamUnmuteAll tidal
    unsoloAll = streamUnsoloAll tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    getcps = streamGetCPS tidal
    getnow = streamGetNow tidal
:}

:{
let setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
:}

:set prompt "tidal> "
:set prompt-cont ""

default (Pattern String, Integer, Double)

:script tidal/functions-tidal.tidal
:script tidal/functions-superdirt.tidal
:script tidal/functions-msp.tidal
:script tidal/func2.tidal
:script tidal/functions-midi.tidal
