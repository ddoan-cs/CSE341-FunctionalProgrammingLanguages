(* CSE 341, Homework 4 Tests *)
open Hw4
open Hw4challenge
open Json

(* This file provides a list of basic tests for your homework.
 * You will surely want to add more! These tests do not guarantee that your code
 * is correct.
 *)

(* 1 *)
let%test _ =
  make_silly_json 2
  =
  Array
    [Object [("n", Num 2.); ("b", True)];
     Object [("n", Num 1.); ("b", True)]]

(* 2 *)
let%test _ = concat_with (";", ["1"; "2"]) = "1;2"

(* 3 *)
let%test _ = quote_string "hello" = "\"hello\""

(* 4 *)
let%test _ = string_of_json json_obj = "{\"foo\" : 3.14159, \"bar\" : [1, \"world\", null], \"ok\" : true}"

(* 5 *)
let%test _ = take (2, [4; 5; 6; 7]) = [4; 5]

(* 6 *)
let%test _ = firsts [(1,2); (3,4)] = [1; 3]

(** Don't forget to write a comment for problem 7 in your other file! **)

(* 8 *)
let%test _ = assoc ("foo", [("bar",17);("foo",19)]) = Some 19

(* 9 *)
let%test _ = dot (json_obj, "ok") = Some True

(* 10 *)
let%test _ = dots (Object [("f", Object [("g", String "gotcha")])], ["f"; "g"]) = Some (String "gotcha")

(* 11 *)
let%test _ = one_fields json_obj = List.rev ["foo";"bar";"ok"]

(* 12 *)
let%test _ = not (no_repeats ["foo";"bar";"foo"])

(* 13 *)
let nest = Array [Object [];
                  Object[("a",True);
                         ("b",Object[("foo",True);
                                     ("foo",True)]);
                         ("c",True)];
                  Object []]
let%test _ = not (recursive_no_field_repeats nest)

(* 14 *)

(* Any order is allowed by the specification, so it's ok to fail this
   test because of a different order. You can edit this test to match
   your implementation's order. *)
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

let pgascse =
  { latitude = 47.653221;
    longitude = -122.305708 }

(* 17 *)
let%test _ = in_rect (u_district, pgascse)

let json_pgascse = Object [("latitude", Num 47.653221); ("longitude", Num (-122.305708))]

(* 18 *)
let%test _ = point_of_json json_pgascse = Some pgascse

(* 19 *)
let%test _ =
  filter_access_path_in_rect (
      ["x"; "y"],
      u_district,
      [Object [("x", Object [("y", json_pgascse)])]; Object []]
  ) = [Object [("x", Object [("y", json_pgascse)])]]

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
