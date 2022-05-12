(* CSE341 HW6 Provided Code *)

(* function composition operator from lecture *)
let (%) f g x = f (g x)

exception NoAnswer
