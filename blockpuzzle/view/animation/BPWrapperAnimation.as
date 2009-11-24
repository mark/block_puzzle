import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPWrapperAnimation extends BPAnimation {
    
    var children:Array;
    var activeChildCount:Number;
    
    function BPWrapperAnimation(children:Array) {
        consistsOf( children );
    }
 
    function setChildren(children:Array) {
        if (this.children == null) {
            this.children = children;
            this.activeChildCount = 0;
            
            for (var i = 0; i < children.length; i++) {
                children[i].startWhenAnimationStarts(this);
                children[i].endWhenAnimationEnds(this);
                listenFor("BPAnimationStop", children[i], childEnded);
                
                if (! children[i].isContinuous()) activeChildCount++;
            }
        }
        
    }
    
    function consistsOf(child) {
        if (child == null)
            return;
        else if (arguments.length == 1 && arguments[0] instanceof Array)
            setChildren( arguments[0] );
        else if (arguments.length > 0)
            setChildren( arguments );
    }
    
    function childEnded() {
        activeChildCount--;
        
        if (activeChildCount == 0) finish();
    }

}
