open Prims
type binding =
  | Binding_var of FStar_Syntax_Syntax.bv
  | Binding_lid of (FStar_Ident.lident* FStar_Syntax_Syntax.tscheme)
  | Binding_sig of (FStar_Ident.lident Prims.list*
  FStar_Syntax_Syntax.sigelt)
  | Binding_univ of FStar_Syntax_Syntax.univ_name
  | Binding_sig_inst of (FStar_Ident.lident Prims.list*
  FStar_Syntax_Syntax.sigelt* FStar_Syntax_Syntax.universes)
let uu___is_Binding_var: binding -> Prims.bool =
  fun projectee  ->
    match projectee with | Binding_var _0 -> true | uu____29 -> false
let __proj__Binding_var__item___0: binding -> FStar_Syntax_Syntax.bv =
  fun projectee  -> match projectee with | Binding_var _0 -> _0
let uu___is_Binding_lid: binding -> Prims.bool =
  fun projectee  ->
    match projectee with | Binding_lid _0 -> true | uu____43 -> false
let __proj__Binding_lid__item___0:
  binding -> (FStar_Ident.lident* FStar_Syntax_Syntax.tscheme) =
  fun projectee  -> match projectee with | Binding_lid _0 -> _0
let uu___is_Binding_sig: binding -> Prims.bool =
  fun projectee  ->
    match projectee with | Binding_sig _0 -> true | uu____64 -> false
let __proj__Binding_sig__item___0:
  binding -> (FStar_Ident.lident Prims.list* FStar_Syntax_Syntax.sigelt) =
  fun projectee  -> match projectee with | Binding_sig _0 -> _0
let uu___is_Binding_univ: binding -> Prims.bool =
  fun projectee  ->
    match projectee with | Binding_univ _0 -> true | uu____85 -> false
let __proj__Binding_univ__item___0: binding -> FStar_Syntax_Syntax.univ_name
  = fun projectee  -> match projectee with | Binding_univ _0 -> _0
let uu___is_Binding_sig_inst: binding -> Prims.bool =
  fun projectee  ->
    match projectee with | Binding_sig_inst _0 -> true | uu____101 -> false
let __proj__Binding_sig_inst__item___0:
  binding ->
    (FStar_Ident.lident Prims.list* FStar_Syntax_Syntax.sigelt*
      FStar_Syntax_Syntax.universes)
  = fun projectee  -> match projectee with | Binding_sig_inst _0 -> _0
type delta_level =
  | NoDelta
  | Inlining
  | Eager_unfolding_only
  | Unfold of FStar_Syntax_Syntax.delta_depth
let uu___is_NoDelta: delta_level -> Prims.bool =
  fun projectee  ->
    match projectee with | NoDelta  -> true | uu____127 -> false
let uu___is_Inlining: delta_level -> Prims.bool =
  fun projectee  ->
    match projectee with | Inlining  -> true | uu____131 -> false
let uu___is_Eager_unfolding_only: delta_level -> Prims.bool =
  fun projectee  ->
    match projectee with | Eager_unfolding_only  -> true | uu____135 -> false
let uu___is_Unfold: delta_level -> Prims.bool =
  fun projectee  ->
    match projectee with | Unfold _0 -> true | uu____140 -> false
let __proj__Unfold__item___0: delta_level -> FStar_Syntax_Syntax.delta_depth
  = fun projectee  -> match projectee with | Unfold _0 -> _0
type mlift =
  {
  mlift_wp:
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ;
  mlift_term:
    (FStar_Syntax_Syntax.typ ->
       FStar_Syntax_Syntax.typ ->
         FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
      Prims.option;}
type edge =
  {
  msource: FStar_Ident.lident;
  mtarget: FStar_Ident.lident;
  mlift: mlift;}
type effects =
  {
  decls:
    (FStar_Syntax_Syntax.eff_decl* FStar_Syntax_Syntax.qualifier Prims.list)
      Prims.list;
  order: edge Prims.list;
  joins:
    (FStar_Ident.lident* FStar_Ident.lident* FStar_Ident.lident* mlift*
      mlift) Prims.list;}
type cached_elt =
  (((FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.typ),(FStar_Syntax_Syntax.sigelt*
                                                               FStar_Syntax_Syntax.universes
                                                               Prims.option))
    FStar_Util.either* FStar_Range.range)
type goal = FStar_Syntax_Syntax.term
type env =
  {
  solver: solver_t;
  range: FStar_Range.range;
  curmodule: FStar_Ident.lident;
  gamma: binding Prims.list;
  gamma_cache: cached_elt FStar_Util.smap;
  modules: FStar_Syntax_Syntax.modul Prims.list;
  expected_typ: FStar_Syntax_Syntax.typ Prims.option;
  sigtab: FStar_Syntax_Syntax.sigelt FStar_Util.smap;
  is_pattern: Prims.bool;
  instantiate_imp: Prims.bool;
  effects: effects;
  generalize: Prims.bool;
  letrecs: (FStar_Syntax_Syntax.lbname* FStar_Syntax_Syntax.typ) Prims.list;
  top_level: Prims.bool;
  check_uvars: Prims.bool;
  use_eq: Prims.bool;
  is_iface: Prims.bool;
  admit: Prims.bool;
  lax: Prims.bool;
  lax_universes: Prims.bool;
  type_of:
    env ->
      FStar_Syntax_Syntax.term ->
        (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.typ* guard_t);
  universe_of:
    env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.universe;
  use_bv_sorts: Prims.bool;
  qname_and_index: (FStar_Ident.lident* Prims.int) Prims.option;}
and solver_t =
  {
  init: env -> Prims.unit;
  push: Prims.string -> Prims.unit;
  pop: Prims.string -> Prims.unit;
  mark: Prims.string -> Prims.unit;
  reset_mark: Prims.string -> Prims.unit;
  commit_mark: Prims.string -> Prims.unit;
  encode_modul: env -> FStar_Syntax_Syntax.modul -> Prims.unit;
  encode_sig: env -> FStar_Syntax_Syntax.sigelt -> Prims.unit;
  preprocess: env -> goal -> (env* goal) Prims.list;
  solve:
    (Prims.unit -> Prims.string) Prims.option ->
      env -> FStar_Syntax_Syntax.typ -> Prims.unit;
  is_trivial: env -> FStar_Syntax_Syntax.typ -> Prims.bool;
  finish: Prims.unit -> Prims.unit;
  refresh: Prims.unit -> Prims.unit;}
and guard_t =
  {
  guard_f: FStar_TypeChecker_Common.guard_formula;
  deferred: FStar_TypeChecker_Common.deferred;
  univ_ineqs:
    (FStar_Syntax_Syntax.universe Prims.list*
      FStar_TypeChecker_Common.univ_ineq Prims.list);
  implicits:
    (Prims.string* env* FStar_Syntax_Syntax.uvar* FStar_Syntax_Syntax.term*
      FStar_Syntax_Syntax.typ* FStar_Range.range) Prims.list;}
type implicits =
  (Prims.string* env* FStar_Syntax_Syntax.uvar* FStar_Syntax_Syntax.term*
    FStar_Syntax_Syntax.typ* FStar_Range.range) Prims.list
type env_t = env
type sigtable = FStar_Syntax_Syntax.sigelt FStar_Util.smap
let should_verify: env -> Prims.bool =
  fun env  ->
    ((Prims.op_Negation env.lax) && (Prims.op_Negation env.admit)) &&
      (FStar_Options.should_verify (env.curmodule).FStar_Ident.str)
let visible_at: delta_level -> FStar_Syntax_Syntax.qualifier -> Prims.bool =
  fun d  ->
    fun q  ->
      match (d, q) with
      | (NoDelta ,_)
        |(Eager_unfolding_only
          ,FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen )
         |(Unfold _,FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen )
          |(Unfold _,FStar_Syntax_Syntax.Visible_default ) -> true
      | (Inlining ,FStar_Syntax_Syntax.Inline_for_extraction ) -> true
      | uu____848 -> false
let default_table_size: Prims.int = Prims.parse_int "200"
let new_sigtab uu____858 = FStar_Util.smap_create default_table_size
let new_gamma_cache uu____866 =
  FStar_Util.smap_create (Prims.parse_int "100")
let initial_env:
  (env ->
     FStar_Syntax_Syntax.term ->
       (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.typ* guard_t))
    ->
    (env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.universe) ->
      solver_t -> FStar_Ident.lident -> env
  =
  fun type_of  ->
    fun universe_of  ->
      fun solver  ->
        fun module_lid  ->
          let uu____905 = new_gamma_cache () in
          let uu____907 = new_sigtab () in
          {
            solver;
            range = FStar_Range.dummyRange;
            curmodule = module_lid;
            gamma = [];
            gamma_cache = uu____905;
            modules = [];
            expected_typ = None;
            sigtab = uu____907;
            is_pattern = false;
            instantiate_imp = true;
            effects = { decls = []; order = []; joins = [] };
            generalize = true;
            letrecs = [];
            top_level = false;
            check_uvars = false;
            use_eq = false;
            is_iface = false;
            admit = false;
            lax = false;
            lax_universes = false;
            type_of;
            universe_of;
            use_bv_sorts = false;
            qname_and_index = None
          }
let sigtab: env -> FStar_Syntax_Syntax.sigelt FStar_Util.smap =
  fun env  -> env.sigtab
let gamma_cache: env -> cached_elt FStar_Util.smap =
  fun env  -> env.gamma_cache
let query_indices:
  (FStar_Ident.lident* Prims.int) Prims.list Prims.list FStar_ST.ref =
  FStar_Util.mk_ref [[]]
let push_query_indices: Prims.unit -> Prims.unit =
  fun uu____950  ->
    let uu____951 = FStar_ST.read query_indices in
    match uu____951 with
    | [] -> failwith "Empty query indices!"
    | uu____965 ->
        let uu____970 =
          let uu____975 =
            let uu____979 = FStar_ST.read query_indices in
            FStar_List.hd uu____979 in
          let uu____993 = FStar_ST.read query_indices in uu____975 ::
            uu____993 in
        FStar_ST.write query_indices uu____970
let pop_query_indices: Prims.unit -> Prims.unit =
  fun uu____1015  ->
    let uu____1016 = FStar_ST.read query_indices in
    match uu____1016 with
    | [] -> failwith "Empty query indices!"
    | hd1::tl1 -> FStar_ST.write query_indices tl1
let add_query_index: (FStar_Ident.lident* Prims.int) -> Prims.unit =
  fun uu____1052  ->
    match uu____1052 with
    | (l,n1) ->
        let uu____1057 = FStar_ST.read query_indices in
        (match uu____1057 with
         | hd1::tl1 -> FStar_ST.write query_indices (((l, n1) :: hd1) :: tl1)
         | uu____1091 -> failwith "Empty query indices")
let peek_query_indices:
  Prims.unit -> (FStar_Ident.lident* Prims.int) Prims.list =
  fun uu____1101  ->
    let uu____1102 = FStar_ST.read query_indices in FStar_List.hd uu____1102
let commit_query_index_mark: Prims.unit -> Prims.unit =
  fun uu____1118  ->
    let uu____1119 = FStar_ST.read query_indices in
    match uu____1119 with
    | hd1::uu____1131::tl1 -> FStar_ST.write query_indices (hd1 :: tl1)
    | uu____1158 -> failwith "Unmarked query index stack"
let stack: env Prims.list FStar_ST.ref = FStar_Util.mk_ref []
let push_stack: env -> env =
  fun env  ->
    (let uu____1172 =
       let uu____1174 = FStar_ST.read stack in env :: uu____1174 in
     FStar_ST.write stack uu____1172);
    (let uu___114_1182 = env in
     let uu____1183 = FStar_Util.smap_copy (gamma_cache env) in
     let uu____1185 = FStar_Util.smap_copy (sigtab env) in
     {
       solver = (uu___114_1182.solver);
       range = (uu___114_1182.range);
       curmodule = (uu___114_1182.curmodule);
       gamma = (uu___114_1182.gamma);
       gamma_cache = uu____1183;
       modules = (uu___114_1182.modules);
       expected_typ = (uu___114_1182.expected_typ);
       sigtab = uu____1185;
       is_pattern = (uu___114_1182.is_pattern);
       instantiate_imp = (uu___114_1182.instantiate_imp);
       effects = (uu___114_1182.effects);
       generalize = (uu___114_1182.generalize);
       letrecs = (uu___114_1182.letrecs);
       top_level = (uu___114_1182.top_level);
       check_uvars = (uu___114_1182.check_uvars);
       use_eq = (uu___114_1182.use_eq);
       is_iface = (uu___114_1182.is_iface);
       admit = (uu___114_1182.admit);
       lax = (uu___114_1182.lax);
       lax_universes = (uu___114_1182.lax_universes);
       type_of = (uu___114_1182.type_of);
       universe_of = (uu___114_1182.universe_of);
       use_bv_sorts = (uu___114_1182.use_bv_sorts);
       qname_and_index = (uu___114_1182.qname_and_index)
     })
let pop_stack: Prims.unit -> env =
  fun uu____1189  ->
    let uu____1190 = FStar_ST.read stack in
    match uu____1190 with
    | env::tl1 -> (FStar_ST.write stack tl1; env)
    | uu____1202 -> failwith "Impossible: Too many pops"
let cleanup_interactive: env -> Prims.unit = fun env  -> (env.solver).pop ""
let push: env -> Prims.string -> env =
  fun env  ->
    fun msg  -> push_query_indices (); (env.solver).push msg; push_stack env
let pop: env -> Prims.string -> env =
  fun env  ->
    fun msg  -> (env.solver).pop msg; pop_query_indices (); pop_stack ()
let mark: env -> env =
  fun env  ->
    (env.solver).mark "USER MARK"; push_query_indices (); push_stack env
let commit_mark: env -> env =
  fun env  ->
    commit_query_index_mark ();
    (env.solver).commit_mark "USER MARK";
    (let uu____1234 = pop_stack () in ());
    env
let reset_mark: env -> env =
  fun env  ->
    (env.solver).reset_mark "USER MARK"; pop_query_indices (); pop_stack ()
let incr_query_index: env -> env =
  fun env  ->
    let qix = peek_query_indices () in
    match env.qname_and_index with
    | None  -> env
    | Some (l,n1) ->
        let uu____1253 =
          FStar_All.pipe_right qix
            (FStar_List.tryFind
               (fun uu____1265  ->
                  match uu____1265 with
                  | (m,uu____1269) -> FStar_Ident.lid_equals l m)) in
        (match uu____1253 with
         | None  ->
             let next = n1 + (Prims.parse_int "1") in
             (add_query_index (l, next);
              (let uu___115_1274 = env in
               {
                 solver = (uu___115_1274.solver);
                 range = (uu___115_1274.range);
                 curmodule = (uu___115_1274.curmodule);
                 gamma = (uu___115_1274.gamma);
                 gamma_cache = (uu___115_1274.gamma_cache);
                 modules = (uu___115_1274.modules);
                 expected_typ = (uu___115_1274.expected_typ);
                 sigtab = (uu___115_1274.sigtab);
                 is_pattern = (uu___115_1274.is_pattern);
                 instantiate_imp = (uu___115_1274.instantiate_imp);
                 effects = (uu___115_1274.effects);
                 generalize = (uu___115_1274.generalize);
                 letrecs = (uu___115_1274.letrecs);
                 top_level = (uu___115_1274.top_level);
                 check_uvars = (uu___115_1274.check_uvars);
                 use_eq = (uu___115_1274.use_eq);
                 is_iface = (uu___115_1274.is_iface);
                 admit = (uu___115_1274.admit);
                 lax = (uu___115_1274.lax);
                 lax_universes = (uu___115_1274.lax_universes);
                 type_of = (uu___115_1274.type_of);
                 universe_of = (uu___115_1274.universe_of);
                 use_bv_sorts = (uu___115_1274.use_bv_sorts);
                 qname_and_index = (Some (l, next))
               }))
         | Some (uu____1277,m) ->
             let next = m + (Prims.parse_int "1") in
             (add_query_index (l, next);
              (let uu___116_1283 = env in
               {
                 solver = (uu___116_1283.solver);
                 range = (uu___116_1283.range);
                 curmodule = (uu___116_1283.curmodule);
                 gamma = (uu___116_1283.gamma);
                 gamma_cache = (uu___116_1283.gamma_cache);
                 modules = (uu___116_1283.modules);
                 expected_typ = (uu___116_1283.expected_typ);
                 sigtab = (uu___116_1283.sigtab);
                 is_pattern = (uu___116_1283.is_pattern);
                 instantiate_imp = (uu___116_1283.instantiate_imp);
                 effects = (uu___116_1283.effects);
                 generalize = (uu___116_1283.generalize);
                 letrecs = (uu___116_1283.letrecs);
                 top_level = (uu___116_1283.top_level);
                 check_uvars = (uu___116_1283.check_uvars);
                 use_eq = (uu___116_1283.use_eq);
                 is_iface = (uu___116_1283.is_iface);
                 admit = (uu___116_1283.admit);
                 lax = (uu___116_1283.lax);
                 lax_universes = (uu___116_1283.lax_universes);
                 type_of = (uu___116_1283.type_of);
                 universe_of = (uu___116_1283.universe_of);
                 use_bv_sorts = (uu___116_1283.use_bv_sorts);
                 qname_and_index = (Some (l, next))
               })))
let debug: env -> FStar_Options.debug_level_t -> Prims.bool =
  fun env  ->
    fun l  -> FStar_Options.debug_at_level (env.curmodule).FStar_Ident.str l
let set_range: env -> FStar_Range.range -> env =
  fun e  ->
    fun r  ->
      if r = FStar_Range.dummyRange
      then e
      else
        (let uu___117_1299 = e in
         {
           solver = (uu___117_1299.solver);
           range = r;
           curmodule = (uu___117_1299.curmodule);
           gamma = (uu___117_1299.gamma);
           gamma_cache = (uu___117_1299.gamma_cache);
           modules = (uu___117_1299.modules);
           expected_typ = (uu___117_1299.expected_typ);
           sigtab = (uu___117_1299.sigtab);
           is_pattern = (uu___117_1299.is_pattern);
           instantiate_imp = (uu___117_1299.instantiate_imp);
           effects = (uu___117_1299.effects);
           generalize = (uu___117_1299.generalize);
           letrecs = (uu___117_1299.letrecs);
           top_level = (uu___117_1299.top_level);
           check_uvars = (uu___117_1299.check_uvars);
           use_eq = (uu___117_1299.use_eq);
           is_iface = (uu___117_1299.is_iface);
           admit = (uu___117_1299.admit);
           lax = (uu___117_1299.lax);
           lax_universes = (uu___117_1299.lax_universes);
           type_of = (uu___117_1299.type_of);
           universe_of = (uu___117_1299.universe_of);
           use_bv_sorts = (uu___117_1299.use_bv_sorts);
           qname_and_index = (uu___117_1299.qname_and_index)
         })
let get_range: env -> FStar_Range.range = fun e  -> e.range
let modules: env -> FStar_Syntax_Syntax.modul Prims.list =
  fun env  -> env.modules
let current_module: env -> FStar_Ident.lident = fun env  -> env.curmodule
let set_current_module: env -> FStar_Ident.lident -> env =
  fun env  ->
    fun lid  ->
      let uu___118_1316 = env in
      {
        solver = (uu___118_1316.solver);
        range = (uu___118_1316.range);
        curmodule = lid;
        gamma = (uu___118_1316.gamma);
        gamma_cache = (uu___118_1316.gamma_cache);
        modules = (uu___118_1316.modules);
        expected_typ = (uu___118_1316.expected_typ);
        sigtab = (uu___118_1316.sigtab);
        is_pattern = (uu___118_1316.is_pattern);
        instantiate_imp = (uu___118_1316.instantiate_imp);
        effects = (uu___118_1316.effects);
        generalize = (uu___118_1316.generalize);
        letrecs = (uu___118_1316.letrecs);
        top_level = (uu___118_1316.top_level);
        check_uvars = (uu___118_1316.check_uvars);
        use_eq = (uu___118_1316.use_eq);
        is_iface = (uu___118_1316.is_iface);
        admit = (uu___118_1316.admit);
        lax = (uu___118_1316.lax);
        lax_universes = (uu___118_1316.lax_universes);
        type_of = (uu___118_1316.type_of);
        universe_of = (uu___118_1316.universe_of);
        use_bv_sorts = (uu___118_1316.use_bv_sorts);
        qname_and_index = (uu___118_1316.qname_and_index)
      }
let has_interface: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun l  ->
      FStar_All.pipe_right env.modules
        (FStar_Util.for_some
           (fun m  ->
              m.FStar_Syntax_Syntax.is_interface &&
                (FStar_Ident.lid_equals m.FStar_Syntax_Syntax.name l)))
let find_in_sigtab:
  env -> FStar_Ident.lident -> FStar_Syntax_Syntax.sigelt Prims.option =
  fun env  ->
    fun lid  ->
      FStar_Util.smap_try_find (sigtab env) (FStar_Ident.text_of_lid lid)
let name_not_found: FStar_Ident.lid -> Prims.string =
  fun l  -> FStar_Util.format1 "Name \"%s\" not found" l.FStar_Ident.str
let variable_not_found: FStar_Syntax_Syntax.bv -> Prims.string =
  fun v1  ->
    let uu____1338 = FStar_Syntax_Print.bv_to_string v1 in
    FStar_Util.format1 "Variable \"%s\" not found" uu____1338
let new_u_univ: Prims.unit -> FStar_Syntax_Syntax.universe =
  fun uu____1341  ->
    let uu____1342 = FStar_Unionfind.fresh None in
    FStar_Syntax_Syntax.U_unif uu____1342
let inst_tscheme_with:
  FStar_Syntax_Syntax.tscheme ->
    FStar_Syntax_Syntax.universes ->
      (FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.term)
  =
  fun ts  ->
    fun us  ->
      match (ts, us) with
      | (([],t),[]) -> ([], t)
      | ((formals,t),uu____1365) ->
          let n1 = (FStar_List.length formals) - (Prims.parse_int "1") in
          let vs =
            FStar_All.pipe_right us
              (FStar_List.mapi
                 (fun i  -> fun u  -> FStar_Syntax_Syntax.UN ((n1 - i), u))) in
          let uu____1381 = FStar_Syntax_Subst.subst vs t in (us, uu____1381)
let inst_tscheme:
  FStar_Syntax_Syntax.tscheme ->
    (FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.term)
  =
  fun uu___102_1386  ->
    match uu___102_1386 with
    | ([],t) -> ([], t)
    | (us,t) ->
        let us' =
          FStar_All.pipe_right us
            (FStar_List.map (fun uu____1400  -> new_u_univ ())) in
        inst_tscheme_with (us, t) us'
let inst_tscheme_with_range:
  FStar_Range.range ->
    FStar_Syntax_Syntax.tscheme ->
      (FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.term)
  =
  fun r  ->
    fun t  ->
      let uu____1410 = inst_tscheme t in
      match uu____1410 with
      | (us,t1) ->
          let uu____1417 = FStar_Syntax_Subst.set_use_range r t1 in
          (us, uu____1417)
let inst_effect_fun_with:
  FStar_Syntax_Syntax.universes ->
    env ->
      FStar_Syntax_Syntax.eff_decl ->
        FStar_Syntax_Syntax.tscheme -> FStar_Syntax_Syntax.term
  =
  fun insts  ->
    fun env  ->
      fun ed  ->
        fun uu____1429  ->
          match uu____1429 with
          | (us,t) ->
              (match ed.FStar_Syntax_Syntax.binders with
               | [] ->
                   let univs1 =
                     FStar_List.append ed.FStar_Syntax_Syntax.univs us in
                   (if
                      (FStar_List.length insts) <> (FStar_List.length univs1)
                    then
                      (let uu____1443 =
                         let uu____1444 =
                           FStar_All.pipe_left FStar_Util.string_of_int
                             (FStar_List.length univs1) in
                         let uu____1447 =
                           FStar_All.pipe_left FStar_Util.string_of_int
                             (FStar_List.length insts) in
                         let uu____1450 =
                           FStar_Syntax_Print.lid_to_string
                             ed.FStar_Syntax_Syntax.mname in
                         let uu____1451 = FStar_Syntax_Print.term_to_string t in
                         FStar_Util.format4
                           "Expected %s instantiations; got %s; failed universe instantiation in effect %s\n\t%s\n"
                           uu____1444 uu____1447 uu____1450 uu____1451 in
                       failwith uu____1443)
                    else ();
                    (let uu____1453 =
                       inst_tscheme_with
                         ((FStar_List.append ed.FStar_Syntax_Syntax.univs us),
                           t) insts in
                     Prims.snd uu____1453))
               | uu____1457 ->
                   let uu____1458 =
                     let uu____1459 =
                       FStar_Syntax_Print.lid_to_string
                         ed.FStar_Syntax_Syntax.mname in
                     FStar_Util.format1
                       "Unexpected use of an uninstantiated effect: %s\n"
                       uu____1459 in
                   failwith uu____1458)
type tri =
  | Yes
  | No
  | Maybe
let uu___is_Yes: tri -> Prims.bool =
  fun projectee  -> match projectee with | Yes  -> true | uu____1463 -> false
let uu___is_No: tri -> Prims.bool =
  fun projectee  -> match projectee with | No  -> true | uu____1467 -> false
let uu___is_Maybe: tri -> Prims.bool =
  fun projectee  ->
    match projectee with | Maybe  -> true | uu____1471 -> false
let in_cur_mod: env -> FStar_Ident.lident -> tri =
  fun env  ->
    fun l  ->
      let cur = current_module env in
      if l.FStar_Ident.nsstr = cur.FStar_Ident.str
      then Yes
      else
        if FStar_Util.starts_with l.FStar_Ident.nsstr cur.FStar_Ident.str
        then
          (let lns = FStar_List.append l.FStar_Ident.ns [l.FStar_Ident.ident] in
           let cur1 =
             FStar_List.append cur.FStar_Ident.ns [cur.FStar_Ident.ident] in
           let rec aux c l1 =
             match (c, l1) with
             | ([],uu____1497) -> Maybe
             | (uu____1501,[]) -> No
             | (hd1::tl1,hd'::tl') when
                 hd1.FStar_Ident.idText = hd'.FStar_Ident.idText ->
                 aux tl1 tl'
             | uu____1513 -> No in
           aux cur1 lns)
        else No
let lookup_qname:
  env ->
    FStar_Ident.lident ->
      (((FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.typ),(FStar_Syntax_Syntax.sigelt*
                                                                   FStar_Syntax_Syntax.universes
                                                                   Prims.option))
        FStar_Util.either* FStar_Range.range) Prims.option
  =
  fun env  ->
    fun lid  ->
      let cur_mod = in_cur_mod env lid in
      let cache t =
        FStar_Util.smap_add (gamma_cache env) lid.FStar_Ident.str t; Some t in
      let found =
        if cur_mod <> No
        then
          let uu____1573 =
            FStar_Util.smap_try_find (gamma_cache env) lid.FStar_Ident.str in
          match uu____1573 with
          | None  ->
              FStar_Util.find_map env.gamma
                (fun uu___103_1594  ->
                   match uu___103_1594 with
                   | Binding_lid (l,t) ->
                       if FStar_Ident.lid_equals lid l
                       then
                         let uu____1617 =
                           let uu____1627 =
                             let uu____1635 = inst_tscheme t in
                             FStar_Util.Inl uu____1635 in
                           (uu____1627, (FStar_Ident.range_of_lid l)) in
                         Some uu____1617
                       else None
                   | Binding_sig
                       (uu____1669,{
                                     FStar_Syntax_Syntax.sigel =
                                       FStar_Syntax_Syntax.Sig_bundle
                                       (ses,uu____1671);
                                     FStar_Syntax_Syntax.sigrng = uu____1672;
                                     FStar_Syntax_Syntax.sigquals =
                                       uu____1673;
                                     FStar_Syntax_Syntax.sigmeta = uu____1674;_})
                       ->
                       FStar_Util.find_map ses
                         (fun se  ->
                            let uu____1683 =
                              FStar_All.pipe_right
                                (FStar_Syntax_Util.lids_of_sigelt se)
                                (FStar_Util.for_some
                                   (FStar_Ident.lid_equals lid)) in
                            if uu____1683
                            then
                              cache
                                ((FStar_Util.Inr (se, None)),
                                  (FStar_Syntax_Util.range_of_sigelt se))
                            else None)
                   | Binding_sig (lids,s) ->
                       let maybe_cache t =
                         match s.FStar_Syntax_Syntax.sigel with
                         | FStar_Syntax_Syntax.Sig_declare_typ uu____1710 ->
                             Some t
                         | uu____1714 -> cache t in
                       let uu____1715 =
                         FStar_List.tryFind (FStar_Ident.lid_equals lid) lids in
                       (match uu____1715 with
                        | None  -> None
                        | Some l ->
                            maybe_cache
                              ((FStar_Util.Inr (s, None)),
                                (FStar_Ident.range_of_lid l)))
                   | Binding_sig_inst (lids,s,us) ->
                       let uu____1755 =
                         FStar_List.tryFind (FStar_Ident.lid_equals lid) lids in
                       (match uu____1755 with
                        | None  -> None
                        | Some l ->
                            Some
                              ((FStar_Util.Inr (s, (Some us))),
                                (FStar_Ident.range_of_lid l)))
                   | uu____1799 -> None)
          | se -> se
        else None in
      if FStar_Util.is_some found
      then found
      else
        (let uu____1841 =
           (cur_mod <> Yes) || (has_interface env env.curmodule) in
         if uu____1841
         then
           let uu____1852 = find_in_sigtab env lid in
           match uu____1852 with
           | Some se ->
               Some
                 ((FStar_Util.Inr (se, None)),
                   (FStar_Syntax_Util.range_of_sigelt se))
           | None  -> None
         else None)
let rec add_sigelt: env -> FStar_Syntax_Syntax.sigelt -> Prims.unit =
  fun env  ->
    fun se  ->
      match se.FStar_Syntax_Syntax.sigel with
      | FStar_Syntax_Syntax.Sig_bundle (ses,uu____1918) ->
          add_sigelts env ses
      | uu____1923 ->
          let lids = FStar_Syntax_Util.lids_of_sigelt se in
          (FStar_List.iter
             (fun l  -> FStar_Util.smap_add (sigtab env) l.FStar_Ident.str se)
             lids;
           (match se.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_new_effect ne ->
                FStar_All.pipe_right ne.FStar_Syntax_Syntax.actions
                  (FStar_List.iter
                     (fun a  ->
                        let se_let =
                          FStar_Syntax_Util.action_as_lb
                            ne.FStar_Syntax_Syntax.mname a in
                        FStar_Util.smap_add (sigtab env)
                          (a.FStar_Syntax_Syntax.action_name).FStar_Ident.str
                          se_let))
            | uu____1932 -> ()))
and add_sigelts: env -> FStar_Syntax_Syntax.sigelt Prims.list -> Prims.unit =
  fun env  ->
    fun ses  -> FStar_All.pipe_right ses (FStar_List.iter (add_sigelt env))
let try_lookup_bv:
  env ->
    FStar_Syntax_Syntax.bv ->
      ((FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax* FStar_Range.range) Prims.option
  =
  fun env  ->
    fun bv  ->
      FStar_Util.find_map env.gamma
        (fun uu___104_1950  ->
           match uu___104_1950 with
           | Binding_var id when FStar_Syntax_Syntax.bv_eq id bv ->
               Some
                 ((id.FStar_Syntax_Syntax.sort),
                   ((id.FStar_Syntax_Syntax.ppname).FStar_Ident.idRange))
           | uu____1963 -> None)
let lookup_type_of_let:
  FStar_Syntax_Syntax.sigelt ->
    FStar_Ident.lident ->
      ((FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.term)*
        FStar_Range.range) Prims.option
  =
  fun se  ->
    fun lid  ->
      match se.FStar_Syntax_Syntax.sigel with
      | FStar_Syntax_Syntax.Sig_let
          ((uu____1984,lb::[]),uu____1986,uu____1987) ->
          let uu____1996 =
            let uu____2001 =
              inst_tscheme
                ((lb.FStar_Syntax_Syntax.lbunivs),
                  (lb.FStar_Syntax_Syntax.lbtyp)) in
            let uu____2007 =
              FStar_Syntax_Syntax.range_of_lbname
                lb.FStar_Syntax_Syntax.lbname in
            (uu____2001, uu____2007) in
          Some uu____1996
      | FStar_Syntax_Syntax.Sig_let ((uu____2014,lbs),uu____2016,uu____2017)
          ->
          FStar_Util.find_map lbs
            (fun lb  ->
               match lb.FStar_Syntax_Syntax.lbname with
               | FStar_Util.Inl uu____2037 -> failwith "impossible"
               | FStar_Util.Inr fv ->
                   let uu____2044 = FStar_Syntax_Syntax.fv_eq_lid fv lid in
                   if uu____2044
                   then
                     let uu____2050 =
                       let uu____2055 =
                         inst_tscheme
                           ((lb.FStar_Syntax_Syntax.lbunivs),
                             (lb.FStar_Syntax_Syntax.lbtyp)) in
                       let uu____2061 = FStar_Syntax_Syntax.range_of_fv fv in
                       (uu____2055, uu____2061) in
                     Some uu____2050
                   else None)
      | uu____2073 -> None
let effect_signature:
  FStar_Syntax_Syntax.sigelt ->
    ((FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.term)*
      FStar_Range.range) Prims.option
  =
  fun se  ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_new_effect ne ->
        let uu____2092 =
          let uu____2097 =
            let uu____2100 =
              let uu____2101 =
                let uu____2104 =
                  FStar_Syntax_Syntax.mk_Total
                    ne.FStar_Syntax_Syntax.signature in
                FStar_Syntax_Util.arrow ne.FStar_Syntax_Syntax.binders
                  uu____2104 in
              ((ne.FStar_Syntax_Syntax.univs), uu____2101) in
            inst_tscheme uu____2100 in
          (uu____2097, (se.FStar_Syntax_Syntax.sigrng)) in
        Some uu____2092
    | FStar_Syntax_Syntax.Sig_effect_abbrev
        (lid,us,binders,uu____2118,uu____2119) ->
        let uu____2122 =
          let uu____2127 =
            let uu____2130 =
              let uu____2131 =
                let uu____2134 =
                  FStar_Syntax_Syntax.mk_Total FStar_Syntax_Syntax.teff in
                FStar_Syntax_Util.arrow binders uu____2134 in
              (us, uu____2131) in
            inst_tscheme uu____2130 in
          (uu____2127, (se.FStar_Syntax_Syntax.sigrng)) in
        Some uu____2122
    | uu____2145 -> None
let try_lookup_lid_aux:
  env ->
    FStar_Ident.lident ->
      ((FStar_Syntax_Syntax.universes*
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax)* FStar_Range.range) Prims.option
  =
  fun env  ->
    fun lid  ->
      let mapper uu____2180 =
        match uu____2180 with
        | (lr,rng) ->
            (match lr with
             | FStar_Util.Inl t -> Some (t, rng)
             | FStar_Util.Inr
                 ({
                    FStar_Syntax_Syntax.sigel =
                      FStar_Syntax_Syntax.Sig_datacon
                      (uu____2230,uvs,t,uu____2233,uu____2234,uu____2235);
                    FStar_Syntax_Syntax.sigrng = uu____2236;
                    FStar_Syntax_Syntax.sigquals = uu____2237;
                    FStar_Syntax_Syntax.sigmeta = uu____2238;_},None
                  )
                 ->
                 let uu____2248 =
                   let uu____2253 = inst_tscheme (uvs, t) in
                   (uu____2253, rng) in
                 Some uu____2248
             | FStar_Util.Inr
                 ({
                    FStar_Syntax_Syntax.sigel =
                      FStar_Syntax_Syntax.Sig_declare_typ (l,uvs,t);
                    FStar_Syntax_Syntax.sigrng = uu____2265;
                    FStar_Syntax_Syntax.sigquals = qs;
                    FStar_Syntax_Syntax.sigmeta = uu____2267;_},None
                  )
                 ->
                 let uu____2275 =
                   let uu____2276 = in_cur_mod env l in uu____2276 = Yes in
                 if uu____2275
                 then
                   let uu____2282 =
                     (FStar_All.pipe_right qs
                        (FStar_List.contains FStar_Syntax_Syntax.Assumption))
                       || env.is_iface in
                   (if uu____2282
                    then
                      let uu____2289 =
                        let uu____2294 = inst_tscheme (uvs, t) in
                        (uu____2294, rng) in
                      Some uu____2289
                    else None)
                 else
                   (let uu____2309 =
                      let uu____2314 = inst_tscheme (uvs, t) in
                      (uu____2314, rng) in
                    Some uu____2309)
             | FStar_Util.Inr
                 ({
                    FStar_Syntax_Syntax.sigel =
                      FStar_Syntax_Syntax.Sig_inductive_typ
                      (lid1,uvs,tps,k,uu____2327,uu____2328);
                    FStar_Syntax_Syntax.sigrng = uu____2329;
                    FStar_Syntax_Syntax.sigquals = uu____2330;
                    FStar_Syntax_Syntax.sigmeta = uu____2331;_},None
                  )
                 ->
                 (match tps with
                  | [] ->
                      let uu____2350 =
                        let uu____2355 = inst_tscheme (uvs, k) in
                        (uu____2355, rng) in
                      Some uu____2350
                  | uu____2364 ->
                      let uu____2365 =
                        let uu____2370 =
                          let uu____2373 =
                            let uu____2374 =
                              let uu____2377 = FStar_Syntax_Syntax.mk_Total k in
                              FStar_Syntax_Util.flat_arrow tps uu____2377 in
                            (uvs, uu____2374) in
                          inst_tscheme uu____2373 in
                        (uu____2370, rng) in
                      Some uu____2365)
             | FStar_Util.Inr
                 ({
                    FStar_Syntax_Syntax.sigel =
                      FStar_Syntax_Syntax.Sig_inductive_typ
                      (lid1,uvs,tps,k,uu____2392,uu____2393);
                    FStar_Syntax_Syntax.sigrng = uu____2394;
                    FStar_Syntax_Syntax.sigquals = uu____2395;
                    FStar_Syntax_Syntax.sigmeta = uu____2396;_},Some
                  us)
                 ->
                 (match tps with
                  | [] ->
                      let uu____2416 =
                        let uu____2421 = inst_tscheme_with (uvs, k) us in
                        (uu____2421, rng) in
                      Some uu____2416
                  | uu____2430 ->
                      let uu____2431 =
                        let uu____2436 =
                          let uu____2439 =
                            let uu____2440 =
                              let uu____2443 = FStar_Syntax_Syntax.mk_Total k in
                              FStar_Syntax_Util.flat_arrow tps uu____2443 in
                            (uvs, uu____2440) in
                          inst_tscheme_with uu____2439 us in
                        (uu____2436, rng) in
                      Some uu____2431)
             | FStar_Util.Inr se ->
                 let uu____2463 =
                   match se with
                   | ({
                        FStar_Syntax_Syntax.sigel =
                          FStar_Syntax_Syntax.Sig_let uu____2474;
                        FStar_Syntax_Syntax.sigrng = uu____2475;
                        FStar_Syntax_Syntax.sigquals = uu____2476;
                        FStar_Syntax_Syntax.sigmeta = uu____2477;_},None
                      ) -> lookup_type_of_let (Prims.fst se) lid
                   | uu____2486 -> effect_signature (Prims.fst se) in
                 FStar_All.pipe_right uu____2463
                   (FStar_Util.map_option
                      (fun uu____2509  ->
                         match uu____2509 with | (us_t,rng1) -> (us_t, rng1)))) in
      let uu____2526 =
        let uu____2532 = lookup_qname env lid in
        FStar_Util.bind_opt uu____2532 mapper in
      match uu____2526 with
      | Some ((us,t),r) ->
          Some
            ((us,
               (let uu___119_2584 = t in
                {
                  FStar_Syntax_Syntax.n =
                    (uu___119_2584.FStar_Syntax_Syntax.n);
                  FStar_Syntax_Syntax.tk =
                    (uu___119_2584.FStar_Syntax_Syntax.tk);
                  FStar_Syntax_Syntax.pos = (FStar_Ident.range_of_lid lid);
                  FStar_Syntax_Syntax.vars =
                    (uu___119_2584.FStar_Syntax_Syntax.vars)
                })), r)
      | None  -> None
let lid_exists: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun l  ->
      let uu____2605 = lookup_qname env l in
      match uu____2605 with | None  -> false | Some uu____2625 -> true
let lookup_bv:
  env ->
    FStar_Syntax_Syntax.bv -> (FStar_Syntax_Syntax.typ* FStar_Range.range)
  =
  fun env  ->
    fun bv  ->
      let bvr = FStar_Syntax_Syntax.range_of_bv bv in
      let uu____2653 = try_lookup_bv env bv in
      match uu____2653 with
      | None  ->
          let uu____2661 =
            let uu____2662 =
              let uu____2665 = variable_not_found bv in (uu____2665, bvr) in
            FStar_Errors.Error uu____2662 in
          Prims.raise uu____2661
      | Some (t,r) ->
          let uu____2672 = FStar_Syntax_Subst.set_use_range bvr t in
          let uu____2673 = FStar_Range.set_use_range r bvr in
          (uu____2672, uu____2673)
let try_lookup_lid:
  env ->
    FStar_Ident.lident ->
      ((FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.typ)*
        FStar_Range.range) Prims.option
  =
  fun env  ->
    fun l  ->
      let uu____2685 = try_lookup_lid_aux env l in
      match uu____2685 with
      | None  -> None
      | Some ((us,t),r) ->
          let use_range = FStar_Ident.range_of_lid l in
          let r1 = FStar_Range.set_use_range r use_range in
          let uu____2727 =
            let uu____2732 =
              let uu____2735 = FStar_Syntax_Subst.set_use_range use_range t in
              (us, uu____2735) in
            (uu____2732, r1) in
          Some uu____2727
let lookup_lid:
  env ->
    FStar_Ident.lident ->
      ((FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.typ)*
        FStar_Range.range)
  =
  fun env  ->
    fun l  ->
      let uu____2752 = try_lookup_lid env l in
      match uu____2752 with
      | None  ->
          let uu____2766 =
            let uu____2767 =
              let uu____2770 = name_not_found l in
              (uu____2770, (FStar_Ident.range_of_lid l)) in
            FStar_Errors.Error uu____2767 in
          Prims.raise uu____2766
      | Some v1 -> v1
let lookup_univ: env -> FStar_Syntax_Syntax.univ_name -> Prims.bool =
  fun env  ->
    fun x  ->
      FStar_All.pipe_right
        (FStar_List.find
           (fun uu___105_2791  ->
              match uu___105_2791 with
              | Binding_univ y -> x.FStar_Ident.idText = y.FStar_Ident.idText
              | uu____2793 -> false) env.gamma) FStar_Option.isSome
let try_lookup_val_decl:
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.tscheme* FStar_Syntax_Syntax.qualifier Prims.list)
        Prims.option
  =
  fun env  ->
    fun lid  ->
      let uu____2804 = lookup_qname env lid in
      match uu____2804 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_declare_typ
                (uu____2819,uvs,t);
              FStar_Syntax_Syntax.sigrng = uu____2822;
              FStar_Syntax_Syntax.sigquals = q;
              FStar_Syntax_Syntax.sigmeta = uu____2824;_},None
            ),uu____2825)
          ->
          let uu____2849 =
            let uu____2855 =
              let uu____2858 =
                FStar_Syntax_Subst.set_use_range
                  (FStar_Ident.range_of_lid lid) t in
              (uvs, uu____2858) in
            (uu____2855, q) in
          Some uu____2849
      | uu____2867 -> None
let lookup_val_decl:
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.typ)
  =
  fun env  ->
    fun lid  ->
      let uu____2889 = lookup_qname env lid in
      match uu____2889 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_declare_typ
                (uu____2902,uvs,t);
              FStar_Syntax_Syntax.sigrng = uu____2905;
              FStar_Syntax_Syntax.sigquals = uu____2906;
              FStar_Syntax_Syntax.sigmeta = uu____2907;_},None
            ),uu____2908)
          -> inst_tscheme_with_range (FStar_Ident.range_of_lid lid) (uvs, t)
      | uu____2932 ->
          let uu____2943 =
            let uu____2944 =
              let uu____2947 = name_not_found lid in
              (uu____2947, (FStar_Ident.range_of_lid lid)) in
            FStar_Errors.Error uu____2944 in
          Prims.raise uu____2943
let lookup_datacon:
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.universes* FStar_Syntax_Syntax.typ)
  =
  fun env  ->
    fun lid  ->
      let uu____2958 = lookup_qname env lid in
      match uu____2958 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_datacon
                (uu____2971,uvs,t,uu____2974,uu____2975,uu____2976);
              FStar_Syntax_Syntax.sigrng = uu____2977;
              FStar_Syntax_Syntax.sigquals = uu____2978;
              FStar_Syntax_Syntax.sigmeta = uu____2979;_},None
            ),uu____2980)
          -> inst_tscheme_with_range (FStar_Ident.range_of_lid lid) (uvs, t)
      | uu____3006 ->
          let uu____3017 =
            let uu____3018 =
              let uu____3021 = name_not_found lid in
              (uu____3021, (FStar_Ident.range_of_lid lid)) in
            FStar_Errors.Error uu____3018 in
          Prims.raise uu____3017
let datacons_of_typ:
  env -> FStar_Ident.lident -> (Prims.bool* FStar_Ident.lident Prims.list) =
  fun env  ->
    fun lid  ->
      let uu____3033 = lookup_qname env lid in
      match uu____3033 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel =
                FStar_Syntax_Syntax.Sig_inductive_typ
                (uu____3047,uu____3048,uu____3049,uu____3050,uu____3051,dcs);
              FStar_Syntax_Syntax.sigrng = uu____3053;
              FStar_Syntax_Syntax.sigquals = uu____3054;
              FStar_Syntax_Syntax.sigmeta = uu____3055;_},uu____3056),uu____3057)
          -> (true, dcs)
      | uu____3087 -> (false, [])
let typ_of_datacon: env -> FStar_Ident.lident -> FStar_Ident.lident =
  fun env  ->
    fun lid  ->
      let uu____3105 = lookup_qname env lid in
      match uu____3105 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_datacon
                (uu____3116,uu____3117,uu____3118,l,uu____3120,uu____3121);
              FStar_Syntax_Syntax.sigrng = uu____3122;
              FStar_Syntax_Syntax.sigquals = uu____3123;
              FStar_Syntax_Syntax.sigmeta = uu____3124;_},uu____3125),uu____3126)
          -> l
      | uu____3153 ->
          let uu____3164 =
            let uu____3165 = FStar_Syntax_Print.lid_to_string lid in
            FStar_Util.format1 "Not a datacon: %s" uu____3165 in
          failwith uu____3164
let lookup_definition:
  delta_level Prims.list ->
    env ->
      FStar_Ident.lident ->
        (FStar_Syntax_Syntax.univ_names* FStar_Syntax_Syntax.term)
          Prims.option
  =
  fun delta_levels  ->
    fun env  ->
      fun lid  ->
        let visible quals =
          FStar_All.pipe_right delta_levels
            (FStar_Util.for_some
               (fun dl  ->
                  FStar_All.pipe_right quals
                    (FStar_Util.for_some (visible_at dl)))) in
        let uu____3189 = lookup_qname env lid in
        match uu____3189 with
        | Some (FStar_Util.Inr (se,None ),uu____3204) ->
            (match se.FStar_Syntax_Syntax.sigel with
             | FStar_Syntax_Syntax.Sig_let
                 ((uu____3230,lbs),uu____3232,uu____3233) when
                 visible se.FStar_Syntax_Syntax.sigquals ->
                 FStar_Util.find_map lbs
                   (fun lb  ->
                      let fv = FStar_Util.right lb.FStar_Syntax_Syntax.lbname in
                      let uu____3248 = FStar_Syntax_Syntax.fv_eq_lid fv lid in
                      if uu____3248
                      then
                        let uu____3253 =
                          let uu____3257 =
                            let uu____3258 =
                              FStar_Syntax_Util.unascribe
                                lb.FStar_Syntax_Syntax.lbdef in
                            FStar_Syntax_Subst.set_use_range
                              (FStar_Ident.range_of_lid lid) uu____3258 in
                          ((lb.FStar_Syntax_Syntax.lbunivs), uu____3257) in
                        Some uu____3253
                      else None)
             | uu____3267 -> None)
        | uu____3270 -> None
let try_lookup_effect_lid:
  env -> FStar_Ident.lident -> FStar_Syntax_Syntax.typ Prims.option =
  fun env  ->
    fun ftv  ->
      let uu____3291 = lookup_qname env ftv in
      match uu____3291 with
      | Some (FStar_Util.Inr (se,None ),uu____3304) ->
          let uu____3327 = effect_signature se in
          (match uu____3327 with
           | None  -> None
           | Some ((uu____3338,t),r) ->
               let uu____3347 =
                 FStar_Syntax_Subst.set_use_range
                   (FStar_Ident.range_of_lid ftv) t in
               Some uu____3347)
      | uu____3348 -> None
let lookup_effect_lid: env -> FStar_Ident.lident -> FStar_Syntax_Syntax.typ =
  fun env  ->
    fun ftv  ->
      let uu____3365 = try_lookup_effect_lid env ftv in
      match uu____3365 with
      | None  ->
          let uu____3367 =
            let uu____3368 =
              let uu____3371 = name_not_found ftv in
              (uu____3371, (FStar_Ident.range_of_lid ftv)) in
            FStar_Errors.Error uu____3368 in
          Prims.raise uu____3367
      | Some k -> k
let lookup_effect_abbrev:
  env ->
    FStar_Syntax_Syntax.universes ->
      FStar_Ident.lident ->
        (FStar_Syntax_Syntax.binders* FStar_Syntax_Syntax.comp) Prims.option
  =
  fun env  ->
    fun univ_insts  ->
      fun lid0  ->
        let uu____3385 = lookup_qname env lid0 in
        match uu____3385 with
        | Some
            (FStar_Util.Inr
             ({
                FStar_Syntax_Syntax.sigel =
                  FStar_Syntax_Syntax.Sig_effect_abbrev
                  (lid,univs1,binders,c,uu____3403);
                FStar_Syntax_Syntax.sigrng = uu____3404;
                FStar_Syntax_Syntax.sigquals = quals;
                FStar_Syntax_Syntax.sigmeta = uu____3406;_},None
              ),uu____3407)
            ->
            let lid1 =
              let uu____3434 =
                FStar_Range.set_use_range (FStar_Ident.range_of_lid lid)
                  (FStar_Ident.range_of_lid lid0) in
              FStar_Ident.set_lid_range lid uu____3434 in
            let uu____3435 =
              FStar_All.pipe_right quals
                (FStar_Util.for_some
                   (fun uu___106_3437  ->
                      match uu___106_3437 with
                      | FStar_Syntax_Syntax.Irreducible  -> true
                      | uu____3438 -> false)) in
            if uu____3435
            then None
            else
              (let insts =
                 if
                   (FStar_List.length univ_insts) =
                     (FStar_List.length univs1)
                 then univ_insts
                 else
                   (let uu____3451 =
                      let uu____3452 = FStar_Syntax_Print.lid_to_string lid1 in
                      let uu____3453 =
                        FStar_All.pipe_right (FStar_List.length univ_insts)
                          FStar_Util.string_of_int in
                      FStar_Util.format2
                        "Unexpected instantiation of effect %s with %s universes"
                        uu____3452 uu____3453 in
                    failwith uu____3451) in
               match (binders, univs1) with
               | ([],uu____3459) ->
                   failwith
                     "Unexpected effect abbreviation with no arguments"
               | (uu____3468,uu____3469::uu____3470::uu____3471) ->
                   let uu____3474 =
                     let uu____3475 = FStar_Syntax_Print.lid_to_string lid1 in
                     let uu____3476 =
                       FStar_All.pipe_left FStar_Util.string_of_int
                         (FStar_List.length univs1) in
                     FStar_Util.format2
                       "Unexpected effect abbreviation %s; polymorphic in %s universes"
                       uu____3475 uu____3476 in
                   failwith uu____3474
               | uu____3482 ->
                   let uu____3485 =
                     let uu____3488 =
                       let uu____3489 = FStar_Syntax_Util.arrow binders c in
                       (univs1, uu____3489) in
                     inst_tscheme_with uu____3488 insts in
                   (match uu____3485 with
                    | (uu____3497,t) ->
                        let t1 =
                          FStar_Syntax_Subst.set_use_range
                            (FStar_Ident.range_of_lid lid1) t in
                        let uu____3500 =
                          let uu____3501 = FStar_Syntax_Subst.compress t1 in
                          uu____3501.FStar_Syntax_Syntax.n in
                        (match uu____3500 with
                         | FStar_Syntax_Syntax.Tm_arrow (binders1,c1) ->
                             Some (binders1, c1)
                         | uu____3531 -> failwith "Impossible")))
        | uu____3535 -> None
let norm_eff_name: env -> FStar_Ident.lident -> FStar_Ident.lident =
  let cache = FStar_Util.smap_create (Prims.parse_int "20") in
  fun env  ->
    fun l  ->
      let rec find1 l1 =
        let uu____3561 =
          lookup_effect_abbrev env [FStar_Syntax_Syntax.U_unknown] l1 in
        match uu____3561 with
        | None  -> None
        | Some (uu____3568,c) ->
            let l2 = FStar_Syntax_Util.comp_effect_name c in
            let uu____3573 = find1 l2 in
            (match uu____3573 with | None  -> Some l2 | Some l' -> Some l') in
      let res =
        let uu____3578 = FStar_Util.smap_try_find cache l.FStar_Ident.str in
        match uu____3578 with
        | Some l1 -> l1
        | None  ->
            let uu____3581 = find1 l in
            (match uu____3581 with
             | None  -> l
             | Some m -> (FStar_Util.smap_add cache l.FStar_Ident.str m; m)) in
      FStar_Ident.set_lid_range res (FStar_Ident.range_of_lid l)
let lookup_effect_quals:
  env -> FStar_Ident.lident -> FStar_Syntax_Syntax.qualifier Prims.list =
  fun env  ->
    fun l  ->
      let l1 = norm_eff_name env l in
      let uu____3593 = lookup_qname env l1 in
      match uu____3593 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_new_effect
                uu____3605;
              FStar_Syntax_Syntax.sigrng = uu____3606;
              FStar_Syntax_Syntax.sigquals = q;
              FStar_Syntax_Syntax.sigmeta = uu____3608;_},uu____3609),uu____3610)
          -> q
      | uu____3635 -> []
let lookup_projector:
  env -> FStar_Ident.lident -> Prims.int -> FStar_Ident.lident =
  fun env  ->
    fun lid  ->
      fun i  ->
        let fail uu____3658 =
          let uu____3659 =
            let uu____3660 = FStar_Util.string_of_int i in
            let uu____3661 = FStar_Syntax_Print.lid_to_string lid in
            FStar_Util.format2
              "Impossible: projecting field #%s from constructor %s is undefined"
              uu____3660 uu____3661 in
          failwith uu____3659 in
        let uu____3662 = lookup_datacon env lid in
        match uu____3662 with
        | (uu____3665,t) ->
            let uu____3667 =
              let uu____3668 = FStar_Syntax_Subst.compress t in
              uu____3668.FStar_Syntax_Syntax.n in
            (match uu____3667 with
             | FStar_Syntax_Syntax.Tm_arrow (binders,uu____3672) ->
                 if
                   (i < (Prims.parse_int "0")) ||
                     (i >= (FStar_List.length binders))
                 then fail ()
                 else
                   (let b = FStar_List.nth binders i in
                    let uu____3693 =
                      FStar_Syntax_Util.mk_field_projector_name lid
                        (Prims.fst b) i in
                    FStar_All.pipe_right uu____3693 Prims.fst)
             | uu____3698 -> fail ())
let is_projector: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun l  ->
      let uu____3705 = lookup_qname env l in
      match uu____3705 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_declare_typ
                (uu____3716,uu____3717,uu____3718);
              FStar_Syntax_Syntax.sigrng = uu____3719;
              FStar_Syntax_Syntax.sigquals = quals;
              FStar_Syntax_Syntax.sigmeta = uu____3721;_},uu____3722),uu____3723)
          ->
          FStar_Util.for_some
            (fun uu___107_3748  ->
               match uu___107_3748 with
               | FStar_Syntax_Syntax.Projector uu____3749 -> true
               | uu____3752 -> false) quals
      | uu____3753 -> false
let is_datacon: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun lid  ->
      let uu____3770 = lookup_qname env lid in
      match uu____3770 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_datacon
                (uu____3781,uu____3782,uu____3783,uu____3784,uu____3785,uu____3786);
              FStar_Syntax_Syntax.sigrng = uu____3787;
              FStar_Syntax_Syntax.sigquals = uu____3788;
              FStar_Syntax_Syntax.sigmeta = uu____3789;_},uu____3790),uu____3791)
          -> true
      | uu____3818 -> false
let is_record: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun lid  ->
      let uu____3835 = lookup_qname env lid in
      match uu____3835 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel =
                FStar_Syntax_Syntax.Sig_inductive_typ
                (uu____3846,uu____3847,uu____3848,uu____3849,uu____3850,uu____3851);
              FStar_Syntax_Syntax.sigrng = uu____3852;
              FStar_Syntax_Syntax.sigquals = quals;
              FStar_Syntax_Syntax.sigmeta = uu____3854;_},uu____3855),uu____3856)
          ->
          FStar_Util.for_some
            (fun uu___108_3885  ->
               match uu___108_3885 with
               | FStar_Syntax_Syntax.RecordType _
                 |FStar_Syntax_Syntax.RecordConstructor _ -> true
               | uu____3888 -> false) quals
      | uu____3889 -> false
let is_action: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun lid  ->
      let uu____3906 = lookup_qname env lid in
      match uu____3906 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_let
                (uu____3917,uu____3918,uu____3919);
              FStar_Syntax_Syntax.sigrng = uu____3920;
              FStar_Syntax_Syntax.sigquals = quals;
              FStar_Syntax_Syntax.sigmeta = uu____3922;_},uu____3923),uu____3924)
          ->
          FStar_Util.for_some
            (fun uu___109_3953  ->
               match uu___109_3953 with
               | FStar_Syntax_Syntax.Action uu____3954 -> true
               | uu____3955 -> false) quals
      | uu____3956 -> false
let is_interpreted: env -> FStar_Syntax_Syntax.term -> Prims.bool =
  let interpreted_symbols =
    [FStar_Syntax_Const.op_Eq;
    FStar_Syntax_Const.op_notEq;
    FStar_Syntax_Const.op_LT;
    FStar_Syntax_Const.op_LTE;
    FStar_Syntax_Const.op_GT;
    FStar_Syntax_Const.op_GTE;
    FStar_Syntax_Const.op_Subtraction;
    FStar_Syntax_Const.op_Minus;
    FStar_Syntax_Const.op_Addition;
    FStar_Syntax_Const.op_Multiply;
    FStar_Syntax_Const.op_Division;
    FStar_Syntax_Const.op_Modulus;
    FStar_Syntax_Const.op_And;
    FStar_Syntax_Const.op_Or;
    FStar_Syntax_Const.op_Negation] in
  fun env  ->
    fun head1  ->
      let uu____3975 =
        let uu____3976 = FStar_Syntax_Util.un_uinst head1 in
        uu____3976.FStar_Syntax_Syntax.n in
      match uu____3975 with
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          fv.FStar_Syntax_Syntax.fv_delta =
            FStar_Syntax_Syntax.Delta_equational
      | uu____3980 -> false
let is_type_constructor: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun lid  ->
      let mapper x =
        match Prims.fst x with
        | FStar_Util.Inl uu____4018 -> Some false
        | FStar_Util.Inr (se,uu____4027) ->
            (match se.FStar_Syntax_Syntax.sigel with
             | FStar_Syntax_Syntax.Sig_declare_typ uu____4036 ->
                 Some
                   (FStar_List.contains FStar_Syntax_Syntax.New
                      se.FStar_Syntax_Syntax.sigquals)
             | FStar_Syntax_Syntax.Sig_inductive_typ uu____4040 -> Some true
             | uu____4049 -> Some false) in
      let uu____4050 =
        let uu____4052 = lookup_qname env lid in
        FStar_Util.bind_opt uu____4052 mapper in
      match uu____4050 with | Some b -> b | None  -> false
let num_inductive_ty_params: env -> FStar_Ident.lident -> Prims.int =
  fun env  ->
    fun lid  ->
      let uu____4079 = lookup_qname env lid in
      match uu____4079 with
      | Some
          (FStar_Util.Inr
           ({
              FStar_Syntax_Syntax.sigel =
                FStar_Syntax_Syntax.Sig_inductive_typ
                (uu____4090,uu____4091,tps,uu____4093,uu____4094,uu____4095);
              FStar_Syntax_Syntax.sigrng = uu____4096;
              FStar_Syntax_Syntax.sigquals = uu____4097;
              FStar_Syntax_Syntax.sigmeta = uu____4098;_},uu____4099),uu____4100)
          -> FStar_List.length tps
      | uu____4132 ->
          let uu____4143 =
            let uu____4144 =
              let uu____4147 = name_not_found lid in
              (uu____4147, (FStar_Ident.range_of_lid lid)) in
            FStar_Errors.Error uu____4144 in
          Prims.raise uu____4143
let effect_decl_opt:
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.eff_decl* FStar_Syntax_Syntax.qualifier
        Prims.list) Prims.option
  =
  fun env  ->
    fun l  ->
      FStar_All.pipe_right (env.effects).decls
        (FStar_Util.find_opt
           (fun uu____4169  ->
              match uu____4169 with
              | (d,uu____4174) ->
                  FStar_Ident.lid_equals d.FStar_Syntax_Syntax.mname l))
let get_effect_decl:
  env -> FStar_Ident.lident -> FStar_Syntax_Syntax.eff_decl =
  fun env  ->
    fun l  ->
      let uu____4183 = effect_decl_opt env l in
      match uu____4183 with
      | None  ->
          let uu____4191 =
            let uu____4192 =
              let uu____4195 = name_not_found l in
              (uu____4195, (FStar_Ident.range_of_lid l)) in
            FStar_Errors.Error uu____4192 in
          Prims.raise uu____4191
      | Some md -> Prims.fst md
let identity_mlift: mlift =
  {
    mlift_wp = (fun t  -> fun wp  -> wp);
    mlift_term = (Some (fun t  -> fun wp  -> fun e  -> e))
  }
let join:
  env ->
    FStar_Ident.lident ->
      FStar_Ident.lident -> (FStar_Ident.lident* mlift* mlift)
  =
  fun env  ->
    fun l1  ->
      fun l2  ->
        if FStar_Ident.lid_equals l1 l2
        then (l1, identity_mlift, identity_mlift)
        else
          if
            ((FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_GTot_lid)
               &&
               (FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_Tot_lid))
              ||
              ((FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_GTot_lid)
                 &&
                 (FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_Tot_lid))
          then
            (FStar_Syntax_Const.effect_GTot_lid, identity_mlift,
              identity_mlift)
          else
            (let uu____4238 =
               FStar_All.pipe_right (env.effects).joins
                 (FStar_Util.find_opt
                    (fun uu____4262  ->
                       match uu____4262 with
                       | (m1,m2,uu____4270,uu____4271,uu____4272) ->
                           (FStar_Ident.lid_equals l1 m1) &&
                             (FStar_Ident.lid_equals l2 m2))) in
             match uu____4238 with
             | None  ->
                 let uu____4281 =
                   let uu____4282 =
                     let uu____4285 =
                       let uu____4286 = FStar_Syntax_Print.lid_to_string l1 in
                       let uu____4287 = FStar_Syntax_Print.lid_to_string l2 in
                       FStar_Util.format2
                         "Effects %s and %s cannot be composed" uu____4286
                         uu____4287 in
                     (uu____4285, (env.range)) in
                   FStar_Errors.Error uu____4282 in
                 Prims.raise uu____4281
             | Some (uu____4291,uu____4292,m3,j1,j2) -> (m3, j1, j2))
let monad_leq:
  env -> FStar_Ident.lident -> FStar_Ident.lident -> edge Prims.option =
  fun env  ->
    fun l1  ->
      fun l2  ->
        if
          (FStar_Ident.lid_equals l1 l2) ||
            ((FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_Tot_lid) &&
               (FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_GTot_lid))
        then Some { msource = l1; mtarget = l2; mlift = identity_mlift }
        else
          FStar_All.pipe_right (env.effects).order
            (FStar_Util.find_opt
               (fun e  ->
                  (FStar_Ident.lid_equals l1 e.msource) &&
                    (FStar_Ident.lid_equals l2 e.mtarget)))
let wp_sig_aux decls m =
  let uu____4339 =
    FStar_All.pipe_right decls
      (FStar_Util.find_opt
         (fun uu____4351  ->
            match uu____4351 with
            | (d,uu____4355) ->
                FStar_Ident.lid_equals d.FStar_Syntax_Syntax.mname m)) in
  match uu____4339 with
  | None  ->
      let uu____4362 =
        FStar_Util.format1 "Impossible: declaration for monad %s not found"
          m.FStar_Ident.str in
      failwith uu____4362
  | Some (md,_q) ->
      let uu____4371 =
        inst_tscheme
          ((md.FStar_Syntax_Syntax.univs),
            (md.FStar_Syntax_Syntax.signature)) in
      (match uu____4371 with
       | (uu____4378,s) ->
           let s1 = FStar_Syntax_Subst.compress s in
           (match ((md.FStar_Syntax_Syntax.binders),
                    (s1.FStar_Syntax_Syntax.n))
            with
            | ([],FStar_Syntax_Syntax.Tm_arrow
               ((a,uu____4386)::(wp,uu____4388)::[],c)) when
                FStar_Syntax_Syntax.is_teff (FStar_Syntax_Util.comp_result c)
                -> (a, (wp.FStar_Syntax_Syntax.sort))
            | uu____4410 -> failwith "Impossible"))
let wp_signature:
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.bv*
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax)
  = fun env  -> fun m  -> wp_sig_aux (env.effects).decls m
let null_wp_for_eff:
  env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.comp
  =
  fun env  ->
    fun eff_name  ->
      fun res_u  ->
        fun res_t  ->
          if
            FStar_Ident.lid_equals eff_name FStar_Syntax_Const.effect_Tot_lid
          then FStar_Syntax_Syntax.mk_Total' res_t (Some res_u)
          else
            if
              FStar_Ident.lid_equals eff_name
                FStar_Syntax_Const.effect_GTot_lid
            then FStar_Syntax_Syntax.mk_GTotal' res_t (Some res_u)
            else
              (let eff_name1 = norm_eff_name env eff_name in
               let ed = get_effect_decl env eff_name1 in
               let null_wp =
                 inst_effect_fun_with [res_u] env ed
                   ed.FStar_Syntax_Syntax.null_wp in
               let null_wp_res =
                 let uu____4446 = get_range env in
                 let uu____4447 =
                   let uu____4450 =
                     let uu____4451 =
                       let uu____4461 =
                         let uu____4463 = FStar_Syntax_Syntax.as_arg res_t in
                         [uu____4463] in
                       (null_wp, uu____4461) in
                     FStar_Syntax_Syntax.Tm_app uu____4451 in
                   FStar_Syntax_Syntax.mk uu____4450 in
                 uu____4447 None uu____4446 in
               let uu____4473 =
                 let uu____4474 =
                   let uu____4480 = FStar_Syntax_Syntax.as_arg null_wp_res in
                   [uu____4480] in
                 {
                   FStar_Syntax_Syntax.comp_univs = [res_u];
                   FStar_Syntax_Syntax.effect_name = eff_name1;
                   FStar_Syntax_Syntax.result_typ = res_t;
                   FStar_Syntax_Syntax.effect_args = uu____4474;
                   FStar_Syntax_Syntax.flags = []
                 } in
               FStar_Syntax_Syntax.mk_Comp uu____4473)
let build_lattice: env -> FStar_Syntax_Syntax.sigelt -> env =
  fun env  ->
    fun se  ->
      match se.FStar_Syntax_Syntax.sigel with
      | FStar_Syntax_Syntax.Sig_new_effect ne ->
          let effects =
            let uu___120_4489 = env.effects in
            {
              decls = ((ne, (se.FStar_Syntax_Syntax.sigquals)) ::
                ((env.effects).decls));
              order = (uu___120_4489.order);
              joins = (uu___120_4489.joins)
            } in
          let uu___121_4494 = env in
          {
            solver = (uu___121_4494.solver);
            range = (uu___121_4494.range);
            curmodule = (uu___121_4494.curmodule);
            gamma = (uu___121_4494.gamma);
            gamma_cache = (uu___121_4494.gamma_cache);
            modules = (uu___121_4494.modules);
            expected_typ = (uu___121_4494.expected_typ);
            sigtab = (uu___121_4494.sigtab);
            is_pattern = (uu___121_4494.is_pattern);
            instantiate_imp = (uu___121_4494.instantiate_imp);
            effects;
            generalize = (uu___121_4494.generalize);
            letrecs = (uu___121_4494.letrecs);
            top_level = (uu___121_4494.top_level);
            check_uvars = (uu___121_4494.check_uvars);
            use_eq = (uu___121_4494.use_eq);
            is_iface = (uu___121_4494.is_iface);
            admit = (uu___121_4494.admit);
            lax = (uu___121_4494.lax);
            lax_universes = (uu___121_4494.lax_universes);
            type_of = (uu___121_4494.type_of);
            universe_of = (uu___121_4494.universe_of);
            use_bv_sorts = (uu___121_4494.use_bv_sorts);
            qname_and_index = (uu___121_4494.qname_and_index)
          }
      | FStar_Syntax_Syntax.Sig_sub_effect sub1 ->
          let compose_edges e1 e2 =
            let composed_lift =
              let mlift_wp r wp1 =
                let uu____4511 = (e1.mlift).mlift_wp r wp1 in
                (e2.mlift).mlift_wp r uu____4511 in
              let mlift_term =
                match (((e1.mlift).mlift_term), ((e2.mlift).mlift_term)) with
                | (Some l1,Some l2) ->
                    Some
                      ((fun t  ->
                          fun wp  ->
                            fun e  ->
                              let uu____4590 = (e1.mlift).mlift_wp t wp in
                              let uu____4591 = l1 t wp e in
                              l2 t uu____4590 uu____4591))
                | uu____4592 -> None in
              { mlift_wp; mlift_term } in
            {
              msource = (e1.msource);
              mtarget = (e2.mtarget);
              mlift = composed_lift
            } in
          let mk_mlift_wp lift_t r wp1 =
            let uu____4627 = inst_tscheme lift_t in
            match uu____4627 with
            | (uu____4632,lift_t1) ->
                let uu____4634 =
                  let uu____4637 =
                    let uu____4638 =
                      let uu____4648 =
                        let uu____4650 = FStar_Syntax_Syntax.as_arg r in
                        let uu____4651 =
                          let uu____4653 = FStar_Syntax_Syntax.as_arg wp1 in
                          [uu____4653] in
                        uu____4650 :: uu____4651 in
                      (lift_t1, uu____4648) in
                    FStar_Syntax_Syntax.Tm_app uu____4638 in
                  FStar_Syntax_Syntax.mk uu____4637 in
                uu____4634 None wp1.FStar_Syntax_Syntax.pos in
          let sub_mlift_wp =
            match sub1.FStar_Syntax_Syntax.lift_wp with
            | Some sub_lift_wp -> mk_mlift_wp sub_lift_wp
            | None  ->
                failwith "sub effect should've been elaborated at this stage" in
          let mk_mlift_term lift_t r wp1 e =
            let uu____4698 = inst_tscheme lift_t in
            match uu____4698 with
            | (uu____4703,lift_t1) ->
                let uu____4705 =
                  let uu____4708 =
                    let uu____4709 =
                      let uu____4719 =
                        let uu____4721 = FStar_Syntax_Syntax.as_arg r in
                        let uu____4722 =
                          let uu____4724 = FStar_Syntax_Syntax.as_arg wp1 in
                          let uu____4725 =
                            let uu____4727 = FStar_Syntax_Syntax.as_arg e in
                            [uu____4727] in
                          uu____4724 :: uu____4725 in
                        uu____4721 :: uu____4722 in
                      (lift_t1, uu____4719) in
                    FStar_Syntax_Syntax.Tm_app uu____4709 in
                  FStar_Syntax_Syntax.mk uu____4708 in
                uu____4705 None e.FStar_Syntax_Syntax.pos in
          let sub_mlift_term =
            FStar_Util.map_opt sub1.FStar_Syntax_Syntax.lift mk_mlift_term in
          let edge =
            {
              msource = (sub1.FStar_Syntax_Syntax.source);
              mtarget = (sub1.FStar_Syntax_Syntax.target);
              mlift =
                { mlift_wp = sub_mlift_wp; mlift_term = sub_mlift_term }
            } in
          let id_edge l =
            {
              msource = (sub1.FStar_Syntax_Syntax.source);
              mtarget = (sub1.FStar_Syntax_Syntax.target);
              mlift = identity_mlift
            } in
          let print_mlift l =
            let bogus_term s =
              let uu____4768 =
                let uu____4769 =
                  FStar_Ident.lid_of_path [s] FStar_Range.dummyRange in
                FStar_Syntax_Syntax.lid_as_fv uu____4769
                  FStar_Syntax_Syntax.Delta_constant None in
              FStar_Syntax_Syntax.fv_to_tm uu____4768 in
            let arg = bogus_term "ARG" in
            let wp = bogus_term "WP" in
            let e = bogus_term "COMP" in
            let uu____4773 =
              let uu____4774 = l.mlift_wp arg wp in
              FStar_Syntax_Print.term_to_string uu____4774 in
            let uu____4775 =
              let uu____4776 =
                FStar_Util.map_opt l.mlift_term
                  (fun l1  ->
                     let uu____4791 = l1 arg wp e in
                     FStar_Syntax_Print.term_to_string uu____4791) in
              FStar_Util.dflt "none" uu____4776 in
            FStar_Util.format2 "{ wp : %s ; term : %s }" uu____4773
              uu____4775 in
          let order = edge :: ((env.effects).order) in
          let ms =
            FStar_All.pipe_right (env.effects).decls
              (FStar_List.map
                 (fun uu____4804  ->
                    match uu____4804 with
                    | (e,uu____4809) -> e.FStar_Syntax_Syntax.mname)) in
          let find_edge order1 uu____4822 =
            match uu____4822 with
            | (i,j) ->
                if FStar_Ident.lid_equals i j
                then
                  FStar_All.pipe_right (id_edge i) (fun _0_29  -> Some _0_29)
                else
                  FStar_All.pipe_right order1
                    (FStar_Util.find_opt
                       (fun e  ->
                          (FStar_Ident.lid_equals e.msource i) &&
                            (FStar_Ident.lid_equals e.mtarget j))) in
          let order1 =
            let fold_fun order1 k =
              let uu____4847 =
                FStar_All.pipe_right ms
                  (FStar_List.collect
                     (fun i  ->
                        if FStar_Ident.lid_equals i k
                        then []
                        else
                          FStar_All.pipe_right ms
                            (FStar_List.collect
                               (fun j  ->
                                  if FStar_Ident.lid_equals j k
                                  then []
                                  else
                                    (let uu____4859 =
                                       let uu____4864 =
                                         find_edge order1 (i, k) in
                                       let uu____4866 =
                                         find_edge order1 (k, j) in
                                       (uu____4864, uu____4866) in
                                     match uu____4859 with
                                     | (Some e1,Some e2) ->
                                         let uu____4875 = compose_edges e1 e2 in
                                         [uu____4875]
                                     | uu____4876 -> []))))) in
              FStar_List.append order1 uu____4847 in
            FStar_All.pipe_right ms (FStar_List.fold_left fold_fun order) in
          let order2 =
            FStar_Util.remove_dups
              (fun e1  ->
                 fun e2  ->
                   (FStar_Ident.lid_equals e1.msource e2.msource) &&
                     (FStar_Ident.lid_equals e1.mtarget e2.mtarget)) order1 in
          (FStar_All.pipe_right order2
             (FStar_List.iter
                (fun edge1  ->
                   let uu____4891 =
                     (FStar_Ident.lid_equals edge1.msource
                        FStar_Syntax_Const.effect_DIV_lid)
                       &&
                       (let uu____4892 =
                          lookup_effect_quals env edge1.mtarget in
                        FStar_All.pipe_right uu____4892
                          (FStar_List.contains
                             FStar_Syntax_Syntax.TotalEffect)) in
                   if uu____4891
                   then
                     let uu____4895 =
                       let uu____4896 =
                         let uu____4899 =
                           FStar_Util.format1
                             "Divergent computations cannot be included in an effect %s marked 'total'"
                             (edge1.mtarget).FStar_Ident.str in
                         let uu____4900 = get_range env in
                         (uu____4899, uu____4900) in
                       FStar_Errors.Error uu____4896 in
                     Prims.raise uu____4895
                   else ()));
           (let joins =
              FStar_All.pipe_right ms
                (FStar_List.collect
                   (fun i  ->
                      FStar_All.pipe_right ms
                        (FStar_List.collect
                           (fun j  ->
                              let join_opt =
                                if FStar_Ident.lid_equals i j
                                then Some (i, (id_edge i), (id_edge i))
                                else
                                  FStar_All.pipe_right ms
                                    (FStar_List.fold_left
                                       (fun bopt  ->
                                          fun k  ->
                                            let uu____4963 =
                                              let uu____4968 =
                                                find_edge order2 (i, k) in
                                              let uu____4970 =
                                                find_edge order2 (j, k) in
                                              (uu____4968, uu____4970) in
                                            match uu____4963 with
                                            | (Some ik,Some jk) ->
                                                (match bopt with
                                                 | None  -> Some (k, ik, jk)
                                                 | Some
                                                     (ub,uu____4993,uu____4994)
                                                     ->
                                                     let uu____4998 =
                                                       let uu____5001 =
                                                         let uu____5002 =
                                                           find_edge order2
                                                             (k, ub) in
                                                         FStar_Util.is_some
                                                           uu____5002 in
                                                       let uu____5004 =
                                                         let uu____5005 =
                                                           find_edge order2
                                                             (ub, k) in
                                                         FStar_Util.is_some
                                                           uu____5005 in
                                                       (uu____5001,
                                                         uu____5004) in
                                                     (match uu____4998 with
                                                      | (true ,true ) ->
                                                          if
                                                            FStar_Ident.lid_equals
                                                              k ub
                                                          then
                                                            (FStar_Util.print_warning
                                                               "Looking multiple times at the same upper bound candidate";
                                                             bopt)
                                                          else
                                                            failwith
                                                              "Found a cycle in the lattice"
                                                      | (false ,false ) ->
                                                          bopt
                                                      | (true ,false ) ->
                                                          Some (k, ik, jk)
                                                      | (false ,true ) ->
                                                          bopt))
                                            | uu____5024 -> bopt) None) in
                              match join_opt with
                              | None  -> []
                              | Some (k,e1,e2) ->
                                  [(i, j, k, (e1.mlift), (e2.mlift))])))) in
            let effects =
              let uu___122_5063 = env.effects in
              { decls = (uu___122_5063.decls); order = order2; joins } in
            let uu___123_5064 = env in
            {
              solver = (uu___123_5064.solver);
              range = (uu___123_5064.range);
              curmodule = (uu___123_5064.curmodule);
              gamma = (uu___123_5064.gamma);
              gamma_cache = (uu___123_5064.gamma_cache);
              modules = (uu___123_5064.modules);
              expected_typ = (uu___123_5064.expected_typ);
              sigtab = (uu___123_5064.sigtab);
              is_pattern = (uu___123_5064.is_pattern);
              instantiate_imp = (uu___123_5064.instantiate_imp);
              effects;
              generalize = (uu___123_5064.generalize);
              letrecs = (uu___123_5064.letrecs);
              top_level = (uu___123_5064.top_level);
              check_uvars = (uu___123_5064.check_uvars);
              use_eq = (uu___123_5064.use_eq);
              is_iface = (uu___123_5064.is_iface);
              admit = (uu___123_5064.admit);
              lax = (uu___123_5064.lax);
              lax_universes = (uu___123_5064.lax_universes);
              type_of = (uu___123_5064.type_of);
              universe_of = (uu___123_5064.universe_of);
              use_bv_sorts = (uu___123_5064.use_bv_sorts);
              qname_and_index = (uu___123_5064.qname_and_index)
            }))
      | uu____5065 -> env
let comp_to_comp_typ:
  env -> FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp_typ =
  fun env  ->
    fun c  ->
      let c1 =
        match c.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Total (t,None ) ->
            let u = env.universe_of env t in
            FStar_Syntax_Syntax.mk_Total' t (Some u)
        | FStar_Syntax_Syntax.GTotal (t,None ) ->
            let u = env.universe_of env t in
            FStar_Syntax_Syntax.mk_GTotal' t (Some u)
        | uu____5087 -> c in
      FStar_Syntax_Util.comp_to_comp_typ c1
let rec unfold_effect_abbrev:
  env -> FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp_typ =
  fun env  ->
    fun comp  ->
      let c = comp_to_comp_typ env comp in
      let uu____5095 =
        lookup_effect_abbrev env c.FStar_Syntax_Syntax.comp_univs
          c.FStar_Syntax_Syntax.effect_name in
      match uu____5095 with
      | None  -> c
      | Some (binders,cdef) ->
          let uu____5105 = FStar_Syntax_Subst.open_comp binders cdef in
          (match uu____5105 with
           | (binders1,cdef1) ->
               (if
                  (FStar_List.length binders1) <>
                    ((FStar_List.length c.FStar_Syntax_Syntax.effect_args) +
                       (Prims.parse_int "1"))
                then
                  (let uu____5122 =
                     let uu____5123 =
                       let uu____5126 =
                         let uu____5127 =
                           FStar_Util.string_of_int
                             (FStar_List.length binders1) in
                         let uu____5133 =
                           FStar_Util.string_of_int
                             ((FStar_List.length
                                 c.FStar_Syntax_Syntax.effect_args)
                                + (Prims.parse_int "1")) in
                         let uu____5141 =
                           let uu____5142 = FStar_Syntax_Syntax.mk_Comp c in
                           FStar_Syntax_Print.comp_to_string uu____5142 in
                         FStar_Util.format3
                           "Effect constructor is not fully applied; expected %s args, got %s args, i.e., %s"
                           uu____5127 uu____5133 uu____5141 in
                       (uu____5126, (comp.FStar_Syntax_Syntax.pos)) in
                     FStar_Errors.Error uu____5123 in
                   Prims.raise uu____5122)
                else ();
                (let inst1 =
                   let uu____5146 =
                     let uu____5152 =
                       FStar_Syntax_Syntax.as_arg
                         c.FStar_Syntax_Syntax.result_typ in
                     uu____5152 :: (c.FStar_Syntax_Syntax.effect_args) in
                   FStar_List.map2
                     (fun uu____5159  ->
                        fun uu____5160  ->
                          match (uu____5159, uu____5160) with
                          | ((x,uu____5174),(t,uu____5176)) ->
                              FStar_Syntax_Syntax.NT (x, t)) binders1
                     uu____5146 in
                 let c1 = FStar_Syntax_Subst.subst_comp inst1 cdef1 in
                 let c2 =
                   let uu____5191 =
                     let uu___124_5192 = comp_to_comp_typ env c1 in
                     {
                       FStar_Syntax_Syntax.comp_univs =
                         (uu___124_5192.FStar_Syntax_Syntax.comp_univs);
                       FStar_Syntax_Syntax.effect_name =
                         (uu___124_5192.FStar_Syntax_Syntax.effect_name);
                       FStar_Syntax_Syntax.result_typ =
                         (uu___124_5192.FStar_Syntax_Syntax.result_typ);
                       FStar_Syntax_Syntax.effect_args =
                         (uu___124_5192.FStar_Syntax_Syntax.effect_args);
                       FStar_Syntax_Syntax.flags =
                         (c.FStar_Syntax_Syntax.flags)
                     } in
                   FStar_All.pipe_right uu____5191
                     FStar_Syntax_Syntax.mk_Comp in
                 unfold_effect_abbrev env c2)))
let effect_repr_aux only_reifiable env c u_c =
  let uu____5222 =
    let uu____5227 = norm_eff_name env (FStar_Syntax_Util.comp_effect_name c) in
    effect_decl_opt env uu____5227 in
  match uu____5222 with
  | None  -> None
  | Some (ed,qualifiers) ->
      let uu____5243 =
        only_reifiable &&
          (let uu____5244 =
             FStar_All.pipe_right qualifiers
               (FStar_List.contains FStar_Syntax_Syntax.Reifiable) in
           Prims.op_Negation uu____5244) in
      if uu____5243
      then None
      else
        (match (ed.FStar_Syntax_Syntax.repr).FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.Tm_unknown  -> None
         | uu____5257 ->
             let c1 = unfold_effect_abbrev env c in
             let uu____5259 =
               let uu____5268 =
                 FStar_List.hd c1.FStar_Syntax_Syntax.effect_args in
               ((c1.FStar_Syntax_Syntax.result_typ), uu____5268) in
             (match uu____5259 with
              | (res_typ,wp) ->
                  let repr =
                    inst_effect_fun_with [u_c] env ed
                      ([], (ed.FStar_Syntax_Syntax.repr)) in
                  let uu____5302 =
                    let uu____5305 = get_range env in
                    let uu____5306 =
                      let uu____5309 =
                        let uu____5310 =
                          let uu____5320 =
                            let uu____5322 =
                              FStar_Syntax_Syntax.as_arg res_typ in
                            [uu____5322; wp] in
                          (repr, uu____5320) in
                        FStar_Syntax_Syntax.Tm_app uu____5310 in
                      FStar_Syntax_Syntax.mk uu____5309 in
                    uu____5306 None uu____5305 in
                  Some uu____5302))
let effect_repr:
  env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.universe ->
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
          FStar_Syntax_Syntax.syntax Prims.option
  = fun env  -> fun c  -> fun u_c  -> effect_repr_aux false env c u_c
let reify_comp:
  env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun c  ->
      fun u_c  ->
        let no_reify l =
          let uu____5366 =
            let uu____5367 =
              let uu____5370 =
                let uu____5371 = FStar_Ident.string_of_lid l in
                FStar_Util.format1 "Effect %s cannot be reified" uu____5371 in
              let uu____5372 = get_range env in (uu____5370, uu____5372) in
            FStar_Errors.Error uu____5367 in
          Prims.raise uu____5366 in
        let uu____5373 = effect_repr_aux true env c u_c in
        match uu____5373 with
        | None  -> no_reify (FStar_Syntax_Util.comp_effect_name c)
        | Some tm -> tm
let is_reifiable_effect: env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun effect_lid  ->
      let quals = lookup_effect_quals env effect_lid in
      FStar_List.contains FStar_Syntax_Syntax.Reifiable quals
let is_reifiable:
  env ->
    (FStar_Syntax_Syntax.lcomp,FStar_Syntax_Syntax.residual_comp)
      FStar_Util.either -> Prims.bool
  =
  fun env  ->
    fun c  ->
      let effect_lid =
        match c with
        | FStar_Util.Inl lc -> lc.FStar_Syntax_Syntax.eff_name
        | FStar_Util.Inr (eff_name,uu____5405) -> eff_name in
      is_reifiable_effect env effect_lid
let is_reifiable_comp: env -> FStar_Syntax_Syntax.comp -> Prims.bool =
  fun env  ->
    fun c  ->
      match c.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Comp ct ->
          is_reifiable_effect env ct.FStar_Syntax_Syntax.effect_name
      | uu____5418 -> false
let is_reifiable_function: env -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun env  ->
    fun t  ->
      let uu____5425 =
        let uu____5426 = FStar_Syntax_Subst.compress t in
        uu____5426.FStar_Syntax_Syntax.n in
      match uu____5425 with
      | FStar_Syntax_Syntax.Tm_arrow (uu____5429,c) ->
          is_reifiable_comp env c
      | uu____5441 -> false
let push_in_gamma: env -> binding -> env =
  fun env  ->
    fun s  ->
      let rec push1 x rest =
        match rest with
        | (Binding_sig _)::_|(Binding_sig_inst _)::_ -> x :: rest
        | [] -> [x]
        | local::rest1 ->
            let uu____5466 = push1 x rest1 in local :: uu____5466 in
      let uu___125_5468 = env in
      let uu____5469 = push1 s env.gamma in
      {
        solver = (uu___125_5468.solver);
        range = (uu___125_5468.range);
        curmodule = (uu___125_5468.curmodule);
        gamma = uu____5469;
        gamma_cache = (uu___125_5468.gamma_cache);
        modules = (uu___125_5468.modules);
        expected_typ = (uu___125_5468.expected_typ);
        sigtab = (uu___125_5468.sigtab);
        is_pattern = (uu___125_5468.is_pattern);
        instantiate_imp = (uu___125_5468.instantiate_imp);
        effects = (uu___125_5468.effects);
        generalize = (uu___125_5468.generalize);
        letrecs = (uu___125_5468.letrecs);
        top_level = (uu___125_5468.top_level);
        check_uvars = (uu___125_5468.check_uvars);
        use_eq = (uu___125_5468.use_eq);
        is_iface = (uu___125_5468.is_iface);
        admit = (uu___125_5468.admit);
        lax = (uu___125_5468.lax);
        lax_universes = (uu___125_5468.lax_universes);
        type_of = (uu___125_5468.type_of);
        universe_of = (uu___125_5468.universe_of);
        use_bv_sorts = (uu___125_5468.use_bv_sorts);
        qname_and_index = (uu___125_5468.qname_and_index)
      }
let push_sigelt: env -> FStar_Syntax_Syntax.sigelt -> env =
  fun env  ->
    fun s  ->
      let env1 =
        push_in_gamma env
          (Binding_sig ((FStar_Syntax_Util.lids_of_sigelt s), s)) in
      build_lattice env1 s
let push_sigelt_inst:
  env -> FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.universes -> env =
  fun env  ->
    fun s  ->
      fun us  ->
        let env1 =
          push_in_gamma env
            (Binding_sig_inst ((FStar_Syntax_Util.lids_of_sigelt s), s, us)) in
        build_lattice env1 s
let push_local_binding: env -> binding -> env =
  fun env  ->
    fun b  ->
      let uu___126_5496 = env in
      {
        solver = (uu___126_5496.solver);
        range = (uu___126_5496.range);
        curmodule = (uu___126_5496.curmodule);
        gamma = (b :: (env.gamma));
        gamma_cache = (uu___126_5496.gamma_cache);
        modules = (uu___126_5496.modules);
        expected_typ = (uu___126_5496.expected_typ);
        sigtab = (uu___126_5496.sigtab);
        is_pattern = (uu___126_5496.is_pattern);
        instantiate_imp = (uu___126_5496.instantiate_imp);
        effects = (uu___126_5496.effects);
        generalize = (uu___126_5496.generalize);
        letrecs = (uu___126_5496.letrecs);
        top_level = (uu___126_5496.top_level);
        check_uvars = (uu___126_5496.check_uvars);
        use_eq = (uu___126_5496.use_eq);
        is_iface = (uu___126_5496.is_iface);
        admit = (uu___126_5496.admit);
        lax = (uu___126_5496.lax);
        lax_universes = (uu___126_5496.lax_universes);
        type_of = (uu___126_5496.type_of);
        universe_of = (uu___126_5496.universe_of);
        use_bv_sorts = (uu___126_5496.use_bv_sorts);
        qname_and_index = (uu___126_5496.qname_and_index)
      }
let push_bv: env -> FStar_Syntax_Syntax.bv -> env =
  fun env  -> fun x  -> push_local_binding env (Binding_var x)
let pop_bv: env -> (FStar_Syntax_Syntax.bv* env) Prims.option =
  fun env  ->
    match env.gamma with
    | (Binding_var x)::rest ->
        Some
          (x,
            (let uu___127_5517 = env in
             {
               solver = (uu___127_5517.solver);
               range = (uu___127_5517.range);
               curmodule = (uu___127_5517.curmodule);
               gamma = rest;
               gamma_cache = (uu___127_5517.gamma_cache);
               modules = (uu___127_5517.modules);
               expected_typ = (uu___127_5517.expected_typ);
               sigtab = (uu___127_5517.sigtab);
               is_pattern = (uu___127_5517.is_pattern);
               instantiate_imp = (uu___127_5517.instantiate_imp);
               effects = (uu___127_5517.effects);
               generalize = (uu___127_5517.generalize);
               letrecs = (uu___127_5517.letrecs);
               top_level = (uu___127_5517.top_level);
               check_uvars = (uu___127_5517.check_uvars);
               use_eq = (uu___127_5517.use_eq);
               is_iface = (uu___127_5517.is_iface);
               admit = (uu___127_5517.admit);
               lax = (uu___127_5517.lax);
               lax_universes = (uu___127_5517.lax_universes);
               type_of = (uu___127_5517.type_of);
               universe_of = (uu___127_5517.universe_of);
               use_bv_sorts = (uu___127_5517.use_bv_sorts);
               qname_and_index = (uu___127_5517.qname_and_index)
             }))
    | uu____5518 -> None
let push_binders: env -> FStar_Syntax_Syntax.binders -> env =
  fun env  ->
    fun bs  ->
      FStar_List.fold_left
        (fun env1  ->
           fun uu____5531  ->
             match uu____5531 with | (x,uu____5535) -> push_bv env1 x) env bs
let binding_of_lb:
  FStar_Syntax_Syntax.lbname ->
    (FStar_Syntax_Syntax.univ_name Prims.list*
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax) -> binding
  =
  fun x  ->
    fun t  ->
      match x with
      | FStar_Util.Inl x1 ->
          let x2 =
            let uu___128_5555 = x1 in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___128_5555.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___128_5555.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = (Prims.snd t)
            } in
          Binding_var x2
      | FStar_Util.Inr fv ->
          Binding_lid
            (((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v), t)
let push_let_binding:
  env -> FStar_Syntax_Syntax.lbname -> FStar_Syntax_Syntax.tscheme -> env =
  fun env  ->
    fun lb  -> fun ts  -> push_local_binding env (binding_of_lb lb ts)
let push_module: env -> FStar_Syntax_Syntax.modul -> env =
  fun env  ->
    fun m  ->
      add_sigelts env m.FStar_Syntax_Syntax.exports;
      (let uu___129_5585 = env in
       {
         solver = (uu___129_5585.solver);
         range = (uu___129_5585.range);
         curmodule = (uu___129_5585.curmodule);
         gamma = [];
         gamma_cache = (uu___129_5585.gamma_cache);
         modules = (m :: (env.modules));
         expected_typ = None;
         sigtab = (uu___129_5585.sigtab);
         is_pattern = (uu___129_5585.is_pattern);
         instantiate_imp = (uu___129_5585.instantiate_imp);
         effects = (uu___129_5585.effects);
         generalize = (uu___129_5585.generalize);
         letrecs = (uu___129_5585.letrecs);
         top_level = (uu___129_5585.top_level);
         check_uvars = (uu___129_5585.check_uvars);
         use_eq = (uu___129_5585.use_eq);
         is_iface = (uu___129_5585.is_iface);
         admit = (uu___129_5585.admit);
         lax = (uu___129_5585.lax);
         lax_universes = (uu___129_5585.lax_universes);
         type_of = (uu___129_5585.type_of);
         universe_of = (uu___129_5585.universe_of);
         use_bv_sorts = (uu___129_5585.use_bv_sorts);
         qname_and_index = (uu___129_5585.qname_and_index)
       })
let push_univ_vars: env_t -> FStar_Syntax_Syntax.univ_names -> env =
  fun env  ->
    fun xs  ->
      FStar_List.fold_left
        (fun env1  -> fun x  -> push_local_binding env1 (Binding_univ x)) env
        xs
let open_universes_in:
  env ->
    FStar_Syntax_Syntax.univ_names ->
      FStar_Syntax_Syntax.term Prims.list ->
        (env* FStar_Syntax_Syntax.univ_names* FStar_Syntax_Syntax.term
          Prims.list)
  =
  fun env  ->
    fun uvs  ->
      fun terms  ->
        let uu____5609 = FStar_Syntax_Subst.univ_var_opening uvs in
        match uu____5609 with
        | (univ_subst,univ_vars) ->
            let env' = push_univ_vars env univ_vars in
            let uu____5625 =
              FStar_List.map (FStar_Syntax_Subst.subst univ_subst) terms in
            (env', univ_vars, uu____5625)
let set_expected_typ: env -> FStar_Syntax_Syntax.typ -> env =
  fun env  ->
    fun t  ->
      let uu___130_5635 = env in
      {
        solver = (uu___130_5635.solver);
        range = (uu___130_5635.range);
        curmodule = (uu___130_5635.curmodule);
        gamma = (uu___130_5635.gamma);
        gamma_cache = (uu___130_5635.gamma_cache);
        modules = (uu___130_5635.modules);
        expected_typ = (Some t);
        sigtab = (uu___130_5635.sigtab);
        is_pattern = (uu___130_5635.is_pattern);
        instantiate_imp = (uu___130_5635.instantiate_imp);
        effects = (uu___130_5635.effects);
        generalize = (uu___130_5635.generalize);
        letrecs = (uu___130_5635.letrecs);
        top_level = (uu___130_5635.top_level);
        check_uvars = (uu___130_5635.check_uvars);
        use_eq = false;
        is_iface = (uu___130_5635.is_iface);
        admit = (uu___130_5635.admit);
        lax = (uu___130_5635.lax);
        lax_universes = (uu___130_5635.lax_universes);
        type_of = (uu___130_5635.type_of);
        universe_of = (uu___130_5635.universe_of);
        use_bv_sorts = (uu___130_5635.use_bv_sorts);
        qname_and_index = (uu___130_5635.qname_and_index)
      }
let expected_typ: env -> FStar_Syntax_Syntax.typ Prims.option =
  fun env  -> match env.expected_typ with | None  -> None | Some t -> Some t
let clear_expected_typ: env -> (env* FStar_Syntax_Syntax.typ Prims.option) =
  fun env_  ->
    let uu____5651 = expected_typ env_ in
    ((let uu___131_5654 = env_ in
      {
        solver = (uu___131_5654.solver);
        range = (uu___131_5654.range);
        curmodule = (uu___131_5654.curmodule);
        gamma = (uu___131_5654.gamma);
        gamma_cache = (uu___131_5654.gamma_cache);
        modules = (uu___131_5654.modules);
        expected_typ = None;
        sigtab = (uu___131_5654.sigtab);
        is_pattern = (uu___131_5654.is_pattern);
        instantiate_imp = (uu___131_5654.instantiate_imp);
        effects = (uu___131_5654.effects);
        generalize = (uu___131_5654.generalize);
        letrecs = (uu___131_5654.letrecs);
        top_level = (uu___131_5654.top_level);
        check_uvars = (uu___131_5654.check_uvars);
        use_eq = false;
        is_iface = (uu___131_5654.is_iface);
        admit = (uu___131_5654.admit);
        lax = (uu___131_5654.lax);
        lax_universes = (uu___131_5654.lax_universes);
        type_of = (uu___131_5654.type_of);
        universe_of = (uu___131_5654.universe_of);
        use_bv_sorts = (uu___131_5654.use_bv_sorts);
        qname_and_index = (uu___131_5654.qname_and_index)
      }), uu____5651)
let finish_module: env -> FStar_Syntax_Syntax.modul -> env =
  let empty_lid = FStar_Ident.lid_of_ids [FStar_Ident.id_of_text ""] in
  fun env  ->
    fun m  ->
      let sigs =
        if
          FStar_Ident.lid_equals m.FStar_Syntax_Syntax.name
            FStar_Syntax_Const.prims_lid
        then
          let uu____5665 =
            FStar_All.pipe_right env.gamma
              (FStar_List.collect
                 (fun uu___110_5669  ->
                    match uu___110_5669 with
                    | Binding_sig (uu____5671,se) -> [se]
                    | uu____5675 -> [])) in
          FStar_All.pipe_right uu____5665 FStar_List.rev
        else m.FStar_Syntax_Syntax.exports in
      add_sigelts env sigs;
      (let uu___132_5680 = env in
       {
         solver = (uu___132_5680.solver);
         range = (uu___132_5680.range);
         curmodule = empty_lid;
         gamma = [];
         gamma_cache = (uu___132_5680.gamma_cache);
         modules = (m :: (env.modules));
         expected_typ = (uu___132_5680.expected_typ);
         sigtab = (uu___132_5680.sigtab);
         is_pattern = (uu___132_5680.is_pattern);
         instantiate_imp = (uu___132_5680.instantiate_imp);
         effects = (uu___132_5680.effects);
         generalize = (uu___132_5680.generalize);
         letrecs = (uu___132_5680.letrecs);
         top_level = (uu___132_5680.top_level);
         check_uvars = (uu___132_5680.check_uvars);
         use_eq = (uu___132_5680.use_eq);
         is_iface = (uu___132_5680.is_iface);
         admit = (uu___132_5680.admit);
         lax = (uu___132_5680.lax);
         lax_universes = (uu___132_5680.lax_universes);
         type_of = (uu___132_5680.type_of);
         universe_of = (uu___132_5680.universe_of);
         use_bv_sorts = (uu___132_5680.use_bv_sorts);
         qname_and_index = (uu___132_5680.qname_and_index)
       })
let uvars_in_env:
  env -> (FStar_Syntax_Syntax.uvar* FStar_Syntax_Syntax.typ) FStar_Util.set =
  fun env  ->
    let no_uvs1 = FStar_Syntax_Syntax.new_uv_set () in
    let ext out uvs = FStar_Util.set_union out uvs in
    let rec aux out g =
      match g with
      | [] -> out
      | (Binding_univ uu____5730)::tl1 -> aux out tl1
      | (Binding_lid (_,(_,t)))::tl1|(Binding_var
        { FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _;
          FStar_Syntax_Syntax.sort = t;_})::tl1 ->
          let uu____5745 =
            let uu____5749 = FStar_Syntax_Free.uvars t in ext out uu____5749 in
          aux uu____5745 tl1
      | (Binding_sig _)::_|(Binding_sig_inst _)::_ -> out in
    aux no_uvs1 env.gamma
let univ_vars: env -> FStar_Syntax_Syntax.universe_uvar FStar_Util.set =
  fun env  ->
    let no_univs = FStar_Syntax_Syntax.no_universe_uvars in
    let ext out uvs = FStar_Util.set_union out uvs in
    let rec aux out g =
      match g with
      | [] -> out
      | (Binding_sig_inst _)::tl1|(Binding_univ _)::tl1 -> aux out tl1
      | (Binding_lid (_,(_,t)))::tl1|(Binding_var
        { FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _;
          FStar_Syntax_Syntax.sort = t;_})::tl1 ->
          let uu____5805 =
            let uu____5807 = FStar_Syntax_Free.univs t in ext out uu____5807 in
          aux uu____5805 tl1
      | (Binding_sig uu____5809)::uu____5810 -> out in
    aux no_univs env.gamma
let univnames: env -> FStar_Syntax_Syntax.univ_name FStar_Util.set =
  fun env  ->
    let no_univ_names = FStar_Syntax_Syntax.no_universe_names in
    let ext out uvs = FStar_Util.set_union out uvs in
    let rec aux out g =
      match g with
      | [] -> out
      | (Binding_sig_inst uu____5847)::tl1 -> aux out tl1
      | (Binding_univ uname)::tl1 ->
          let uu____5857 = FStar_Util.set_add uname out in aux uu____5857 tl1
      | (Binding_lid (_,(_,t)))::tl1|(Binding_var
        { FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _;
          FStar_Syntax_Syntax.sort = t;_})::tl1 ->
          let uu____5871 =
            let uu____5873 = FStar_Syntax_Free.univnames t in
            ext out uu____5873 in
          aux uu____5871 tl1
      | (Binding_sig uu____5875)::uu____5876 -> out in
    aux no_univ_names env.gamma
let bound_vars_of_bindings:
  binding Prims.list -> FStar_Syntax_Syntax.bv Prims.list =
  fun bs  ->
    FStar_All.pipe_right bs
      (FStar_List.collect
         (fun uu___111_5892  ->
            match uu___111_5892 with
            | Binding_var x -> [x]
            | Binding_lid _|Binding_sig _|Binding_univ _|Binding_sig_inst _
                -> []))
let binders_of_bindings:
  binding Prims.list -> FStar_Syntax_Syntax.binder Prims.list =
  fun bs  ->
    let uu____5904 =
      let uu____5906 = bound_vars_of_bindings bs in
      FStar_All.pipe_right uu____5906
        (FStar_List.map FStar_Syntax_Syntax.mk_binder) in
    FStar_All.pipe_right uu____5904 FStar_List.rev
let bound_vars: env -> FStar_Syntax_Syntax.bv Prims.list =
  fun env  -> bound_vars_of_bindings env.gamma
let all_binders: env -> FStar_Syntax_Syntax.binders =
  fun env  -> binders_of_bindings env.gamma
let print_gamma: env -> Prims.unit =
  fun env  ->
    let uu____5922 =
      let uu____5923 =
        FStar_All.pipe_right env.gamma
          (FStar_List.map
             (fun uu___112_5927  ->
                match uu___112_5927 with
                | Binding_var x ->
                    let uu____5929 = FStar_Syntax_Print.bv_to_string x in
                    Prims.strcat "Binding_var " uu____5929
                | Binding_univ u ->
                    Prims.strcat "Binding_univ " u.FStar_Ident.idText
                | Binding_lid (l,uu____5932) ->
                    let uu____5933 = FStar_Ident.string_of_lid l in
                    Prims.strcat "Binding_lid " uu____5933
                | Binding_sig (ls,uu____5935) ->
                    let uu____5938 =
                      let uu____5939 =
                        FStar_All.pipe_right ls
                          (FStar_List.map FStar_Ident.string_of_lid) in
                      FStar_All.pipe_right uu____5939
                        (FStar_String.concat ", ") in
                    Prims.strcat "Binding_sig " uu____5938
                | Binding_sig_inst (ls,uu____5945,uu____5946) ->
                    let uu____5949 =
                      let uu____5950 =
                        FStar_All.pipe_right ls
                          (FStar_List.map FStar_Ident.string_of_lid) in
                      FStar_All.pipe_right uu____5950
                        (FStar_String.concat ", ") in
                    Prims.strcat "Binding_sig_inst " uu____5949)) in
      FStar_All.pipe_right uu____5923 (FStar_String.concat "::\n") in
    FStar_All.pipe_right uu____5922 (FStar_Util.print1 "%s\n")
let eq_gamma: env -> env -> Prims.bool =
  fun env  ->
    fun env'  ->
      let uu____5962 = FStar_Util.physical_equality env.gamma env'.gamma in
      if uu____5962
      then true
      else
        (let g = all_binders env in
         let g' = all_binders env' in
         ((FStar_List.length g) = (FStar_List.length g')) &&
           (FStar_List.forall2
              (fun uu____5979  ->
                 fun uu____5980  ->
                   match (uu____5979, uu____5980) with
                   | ((b1,uu____5990),(b2,uu____5992)) ->
                       FStar_Syntax_Syntax.bv_eq b1 b2) g g'))
let fold_env env f a =
  FStar_List.fold_right (fun e  -> fun a1  -> f a1 e) env.gamma a
let lidents: env -> FStar_Ident.lident Prims.list =
  fun env  ->
    let keys =
      FStar_List.fold_left
        (fun keys  ->
           fun uu___113_6035  ->
             match uu___113_6035 with
             | Binding_sig (lids,uu____6039) -> FStar_List.append lids keys
             | uu____6042 -> keys) [] env.gamma in
    FStar_Util.smap_fold (sigtab env)
      (fun uu____6044  ->
         fun v1  ->
           fun keys1  ->
             FStar_List.append (FStar_Syntax_Util.lids_of_sigelt v1) keys1)
      keys
let dummy_solver: solver_t =
  {
    init = (fun uu____6048  -> ());
    push = (fun uu____6049  -> ());
    pop = (fun uu____6050  -> ());
    mark = (fun uu____6051  -> ());
    reset_mark = (fun uu____6052  -> ());
    commit_mark = (fun uu____6053  -> ());
    encode_modul = (fun uu____6054  -> fun uu____6055  -> ());
    encode_sig = (fun uu____6056  -> fun uu____6057  -> ());
    preprocess = (fun e  -> fun g  -> [(e, g)]);
    solve = (fun uu____6064  -> fun uu____6065  -> fun uu____6066  -> ());
    is_trivial = (fun uu____6070  -> fun uu____6071  -> false);
    finish = (fun uu____6072  -> ());
    refresh = (fun uu____6073  -> ())
  }