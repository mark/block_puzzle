class blockpuzzle.controller.mailbox.BPDelayedCall {
    
    var self:Object;
    var action;
    var note:String;
    
    function BPDelayedCall(self:Object, action, note:String) {
        this.self = self;
        this.action = action;
        this.note = note;
    }
    
    function call() {
        if (action instanceof Function) {
            action.call(self);
        } else {
            self[action].call(self);
        }
    }

}