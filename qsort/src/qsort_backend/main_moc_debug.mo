import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

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

var arr: [var Int] = [var 7, 3, -9, 12, 98, -27, 54, 8, -1];
quicksort(arr);
Debug.print(debug_show(arr));

// moc调试结果
// $ moc --package base $(dfx cache show)/base -r src/qsort_backend/main.mo
// [var -27, -9, -1, +3, +7, +8, +12, +54, +98]