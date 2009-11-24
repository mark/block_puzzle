import blockpuzzle.base.BPObject;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.event.BPUndoManager;
import blockpuzzle.controller.pen.*;
import blockpuzzle.model.data.BPDirection;
import blockpuzzle.model.game.*;
import blockpuzzle.view.gui.*;

class blockpuzzle.controller.pen.BPPen extends BPObject {

    var allowUndos:Boolean; // Do the normal keys for undo work?
    
    var controller:BPController;
    
    var penName:String; // How thehe controller refers to this pen
    var editorPen:Boolean; // Is this an editor pen (depends on which undo queue it uses)
    
    function BPPen(controller:BPController) {
        this.controller = controller;
        
		allowUndos = true;
		
		setIsEditorPen(true);
		
		controller.registerPen(this);
    }

    /***************
    *              *
    * Name methods *
    *              *
    ***************/
    
    function setName(penName:String) {
        this.penName = penName;
    }
    
    function name() {
        return penName;
    }
    
    /***************
    *              *
    * Grid Methods *
    *              *
    ***************/
    
	function board():BPBoard {
		return controller.board();
	}

    function grid():BPGrid {
        return controller.grid();
    }
    
    function geometry():BPGeometry {
        return grid().geometry();
    }
    
    /**************
    *             *
    * Editor pen? *
    *             *
    **************/
    
    function setIsEditorPen(editorPen:Boolean) {
        this.editorPen = editorPen;
    }
    
    function isEditorPen() {
        return editorPen;
    }
    
	/**********************
	*                     *
	* Up and Down methods *
	*                     *
	**********************/

    function set() {
        Key.addListener(this);
        //Mouse.addListener(this);
        controller.showBank(name() + " Buttons");
        onSet();
    }

    function unset() {
	    Key.removeListener(this);
	    Mouse.removeListener(this);
        controller.hideBank(name() + " Buttons");
	    onUnset();
    }

    function onSet() {
        // OVERRIDE THIS!
    }
    
    function onUnset() {
        // OVERRIDE THIS!
    }
    
	/****************
	*               *
	* Mouse methods *
	*               *
	****************/
	
	// These may go away?  I know at least that right now they're shortcuts to the mouse event stuff.
	
	function x():Number {
		return mouse().patch().x();
	}
	
	function y():Number {
		return mouse().patch().y();
	}
	
	function isOnBoard():Boolean {
		//var locX = x();
		//var locY = y();
        //
		//return locX >= 0 && locY >= 0 && locX < board().width() && locY < board().height();
		return true; // Not sure how to handle this right now--it might not even be necessary?
	}
	
	function patch():BPPatch {
		return mouse().patch();
	}
	
	function actor():BPActor {
		return board().allActors().thatAreAt(patch()).theFirst();
	}

	/********************
	*                   *
	* Basic Pen Actions *
	*                   *
	********************/
	
	function beat() {
        controller.beat();
	}

    function up() {
        // OVERRIDE THIS!
    }

    function down() {
        // OVERRIDE THIS!
    }

    function startDrag() {
        
    }
    
    function drag() {
        // OVERRIDE THIS!
    }

    function endDrag() {
        
    }

    function cancelDrag() {
        // OVERRIDE THIS!
    }
    
    function press(char:String) {
        // OVERRIDE THIS!
    }
    
    function arrow(direction:BPDirection) {
        // OVERRIDE THIS!
    }
    
    function press_space() {        
        // OVERRIDE THIS!
    }
    
    function press_cmd() {
        // OVERRIDE THIS!
    }

    /***************
    *              *
    * Undo methods *
    *              *
    ***************/

    function press_Z() {
        if (allowUndos) BPUndoManager.undoQueue().undo();
    }
    
    function press_z() {        
        if (allowUndos) BPUndoManager.undoQueue().reset();
    }
    
    /****************************************
    *                                       *
    * MouseListener and KeyListener methods *
    *                                       *
    ****************************************/

    function onKeyDown() {
    	var keyCode = Key.getCode(); // get key code
        var keyChar = String.fromCharCode(Key.getAscii());        

        // For character keys
        
        var keyFunction = null;
        
        if (keyFunction == null) keyFunction = this["press_" + keyChar];
        if (keyFunction == null) keyFunction = this["press_" + keyChar.toUpperCase() + keyChar.toLowerCase()];
        if (keyFunction == null) keyFunction = this.press;

        if (keyFunction) keyFunction.call(this, keyChar);

        // For non-character keys
        
        if (keyCode > 36 && keyCode < 41) {
            arrow(BPDirection.getDirection(keyCode));
        }
        
        if (keyCode == 32) {
            press_space();
        }
        
        if (keyCode == 17) {
            press_cmd();
        }
    }

    function toXml(current:Boolean):String {
        var s = "<pen"

        s += " class='" + className(null, true).join('.') + "'";
        s += " name='" + name() + "'";
        s += current ? " default='true'" : "";
        s += " />\n";
        
        return s;
    }
    
    static function loadFromXml(controller:BPController, xml:XML) {
        var classPath = xml.attributes['class'].split('.');
        var klass = BPObject.classWithName(classPath);
        var pen = new klass(controller);
        
        if (xml.attributes['default']) {
            controller.switchToPen(pen.name());
        }
        
        return pen;
    }

}