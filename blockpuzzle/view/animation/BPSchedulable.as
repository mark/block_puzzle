import blockpuzzle.base.BPObject;
import blockpuzzle.view.clock.BPClock;

class blockpuzzle.view.animation.BPSchedulable extends BPObject {

    
    var _isStarted:Boolean;
    var _startTime:Number;
    var _isFinished:Boolean;
    
    function BPSchedulable() {
        _isStarted = false;
        _isFinished = false;
    }
    
    /***********
    *          *
    * Starting *
    *          *
    ***********/
    
    function start() {
        _isStarted = true;
        _startTime = BPClock.clock.now();
        
        post("BPStartAnimation");

        setup();
    }
    
    function isStarted():Boolean {
        return _isStarted;
    }
    
    function setup() {
        // OVERRIDE ME!
    }
    
    /************
    *           *
    * Finishing *
    *           *
    ************/
    
    function finish() {
        _isFinished = true;
        post("BPFinishAnimation");
        
        cleanup();
    }
    
    function cancel() {
        cleanup();
    }
    
    function isFinished():Boolean {
        return _isFinished;
    }
    
    function cleanup() {
        later(stopListening);
    }

}
