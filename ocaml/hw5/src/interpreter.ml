open Ast
open Errors

type entry =
  | VariableEntry of expr
  | FunctionEntry of function_binding * dynamic_env
  | StructEntry of struct_binding
[@@deriving show]
and dynamic_env = (string * entry) list
let entry_of_string = show_entry

let rec lookup (dynenv, name) =
  match dynenv with
  | [] -> None
  | (x, entry) :: dynenv ->
     if x = name
     then Some entry
     else lookup (dynenv, name)

(* ignore this until working on part 2 *)
let rec interpret_pattern (pattern, value): dynamic_env option =
  match pattern, value with
  | WildcardPattern, _ -> Some []
  | ConsPattern (p1, p2), Cons (v1, v2) -> begin
     match interpret_pattern (p1, v1), interpret_pattern (p2, v2) with
     | Some l1, Some l2 -> Some (l1 @ l2)
     | _ -> None
    end
  (* TODO: add cases for other kinds of patterns here *)
  | BoolLitPattern b, BoolLit v -> begin
    if b == v 
      then Some []
  else None   
   end
  | NilPattern, v -> begin
    if v  = Nil 
      then Some []
  else None   
   end
  | IntLitPattern b, IntLit v -> begin
    if v == b 
      then Some []
  else None   
   end
  | SymbolPattern b, Symbol v -> begin
    if v == b 
      then Some []
  else None   
   end 
  | _ -> None

let rec interpret_expression (dynenv, e) =
  (* helper function to interpret a list of expressions into a list of values *)
  let rec interpret_list (dynenv, es) =
    match es with
    | [] -> []
    | e :: es -> interpret_expression (dynenv, e) :: interpret_list (dynenv, es)
  in
  match e with
  | IntLit _ | BoolLit _ | Nil | StructConstructor _ -> e
  | Variable x -> begin
      match lookup (dynenv, x) with
      | None -> raise (RuntimeError ("Unbound variable " ^ x))
      | Some (VariableEntry value) -> value
      | Some e -> raise (RuntimeError ("Expected name " ^ x ^ " to refer to a variable, but got something else: " ^ entry_of_string e))
    end
  | Plus (e1, e2) -> begin
      match interpret_expression (dynenv, e1), interpret_expression (dynenv, e2) with
      | IntLit n1, IntLit n2 -> IntLit (n1 + n2)
      | IntLit _, v2 -> raise (RuntimeError ("Plus applied to non-integer " ^ string_of_expr v2))
      | v1, _ -> raise (RuntimeError ("Plus applied to non-integer " ^ string_of_expr v1))
    end
  | Minus (e1, e2) -> begin
      match interpret_expression (dynenv, e1), interpret_expression (dynenv, e2) with
      | IntLit n1, IntLit n2 -> IntLit (n1 - n2)
      | IntLit _, v2 -> raise (RuntimeError ("Minus applied to non-integer " ^ string_of_expr v2))
      | v1, _ -> raise (RuntimeError ("Minus applied to non-integer " ^ string_of_expr v1))
    end
  | Times (e1, e2) -> begin
      match interpret_expression (dynenv, e1), interpret_expression (dynenv, e2) with
      | IntLit n1, IntLit n2 -> IntLit (n1 * n2)
      | IntLit _, v2 -> raise (RuntimeError ("Times applied to non-integer " ^ string_of_expr v2))
      | v1, _ -> raise (RuntimeError ("Times applied to non-integer " ^ string_of_expr v1))
    end
  | Equals (e1, e2) -> begin
      match interpret_expression (dynenv, e1), interpret_expression (dynenv, e2) with
      | n1, n2 -> BoolLit (n1 = n2)
    end
  | If (e1, e2, e3) -> begin
      match interpret_expression (dynenv, e1) with
      | BoolLit false -> interpret_expression (dynenv, e3)
      | _ -> interpret_expression (dynenv, e2)
    end
  (* TODO: add case for let expressions here *)
  | Let (e1, e2, e3) -> begin
    let v1 = interpret_expression (dynenv, e2) in
    interpret_expression (((e1, VariableEntry v1) :: dynenv), e3) 

  end
  | Cons (e1, e2) ->
     let v1 = interpret_expression (dynenv, e1) in
     let v2 = interpret_expression (dynenv, e2) in
     Cons (v1, v2)
  | IsNil e -> begin
     match interpret_expression (dynenv, e) with
     | Nil -> BoolLit true
     | _ -> BoolLit false
    end
  | IsCons e -> begin
     match interpret_expression (dynenv, e) with
     | Cons _ -> BoolLit true
     | _ -> BoolLit false
    end
  | Car e -> begin
     match interpret_expression (dynenv, e) with
     | Cons (v1, _)  -> v1
     | v -> raise (RuntimeError("car applied to non-cons " ^ string_of_expr v))
    end
  | Cdr e -> begin
     match interpret_expression (dynenv, e) with
     | Cons (_, v2)  -> v2
     | v -> raise (RuntimeError("car applied to non-cons " ^ string_of_expr v))
   end
  | Call (fun_name, arg_exprs) -> begin
      let callenv = dynenv in
      match lookup (callenv, fun_name) with
      | None -> raise (RuntimeError ("Unbound function " ^ fun_name))
      | Some ((FunctionEntry (fb, defenv)) as entry) ->   
         let defenv = (fun_name, entry) :: defenv in
         let values: expr list = interpret_list (callenv, arg_exprs) in
         let param_names: string list = fb.param_names in
         let rec helper ((l: expr list), (n: string list), (p: (string * entry) list)) =
          match l, n with 
          | [],[] -> p
          | x :: xs, y :: ys -> helper(xs, ys, ((y, VariableEntry x) :: p))
          | _ -> raise (RuntimeError ("arguments not valid")) in
        interpret_expression(helper(values, param_names, []) @ defenv, fb.body) 
      | Some (StructEntry sb) -> 
        let values = interpret_list(dynenv, arg_exprs) in  
        if List.length(sb.field_names) != List.length(values) 
          then raise (RuntimeError ("parameters do not match arguments")) 
      else StructConstructor(sb.name, values)
      | Some e -> raise (RuntimeError ("Expected name " ^ fun_name ^ " to refer to a function or struct, but got something else: " ^ entry_of_string e))
    end
  | Cond clauses ->
     let rec loop clauses =
       match clauses with
       | [] -> raise (RuntimeError("cond failure: no clauses left"))
       | (predicate, body) :: clauses ->
        let v1 = interpret_expression (dynenv, predicate) in
        if v1 != BoolLit false
        then interpret_expression (dynenv, body) 
      else 
        loop clauses   
     in
     loop clauses
  | Symbol _ -> e
  (* TODO: add cases for the other "internal" expressions here *)
  | StructPredicate (s, v) -> begin
    match interpret_expression (dynenv, v) with
    | StructConstructor (s', vs) -> 
      if s = s' 
        then BoolLit true 
    else BoolLit false  
  end
  | StructAccess (s, i, v) -> begin
    match interpret_expression (dynenv, v) with
    | StructConstructor (s', vs) -> 
      if s = s' && i < List.length vs
       then let rec helper ((index: int), (l)) = 
        match index, l with 
        | i, x :: _ -> x 
        | _, x :: xs -> helper(index + 1, xs) in
      helper(0, vs)
      else raise (RuntimeError ("there is no such element"))
    end    
  (* TODO: add case for match expressions here *)
  | Match (e, clauses) -> 
    let v = interpret_expression (dynenv, e) in
    let rec loop clauses =
      match clauses with
      | [] -> raise (RuntimeError("match failure: no clauses left"))
      | (pattern, expr) :: clauses ->
      match interpret_pattern (pattern, v) with
       | None -> loop clauses
       | Some(b) -> interpret_expression(b, expr) 
    in
    loop clauses
    

let interpret_binding (dynenv, b) =
  match b with
  | VarBinding (x, e) ->
     let v = interpret_expression (dynenv, e) in
     Printf.printf "%s = %s\n%!" x (string_of_expr v);
     (x, VariableEntry v) :: dynenv
  | TopLevelExpr e ->
     let v = interpret_expression (dynenv, e) in
     print_endline (string_of_expr v);
     dynenv
  | FunctionBinding fb ->
     Printf.printf "%s is defined\n%!" fb.name;
     (fb.name, FunctionEntry (fb, dynenv)) :: dynenv
  (* TODO: implement test bindings here *)
  | TestBinding tb -> 
    (let v1 = interpret_expression(dynenv, tb) in
    match v1 with 
    | BoolLit false -> raise (RuntimeError("test is false"))
    | _ -> dynenv) 
  | StructBinding sb ->
     (* TODO: uncomment the comment on the next line and replace the "..." with
        a mapping for the structs name to a StructEntry containing sb. *)
     let dynenv = (sb.name, StructEntry (sb)) :: dynenv in

     (* TODO: create struct predicate function here *)
     let dynenv = (sb.name, FunctionEntry ({name = (sb.name ^ "?"); param_names = sb.field_names;
     body = StructPredicate(sb.name, Variable "x")}, dynenv))  :: dynenv in

    (* TODO: uncomment this when ready to do accessor functions *)
    let fun_entry_for_accessor (idx, field_name): string * entry =
      (sb.name, FunctionEntry ({name = (sb.name ^ "?"); param_names = sb.field_names;
      body = StructAccess(field_name, idx, Variable "x")}, dynenv)) in
      let rec fun_entry_accessor_loop (idx, field_names) =
         match field_names with
         | [] -> []
         | f :: field_names -> fun_entry_for_accessor (idx, f) :: fun_entry_accessor_loop (idx+1, field_names)
       in
       let dynenv = fun_entry_accessor_loop (0, sb.field_names) @ dynenv in
  

     dynenv

(* the semantics of a whole program (sequence of bindings) *)
let rec interpret_bindings (dynenv, bs) =
  match bs with
  | [] -> dynenv
  | b :: bs ->
     interpret_bindings (interpret_binding (dynenv, b), bs)

(* starting from dynenv, first interpret the list of bindings in order. then, in
   the resulting dynamic environment, interpret the expression and return its
   value *)
let interpret_expression_after_bindings (dynenv, bindings, expr) =
  interpret_expression (interpret_bindings (dynenv, bindings), expr)
