import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.event.*;
import blockpuzzle.model.game.*;

class blockpuzzle.controller.event.BPBoardChangeAction extends BPAction {
    
    var controller:BPController;
    
    var patches:Array;
    
    function BPBoardChangeAction(controller:BPController) {
        this.controller = controller;
        setKey("_BoardChange");
    }

    /**********************
    *                     *
    * Methods to Override *
    *                     *
    **********************/
    
    function handleActor(actor:BPActor) {
        // Override me!
    }
    
    function updateBoard() {
        // Override me!
    }
    
    /*******************
    *                  *
    * BPAction Methods *
    *                  *
    *******************/
    
    function act() {
        var self = this;
        
        board().allActors().each( function(actor) {
            self.handleActor(actor);
        } );
        
        patches = board().clearPatches();
        
        updateBoard();
	    
	    performed = true;
    }
    
    function undo() {
        board().clearPatches();
        
	    for (var y = 0; y < patches.length; y++) {
	        for (var x = 0; x < patches[y].length; x++) {
	            board().attach(old(x, y), x, y);
	        }
	    }
	    
    }

    function animate() {
        // board().display();
    }

    /*****************
    *                *
    * Helper Methods *
    *                *
    *****************/
    
    function board():BPBoard {
        return controller.board();
    }
    
    function old(x:Number, y:Number):BPPatch {
        return patches[y][x];
    }
    
    function oldWidth():Number {
        return patches[0].length;
    }
    
    function oldHeight():Number {
        return patches.length;
    }

}