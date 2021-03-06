import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.BPMessage;
import blockpuzzle.model.collection.BPSet;
import blockpuzzle.view.animation.BPSchedulable;

class blockpuzzle.view.choreography.BPChannel extends BPObject {
    
    var waiting: BPSet;
    var active:  BPSet;
    var finished:BPSet;
    
    var timePaused:Number;
    
    function BPChannel() {
        waiting  = new BPSet();
        active   = new BPSet();
        finished = new BPSet();
    }

    /******************************
    *                             *
    * Adding Schedulable Elements *
    *                             *
    ******************************/
    
    function add(schedulable:BPSchedulable) {
        if (schedulable.isFinished()) {
            finished.insert( schedulable );
        } else if (schedulable.isStarted()) {
            active.insert( schedulable );
            listenFor("BPFinishAnimation", schedulable, animationFinished);
        } else {
            waiting.insert( schedulable );
            listenFor("BPStartAnimation",  schedulable, animationStarted );
            listenFor("BPFinishAnimation", schedulable, animationFinished);
        }
    }

    /******************************
    *                             *
    * Keeping Track of Animations *
    *                             *
    ******************************/
    
    function animationStarted(message:BPMessage) {
        var schedulable = message.source;
        
        waiting.remove(schedulable);
        active.insert(schedulable);
    }
    
    function animationFinished(message:BPMessage) {
        var schedulable = message.source;
        
        active.remove(schedulable);
        finished.insert(schedulable);
        
        post("BPChannelAnimationFinished", schedulable);
        
        if (waiting.isEmpty() && active.isEmpty()) {
            post("BPChannelClear")
        }
    }
    
    /************************
    *                       *
    * Retrieving Animations *
    *                       *
    ************************/
    
    function getAnimation(id:Number):BPSchedulable {
        var animation:BPSchedulable;
        
        animation = waiting.fetch(id);
        if (animation) return animation;
        
        animation = active.fetch(id);
        if (animation) return animation;

        animation = finished.fetch(id);
        return animation;
    }
    
    function waitingAnimations():BPSet {
        return waiting;
    }
    
    function activeAnimations():BPSet {
        return active;
    }
    
    function finishedAnimations():BPSet {
        return finished;
    }
    
    /*******************
    *                  *
    * Pause and Resume *
    *                  *
    *******************/
    
    function pause() {
        
    }
    
    function resume() {
        
    }

}