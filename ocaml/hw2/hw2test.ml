open Hw2

(* 1 *)

(* the testing framework checks that each test returns true *)
let%test _ = is_older((15, 1, 2021), (1, 4, 2022))

(* we expect is_older to return false here, so we put a "not" around
   it so that the test framework will check that "not" returns true. *)
let%test _ = not (is_older((1, 2, 3), (3, 2, 1)))
  (* this test actually passes on the starter code, which always
     returns false. once you actually implement is_older, the test
     will actually be testing something :) *)

(* TODO: more tests for problem 1 here, probably... *)

(* 2 *)

(* here we want to check that number_in_month returns 1 on this input.
   we use "=" so that the whole test returns true when it passes. *)
let%test _ = number_in_month([(15, 1, 2021); (1, 4, 2022)], 1) = 1

(* TODO: more tests for problem 2 here, probably... *)

(* TODO: continue with tests for problem 3 and onward here *)
