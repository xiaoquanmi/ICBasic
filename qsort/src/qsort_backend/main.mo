import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Array "mo:base/Array";

actor {
    func quicksort(arr: [var Int]) {
        sort(arr, 0, arr.size()-1)
    };

    func sort(arr: [var Int], low: Nat, high: Nat) {
        if(low >= high) return;

        var mid = arr[low];
        var left = low;
        var right = high;

        while(left < right){
            while(arr[right] >= mid and right > left) {
                right -= 1;
            };

            arr[left] := arr[right];
            while(arr[left] <= mid and left < right) {
                left += 1;
            };

            arr[right] := arr[left];
        };

        arr[right] := mid;
        if(left >= 1) {
            sort(arr, low, left-1);
        };

        sort(arr, left+1, high);
    };

    public func qsort(arr: [Int]): async [Int] {
        var newArr: [var Int] = Array.thaw(arr);
        quicksort(newArr);
        Array.freeze(newArr)
    };
}
