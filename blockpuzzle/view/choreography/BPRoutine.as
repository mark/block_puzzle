import blockpuzzle.view.animation.BPEmptyAnimation;
import blockpuzzle.view.choreography.BPChannel;
import blockpuzzle.view.choreography.BPSchedulable;

class blockpuzzle.view.choreography.BPRoutine extends BPSchedulable {
    
    var channel:BPChannel;
    var waitingFor:Object;
    
    function BPRoutine(options:Object) {
        this.channel = new BPChannel();
        this.waitingFor = new Object();

        // So we know when animations finish...
        listenFor("BPChannelAnimationFinished", channel, tryStartingAnimations);
        
        later(setup, options);
    }
    
    /*******************
    *                  *
    * Starting Methods *
    *                  *
    *******************/
    
    function setup(options:Object) {
        // OVERRIDE ME!
    }
    
    function start() {
        super.start();
        
        tryStartingAnimations();
    }
    
    /********************
    *                   *
    * Finishing Methods *
    *                   *
    ********************/
    
    function finish() {
        super.finish();
    }
    
    /*******************
    *                  *
    * Observer Methods *
    *                  *
    *******************/
    
    function tryStartingAnimations() {
        var waitingAnimations = channel.waitingAnimations();
        var localWaitingFor = this.waitingFor;
        
        // Iterate through the animations that are waiting to start
        waitingAnimations.each( function(animation) {
            // Get the ids of the animations that they're waiting for
            var toStart = localWaitingFor[ animation.id() ];

            for (var i = 0; i < toStart.length; i++) {
                // If the animation that we're waiting for hasn't finished yet
                if (! toStart[i].isFinished()) return;
            }
            
            // If we've gotten here, then all of the animations we're waiting for have started
            animation.start();
        });
    }
    
    /******************************
    *                             *
    * Atomic Choreography Methods *
    *                             *
    ******************************/
    
    function add(animation:BPSchedulable) {
        if (animation == null) return;
        
        if (waitingFor[ animation.id() ] == null) {
            channel.add(animation);
            waitingFor[ animation.id() ] = new Array();
        }
    }
    
    function animateInSequence(animation1:BPSchedulable, animation2:BPSchedulable) {
        add(animation1);
        add(animation2);
        
        waitingFor[ animation2.id() ].push( animation1 );
    }
    
    function animateInParallel(animation1:BPSchedulable, animation2:BPSchedulable) {
        add(animation1);
        add(animation2);
        
        var animation1Waiting = waitingFor[ animation1.id() ];
        var animation2Waiting = waitingFor[ animation2.id() ];
        
        // Combine the animations that each is waiting for...
        for (var i = 0; i < animation2Waiting.length; i++) {
            animation1Waiting.push( animation2Waiting[i] );
        }
        
        // Ensure that they are both waiting for the same animations...
        // (This will keep them in sync)
        waitingFor[ animation2.id() ] = animation1Waiting;
    }
    
    /***********************
    *                      *
    * Choreography Methods *
    *                      *
    ***********************/
    
    function startWith() {
        var animations = arguments;
        
        for (var i = 0; i < animations.length; i++) {
            add(animations[i]);
        }
    }
    
    function sequence() {
        var animations = arguments;
        var earlier = animations[0];
        
        for (var i = 1; i < animations.length; i++) {
            var later = animations[i];
            animateInSequence(earlier, later);
            earlier = later;
        }
    }
    
    function parallel() {
        var animations = arguments;
        var animation1 = animations[0];
        
        for (var i = 1; i < animations.length; i++) {
            var animation2 = animations[i];
            animateInParallel(animation1, animation2);
        }
    }
    
    function delay(seconds:Number) {
        return new BPEmptyAnimation(seconds);
    }
    
    function replaceWith(original:BPSchedulable, replacement:BPSchedulable) {
        // ...yeah.  Good question...
        // Possible: rewrite all of the waitingFor arrays that include orginal.id()
        // Possible: add a level of indirection between animation.id() and the elements of waitingFor
        // Possible: use sets instead of arrays, and then do a remove-then-insert <-- I like this
        // Possible: hold off on this for a bit
    }
}