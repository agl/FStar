// This file needs --universes now

module Bug121

open FStar.FunctionalExtensionality

type var = nat

type exp =
  | EVar   : var -> exp
  | ELam   : exp -> exp

type sub = var -> Tot exp

type renaming (s:sub) = (forall (x:var). EVar? (s x))

assume val is_renaming : s:sub -> Tot (n:int{  (renaming s  ==> n=0) /\
                                      (~(renaming s) ==> n=1)})

val sub_inc : var -> Tot exp
let sub_inc y = EVar (y+1)

val renaming_sub_inc : unit -> Lemma (renaming (sub_inc))
let renaming_sub_inc _ = ()

let is_var (e:exp) : int = if EVar? e then 0 else 1

val sub_lam: s:sub -> Tot sub
val subst : s:sub -> e:exp -> Pure exp (requires True)
      (ensures (fun e' -> (renaming s /\ EVar? e) ==> EVar? e'))
      (decreases %[is_var e; is_renaming s; e])

let rec subst s e =
  match e with
  | EVar x -> s x

  | ELam e1 ->
     let sub_elam = sub_lam s in
     assert (forall y. renaming s ==> EVar? (sub_elam y)) ;
     ELam (subst sub_elam e1)

and sub_lam s y : Tot (e:exp{renaming s ==> EVar? e}) =
  if y=0 then EVar y
  else subst sub_inc (s (y-1))


(* Substitution extensional; trivial with the extensionality axiom *)
val subst_extensional: s1:sub -> s2:sub{feq s1 s2} -> e:exp ->
                        Lemma (requires True) (ensures (subst s1 e = subst s2 e))
                       (* [smt_pat (subst s1 e);  smt_pat (subst s2 e)] *)
let subst_extensional s1 s2 e = ()

(* This only works automatically with the patterns in
   subst_extensional above; it would be a lot cooler if this worked
   without, since that increases checking time.  Even worse, there is
   no way to prove this without the smt_pat (e.g. manually), or to use
   the smt_pat only locally, in this definition (`using` needed). *)
val sub_lam_hoist : e:exp -> s:sub -> Lemma (requires True)
      (ensures (subst s (ELam e) = ELam (subst (sub_lam s) e)))
let sub_lam_hoist e s = ()
