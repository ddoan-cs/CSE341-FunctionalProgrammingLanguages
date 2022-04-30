(* CSE 341, HW4 Provided Code *)

(* json.ml contains the main datatype definition we will use
   throughout the assignment. You will want to look over that file
   before starting. *)
open Json

(* These come from the parsed_*_bus.ml.
   Each file binds one variable: small_bus_positions (10 reports),
   medium_bus_positions (100 reports), and complete_bus_positions (~500 reports),
   respectively with the data that you will need to implement
   your homework.
*)
open Json_structures.Parsed_complete_bus
open Json_structures.Parsed_medium_bus
open Json_structures.Parsed_small_bus

(* provided helper function that deduplicates a list *)
let dedup xs = List.sort_uniq compare xs

(* provided helper function that sorts a given list *)
let sort xs = List.sort compare xs

(* Here is a provided helper function to convert a float to a string.
   OCaml's string_of_float is not quite RFC-compliant due to its tendency
   to output whole numbers with trailing decimal points without a zero.
   But, printf does the job how we want. *)
let json_string_of_float f =
  Printf.sprintf "%g" f

(* 1 *)
let make_silly_json i =
  let rec helper ((n: int), (l: json list)): json = 
    if n = 0
      then Array (List.rev(l))
    else
      helper(n - 1, (Object[("n",Num(float_of_int(n))); ("b", True)] :: l)) 
    in 
    helper(i, [])

(* 2 *)
let rec concat_with (sep, ss) =
  match ss with
  | [] -> ""
  | [x] -> x
  | x::xs -> x ^ sep ^ concat_with(sep, xs)

(* 3 *)
let quote_string s = 
  "\"" ^ s ^ "\""  

(* 4 *)
let rec string_of_json j =
  match j with
  | Num n -> json_string_of_float(n)
  | String s -> quote_string(s)
  | False -> "false"
  | True -> "true"
  | Null -> "null"
  | Array js ->
    let rec helperArray (a: json list): string list =
      match a with
      | [] -> []
      | x::xs -> string_of_json(x) :: helperArray(xs)   
    in
    "[" ^ concat_with(", ", helperArray(js)) ^ "]"
  | Object kvs -> 
    let rec helperObject (o: (string * json) list): string list =
      match o with
      | [] -> []
      | (s, j)::xs -> (quote_string(s) ^ " : " ^ string_of_json(j)) :: helperObject(xs) 
    in
     "{" ^ concat_with(", ", helperObject(kvs)) ^ "}";;

 string_of_json json_array    
  
(* 5 *)
let rec take (n,xs) =
  match n with
  | 0 -> []
  | _ -> 
    match xs with
    | [] -> []
    | y::ys -> y :: take(n - 1, ys)

(* 6 *)
let rec firsts xs =
  match xs with
  | [] -> []
  | (s, j)::ys -> s :: firsts(ys)

(* 7 *)
(* The expressions are equivalent because both expressions operate first on
   a pair list then either take the first components(first expression) or 
   reduce it to the first components (2nd expression) which do the same 
   thing in the end.
   
   I think both expressions would take around the same time because both 
   functions are taking the same type of arguments but just in different 
   order. Also I think that take on a pair list and an int list would still 
   run the same. 
   *)

(* 8 *)
let rec assoc (k, xs) =
  match xs with
  | [] -> None
  | (k1, v1)::ys ->
    if k = k1 
      then Some(v1)
  else assoc(k, ys) 

(* 9 *)
let dot (j, f) =
  match j with 
  | Object o -> assoc(f, o) 
  | _ -> None  

(* 10 *)
let rec dots (j, fs) =
  match fs with
  | [] -> None
  | x::[] -> dot(j, x)
  | x::xs -> 
    if dot(j, x) != None
      then dots(Option.get(dot(j, x)), xs)
  else None

(* 11 *)
let one_fields j =
  match j with 
  | Object o -> 
    let rec helper ((js: (string * json) list), (l: string list)): string list =
      match js with
      | [] -> l  
      | (s, j)::xs -> helper(xs, s :: l)
    in
    helper(o, [])
  | _ -> []  

(* 12 *)
let no_repeats xs =
  if List.length(xs) = List.length(dedup xs) 
    then true
else false

(* 13 *)
let rec recursive_no_field_repeats j =
  match j with 
  | Array js ->
    (let rec helperArray ((a: json list), (b: bool)) =
      match a with
      | [] -> b
      | x::xs -> no_repeats(one_fields x) && helperArray(xs, b)
    in
    helperArray(js, false))
  | Object kvs -> 
    let rec helperObject ((o: (string * json) list), (l: string list)) =
      match o with
      | [] -> l
      | (s, j)::xs -> helperObject(xs, s :: l)  
    in
    no_repeats(helperObject(kvs, []))
  | _ -> true 

(* 14 *)
let count_occurrences (xs, e) =
  let rec loop ((l: string list), (cur: string), (count: int), (k: (string * int) list)) =  
  match l with 
  | [] -> (cur, 1) :: k
  | y::ys -> 
    if cur > y 
      then raise e
  else
      if y = cur 
        then loop(ys, cur, count + 1, k) 
    else loop(ys, y, 0, (cur, count) :: k)
in 
loop(xs, List.hd xs, 0, [])

(* 15 *)
let rec string_values_for_access_path (fs, js) =
  match js with
  | [] -> [] 
  | x::xs -> 
    match dots(x, fs) with 
    | Some(String s) -> s :: string_values_for_access_path(fs, xs)
    | _ -> string_values_for_access_path(fs, xs) 

(* 16 *)
let rec filter_access_path_value (fs, v, js): json list =
  match js with
  | [] -> [] 
  | x::xs -> 
    match dots(x, fs) with 
    | Some(String s) -> 
      if s = v 
        then x :: filter_access_path_value (fs, v, xs)
    else filter_access_path_value (fs, v, xs)
    | _ -> filter_access_path_value (fs, v, xs)

(* Types for use in problems 17-20. *)
type rect = { min_latitude: float; max_latitude: float;
              min_longitude: float; max_longitude: float }
type point = { latitude: float; longitude: float }

(* 17 *)
let in_rect (r, p) =
  p.latitude <= r.max_latitude && p.latitude >= r.min_latitude &&
  p.longitude <= r.max_longitude && p.longitude >= r.min_longitude 

(* 18 *)
let point_of_json j =
  match j with 
  | Object o -> 
    match (dot(j, "latitude"), dot(j, "longitude"))  with 
    | Some(Num n1), Some(Num n2) -> Some({latitude = n1; longitude = n2})
    | _ -> None
  | _ -> None  

(* 19 *)
let rec filter_access_path_in_rect (fs, r, js) =
  match js with
  | [] -> [] 
  | x::xs -> 
    match dots(x, fs) with 
    | Some(Object o) ->  
      if in_rect(r, Option.get(point_of_json(Object o)))
        then x :: filter_access_path_in_rect (fs, r, xs)
    else filter_access_path_in_rect (fs, r, xs)
    | _ -> filter_access_path_in_rect (fs, r, xs)

(* 20 *)
(* The two functions are similar because they both do the same things,
   search and compare JSON values, except one function compares a 
   String and the other an Object. They both also follow the same 
   syntax, a match expression with a nested if statement, which contains 
   the comparison condition. I do think we can refactor them, we can probably
   take the type of the comparison and the condition as additional 
   arguments. 5 since it was simple to adapt the original function to the 
   other.  *)

(* The definition of U district and the functions to calculate a
   histogram. Use these to create the bindings as requested by the
   handout.

   Notice that our implementation of histogram uses *your* definition
   of count_occurrences.
*)

exception SortIsBroken

(* The definition of the U district for purposes of this assignment :) *)
let u_district =
  { min_latitude  =  47.648637;
    min_longitude = -122.322099;
    max_latitude  =  47.661176;
    max_longitude = -122.301019
  }

(* Creates a histogram for the given list of strings.
   Returns a tuple in which the first element is
   a string, and the second is the number of times that string
   is found. *)
let histogram xs =
  let sorted_xs = List.sort (fun a b -> compare a b) xs in
  let counts = count_occurrences (sorted_xs, SortIsBroken) in
  let compare_counts (s1, n1) (s2, n2) =
    if n1 = n2 then compare s1 s2 else compare n1 n2
  in
  List.rev (List.sort compare_counts counts)

let histogram_for_access_path (fs, js) =
  histogram (string_values_for_access_path (fs,js))

let complete_bus_positions_list =
  match (dot (complete_bus_positions, "entity")) with
  | Some (Array xs) -> xs
  | _ -> failwith "complete_bus_positions_list"

(* TODO: fill out these bindings as described in the PDF. *) 
let route_histogram     = histogram_for_access_path (["vehicle"; "trip"; "route_num"], complete_bus_positions_list)
let top_three_routes    = take(3, firsts(route_histogram))
let buses_in_ud         = filter_access_path_in_rect(["vehicle"; "position";], u_district, complete_bus_positions_list)
let ud_route_histogram  = histogram_for_access_path (["vehicle"; "trip"; "route_num"], buses_in_ud)
let top_three_ud_routes = take(3, firsts(ud_route_histogram))
let all_fourty_fours    = filter_access_path_value (["vehicle"; "trip"; "route_num"], "44", complete_bus_positions_list)