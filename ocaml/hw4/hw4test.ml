(* CSE 341, Homework 4 Tests *)
open Hw4
open Hw4challenge
open Json

(* This file provides a list of basic tests for your homework.
 * You will surely want to add more! These tests do not guarantee that your code
 * is correct.
 *)

(* 1 *)
let%test _ = make_silly_json 2 = Array [Object [("n", Num 2.); ("b", True)]; Object [("n", Num 1.); ("b", True)]]

let%test _ = make_silly_json 5 = Array [Object [("n", Num 5.); ("b", True)]; Object [("n", Num 4.); ("b", True)]; 
Object [("n", Num 3.); ("b", True)]; Object [("n", Num 2.); ("b", True)]; Object [("n", Num 1.); ("b", True)]]

let%test _ = make_silly_json 0 = Array []


(* 2 *)
let%test _ = concat_with (";", ["1"; "2"]) = "1;2"

let%test _ = concat_with (",", ["1"; "2"]) = "1,2"

let%test _ = concat_with (" ", ["1"; "2"]) = "1 2"

let%test _ = concat_with ("", ["1"; "2"]) = "12"

let%test _ = concat_with (";", []) = ""

(* 3 *)
let%test _ = quote_string "hello" = "\"hello\""

let%test _ = quote_string "" = "\"\""

let%test _ = quote_string " " = "\" \""

let%test _ = quote_string "hello 1234" = "\"hello 1234\""

(* 4 *)
let%test _ = string_of_json json_obj = "{\"foo\" : 3.14159, \"bar\" : [1, \"world\", null], \"ok\" : true}"

let%test _ = string_of_json json_hello = "\"hello\""

let%test _ = string_of_json json_pi = "3.14159"

let%test _ = string_of_json json_false = "false"

let%test _ = string_of_json Null = "null"

let%test _ = string_of_json True = "true"

let%test _ = string_of_json json_array = "[1, \"world\", null]"


(* 5 *)
let%test _ = take (2, [4; 5; 6; 7]) = [4; 5]

let%test _ = take (0, [4; 5; 6; 7]) = []

let%test _ = take (2, []) = []

let%test _ = take (2, ["2"; "2"; "2"; "5"]) = ["2"; "2"]

(* 6 *)
let%test _ = firsts [(1,2); (3,4)] = [1; 3]

let%test _ = firsts [(2,1); (4,3)] = [2; 4]

let%test _ = firsts [("1","2"); ("3","4")] = ["1"; "3"]

let%test _ = firsts [] = []


(** Don't forget to write a comment for problem 7 in your other file! **)

(* 8 *)
let%test _ = assoc ("foo", [("bar",17);("foo",19)]) = Some 19

let%test _ = assoc ("bar", [("bar",17);("foo",19)]) = Some 17

let%test _ = assoc ("", [("bar",17);("foo",19)]) = None

let%test _ = assoc ("foo", []) = None

(* 9 *)
let%test _ = dot (json_obj, "ok") = Some True

let%test _ = dot (json_obj, "foo") = Some json_pi

let%test _ = dot (json_obj, "asdfasdf") = None

let%test _ = dot (json_false, "foo") = None

(* 10 *)
let%test _ = dots (Object [("f", Object [("g", String "gotcha")])], ["f"; "g"]) = Some (String "gotcha")

let%test _ = dots (Object [("f", Object [("g", String "gotcha")])], ["f"]) = Some (Object [("g", String "gotcha")])

let%test _ = dots (Object [("f", Object [("g", String "gotcha")])], ["f"; "l"; "g"]) = None

let%test _ = dots (Object [("f", Object [("g", String "gotcha")])], []) = None

(* 11 *)
let%test _ = one_fields json_obj = List.rev ["foo";"bar";"ok"]

let%test _ = not (one_fields json_obj = List.rev ["ok";"bar";"foo"])

let%test _ = one_fields (Object []) = List.rev []

let%test _ = one_fields json_false = []

(* 12 *)
let%test _ = not (no_repeats ["foo";"bar";"foo"])

let%test _ = no_repeats ["foo";"bar"]

let%test _ = no_repeats ["foo"]

let%test _ = no_repeats []

(* 13 *)
let nest = Array [Object [];
                  Object[("a",True);
                         ("b",Object[("foo",True);
                                     ("foo",True)]);
                         ("c",True)];
                  Object []]
let%test _ = not (recursive_no_field_repeats nest)

let%test _ = recursive_no_field_repeats True

let%test _ = recursive_no_field_repeats json_false

let%test _ = not (recursive_no_field_repeats (Array [Object [("a",True)]; Object[("a", True)]]))


(* 14 *)

(* Any order is allowed by the specification, so it's ok to fail this
   test because of a different order. You can edit this test to match
   your implementation's order. *)
let%test _ = count_occurrences (["a"; "a"; "b"], (Failure "")) = [("b",1);("a",2)]

let%test _ = count_occurrences (["b"], (Failure "")) = [("b",1)]

let%test _ = try count_occurrences ([], (Failure "")) = []
with Failure _ -> true
             

let%test _ = count_occurrences (["a"; "a"; "b"], (Failure "")) = [("b",1);("a",2)]

(* test to see that an exception is thrown when the input list is not sorted *)
let%test _ = try count_occurrences (["b"; "a"; "b"], (Failure "")) = []
             with Failure _ -> true

(* 15 *)
let%test _ =
  string_values_for_access_path (
      ["x"; "y"],
      [Object [("a", True);("x", Object [("y", String "foo")])];
       Object [("x", Object [("y", String "bar")]); ("b", True)]]
  ) = ["foo";"bar"]

let%test _ =
  string_values_for_access_path (
      ["x"; "y"],
      [] 
  ) = []     

let%test _ =
  string_values_for_access_path (
      ["hi"; "ho"],
      [Object [("a", True);("x", Object [("y", String "foo")])];
       Object [("x", Object [("y", String "bar")]); ("b", True)]]
  ) = []  

  let%test _ =
  string_values_for_access_path (
      ["hi"; "ho"],
      [Object [("a", True);("x", Object [("y", Num 2.0)])];
       Object [("x", Object [("y", Num 1.0)]); ("b", True)]]
  ) = []  
(* 16 *)
let%test _ =
  filter_access_path_value (
      ["x"; "y"],
      "foo",
      [Object [("x", Object [("y", String "foo")]); ("z", String "bar")];
       Object [("x", Object [("y", String "foo")]); ("z", String "baz")];
       Object [("x", String "a")];
       Object []]
  ) = [Object [("x", Object [("y", String "foo")]); ("z", String "bar")];
       Object [("x", Object [("y", String "foo")]); ("z", String "baz")]]

let%test _ =
  filter_access_path_value (
      ["y"; "z"],
      "foo",
      [Object [("x", Object [("y", String "foo")]); ("z", String "bar")];
       Object [("x", Object [("y", String "foo")]); ("z", String "baz")];
       Object [("x", String "a")];
       Object []]
  ) = []

let%test _ =
  filter_access_path_value (
      ["x"; "y"],
      "foo",
      [Object [("x", Object [("y", String "bar")]); ("z", String "bar")];
       Object [("x", Object [("y", String "foo")]); ("z", String "baz")];
       Object [("x", String "a")];
       Object []]
  ) =  [Object [("x", Object [("y", String "foo")]); ("z", String "baz")]]      
  
let%test _ = filter_access_path_value ( ["x"; "y"],"foo", []) = []

let pgascse =
  { latitude = 47.653221;
    longitude = -122.305708 }

(* 17 *)
let%test _ = in_rect (u_district, pgascse)

let%test _ = not (in_rect (u_district, {latitude = 48.; longitude = -121. }))

let%test _ = not (in_rect (u_district, {latitude = 46.; longitude = -123. }))

let%test _ = not (in_rect (u_district, {latitude = 46.; longitude = -121. }))

let%test _ = not (in_rect (u_district, {latitude = 48.; longitude = -123. }))

let json_pgascse = Object [("latitude", Num 47.653221); ("longitude", Num (-122.305708))]

(* 18 *)
let%test _ = point_of_json json_pgascse = Some pgascse

let%test _ = point_of_json (Object []) = None

let%test _ = point_of_json (Object [("latitude",  False); ("longitude", String "-122.305708")]) = None

(* 19 *)
let%test _ =
  filter_access_path_in_rect (
      ["x"; "y"],
      u_district,
      [Object [("x", Object [("y", json_pgascse)])]; Object []]
  ) = [Object [("x", Object [("y", json_pgascse)])]]

let%test _ =
  filter_access_path_in_rect (
      ["x"; "y"],
      u_district,
      [Object [("x", Object [("y", Object [("latitude", Num 46.); ("longitude", Num (-123.))])])]; Object []]
  ) = []

let%test _ =
  filter_access_path_in_rect (
      ["x"; "y"],
      u_district,
      []
  ) = []

let%test _ =
  filter_access_path_in_rect (
      ["x"; "y"],
      u_district,
      [Object [("x", Object [("y", False)])]; Object []]
  ) = []

(** Don't forget to write a comment for problem 20 in your other file! **)

(* You do not need to test your solutions to Problems 21-26. *)


(* Challenge problems *)

(* Uncomment these tests if you do the challenge problems. *)

(*
(* C1 *)
let%test _ = consume_string_literal (char_list_of_string "\"foo\" : true") = ("foo", [' '; ':'; ' '; 't'; 'r'; 'u'; 'e'])

(* C2 *)
let%test _ = consume_keyword (char_list_of_string "false foo") = (FalseTok, [' '; 'f'; 'o'; 'o'])

(* C3 *)
let%test _ = tokenize_char_list (char_list_of_string "{ \"foo\" : 3.14, \"bar\" : [true, false] }")
             = [LBrace; StringLit "foo"; Colon; NumLit "3.14"; Comma; StringLit "bar";
                Colon; LBracket; TrueTok; Comma; FalseTok; RBracket; RBrace]

(* C4 *)
(* You should write a test for C4 here. *)


(* C5 *)
let%test _ = parse_string [StringLit "foo"; FalseTok] = ("foo", [FalseTok])

(* C6 *)
let%test _ = expect (Colon, [Colon; FalseTok]) = [FalseTok]

(* C6 through C10 *)
let%test _ = parse_json (tokenize "{ \"foo\" : null, \"bar\" : [true, false] }")
             = (Object [("foo", Null); ("bar", Array [True; False])], [])

(* C11 *)

*)
