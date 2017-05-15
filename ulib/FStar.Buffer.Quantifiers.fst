module FStar.Buffer.Quantifiers

open FStar.Seq
open FStar.UInt32
open FStar.HyperStack
open FStar.Ghost
open FStar.Buffer
open FStar.Classical

#set-options "--initial_fuel 0 --max_fuel 0"

val lemma_sub_quantifiers: #a:Type -> h:mem -> b:buffer a -> b':buffer a -> i:FStar.UInt32.t -> len:FStar.UInt32.t{v len <= length b /\ v i + v len <= length b} -> Lemma
  (requires (live h b /\ live h b' /\ Seq.slice (as_seq h b) (v i) (v i + v len) == as_seq h b'))
  (ensures  (live h b /\ live h b' /\ Seq.slice (as_seq h b) (v i) (v i + v len) == as_seq h b'
    /\ length b' = v len
    /\ (forall (j:nat). {:pattern (get h b' j)} j < length b' ==> get h b' j == get h b (j + v i)) ))
  [smt_pat (Seq.slice (as_seq h b) (v i) (v i + v len)); smt_pat (as_seq h b')]
let lemma_sub_quantifiers #a h b b' i len = 
  assert (Seq.length (Seq.slice (as_seq h b) (v i) (v i + v len)) = v len);
  let lemma_post (j:nat) = j < length b' ==> get h b' j == get h b (j + v i) in
  let qj : j:nat -> Lemma (lemma_post j)
    = fun j -> assert (j < v len ==> Seq.index (as_seq h b') j == Seq.index (as_seq h b) (j + v i)) in
  Classical.forall_intro #_ #lemma_post qj
  
val lemma_offset_quantifiers: #a:Type -> h:mem -> b:buffer a -> b':buffer a -> i:FStar.UInt32.t{v i <= length b} -> Lemma
  (requires (live h b /\ live h b' /\ Seq.slice (as_seq h b) (v i) (length b) == as_seq h b'))
  (ensures  (live h b /\ live h b' /\ Seq.slice (as_seq h b) (v i) (length b) == as_seq h b'
    /\ length b' = length b - v i
    /\ (forall (j:nat). {:pattern (get h b' j)} j < length b' ==> get h b' j == get h b (j + v i)) ))
  [smt_pat (Seq.slice (as_seq h b) (v i) (length b)); smt_pat (as_seq h b')]
let lemma_offset_quantifiers #a h b b' i =
  lemma_sub_quantifiers #a h b b' i (uint_to_t (length b - v i))
  
val lemma_create_quantifiers: #a:Type -> h:mem -> b:buffer a -> init:a -> len:FStar.UInt32.t -> Lemma
  (requires (live h b /\ as_seq h b == Seq.create (v len) init))
  (ensures  (live h b /\ length b = v len
    /\ (forall (i:nat). {:pattern (get h b i)} i < length b ==> get h b i == init)))
  [smt_pat (as_seq h b); smt_pat (Seq.create (v len) init)]  
let lemma_create_quantifiers #a h b init len =
  assert (Seq.length (as_seq h b) = v len);
  let lemma_post (i:nat) = i < length b ==> get h b i == init in
  let qi : i:nat -> Lemma (lemma_post i) = 
   fun i -> assert (i < length b ==> get h b i == Seq.index (as_seq h b) i) in
  Classical.forall_intro #_ #lemma_post qi

val lemma_index_quantifiers: #a:Type -> h:mem -> b:buffer a -> n:FStar.UInt32.t -> Lemma
  (requires (live h b /\ v n < length b))
  (ensures  (live h b /\ v n < length b /\ get h b (v n) == Seq.index (as_seq h b) (v n)))
  [smt_pat (Seq.index (as_seq h b) (v n))]
let lemma_index_quantifiers #a h b n = ()

val lemma_upd_quantifiers: #a:Type -> h0:mem -> h1:mem -> b:buffer a -> n:FStar.UInt32.t -> z:a -> Lemma
  (requires (live h0 b /\ live h1 b /\ v n < length b /\ as_seq h1 b == Seq.upd (as_seq h0 b) (v n) z))
  (ensures  (live h0 b /\ live h1 b /\ v n < length b
    /\ (forall (i:nat). {:pattern (get h1 b i)} (i < length b /\ i <> v n)
      ==> get h1 b i == get h0 b i)
    /\ get h1 b (v n) == z))
  [smt_pat (as_seq h1 b); smt_pat (Seq.upd (as_seq h0 b) (v n) z)]
let lemma_upd_quantifiers #a h0 h1 b n z =
  assert(forall (i:nat). i < length b ==> get h1 b i == Seq.index (as_seq h1 b) i)

#reset-options "--initial_fuel 0 --max_fuel 0 --z3rlimit 8"

val lemma_blit_quantifiers: #a:Type -> h0:mem -> h1:mem -> b:buffer a -> bi:UInt32.t{v bi <= length b} ->
  b':buffer a{disjoint b b'} -> bi':UInt32.t{v bi' <= length b'} -> len:UInt32.t{v bi+v len <= length b /\ v bi'+v len <= length b'} -> Lemma
    (requires (live h0 b /\ live h0 b' /\ live h1 b'
      /\ Seq.slice (as_seq h1 b') (v bi') (v bi'+v len) == Seq.slice (as_seq h0 b) (v bi) (v bi+v len)
      /\ Seq.slice (as_seq h1 b') 0 (v bi') == Seq.slice (as_seq h0 b') 0 (v bi')
      /\ Seq.slice (as_seq h1 b') (v bi'+v len) (length b') == Seq.slice (as_seq h0 b') (v bi'+v len) (length b')
    ))
    (ensures  (live h0 b /\ live h0 b' /\ live h1 b'
      /\ (forall (i:nat). {:pattern (get h1 b' (v bi'+i))} i < v len ==> get h1 b' (v bi'+i) == get h0 b (v bi+i))
      /\ (forall (i:nat). {:pattern (get h1 b' i)} ((i >= v bi' + v len /\ i < length b') \/ i < v bi') ==> get h1 b' i == get h0 b' i)
))
let lemma_blit_quantifiers #a h0 h1 b bi b' bi' len =  
  let lemma_post_1 (j:nat) = j < v len ==> get h1 b' (v bi'+j) == get h0 b (v bi+j) in
  let qj_1 : j:nat -> Lemma (lemma_post_1 j)
    = fun j -> assert (j < v len ==> Seq.index (Seq.slice (as_seq h1 b') (v bi') (v bi'+v len)) j
  	== Seq.index (Seq.slice (as_seq h0 b) (v bi) (v bi+v len)) j) in
  let lemma_post_2 (j:nat) = ((j >= v bi' + v len /\ j < length b') \/ j < v bi') 
    ==> get h1 b' j == get h0 b' j in
  let qj_2 : j:nat -> Lemma (lemma_post_2 j)
    = fun j -> assert (j < v bi' ==> Seq.index (Seq.slice (as_seq h1 b') 0 (v bi')) j
	== Seq.index (Seq.slice (as_seq h0 b') 0 (v bi')) j);
	assert ((j >= v bi' + v len /\ j < length b') 
	  ==> Seq.index (Seq.slice (as_seq h1 b') (v bi'+v len) (length b')) (j - (v bi'+v len))
	      == Seq.index (Seq.slice (as_seq h0 b') (v bi'+v len) (length b')) (j - (v bi'+v len)))
	in
  Classical.forall_intro #_ #lemma_post_1 qj_1;
  Classical.forall_intro #_ #lemma_post_2 qj_2
  

(* Equality predicate between buffers wih quantifiers *)
val eq_lemma: #a:Type -> h:mem -> b:buffer a{live h b} -> h':mem -> b':buffer a{live h' b'} -> Lemma
  (requires (equal h b h' b'))
  (ensures  (length b = length b' /\ (forall (i:nat). {:pattern (get h b i)} 
    i < length b ==> get h b i == get h' b' i)))
  [smt_pat (equal h b h' b')]
let eq_lemma #a h b h' b' =
  assert(Seq.length (as_seq h b) = Seq.length (as_seq h' b')); 
  let lemma_post (j:nat) = j < length b ==> get h b j == get h' b' j in
  let qj : j:nat -> Lemma (lemma_post j) = fun j ->
    assert(j < length b ==> Seq.index (as_seq h b) j == Seq.index (as_seq h' b') j) in
  Classical.forall_intro #_ #lemma_post qj
