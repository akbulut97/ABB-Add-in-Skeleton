MODULE AddinMain
    CONST speeddata vSetup:=\Speed:=100, \Zone:=fine;
    CONST jointtarget jtHome:=[[0,0,0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PROC AddinGoHome()
        MoveAbsJ jtHome, vSetup, fine, tool0;
        TPWrite "YOUR_ADDIN_NAME: robot at home.";
    ENDPROC

    PROC AddinDemoCycle()
        AddinGoHome;
        WaitUntil diAddinStart=1;
        PulseDO\PLength:=1, doAddinReady;
        TPWrite "YOUR_ADDIN_NAME: handshake complete.";
    ENDPROC
ENDMODULE
