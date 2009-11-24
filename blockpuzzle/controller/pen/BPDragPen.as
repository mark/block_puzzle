import blockpuzzle.model.game.BPPatch;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.pen.*;

class blockpuzzle.controller.pen.BPDragPen extends BPPen { 
    // This really will become BPPen
    
    //var currentDrag:BPDrag
    
    function BPDragPen(controller:BPController) {
        super(controller);
        
        setName("drag");
    }
    
    /********************
    *                   *
    * Basic Pen Methods *
    *                   *
    ********************/
    
   //function up() {
   //    // OVERRIDE THIS!
   //    if (currentDrag) currentDrag.endDrag();
   //    
   //    currentDrag = null;
   //}
   //
   //function move() {
   //    // OVERRIDE THIS!
   //    
   //    if (currentDrag) currentDrag.continueDrag();
   //}
   //
   //function down() {
   //    trace("down() on " + patch());
   //    
   //    currentDrag = new BPDrag(this);
   //}
    
    /***************
    *              *
    * Drag Methods *
    *              *
    ***************/
    
    // function startDrag() {
    //     trace("startDrag() on " + patch());
    // }
    // 
    // function drag() {
    //     trace("drag() on " + patch());
    // }
    // 
    // function endDrag() {
    //     trace("endDrag() on " + patch());
    // }
    
}