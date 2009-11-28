import blockpuzzle.controller.game.BPController;

class blockpuzzle.controller.phase.BPPhase extends BPObject {
    
    var name:String;
    var phaseTable:BPPhaseTable;
    
    var options:Object;
    
    // Main Loop elements
    
    var _runCount:Number;
    var _lastRun:Boolean;
    var _nextPhase:BPPhase;
    
    function BPPhase(name:String, options:Object) {
        this.name = name;
        this.options = options;
        this._runCount = 0;
    }
    
    function setPhaseTable(phaseTable:BPPhaseTable) {
        this.phaseTable = phaseTable;
    }
    
    /*********************
    *                    *
    * Controller Methods *
    *                    *
    *********************/
    
    function controller():BPController {
        phaseTable.controller;
    }
    
    function executeOnController(methodName:String) {
        if (methodName == null) return;

        var method = controller()[method];
        
        if (method != null && method instanceof Function) {
            return controller()[methodName](this);
        }
    }
    
    /*********************
    *                    *
    * Transition Methods *
    *                    *
    *********************/
    
    function onEnter() {
        executeOnController( options.enter );
    }
    
    function onRun() {
        _runCount++;
        _lastCall = executeOnController( options.call ) ? true : false;
    }
    
    function onExit() {
        executeOnController( options.exit );
    }
    
    /********************
    *                   *
    * Main Loop Methods *
    *                   *
    ********************/
    
    function firstRun():Boolean {
        return _runCount == 0;
    }
    
    function run() {
        if (firstRun()) {
            onEnter();
        }
        
        onRun();
        determineNextPhase();
        
        if (nextPhase() != this) {
            cleanup();
            onExit();
        }
    }

    function determineNextPhase() {
        var phaseName;
        
        if (options.terminal) {
            _nextPhase = null;
        } else if (_lastCall) {
            phaseName = options.success;
        } else if (_runCount == 1) {
            phaseName = options.failEarly || options.failure;
        } else {
            phaseName = options.failLate || options.failure;
        }
        
        _nextPhase = phaseTable.phaseNamed(phaseName);
    }
    
    function nextPhase():BPPhase {
        return _nextPhase;
    }
    
    function cleanup() {
        runCount = 0;
    }
}