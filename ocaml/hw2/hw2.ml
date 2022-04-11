(* CSE 341, Homework 2, Provided Code *)

(* Use these functions to extract parts of a date *)
let fst3 (x,_,_) = x (* gets the first element of a triple *) 
let snd3 (_,x,_) = x (* gets the second element of a triple *) 
let thd3 (_,_,x) = x (* gets the third element of a triple *) 

(* TODO: Complete the 12 function bindings described in the
   assignment. For the first two problems, we have given you the
   *correct* first line and an *incorrect* function body. *)

(* 1 *)
let is_older ((date1 : int * int * int), (date2 : int * int * int)) =
  if thd3(date1) < thd3(date2)
    then true
else if snd3(date1)  < snd3(date2) && fst3(date1) <= fst3(date2)
  then true
else if (thd3(date1) < thd3(date2)  && fst3(date1) = fst3(date2)  && snd3(date1)  > snd3(date2))  
  then true
else false


(* 2 *)
let rec number_in_month ((dates : (int * int * int) list), (month : int)) =
  if dates = []
  then 0
else if (snd3(List.hd dates)) = month then
  let count = 1 + number_in_month((List.tl dates), (month)) in
  count
else number_in_month((List.tl dates), (month))

(* 3 *)
let rec number_in_months ((dates : (int * int * int) list), (months : (int) list))=
  if months = [] || dates = []
  then 0
else number_in_months(dates, List.tl months) + number_in_month(dates, List.hd months)

(* 4 *)
let rec dates_in_month ((dates : (int * int * int) list), (month : int)) = 
  if dates = []
  then []
else if snd3(List.hd dates) = month
  then List.hd dates :: dates_in_month(List.tl dates, month)
else dates_in_month(List.tl dates, month)

(* 5 *)
let rec dates_in_months ((dates : (int * int * int) list), (months : (int) list)) =
  if months = [] || dates = []
    then []
else 
  dates_in_month(dates, List.hd months) @ dates_in_months(dates, List.tl months)


(* 6 *)
let rec get_nth ((strings : (string) list), (n : int)) = 
  if strings = []
    then ""
else if n == 1 then
  List.hd strings
else 
  get_nth(List.tl strings, n - 1)


(* 7 *)
let string_of_date((date : (int * int * int))) = 
get_nth((["January"; "February"; "March"; "April"; "May"; "June"; "July"; "August";"September"; "October"; "November"; "December"]), 
snd3(date)) ^ "-" ^ string_of_int(fst3(date))^ "-" ^ string_of_int(thd3(date))


(* 8 *)
let number_before_reaching_sum((sum: int), (numbers: (int) list)) = 
  let rec loop((numbers: (int) list), (currentSum: int), (nthNum: int)) = 
  if numbers = [] 
    then 0
else if List.hd numbers + currentSum >= sum 
  then nthNum 
else loop((List.tl numbers), (List.hd numbers + currentSum), (nthNum + 1)) in
loop((numbers), (0), (0)) 


(* 9 *)
let what_month ((day: int)) =
number_before_reaching_sum((day), ([31; 28; 31; 30; 31; 30; 31; 31; 30; 31; 30; 31])) + 1

(* 10 *)
let rec month_range((day1: int), (day2: int)) = 
if day1 > day2 
  then [] 
else what_month(day1) :: month_range((day1 + 1), (day2))

(* 11 *)
let rec oldest (dates: (int * int * int) list): (int * int * int) option =
  if dates = []
    then None
else if List.tl dates = [] then
  Some(List.hd dates)
else 
  let last = oldest(List.tl dates) in
  let first = List.hd dates in
  if is_older(first, Option.get(last))
    then Some(first) 
  else last 

(* 12 *)
let cumulative_sum (numbers: (int) list) = 
  let rec loop((numbers: (int) list), (currentSum: int), (sums: (int) list)) = 
  if numbers = [] 
    then []
else if List.tl numbers = [] then
  sums
else
 loop((List.tl numbers), (List.hd numbers + currentSum), (currentSum :: sums )) 
in
loop((numbers), (0), ([]))