class blockpuzzle.base.BPSystem extends blockpuzzle.base.BPObject {
    
    static var initialized = false;
    
    static function initialize() {
        if (initialized) return;
        
        initialized = true;
        new blockpuzzle.controller.mailbox.BPMailbox();
        new blockpuzzle.view.clock.BPClock();
    }
}