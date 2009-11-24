import blockpuzzle.controller.BPController;

class BPPhaseTable {
    
    var controller:BPController;
    var phases:Object;
    var initalPhase:BPPhase;
    
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
    
    function run() {
        var currentPhase = initialPhase;
        
        do {
            
            currentPhase = currentPhase.nextPhase();
        } while (currentPhase != null);
    }
}