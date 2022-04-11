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
let%test _ = not (is_older((1, 1, 1), (1, 1, 1)))

let%test _ = (is_older((12, 1, 1), (15, 1, 1)))

let%test _ = (is_older((1, 12, 1), (1, 15, 1)))

let%test _ = (is_older((1, 1, 12), (1, 1, 15)))

(* 2 *)

(* here we want to check that number_in_month returns 1 on this input.
   we use "=" so that the whole test returns true when it passes. *)
let%test _ = number_in_month([(15, 1, 2021); (1, 4, 2022)], 1) = 1

(* TODO: more tests for problem 2 here, probably... *)

let%test _ = number_in_month([], 1) = 0

let%test _ = number_in_month([(15, 1, 2021); (1, 4, 2022)], 5) = 0

(* TODO: continue with tests for problem 3 and onward here *)

(* 3 *)
let%test _ = number_in_months([(15, 1, 2021); (1, 1, 2022)], [1; 2]) = 2

let%test _ = number_in_months([(15, 1, 2021); (1, 2, 2022)], [1; 2]) = 2

let%test _ = number_in_months([(15, 1, 2021); (1, 2, 2022)], []) = 0

let%test _ = number_in_months([], [1; 2]) = 0

(* 4 *) 
let%test _ = dates_in_month([(15, 1, 2021); (1, 4, 2022)], 1) = [(15, 1, 2021)]

let%test _ = dates_in_month([(15, 1, 2021); (1, 1, 2022)], 1) = [(15, 1, 2021); (1, 1, 2022)]

let%test _ = dates_in_month([], 1) = []


(* 5 *)
let%test _ = dates_in_months([(15, 1, 2021); (1, 2, 2022)], [1; 2]) = [(15, 1, 2021); (1, 2, 2022)]

let%test _ = dates_in_months([(15, 3, 2021); (1, 1, 2022)], [1; 2]) = [(1, 1, 2022)]

let%test _ = dates_in_months([], [1; 2]) = []

let%test _ = dates_in_months([(15, 3, 2021); (1, 1, 2022)], []) = []


(* 6 *)
let%test _ = get_nth(["1"; "2"; "3"; "4"], 4) = "4"

let%test _ = get_nth(["1"; "2"; "3"; "4"], 1) = "1"

let%test _ = get_nth([], 1) = ""


(* 7 *)
let%test _ = string_of_date(15, 12, 2002) = "December-15-2002"

let%test _ = string_of_date(31, 2, 2006) = "February-31-2006"


(* 8 *)
let%test _ = number_before_reaching_sum(10, [1; 2; 3; 4; 5;]) = 3

let%test _ = number_before_reaching_sum(10, []) = 0

let%test _ = number_before_reaching_sum(10, [0; 10; 3; 4; 5;]) = 1

(* 9 *)
let%test _ = what_month(20) = 1

let%test _ = what_month(365) = 12

let%test _ = what_month(1) = 1


(* 10 *)
let%test _ = month_range((30), (35)) = [1; 1; 2; 2; 2; 2]

let%test _ = month_range((50), (20)) = []


(* 11 *)
let%test _ = oldest([(15, 1, 2021); (1, 4, 2022)]) = Some((15, 1, 2021))

let%test _ = oldest([(15, 1, 2021); (1, 4, 2020)]) = Some((1, 4, 2020))

let%test _ = oldest([]) = None


(* 12 *) 
let%test _ = cumulative_sum[1; 2; 3; 4; 5; 6] = [1; 3; 6; 10; 15; 21]

let%test _ = cumulative_sum[] = []

let%test _ = cumulative_sum[0; 0; 0; 0; 0; 1] = [0; 0; 0; 0; 0; 1]

