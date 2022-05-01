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
let rec interpret_pattern (pattern, value): entry list option =
  match pattern, value with
  | WildcardPattern, _ -> Some []
  | ConsPattern (p1, p2), Cons (v1, v2) -> begin
     match interpret_pattern (p1, v1), interpret_pattern (p2, v2) with
     | Some l1, Some l2 -> Some (l1 @ l2)
     | _ -> None
    end
  (* TODO: add cases for other kinds of patterns here *)
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
      | IntLit n1, IntLit n2 -> BoolLit (n1 = n2)
      | IntLit _, v2 -> raise (RuntimeError ("Equals applied to non-integer " ^ string_of_expr v2))
      | v1, _ -> raise (RuntimeError ("Equals applied to non-integer " ^ string_of_expr v1))
    end
  | If (e1, e2, e3) -> begin
      match interpret_expression (dynenv, e1) with
      | BoolLit false -> interpret_expression (dynenv, e3)
      | _ -> interpret_expression (dynenv, e2)
    end
  (* TODO: add case for let expressions here *)
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
         (* This provided line handles recursion differently than (but
            equivalent to) HW3! When you build the environment to evaluate the
            function body, start from this defenv. *)
         let defenv = (fun_name, entry) :: defenv in
         failwith "TODO: implement function calls here"
      | Some (StructEntry sb) ->
         (* ignore this until part 2 *)
         failwith "TODO: implement 'calling' a struct as calling its constructor"
      | Some e -> raise (RuntimeError ("Expected name " ^ fun_name ^ " to refer to a function or struct, but got something else: " ^ entry_of_string e))
    end
  | Cond clauses ->
     let rec loop clauses =
       match clauses with
       | [] -> raise (RuntimeError("cond failure: no clauses left"))
       | (predicate, body) :: clauses ->
          failwith "TODO: implement the semantics of cond here"
     in
     loop clauses
  | Symbol _ -> failwith "TODO: handle Symbols in the interpreter"

  (* TODO: add cases for the other "internal" expressions here *)
  (* TODO: add case for match expressions here *)

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
  | StructBinding sb ->
     (* TODO: uncomment the comment on the next line and replace the "..." with
        a mapping for the structs name to a StructEntry containing sb. *)
     let dynenv = (* ... :: *) dynenv in

     (* TODO: create struct predicate function here *)
     let dynenv = (* ... :: *) dynenv in

     (* TODO: uncomment this when ready to do accessor functions *)
     (*
     let fun_entry_for_accessor (idx, field_name): string * entry =
       failwith "TODO: generate a function entry mapping that defines a struct accessor function"
     in
     let rec fun_entry_accessor_loop (idx, field_names) =
       match field_names with
       | [] -> []
       | f :: field_names -> fun_entry_for_accessor (idx, f) :: fun_entry_accessor_loop (idx+1, field_names)
     in
     let dynenv = fun_entry_accessor_loop (0, sb.field_names) @ dynenv in
      *)


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
