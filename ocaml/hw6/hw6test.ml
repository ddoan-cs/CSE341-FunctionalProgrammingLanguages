open Hw6types
open Hw6

(*
We have provided one correct (but usually very boring) test for each
problem. You should add more.

The provided tests are commented out because they all fail at the
moment. Uncomment them as you go.
*)

(* 1 *)
let%test _ = only_lowercase [] = []
let%test _ = only_lowercase ["hi"; "Hi"] = ["hi"]
let%test _ = only_lowercase ["Hi"; "hi"] = ["hi"]
let%test _ = only_lowercase ["1234"; "hi"] = ["hi"]
let%test _ = only_lowercase ["1234"; "hi"; "HI"; "hello"; "h"] = ["hi"; "hello"; "h"]
let%test _ = not (only_lowercase ["1234"; "hi"; "HI"; "hello"; "h"] = ["hello"; "h"; "hi"])

(* 2 *)
let%test _ = longest_string1 [] = ""
let%test _ = longest_string1 ["hello"; "doggy"] = "hello"
let%test _ = longest_string1 ["hello"; "doggy"; "catty"; "fishy"] = "hello"
let%test _ = longest_string1 ["hello"; "hi"] = "hello"
let%test _ = longest_string1 ["hi"; "hello"] = "hello"
let%test _ = longest_string1 ["hello"; "hi"; "doggy"; "cat"; "fishy"; "It's a cat!"] = "It's a cat!"

(* 3 *)
let%test _ = longest_string2 [] = ""
let%test _ = longest_string2 ["hello"; "doggy"] = "doggy"
let%test _ = longest_string2 ["hello"; "doggy"; "catty"; "fishy"] = "fishy"
let%test _ = longest_string2 ["hello"; "hi"] = "hello"
let%test _ = longest_string2 ["hi"; "hello"] = "hello"
let%test _ = longest_string2 ["hello"; "hi"; "doggy"; "cat"; "fishy"; "It's a cat!"] = "It's a cat!"

(* 4 *)
let%test _ = longest_string_helper (>) [] = ""
let%test _ = longest_string3 [] = ""
let%test _ = longest_string4 [] = "" 

let%test _ = longest_string3 ["hello"; "doggy"] = "hello"
let%test _ = longest_string3 ["hello"; "doggy"; "catty"; "fishy"] = "hello"
let%test _ = longest_string3 ["hello"; "hi"] = "hello"
let%test _ = longest_string3 ["hi"; "hello"] = "hello"
let%test _ = longest_string3 ["hello"; "hi"; "doggy"; "cat"; "fishy"; "It's a cat!"] = "It's a cat!"

let%test _ = longest_string4 ["hello"; "doggy"] = "doggy"
let%test _ = longest_string4 ["hello"; "doggy"; "catty"; "fishy"] = "fishy"
let%test _ = longest_string4 ["hello"; "hi"] = "hello"
let%test _ = longest_string4 ["hi"; "hello"] = "hello"
let%test _ = longest_string4 ["hello"; "hi"; "doggy"; "cat"; "fishy"; "It's a cat!"] = "It's a cat!"


(* 5 *)
let%test _ = longest_lowercase [] = ""
let%test _ = longest_lowercase ["hello"; "doggy"] = "hello"
let%test _ = longest_lowercase ["hello"; "doggy"; "catty"; "fishy"] = "hello"
let%test _ = longest_lowercase ["hello"; "hi"] = "hello"
let%test _ = longest_lowercase ["hi"; "hello"] = "hello"
let%test _ = longest_lowercase ["hello"; "hi"; "doggy"; "cat"; "fishy"; "It's a cat!"] = "hello"


(* 6 *)
let%test _ = caps_no_X_string "" = ""
let%test _ = caps_no_X_string "Xxa" = "A"
let%test _ = caps_no_X_string "XxA" = "A"
let%test _ = caps_no_X_string "abc" = "ABC"
let%test _ = caps_no_X_string "aBxXXxDdx" = "ABDD"
let%test _ = caps_no_X_string "aBxXXx123Ddx" = "AB123DD"

(* 7 *)
let%test _ = first_answer (fun x -> Some (x * 10)) [1; 2; 3] = 10
let%test _ = first_answer (fun x -> Some (x * 10)) [3] = 30

let%test _ = first_answer (fun x -> Some (x ^ "!")) ["hi"; "hello"] = "hi!"
let%test _ = first_answer (fun x -> if x = "hello" then Some x else None) ["hi"; "hello"] = "hello"

let%test _ = try first_answer (fun _ -> failwith "possible") [] with NoAnswer -> true
let%test _ = try first_answer (fun x -> if x then Some x else None) [] with NoAnswer -> true

(* 8 *)
let%test _ = all_answers (fun _ -> failwith "impossible") [] = Some []
let%test _ = all_answers (fun x -> if x then Some [x] else None) [] = Some []

let%test _ = all_answers (fun x -> Some [(x * 10)]) [1; 2; 3] = Some [30; 20; 10]
let%test _ = all_answers (fun x -> Some [(x * 10)]) [3] = Some [30]

let%test _ = all_answers (fun x -> Some [(x ^ "!")]) ["hi"; "hello"] = Some ["hello!"; "hi!"] 
let%test _ = all_answers (fun x -> if x = "hello" then Some [x] else None) ["hello"; "hi"] = None


