import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPUndoManager {
	var undos:Array;
	
	static var currentQueue:BPUndoManager;
	
	function BPUndoManager() {
		undos = new Array();
	}
	
	static function undoQueue() {
	    if (currentQueue == null) {
	        currentQueue = new BPUndoManager();
	    }
	    
	    return currentQueue;
	}

	static function setUndoQueue(newQueue:BPUndoManager) {
	    // This doesn't save the undo queue, so you probably want
	    // to save it somewhere when calling this.
	    currentQueue = newQueue;
	}
	
	function undo() {
		if (undos.length == 0) return;
		
		var mostRecent = undos.pop();

		mostRecent.undo();
	}
	
	function post(action:BPAction) {
		undos.push(action);
	}
	
	function depth():Number {
		return undos.length;
	}
	
	function reset() {
		while (depth() > 0) {
			undo();
		}
	}
	
    function set() {
        BPUndoManager.setUndoQueue(this);
    }

}