import blockpuzzle.controller.mailbox.*;

class blockpuzzle.view.clock.BPSignal {
    
    var message:BPMessage;
    var when:Number;
    
    function BPSignal(message:String, when:Number, source, info) {
        this.message = new BPMessage(message, source, info);
        this.when = when;
    }

    /*****************
    *                *
    * Helper Methods *
    *                *
    *****************/
    
    function shouldOccur(now:Number):Boolean {
        return now <= when;
    }
    
    function isBefore(other:BPSignal):Boolean {
        return when < other.when;
    }

    function post(now:Number) {
        if (shouldOccur(now)) {
            BPMailbox.mailbox.postMessage( message );
        }
        
        return shouldOccur(now);
    }

}