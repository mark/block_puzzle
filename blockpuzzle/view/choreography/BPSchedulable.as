import blockpuzzle.base.BPObject;

class blockpuzzle.view.choreography.BPSchedulable extends BPObject {

    var _isStarted:Boolean;
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
        post("BPStarting");
    }
    
    function isStarted():Boolean {
        return _isStarted;
    }
    
    /************
    *           *
    * Finishing *
    *           *
    ************/
    
    function finish() {
        _isFinished = true;
        post("BPFinishing");
        later(stopListening);
    }
    
    function isFinished():Boolean {
        return _isFinished;
    }
}
