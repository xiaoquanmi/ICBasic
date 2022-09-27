import List "mo:base/List";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

actor {
    type Message = {
        text: Text;
        time: Time.Time;
        author: Text;
    };

    public type Microblog = actor {
        follow: shared(Principal) -> async ();
        follows: shared query() -> async [Principal];
        post: shared(Text) -> async ();
        posts: shared query() -> async [Message];
        timeline: shared () -> async [Message];
    };

    stable var followed: List.List<Principal> = List.nil();
    stable var messages: List.List<Message> = List.nil();

    stable var cname: Text = "noname";

    public shared func set_name(opt: Text, name: Text) {
        assert(opt == "pwd");
        cname := name;
    };

    public shared func get_name() : async ?Text {
        return ?cname;
    };

    public shared func follow(id: Principal): async () {
        followed := List.push(id, followed);
    };

    public shared query func follows(): async [Principal] {
        List.toArray(followed)
    };

    public shared (msg) func post(opt: Text, text: Text): async () {
        //assert(Principal.toText(msg.caller) == "tgepg-tkfq4-xlmpw-3ofey-mx2xu-h5sse-g374z-mfvkx-lu6jt-h2axk-fae");
        assert(opt == "pwd");

        var now = Time.now();
        let message = {
            text = text;
            time =  now;
            author = cname;
        };

        messages := List.push(message, messages);
    };

    public shared query func posts(): async [Message] {
        List.toArray(messages)
    };

    public shared func timeline(): async [Message] {
        var all: List.List<Message> = List.nil();

        for (id in Iter.fromList(followed)) {
            let userBlogs = await queryFollowsPosts(id);
            for (msg in Iter.fromArray(userBlogs)) {
                all := List.push(msg, all);
            };
        };

        List.toArray(all)
    };

    public shared func queryFollowsPosts(id: Principal): async [Message] {
        var all: List.List<Message> = List.nil();
        let canister: Microblog = actor(Principal.toText(id));
        let msgs = await canister.posts();
        for (msg in Iter.fromArray(msgs)) {
            all := List.push(msg, all);
        };

        List.toArray(all)
    }
}
