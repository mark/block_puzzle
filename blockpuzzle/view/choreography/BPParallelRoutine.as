import blockpuzzle.view.animation.BPSchedulable;
import blockpuzzle.view.choreography.BPRoutine;

class blockpuzzle.view.choreography.BPParallelRoutine extends BPRoutine {
    
    function BPParallelRoutine() {
        super();
    }
    
    function addAnimations(animations:Array) {
        for (var i = 0; i < animations.length; i++) {
            var animation:BPSchedulable = animations[i];
            
            add(animation);
            startWith(animation);
        }
    }    
    
}