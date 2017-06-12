module TestMRef
open FStar.Heap
open FStar.ST
(*opaque logic type increasing (x:int) (y:int) = b2t (y >= x)*)
(*assume val x : MRef.mref int increasing *)

val x : MRef.mref int (fun (x:int) (y:int) -> b2t (y >= x))
let x = MRef.alloc 0
assume val y : ref int
assume val z : ref int

val test_frame_write_ref : unit -> ST unit
                              (requires (fun h -> addr_of y =!= addr_of z))
                              (ensures (fun h0 x h1 -> modifies (only y) h0 h1))
let test_frame_write_ref u =
  let v = !z in
  y := 17;
  let v' = !z in
  assert (v=v')

val test_frame_write_mref : unit -> ST unit
                              (requires (fun h -> addr_of y =!= addr_of (MRef.as_ref x)))
                              (ensures (fun h0 x h1 -> modifies (only y) h0 h1))
let test_frame_write_mref u =
  let v = MRef.read x in
  y := 17;
  let v' = MRef.read x in
  assert (v=v')

val test_frame_alloc_mref : unit -> ST unit
                              (requires (fun h -> MRef.contains h x))
                              (ensures (fun h0 x h1 -> modifies (only y) h0 h1))
let test_frame_alloc_mref u =
  let h0 = get() in
  assert (MRef.contains h0 x);
  assert (Heap.contains h0 (MRef.as_ref x));
  let v = MRef.read x in
  let h1 = get() in
  assert (MRef.contains h1 x);
  assert (Heap.contains h1 (MRef.as_ref x));
  let _ = alloc 0 in
  let h2 = get() in
  assert (MRef.contains h2 x);
  assert (Heap.contains h2 (MRef.as_ref x));
  let v' = MRef.read x in
  let h3 = get() in
  assert (MRef.contains h3 x);
  assert (Heap.contains h3 (MRef.as_ref x));
  assert (v=v')


val test_write_mref : unit -> ST unit
                              (requires (fun h -> MRef.contains h x))
                              (ensures (fun h0 u h1 -> modifies (only (MRef.as_ref x)) h0 h1))
let test_write_mref u =
  let v = MRef.read x in
  MRef.write x (v + 1)
