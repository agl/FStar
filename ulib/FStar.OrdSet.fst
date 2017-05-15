module FStar.OrdSet

type total_order (a:eqtype) (f: (a -> a -> Tot bool)) =
   (forall a1 a2. (f a1 a2 /\ f a2 a1)  ==> a1 = a2)  (* anti-symmetry *)
 /\ (forall a1 a2 a3. f a1 a2 /\ f a2 a3 ==> f a1 a3)   (* transitivity  *)
 /\ (forall a1 a2. f a1 a2 \/ f a2 a1)                 (* totality      *)

type cmp (a:eqtype) = f:(a -> a -> Tot bool){total_order a f}

val sorted: #a:eqtype -> f:cmp a -> list a -> Tot bool
let rec sorted #a f l = match l with
  | []       -> true
  | x::[]    -> true
  | x::y::tl -> f x y && x <> y && sorted f (y::tl)

abstract type ordset (a:eqtype) (f:cmp a) = l:(list a){sorted f l}

val hasEq_ordset: a:eqtype -> f:cmp a -> Lemma (requires (True)) (ensures (hasEq (ordset a f))) [smt_pat (hasEq (ordset a f))]
let hasEq_ordset a f = ()

abstract val empty        : #a:eqtype -> #f:cmp a -> Tot (ordset a f)
abstract val union        : #a:eqtype -> #f:cmp a -> ordset a f -> ordset a f -> Tot (ordset a f)
abstract val intersect    : #a:eqtype -> #f:cmp a -> ordset a f -> ordset a f -> Tot (ordset a f)

abstract val mem          : #a:eqtype -> #f:cmp a -> a -> s:ordset a f -> Tot bool
abstract val choose       : #a:eqtype -> #f:cmp a -> s:ordset a f -> Tot (option a)
abstract val remove       : #a:eqtype -> #f:cmp a -> a -> ordset a f -> Tot (ordset a f)

abstract val size         : #a:eqtype -> #f:cmp a -> ordset a f -> Tot nat

abstract val subset       : #a:eqtype -> #f:cmp a -> ordset a f -> ordset a f -> Tot bool
abstract val singleton    : #a:eqtype -> #f:cmp a -> a -> Tot (ordset a f)

abstract val minus        : #a:eqtype -> #f:cmp a -> ordset a f -> ordset a f -> Tot (ordset a f)
abstract val strict_subset: #a:eqtype -> #f:cmp a -> ordset a f -> ordset a f -> Tot bool


let mem (#a:eqtype) #f x s = List.Tot.mem x s

private val set_props:
  #a:eqtype -> #f:cmp a -> s:ordset a f{Cons? s}
  -> Lemma (requires (True))
          (ensures (forall x. mem #a #f x (Cons?.tl s) ==> (f (Cons?.hd s) x /\ Cons?.hd s =!= x)))
let rec set_props (#a:eqtype) #f s = match s with
  | x::tl -> if tl = [] then () else set_props #a #f tl

private val hd_unique: #a:eqtype -> #f:cmp a -> s:ordset a f{Cons? s}
               -> Lemma (requires (Cons? s))
                       (ensures (not (mem #a #f (Cons?.hd s) (Cons?.tl s))))
let hd_unique (#a:eqtype) #f s = set_props #a #f s

let empty (#a:eqtype) #f = []

private val insert': #a:eqtype -> #f:cmp a -> x:a -> s:ordset a f
             -> Tot (l:(ordset a f){Cons? l /\
                                    (Cons?.hd l = x \/
                                    (Cons? s /\ Cons?.hd l = Cons?.hd s))})
let rec insert' (#a:eqtype) #f x s = match s with
  | []     -> [x]
  | hd::tl ->
    if x = hd then hd::tl
    else if f x hd then x::hd::tl
    else hd::(insert' #_ #f x tl)

let rec union (#a:eqtype) #f s1 s2 = match s1 with
  | []     -> s2
  | hd::tl -> union #_ #f tl (insert' #_ #f hd s2)

let rec intersect (#a:eqtype) #f s1 s2 = match s1 with
  | []     -> []
  | hd::tl ->
    if mem #_ #f hd s2 then
      insert' #_ #f hd (intersect #_ #f tl s2)
    else
      intersect #_ #f tl s2

let choose (#a:eqtype) #f s = match s with
  | []   -> None
  | x::_ -> Some x

private val remove': #a:eqtype -> #f:cmp a -> x:a -> s:ordset a f
             -> Tot (l:(ordset a f){(Nil? s ==> Nil? l) /\
                                    (Cons? s ==> Cons?.hd s = x ==> l = Cons?.tl s) /\
                                    (Cons? s ==> Cons?.hd s =!= x ==> (Cons? l /\ Cons?.hd l = Cons?.hd s))})
let rec remove' (#a:eqtype) #f x s = match s with
  | []     -> []
  | hd::tl ->
    if x = hd then tl
    else hd::(remove' #_ #f x tl)

let remove (#a:eqtype) #f x s = remove' #_ #f x s

let size (#a:eqtype) #f s = List.Tot.length s

let rec subset (#a:eqtype) #f s1 s2 = match s1, s2 with
  | [], _          -> true
  | hd::tl, hd'::tl' ->
    if f hd hd' && hd = hd' then subset #a #f tl tl'
    else if f hd hd' && not (hd = hd') then false
    else subset #a #f s1 tl'
  | _, _           -> false

let singleton (#a:eqtype) #f x = [x]

type equal (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f) =
  (forall x. mem #_ #f x s1 = mem #_ #f x s2)

val eq_lemma: #a:eqtype -> #f:cmp a -> s1:ordset a f -> s2:ordset a f
              -> Lemma (requires (equal s1 s2))
                       (ensures (s1 = s2))
                 [smt_pat (equal s1 s2)]

val mem_empty: #a:eqtype -> #f:cmp a -> x:a
               -> Lemma (requires True) (ensures (not (mem #a #f x (empty #a #f))))
                  [smt_pat (mem #a #f x (empty #a #f))]

val mem_singleton: #a:eqtype -> #f:cmp a -> x:a -> y:a
                   -> Lemma (requires True)
                            (ensures (mem #a #f y (singleton #a #f x)) = (x = y))
                      [smt_pat (mem #a #f y (singleton #a #f x))]

val mem_union: #a:eqtype -> #f:cmp a -> x:a -> s1:ordset a f -> s2:ordset a f
               -> Lemma (requires True)
                        (ensures (mem #a #f x (union #a #f s1 s2) =
                                  (mem #a #f x s1 || mem #a #f x s2)))
                  [smt_pat (mem #a #f x (union #a #f s1 s2))]

val mem_intersect: #a:eqtype -> #f:cmp a -> x:a -> s1:ordset a f -> s2:ordset a f
                   -> Lemma (requires True)
                            (ensures (mem #a #f x (intersect s1 s2) =
                                      (mem #a #f x s1 && mem #a #f x s2)))
                      [smt_pat (mem #a #f x (intersect #a #f s1 s2))]

val mem_subset: #a:eqtype -> #f:cmp a -> s1:ordset a f -> s2:ordset a f
                -> Lemma (requires True)
                         (ensures  (subset #a #f s1 s2 <==>
                                    (forall x. mem #a #f x s1 ==> mem #a #f x s2)))
                   [smt_pat (subset #a #f s1 s2)]

val choose_empty: #a:eqtype -> #f:cmp a
                  -> Lemma (requires True) (ensures (None? (choose #a #f (empty #a #f))))
                     [smt_pat (choose #a #f (empty #a #f))]

(* TODO: FIXME: Pattern does not contain all quantified vars *)
val choose_s: #a:eqtype -> #f:cmp a -> s:ordset a f
              -> Lemma (requires (not (s = (empty #a #f))))
                       (ensures (Some? (choose #a #f s) /\
                                 s = union #a #f (singleton #a #f (Some?.v (choose #a #f s)))
                                                 (remove #a #f (Some?.v (choose #a #f s)) s)))
                 [smt_pat (choose #a #f s)]

val mem_remove: #a:eqtype -> #f:cmp a -> x:a -> y:a -> s:ordset a f
                -> Lemma (requires True)
                         (ensures (mem #a #f x (remove #a #f y s) =
                                   (mem #a #f x s && not (x = y))))
                   [smt_pat (mem #a #f x (remove #a #f y s))]

val eq_remove: #a:eqtype -> #f:cmp a -> x:a -> s:ordset a f
               -> Lemma (requires (not (mem #a #f x s)))
                        (ensures (s = remove #a #f x s))
                  [smt_pat (remove #a #f x s)]

val size_empty: #a:eqtype -> #f:cmp a -> s:ordset a f
                -> Lemma (requires True) (ensures ((size #a #f s = 0) = (s = empty #a #f)))
                  [smt_pat (size #a #f s)]

val size_remove: #a:eqtype -> #f:cmp a -> y:a -> s:ordset a f
                 -> Lemma (requires (mem #a #f y s))
                          (ensures (size #a #f s = size #a #f (remove #a #f y s) + 1))
                    [smt_pat (size #a #f (remove #a #f y s))]

val size_singleton: #a:eqtype -> #f:cmp a -> x:a
                    -> Lemma (requires True) (ensures (size #a #f (singleton #a #f x) = 1))
                       [smt_pat (size #a #f (singleton #a #f x))]

private val eq_helper: #a:eqtype -> #f:cmp a -> x:a -> s:ordset a f
               -> Lemma (requires (Cons? s /\ f x (Cons?.hd s) /\ x =!= Cons?.hd s))
                       (ensures (not (mem #a #f x s)))
let eq_helper (#a:eqtype) #f x s = set_props #a #f s

let rec eq_lemma (#a:eqtype) #f s1 s2 = match s1, s2 with
  | [], []             -> ()
  | _::_, []           -> ()
  | [], _::_           -> ()
  | hd1::tl1, hd2::tl2 ->
    if hd1 = hd2 then
      (* hd_unique calls help us prove that forall x. mem f x tl1 = mem f x tl2 *)
      (* so that we can apply IH *)
      (hd_unique #_ #f s1; hd_unique #_ #f s2; eq_lemma #_ #f tl1 tl2)
    else if f hd1 hd2 then
      eq_helper #_ #f hd1 s2
    else
      eq_helper #_ #f hd2 s1

let mem_empty (#a:eqtype) #f x = ()

let mem_singleton (#a:eqtype) #f x y = ()

private val insert_mem: #a:eqtype -> #f:cmp a -> x:a -> y:a -> s:ordset a f
                -> Lemma (requires (True))
                         (ensures (mem #a #f y (insert' #a #f x s) =
                                   (x = y || mem #a #f y s)))
let rec insert_mem (#a:eqtype) #f x y s = match s with
  | []     -> ()
  | hd::tl ->
    if x = hd then ()
    else if f x hd then ()
    else insert_mem #_ #f x y tl

let rec mem_union (#a:eqtype) #f x s1 s2 = match s1 with
  | []     -> ()
  | hd::tl ->
    mem_union #_ #f x tl (insert' #_ #f hd s2); insert_mem #_ #f hd x s2

let rec mem_intersect (#a:eqtype) #f x s1 s2 = match s1 with
  | []     -> ()
  | hd::tl ->
    let _ = mem_intersect #_ #f x tl s2 in
    if mem #_ #f hd s2 then insert_mem #_ #f hd x (intersect #_ #f tl s2) else ()

private val subset_implies_mem:
  #a:eqtype -> #f:cmp a -> s1:ordset a f -> s2:ordset a f
  -> Lemma (requires (True))
          (ensures (subset #a #f s1 s2 ==> (forall x. mem #a #f x s1 ==>
                                                mem #a #f x s2)))
let rec subset_implies_mem (#a:eqtype) #f s1 s2 = match s1, s2 with
  | [], _          -> ()
  | hd::tl, hd'::tl' ->
    if f hd hd' && hd = hd' then subset_implies_mem #a #f tl tl'
    else subset_implies_mem #a #f s1 tl'
  | _, _           -> ()

private val mem_implies_subset:
  #a:eqtype -> #f:cmp a -> s1:ordset a f -> s2:ordset a f
  -> Lemma (requires (True))
          (ensures ((forall x. mem #a #f x s1 ==> mem #a #f x s2) ==> subset #a #f s1 s2))
let rec mem_implies_subset (#a:eqtype) #f s1 s2 = match s1, s2 with
  | [], [] -> ()
  | _::_, [] -> ()
  | [], _::_ -> ()
  | hd::tl, hd'::tl' ->
    set_props #a #f s1; set_props #a #f s2;

    if f hd hd' && hd = hd' then
      mem_implies_subset #a #f tl tl'
    else if f hd hd' && not (hd = hd') then
      ()
    else mem_implies_subset #a #f s1 tl'

let mem_subset (#a:eqtype) #f s1 s2 =
  subset_implies_mem #a #f s1 s2; mem_implies_subset #a #f s1 s2

let choose_empty (#a:eqtype) #f = ()

let choose_s (#a:eqtype) #f s =
  let Some e = choose #_ #f s in
  cut (equal #a #f s (insert' #a #f e (remove #a #f e s)))

let rec mem_remove (#a:eqtype) #f x y s = match s with
  | []     -> ()
  | hd::tl -> if y = hd then hd_unique #_ #f s else mem_remove #_ #f x y tl

let rec eq_remove (#a:eqtype) #f x s = match s with
  | []    -> ()
  | _::tl -> eq_remove #_ #f x tl

let size_empty (#a:eqtype) #f s = ()

let rec size_remove (#a:eqtype) #f x s = match s with
  | hd::tl ->
    if x = hd then () else size_remove #_ #f x tl

let rec size_singleton (#a:eqtype) #f x = ()

val subset_size: #a:eqtype -> #f:cmp a -> x:ordset a f -> y:ordset a f
                 -> Lemma (requires (subset #a #f x y))
 	                  (ensures (size #a #f x <= size #a #f y))
	           [smt_pat (subset #a #f x y)]
let rec subset_size (#a:eqtype) #f x y = match x, y with
  | [], _          -> ()
  | hd::tl, hd'::tl' ->
    if f hd hd' && hd = hd' then subset_size #a #f tl tl'
    else subset_size #a #f x tl'

(**********)

(* TODO:FIXME: implement *)
assume val size_union: #a:eqtype -> #f:cmp a -> s1:ordset a f -> s2:ordset a f
                -> Lemma (requires True)
                         (ensures ((size #a #f (union #a #f s1 s2) >= size #a #f s1) &&
                                   (size #a #f (union #a #f s1 s2) >= size #a #f s2)))
                         [smt_pat (size #a #f (union #a #f s1 s2))]

(**********)

private
let rec remove_le #a #f x (s:ordset a f)
  : Pure (ordset a f)
    (requires True)
    (ensures (fun r -> sorted f (x :: r)))
    (decreases s)
=
  match s with
  | [] -> []
  | y :: ys ->
    if f x y && x <> y
    then s
    else remove_le #a #f x ys

private
let rec minus' #a #f x (s1 s2:ordset a f)
  : Pure (list a)
    (requires (sorted f (x::s1) /\ sorted f (x::s2)))
    (ensures (fun r -> sorted f (x::r)))
    (decreases s1)
=
  match s1 with
  | [] -> []
  | x1 :: xs1 ->
    assert (sorted f xs1) ;
    match s2 with
    | [] -> s1
    | x2 :: xs2 ->
      assert (sorted f xs1) ;
      if x1 = x2
      then minus' #a #f x xs1 xs2
      else x1 :: (minus' #a #f x1 xs1 (remove_le x1 s2))

let minus #a #f s1 s2 =
  match s1 with
  | [] -> []
  | x1 :: xs1 -> minus' #a #f x1 xs1 (remove_le #a #f x1 s2)

let strict_subset #a #f s1 s2 = s1 <> s2 && subset #a #f s1 s2

let lemma_strict_subset_size (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f)
  :Lemma (requires (strict_subset s1 s2))
         (ensures  (subset s1 s2 /\ size s1 < size s2))
   [smt_pat (strict_subset s1 s2)]
  = admit ()

let lemma_minus_mem (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f) (x:a)
  :Lemma (requires True) (ensures (mem x (minus s1 s2) = (mem x s1 && not (mem x s2))))
   [smt_pat (mem x (minus s1 s2))]
  = admit ()

let lemma_strict_subset_minus_size (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f) (s:ordset a f)
  :Lemma (requires (strict_subset s1 s2 /\ subset s1 s /\ subset s2 s))
         (ensures  (size (minus s s2) < size (minus s s1)))
   [smt_pat (strict_subset s1 s2); smt_pat (subset s1 s); smt_pat (subset s2 s)]
  = admit ()

let lemma_disjoint_union_subset (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f)
  :Lemma (requires (~ (s1 == empty) /\ ~ (s2 == empty) /\ intersect s1 s2 == empty))
         (ensures  (strict_subset s1 (union s1 s2) /\ strict_subset s2 (union s1 s2)))
   [smt_pat_or [[smt_pat (strict_subset s1 (union s1 s2))]; [smt_pat (strict_subset s2 (union s1 s2))]]]
  = admit ()

let lemma_subset_union (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f) (s:ordset a f)
  :Lemma (requires (subset s1 s /\ subset s2 s))
         (ensures  (subset (union s1 s2) s))
   [smt_pat (subset (union s1 s2) s)]
  = ()

let lemma_strict_subset_transitive (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f) (s3:ordset a f)
  :Lemma (requires (strict_subset s1 s2 /\ strict_subset s2 s3))
         (ensures  (strict_subset s1 s3))
   [smt_pat (strict_subset s1 s2); smt_pat (strict_subset s2 s3)]
  = admit ()

let lemma_intersect_symmetric (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f)
  :Lemma (requires True) (ensures (intersect s1 s2 == intersect s2 s1))
   [smt_pat_or [[smt_pat (intersect s1 s2)]; [smt_pat (intersect s2 s1)]]]
  = admit ()

let lemma_intersect_union_empty (#a:eqtype) (#f:cmp a) (s1:ordset a f) (s2:ordset a f) (s3:ordset a f)
  :Lemma (requires (intersect s1 s3 == empty /\ intersect s2 s3 == empty))
         (ensures  (intersect (union s1 s2) s3 == empty))
   [smt_pat (intersect (union s1 s2) s3)]
  = admit ()
