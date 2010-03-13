import blockpuzzle.base.BPObject;
import blockpuzzle.view.clock.BPSignal;

class blockpuzzle.view.clock.BPSignalQueue extends BPObject {
    
    var signals:Array;
    
    function BPSignalQueue() {
        this.signals = new Array();
    }

    /*****************
    *                *
    * Adding Signals *
    *                *
    *****************/
    
    function addSignal(message:String, when:Number, source, info) {
        var newSignal = new BPSignal(message, when, source, info);
        
        for (var i = 0; i < signals.length; i++) {
            if (newSignal.isBefore(signals[i])) {
                signals.splice(i, 0, newSignal);
                return;
            }
        }
        
        // If we get here then the new signal is later than current signals
        signals.push( newSignal );
    }
    
    /********************
    *                   *
    * Resolving Signals *
    *                   *
    ********************/
    
    function resolveSignals( now:Number ) {
        for (var i = 0; i < signals.length; i++) {
            if (! signals[i].post( now )) {
                signals.splice(0, i);
                return;
            }
        }
    }
    
}