open Prims
let uncurry f uu____37 = match uu____37 with | (x,y) -> f x y
let curry f x y = f (x, y)
let rec mk_app_collect_inv_s:
  FStar_Reflection_Types.term ->
    FStar_Reflection_Types.term Prims.list -> Prims.unit
  = fun t  -> fun args  -> ()
let rec mk_app_collect_inv: FStar_Reflection_Types.term -> Prims.unit =
  fun t  -> ()
let rec forall_list = Obj.magic (fun l  -> ())
let rec collect_app_order':
  FStar_Reflection_Types.term Prims.list ->
    FStar_Reflection_Types.term -> FStar_Reflection_Types.term -> Prims.unit
  = fun args  -> fun tt  -> fun t  -> ()
let collect_app_order: FStar_Reflection_Types.term -> Prims.unit =
  fun t  -> ()