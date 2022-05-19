open Hw6types

(**** Implement the following functions, remembering the "important
      note on function bindings" in the assignment write-up ****)

exception Unimplemented of string

(* 1 *)
let only_lowercase = 
  List.filter (fun x -> x.[0] = Char.lowercase_ascii x.[0] && x.[0] > 'A' && x.[0] <= 'z')

(* 2 *)
let longest_string1 =
  List.fold_left (fun acc x -> if String.length x > String.length acc then x else acc) ""

(* 3 *)
let longest_string2 =
  List.fold_left (fun acc x -> if String.length acc > String.length x then acc else x) ""

(* 4 *)
let longest_string_helper f =
  List.fold_left (fun acc x -> if f (String.length x) (String.length acc) then acc else x) ""

let longest_string3 =
  longest_string_helper(fun x y -> if  y >= x then true else false)

let longest_string4 =
  longest_string_helper(fun x y -> if  x >= y then false else true)

(* 5 *)
let longest_lowercase =
longest_string3 % only_lowercase 

(* 6 *)
let caps_no_X_string =
String.concat "" % String.split_on_char 'X' % String.uppercase_ascii

(* 7 *)
let rec first_answer f xs =
  match xs with 
  | [] -> raise NoAnswer
  | x::xs' -> 
    match f x with 
    | None -> first_answer f xs'
    | Some v -> v 

(* 8 *)
let all_answers f xs =
  let rec helper_append (f, xs, acc) = 
    match xs with 
    | [] -> Some acc
    | x::xs' -> 
      match f x with 
      | None -> None
      | Some v -> helper_append (f, xs', v @ acc) 
  in
  helper_append(f, xs, [])

