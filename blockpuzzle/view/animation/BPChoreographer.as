import blockpuzzle.base.BPObject;
import blockpuzzle.controller.event.*;
import blockpuzzle.controller.mailbox.*;
import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPChoreographer extends BPObject {
    
    var event:BPEvent;    
    var nextIndex:Number;
    
    // Keeping track of different stages
    static var nextId = 0;
    var id:Number;
    
    /*  NOTES:
    
        I would also like to include some sort of table of object -> latest animation
    */
    
    function BPChoreographer(event:BPEvent) {
        this.id = nextId++;

        this.event = event;
        this.nextIndex = 0;

        choreographAction(event.originalCause());

        listenForAny("BPStartOfChoreography", cancel);

        post("BPStartOfChoreography");
        
        event.originalCause().animation().later("start");
    }

    function choreographAction(cause:BPAction) {
        var actionKey = cause.key();

        BPMailbox.mailbox.listenFor("BPCancelAnimation", this, cause.animation(), cause.animation().cancel);
        // cause.animation().listenFor("BPCancelAnimation", this, cause.animation().cancel);
        
        for (var i = 0; i < cause.effects.length; i++) {
            var effect = cause.effects[i];
            
            if (! effect.failed) {
                var effectKey = effect.key();
                var fcn:Function;

                if (fcn == null) fcn = this["arrange" + effectKey + "CausedBy" + actionKey];
                if (fcn == null) fcn = this["arrangeActionCausedBy" + actionKey];
                if (fcn == null) fcn = this["arrange" + effectKey];
                if (fcn == null) fcn = this["arrangeActions"];

                var choreographyType = fcn(cause, effect);

                //var choreographyType = callCascade( ["arrange" + effectKey + "CausedBy" + actionKey, "arrangeActionCausedBy" + actionKey,
                //                                     "arrange" + effectKey, "arrangeActions"], [cause, effect] );

                this[choreographyType + "Choreography"](cause.animation(), effect.animation());

                choreographAction(effect);
            }
        }
    }
    
    function cancel(message:BPMessage) {
        if (this != message.source){
            //post("BPCancelAnimation");
            stopListening();
        }
    }
    
    /************************
    *                       *
    * Built-In Arrangements *
    *                       *
    ************************/
    
    function arrangeMoveCausedByMove(cause:BPBehavior, effect:BPBehavior):String {
        return (cause.actor() == effect.actor()) ? "serial" : "parallel";
    }
    
    function arrangeDisableCausedByMove(move:BPMoveAction, disable:BPDisableAction) {
        return (move.actor() == disable.actor) ? "serial" : "parallel";
    }
    
    function arrangeActions(cause:BPAction, effect:BPAction):String {
        return "parallel";
    }

    /************************
    *                       *
    * Built-In Choreography *
    *                       *
    ************************/

    function serialChoreography(cause:BPAnimation, effect:BPAnimation) {
        //trace(">\n> " + effect + ".startWhenAnimationEnds(" + cause + ")\n>")
        effect.startWhenAnimationEnds(cause);
    }

    function parallelChoreography(cause:BPAnimation, effect:BPAnimation) {
        //trace(">\n> " + effect + ".startWhenAnimationStarts(" + cause + ")\n>")
        effect.startWhenAnimationStarts(cause);
    }

}