import blockpuzzle.model.collection.*;

class blockpuzzle.model.collection.BPTrigger {
    
    var set:BPSet;
    var condition:String;
    var function:Function;
    var message:String;

    // Sending the message multiple times...
    var repeat:Boolean;
    var messageSent:Boolean;

    function BPTrigger(set:BPSet, condition:String) {
        this.set = set;
        this.condition = condition;
        this.repeat = false;
        
        BPMailbox.mailbox.listenFor("BPEventCompleted", null, this, testCondition);
    }
    
    /*****************
    *                *
    * Test Condition *
    *                *
    *****************/
    
    function testCondition() {
        if ((repeat || ! messageSent) && this["test" + condition + "Condition"].call(this)) {
            BPMailbox.mailbox.post(message, set, this);
            messageSent == true;
        }
    }
    
    function testAllCondition():Boolean {
        
    }
    
    function testAnyCondition():Boolean {
        
    }
    
    function testWhenCondition():Boolean {
        
    }
    
    function testAreCondition():Boolean {
        
    }
    
    /**********************
    *                     *
    * Setup Chain Methods *
    *                     *
    **********************/
    
    function send(message:String):BPTrigger {
        this.message = message;
        return this;
    }
    
    function repeatedly():BPTrigger {
        this.repeat = true;
        return this;
    }
    
    /*********************
    *                    *
    * Ending the Trigger *
    *                    *
    *********************/
    
    function enough() {
        repeat = false;
        messageSent = true;
        
        BPMailbox.mailbox.removeObserver(this);
        BPMailbox.mailbox.removeSource(this);
    }

}