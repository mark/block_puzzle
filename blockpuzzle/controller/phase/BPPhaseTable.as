import blockpuzzle.controller.game.BPController;

class blockpuzzle.controller.phase.BPPhaseTable extends BPObject {
    
    var controller:BPController;
    var phases:Object;
    var initalPhase:BPPhase;
    
    // Main Loop elements
    
    var __currentPhase:BPPhase;
    
    function BPPhaseTable(controller:BPController) {
        this.controller = controller;
        this.phases = new Object();
    }
    
    /****************
    *               *
    * Phase Methods *
    *               *
    ****************/
    
    function addPhase(phase:BPPhase) {
        var name = phase.name;
        phases[name] = phase;
        phase.setPhaseTable(this);
        
        if (phase.initial) {
            initialPhase = phase;
        }
    }
    
    function phaseNamed(name:String):BPPhase {
        return phases[name];
    }

    /****************
    *               *
    * Main Run Loop *
    *               *
    ****************/
    
    function mainLoop() {
        if (__currentPhase == null) __currentPhase = initialPhase;

        __currentPhase.run();
        var transition = __currentPhase.transition();
        __currentPhase = __currentPhase.nextPhase();

        if (transition == BPPhase.STOP) {
            // Do nothing... loop execution stops...
        } else if (transition == BPPhase.IMMEDIATE) {
            later('mainLoop');
        } else {
            var nextPhaseTimer = new BPTimer("Main Loop Timer", transition);
            listenFor("BPTimerStop", nextPhaseTimer, mainLoop);
        }
    }

}