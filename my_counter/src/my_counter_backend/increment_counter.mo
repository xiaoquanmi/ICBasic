import Text "mo:base/Text";
import Nat "mo:base/Nat";

// Create a simple Counter actor.
actor Counter {
  stable var currentValue : Nat = 0;

  type HttpRequest = {
    body: Blob;
    headers: [HeaderField];
    method: Text;
    url: Text;
  };

  type HttpResponse = {
    body: Blob;
    headers: [HeaderField];
    status_code: Nat16;
  };

  type HeaderField = (Text, Text);

  public query func http_request(request: HttpRequest): async HttpResponse {
    {
      body = Text.encodeUtf8(Nat.toText(currentValue));
      headers = [];
      status_code = 200;
    }
  };

  // Increment the counter with the increment function.
  public func increment() : async () {
    currentValue += 1;
  };

  // Read the counter value with a get function.
  public query func get() : async Nat {
    currentValue
  };

  // Write an arbitrary value with a set function.
  public func set(n: Nat) : async () {
    currentValue := n;
  };
}
