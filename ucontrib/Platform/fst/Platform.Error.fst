module Platform.Error
open FStar.ST
open FStar.Heap
open FStar.HyperHeap

type optResult 'a 'b =
    | Error of 'a
    | Correct of 'b

//allowing inverting optResult without having to globally increase the fuel just for this
val invertOptResult : a:Type -> b:Type -> Lemma 
  (requires True)
  (ensures (forall (x:optResult a b). Error? x \/ Correct? x))
  [smt_pat (optResult a b)]
let invertOptResult a b = allow_inversion (optResult a b)

assume val perror: string -> int -> string -> Tot string

//assume val correct: #a:Type -> #b:Type -> x:a -> Tot (y:(optResult b a){y = Correct(x)})
assume val correct: #r:Type -> r -> Tot (optResult 'a r)

(* Both unexpected and unreachable are aliases for failwith;
   they indicate code that should never be executed at runtime.
   This is verified by typing only for the unreachable function;
   this matters e.g. when dynamic errors are security-critical *)

assume val unexpected: string -> ST 'a
  (requires (fun _ -> True))
  (ensures (fun _ _ _ -> True))

assume val unreachable: string -> ST 'a
  (requires (fun _ -> False))
  (ensures (fun _ _ _ -> False))

assume val if_ideal: (unit -> 'a) -> 'a -> 'a 
