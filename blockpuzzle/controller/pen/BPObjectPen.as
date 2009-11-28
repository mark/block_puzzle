import blockpuzzle.model.game.BPActor;
import blockpuzzle.controller.event.*;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.pen.*;

class blockpuzzle.controller.pen.BPObjectPen extends BPPen {
    
    var object:BPActor; // What object this pen is currently holding.

    var newObject:Boolean; // Is this a newly created object? (did it have to be added to the pen manually?)
    var dragOn:Boolean;    // Is the current object being dragged?
    
	var currentAction:BPAction; // What the action started as
	
    function BPObjectPen(controller:BPController) {
        super(controller);
        
        setName("actor");
    }
    
    function selection() {
        return controller.currentSelection;
    }
    
    function attachActor(object:BPActor) {
        this.object = object;
        object.display(grid());
        
        object.sprite().goto([_xmouse, _ymouse]);
        object.startDrag();
        this.newObject = true;
        this.dragOn = true;
    }
    
	function detatchActor() {
		object.stopDrag();
		this.object = null;
		this.newObject = false;
		this.dragOn = false;
	}
	
	/********************
	*                   *
	* respondTo Methods *
	*                   *
	********************/
	
	function grabHand() {}

    // When you create an object from a button, use this to manually add it to the pen
    function addActor(key:String, options:Object) {
        var actorController = controller.actorControllerFor(key, options);
        var actor = actorController.loadActor(board(), options);
        //trace("addActor('" + key + "') => " + actor.sprite());
        
        attachActor(actor);
        
        currentAction = new BPAddAction(object).wait(true);
		currentAction.causes(new BPSelectionAction(controller));
    }

    function actorDrag(dragObject:BPDragObject) {
        //dragObject.attach();        
    }
    
    function endDrag(mouseEvent:BPMouseEvent) {
        var actorController = controller.actorControllerFor(mouseEvent.dragObject.dragKey); //, options);
        var actor = actorController.loadActor(board()); //, options);

        currentAction = new BPAddAction(object).wait(true);
		currentAction.causes(new BPSelectionAction(controller));
		currentAction.start();
    }
    
    /********************
    *                   *
    * Interface Actions *
    *                   *
    ********************/
    
    function down() {
        var obj = board().allActors().thatAreAt(patch()).theFirst();
        
        if (obj != null) {
            object = obj;
            this.newObject = false;

			currentAction = new BPSelectionAction(controller).wait(true);
        }
    }
    
    function move() {
        if (isOnBoard()) {
            if (object != null) {
                currentAction.causes(new BPPlaceAction(object, patch()));
            }
            
            if (dragOn) {
                dragOn = false;
                object.stopDrag();
            }
        } else {
            if (object != null) {
                if (! dragOn) {
                    dragOn = true;
                    object.startDrag();
                }
            }
        }
    }

    function up() {
        if (currentAction == null) return;
        
        if (isOnBoard()) {
			//currentAction.causes(new BPPlaceAction(object, patch()));

			currentAction.start();
			currentAction = null;
			detatchActor();
        } else {
            // Should this depend on whether it is a new object or not?
			currentAction.causes(new BPDestroyAction(object));

			currentAction.start();
			currentAction = null;
			detatchActor();
        }
        
        dragOn = false;
        newObject = false;
    }

}
