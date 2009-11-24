import blockpuzzle.model.data.BPDirection;
import blockpuzzle.model.game.BPActor;
import blockpuzzle.controller.event.*;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.pen.*;
import blockpuzzle.view.clock.BPClock;

class blockpuzzle.controller.pen.BPGamePen extends BPPen {
    
    var currentPlayer; // Untyped, to prevent casting issues...
    
    var allowCharacterSwitching:Boolean;
    
    function BPGamePen(controller:BPController) {
        super(controller);
        
        allowCharacterSwitching = true;
        
        setName("play");
        setIsEditorPen(false);
    }
    
    /************************
    *                       *
    * Pen Interface Methods *
    *                       *
    ************************/
    
    function arrow(direction:BPDirection) {
        if (currentPlayer == null) currentPlayer = board().firstPlayer();
        
        var action = new BPMoveAction(currentPlayer, direction).wait();
        
        controller.addToEvent(action);
        
        var didMove:Boolean;
        
        didMove = action.start();
        
        if (didMove) {
            beat();
            
            BPClock.clock.timerNamed("Game").unpause(); // If this is the first action, the timer will have been paused
        }
    }
    
    /*************************
    *                        *
    * Current Player Methods *
    *                        *
    *************************/
    
    function press_space() {
        var nextPlayer = board().nextPlayer(currentPlayer);

        if (allowCharacterSwitching && nextPlayer != currentPlayer){
            //new SelectAction(currentPlayer).post();
            currentPlayer = nextPlayer;                
        }
    }
    
    
}