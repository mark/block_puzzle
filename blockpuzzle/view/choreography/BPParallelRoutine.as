import blockpuzzle.view.animation.BPSchedulable;
import blockpuzzle.view.animation.BPRoutine;

class BPParallelRoutine extends BPRoutine {
    
    function BPParallelRoutine() {
        super();
    }
    
    function addAnimations() {
        for (var i = 0; i < arguments.length; i++) {
            var animation:BPSchedulable = arguments[i];
            
            add(animation);
            startWith(animation);
        }
    }
    
}