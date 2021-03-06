open Prims
type rel =
  | EQ
  | SUB
  | SUBINV
let uu___is_EQ: rel -> Prims.bool =
  fun projectee  -> match projectee with | EQ  -> true | uu____4 -> false
let uu___is_SUB: rel -> Prims.bool =
  fun projectee  -> match projectee with | SUB  -> true | uu____8 -> false
let uu___is_SUBINV: rel -> Prims.bool =
  fun projectee  ->
    match projectee with | SUBINV  -> true | uu____12 -> false
type ('a,'b) problem =
  {
  pid: Prims.int;
  lhs: 'a;
  relation: rel;
  rhs: 'a;
  element: 'b FStar_Pervasives_Native.option;
  logical_guard:
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2;
  scope: FStar_Syntax_Syntax.binders;
  reason: Prims.string Prims.list;
  loc: FStar_Range.range;
  rank: Prims.int FStar_Pervasives_Native.option;}
type prob =
  | TProb of (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.term) problem
  | CProb of (FStar_Syntax_Syntax.comp,Prims.unit) problem
let uu___is_TProb: prob -> Prims.bool =
  fun projectee  ->
    match projectee with | TProb _0 -> true | uu____252 -> false
let __proj__TProb__item___0:
  prob -> (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.term) problem =
  fun projectee  -> match projectee with | TProb _0 -> _0
let uu___is_CProb: prob -> Prims.bool =
  fun projectee  ->
    match projectee with | CProb _0 -> true | uu____272 -> false
let __proj__CProb__item___0:
  prob -> (FStar_Syntax_Syntax.comp,Prims.unit) problem =
  fun projectee  -> match projectee with | CProb _0 -> _0
type probs = prob Prims.list
type guard_formula =
  | Trivial
  | NonTrivial of FStar_Syntax_Syntax.formula
let uu___is_Trivial: guard_formula -> Prims.bool =
  fun projectee  ->
    match projectee with | Trivial  -> true | uu____294 -> false
let uu___is_NonTrivial: guard_formula -> Prims.bool =
  fun projectee  ->
    match projectee with | NonTrivial _0 -> true | uu____299 -> false
let __proj__NonTrivial__item___0:
  guard_formula -> FStar_Syntax_Syntax.formula =
  fun projectee  -> match projectee with | NonTrivial _0 -> _0
type deferred = (Prims.string,prob) FStar_Pervasives_Native.tuple2 Prims.list
type univ_ineq =
  (FStar_Syntax_Syntax.universe,FStar_Syntax_Syntax.universe)
    FStar_Pervasives_Native.tuple2
let tconst:
  FStar_Ident.lident ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun l  ->
    let uu____317 =
      let uu____320 =
        let uu____321 =
          FStar_Syntax_Syntax.lid_as_fv l FStar_Syntax_Syntax.Delta_constant
            FStar_Pervasives_Native.None in
        FStar_Syntax_Syntax.Tm_fvar uu____321 in
      FStar_Syntax_Syntax.mk uu____320 in
    uu____317
      (FStar_Pervasives_Native.Some
         (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
      FStar_Range.dummyRange
let tabbrev:
  FStar_Ident.lident ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun l  ->
    let uu____335 =
      let uu____338 =
        let uu____339 =
          FStar_Syntax_Syntax.lid_as_fv l
            (FStar_Syntax_Syntax.Delta_defined_at_level (Prims.parse_int "1"))
            FStar_Pervasives_Native.None in
        FStar_Syntax_Syntax.Tm_fvar uu____339 in
      FStar_Syntax_Syntax.mk uu____338 in
    uu____335
      (FStar_Pervasives_Native.Some
         (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
      FStar_Range.dummyRange
let t_unit:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Parser_Const.unit_lid
let t_bool:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Parser_Const.bool_lid
let t_int:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Parser_Const.int_lid
let t_string:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Parser_Const.string_lid
let t_float:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Parser_Const.float_lid
let t_char:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tabbrev FStar_Parser_Const.char_lid
let t_range:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Parser_Const.range_lid
let t_tactic_unit:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  =
  let uu____364 =
    let uu____365 =
      let uu____366 = tabbrev FStar_Parser_Const.tactic_lid in
      FStar_Syntax_Syntax.mk_Tm_uinst uu____366 [FStar_Syntax_Syntax.U_zero] in
    let uu____367 =
      let uu____368 = FStar_Syntax_Syntax.as_arg t_unit in [uu____368] in
    FStar_Syntax_Syntax.mk_Tm_app uu____365 uu____367 in
  uu____364
    (FStar_Pervasives_Native.Some
       (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
    FStar_Range.dummyRange
let unit_const:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  =
  (FStar_Syntax_Syntax.mk
     (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_unit))
    (FStar_Pervasives_Native.Some (t_unit.FStar_Syntax_Syntax.n))
    FStar_Range.dummyRange
let mk_by_tactic:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax
  =
  fun tac  ->
    fun f  ->
      let t_by_tactic =
        let uu____392 = tabbrev FStar_Parser_Const.by_tactic_lid in
        FStar_Syntax_Syntax.mk_Tm_uinst uu____392
          [FStar_Syntax_Syntax.U_zero] in
      let tac1 =
        let uu____396 =
          let uu____397 = tabbrev FStar_Parser_Const.reify_tactic_lid in
          let uu____398 =
            let uu____399 = FStar_Syntax_Syntax.as_arg tac in [uu____399] in
          FStar_Syntax_Syntax.mk_Tm_app uu____397 uu____398 in
        uu____396 FStar_Pervasives_Native.None FStar_Range.dummyRange in
      let uu____404 =
        let uu____405 =
          let uu____406 = FStar_Syntax_Syntax.as_arg tac1 in
          let uu____407 =
            let uu____409 = FStar_Syntax_Syntax.as_arg f in [uu____409] in
          uu____406 :: uu____407 in
        FStar_Syntax_Syntax.mk_Tm_app t_by_tactic uu____405 in
      uu____404
        (FStar_Pervasives_Native.Some
           (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
        FStar_Range.dummyRange
let rec delta_depth_greater_than:
  FStar_Syntax_Syntax.delta_depth ->
    FStar_Syntax_Syntax.delta_depth -> Prims.bool
  =
  fun l  ->
    fun m  ->
      match (l, m) with
      | (FStar_Syntax_Syntax.Delta_constant ,uu____420) -> false
      | (FStar_Syntax_Syntax.Delta_equational ,uu____421) -> true
      | (uu____422,FStar_Syntax_Syntax.Delta_equational ) -> false
      | (FStar_Syntax_Syntax.Delta_defined_at_level
         i,FStar_Syntax_Syntax.Delta_defined_at_level j) -> i > j
      | (FStar_Syntax_Syntax.Delta_defined_at_level
         uu____425,FStar_Syntax_Syntax.Delta_constant ) -> true
      | (FStar_Syntax_Syntax.Delta_abstract d,uu____427) ->
          delta_depth_greater_than d m
      | (uu____428,FStar_Syntax_Syntax.Delta_abstract d) ->
          delta_depth_greater_than l d
let rec decr_delta_depth:
  FStar_Syntax_Syntax.delta_depth ->
    FStar_Syntax_Syntax.delta_depth FStar_Pervasives_Native.option
  =
  fun uu___96_433  ->
    match uu___96_433 with
    | FStar_Syntax_Syntax.Delta_constant  -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Delta_equational  -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Delta_defined_at_level _0_28 when
        _0_28 = (Prims.parse_int "1") ->
        FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Delta_constant
    | FStar_Syntax_Syntax.Delta_defined_at_level i ->
        FStar_Pervasives_Native.Some
          (FStar_Syntax_Syntax.Delta_defined_at_level
             (i - (Prims.parse_int "1")))
    | FStar_Syntax_Syntax.Delta_abstract d -> decr_delta_depth d
type identifier_info =
  {
  identifier:
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either;
  identifier_ty: FStar_Syntax_Syntax.typ;
  identifier_range: FStar_Range.range;}
let rec insert_col_info col info col_infos =
  match col_infos with
  | [] -> [(col, info)]
  | (c,i)::rest ->
      if col < c
      then (col, info) :: col_infos
      else
        (let uu____513 = insert_col_info col info rest in (c, i) :: uu____513)
let find_nearest_preceding_col_info col col_infos =
  let rec aux out uu___97_549 =
    match uu___97_549 with
    | [] -> out
    | (c,i)::rest ->
        if c > col then out else aux (FStar_Pervasives_Native.Some i) rest in
  aux FStar_Pervasives_Native.None col_infos
type col_info =
  (Prims.int,identifier_info) FStar_Pervasives_Native.tuple2 Prims.list
type row_info = col_info FStar_ST.ref FStar_Util.imap
type file_info = row_info FStar_Util.smap
let mk_info:
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either ->
    FStar_Syntax_Syntax.typ -> FStar_Range.range -> identifier_info
  =
  fun id  ->
    fun ty  ->
      fun range  ->
        { identifier = id; identifier_ty = ty; identifier_range = range }
let file_info_table: row_info FStar_Util.smap =
  FStar_Util.smap_create (Prims.parse_int "50")
let insert_identifier_info:
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either ->
    FStar_Syntax_Syntax.typ -> FStar_Range.range -> Prims.unit
  =
  fun id  ->
    fun ty  ->
      fun range  ->
        let use_range =
          let uu___98_601 = range in
          {
            FStar_Range.def_range = (range.FStar_Range.use_range);
            FStar_Range.use_range = (uu___98_601.FStar_Range.use_range)
          } in
        let info = mk_info id ty use_range in
        let fn = FStar_Range.file_of_range use_range in
        let start = FStar_Range.start_of_range use_range in
        let uu____605 =
          let uu____608 = FStar_Range.line_of_pos start in
          let uu____609 = FStar_Range.col_of_pos start in
          (uu____608, uu____609) in
        match uu____605 with
        | (row,col) ->
            let uu____612 = FStar_Util.smap_try_find file_info_table fn in
            (match uu____612 with
             | FStar_Pervasives_Native.None  ->
                 let col_info =
                   let uu____619 = insert_col_info col info [] in
                   FStar_Util.mk_ref uu____619 in
                 let rows = FStar_Util.imap_create (Prims.parse_int "1000") in
                 (FStar_Util.imap_add rows row col_info;
                  FStar_Util.smap_add file_info_table fn rows)
             | FStar_Pervasives_Native.Some file_rows ->
                 let uu____647 = FStar_Util.imap_try_find file_rows row in
                 (match uu____647 with
                  | FStar_Pervasives_Native.None  ->
                      let col_info =
                        let uu____657 = insert_col_info col info [] in
                        FStar_Util.mk_ref uu____657 in
                      FStar_Util.imap_add file_rows row col_info
                  | FStar_Pervasives_Native.Some col_infos ->
                      let uu____673 =
                        let uu____674 = FStar_ST.read col_infos in
                        insert_col_info col info uu____674 in
                      FStar_ST.write col_infos uu____673))
let info_at_pos:
  Prims.string ->
    Prims.int -> Prims.int -> identifier_info FStar_Pervasives_Native.option
  =
  fun fn  ->
    fun row  ->
      fun col  ->
        let uu____693 = FStar_Util.smap_try_find file_info_table fn in
        match uu____693 with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some rows ->
            let uu____697 = FStar_Util.imap_try_find rows row in
            (match uu____697 with
             | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
             | FStar_Pervasives_Native.Some cols ->
                 let uu____706 =
                   let uu____708 = FStar_ST.read cols in
                   find_nearest_preceding_col_info col uu____708 in
                 (match uu____706 with
                  | FStar_Pervasives_Native.None  ->
                      FStar_Pervasives_Native.None
                  | FStar_Pervasives_Native.Some ci ->
                      let last_col =
                        let uu____717 =
                          FStar_Range.end_of_range ci.identifier_range in
                        FStar_Range.col_of_pos uu____717 in
                      if col <= last_col
                      then FStar_Pervasives_Native.Some ci
                      else FStar_Pervasives_Native.None))
let insert_bv:
  FStar_Syntax_Syntax.bv -> FStar_Syntax_Syntax.typ -> Prims.unit =
  fun bv  ->
    fun ty  ->
      let uu____726 = FStar_Syntax_Syntax.range_of_bv bv in
      insert_identifier_info (FStar_Util.Inl bv) ty uu____726
let insert_fv:
  FStar_Syntax_Syntax.fv -> FStar_Syntax_Syntax.typ -> Prims.unit =
  fun fv  ->
    fun ty  ->
      let uu____733 = FStar_Syntax_Syntax.range_of_fv fv in
      insert_identifier_info (FStar_Util.Inr fv) ty uu____733