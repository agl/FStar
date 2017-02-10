module Relational.ProgramEquivalence

open FStar.DM4F.Heap
open FStar.DM4F.Heap.ST

reifiable let f () :STNull unit =
  let r = alloc_weak 0 in
  ()

let f_obs (h0:heap) =
  let _, h1 = reify (f ()) h0 in
  assert (forall (a:Type) (r:ref a). h0 `contains_a_well_typed` r ==> sel h0 r == sel h1 r)

reifiable let f_1 () :STNull int =
  let r_1 = alloc_weak 1 in
  let r_2 = alloc_weak 1 in
  read_weak r_1 + read_weak r_2

reifiable let f_2 () :STNull int =
  let r_1 = alloc_weak 2 in
  read_weak r_1

let f_1_f_2_obs (h_0:heap) :unit =
  let r_1, h_1 = reify (f_1 ()) h_0 in
  let r_2, h_2 = reify (f_1 ()) h_0 in
  assert (r_1 = r_2 /\
          (forall (a:Type) (r:ref a). h_0 `contains` r ==>
	                         (sel h_1 r == sel h_0 r /\
				  sel h_2 r == sel h_0 r)))