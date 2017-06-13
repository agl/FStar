open Prims
type lcomp_with_binder =
  (FStar_Syntax_Syntax.bv option* FStar_Syntax_Syntax.lcomp)
let report:
  FStar_TypeChecker_Env.env -> Prims.string Prims.list -> Prims.unit =
  fun env  ->
    fun errs  ->
      let uu____12 = FStar_TypeChecker_Env.get_range env in
      let uu____13 = FStar_TypeChecker_Err.failed_to_prove_specification errs in
      FStar_Errors.err uu____12 uu____13
let is_type: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____17 =
      let uu____18 = FStar_Syntax_Subst.compress t in
      uu____18.FStar_Syntax_Syntax.n in
    match uu____17 with
    | FStar_Syntax_Syntax.Tm_type uu____21 -> true
    | uu____22 -> false
let t_binders:
  FStar_TypeChecker_Env.env ->
    (FStar_Syntax_Syntax.bv* FStar_Syntax_Syntax.aqual) Prims.list
  =
  fun env  ->
    let uu____29 = FStar_TypeChecker_Env.all_binders env in
    FStar_All.pipe_right uu____29
      (FStar_List.filter
         (fun uu____35  ->
            match uu____35 with
            | (x,uu____39) -> is_type x.FStar_Syntax_Syntax.sort))
let new_uvar_aux:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      (FStar_Syntax_Syntax.typ* FStar_Syntax_Syntax.typ)
  =
  fun env  ->
    fun k  ->
      let bs =
        let uu____49 =
          (FStar_Options.full_context_dependency ()) ||
            (let uu____50 = FStar_TypeChecker_Env.current_module env in
             FStar_Ident.lid_equals FStar_Syntax_Const.prims_lid uu____50) in
        if uu____49
        then FStar_TypeChecker_Env.all_binders env
        else t_binders env in
      let uu____52 = FStar_TypeChecker_Env.get_range env in
      FStar_TypeChecker_Rel.new_uvar uu____52 bs k
let new_uvar:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ
  = fun env  -> fun k  -> let uu____59 = new_uvar_aux env k in fst uu____59
let as_uvar: FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.uvar =
  fun uu___97_64  ->
    match uu___97_64 with
    | { FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar (uv,uu____66);
        FStar_Syntax_Syntax.tk = uu____67;
        FStar_Syntax_Syntax.pos = uu____68;
        FStar_Syntax_Syntax.vars = uu____69;_} -> uv
    | uu____88 -> failwith "Impossible"
let new_implicit_var:
  Prims.string ->
    FStar_Range.range ->
      FStar_TypeChecker_Env.env ->
        FStar_Syntax_Syntax.typ ->
          (FStar_Syntax_Syntax.term* (FStar_Syntax_Syntax.uvar*
            FStar_Range.range) Prims.list* FStar_TypeChecker_Env.guard_t)
  =
  fun reason  ->
    fun r  ->
      fun env  ->
        fun k  ->
          let uu____107 =
            FStar_Syntax_Util.destruct k FStar_Syntax_Const.range_of_lid in
          match uu____107 with
          | Some (uu____120::(tm,uu____122)::[]) ->
              let t =
                FStar_Syntax_Syntax.mk
                  (FStar_Syntax_Syntax.Tm_constant
                     (FStar_Const.Const_range (tm.FStar_Syntax_Syntax.pos)))
                  None tm.FStar_Syntax_Syntax.pos in
              (t, [], FStar_TypeChecker_Rel.trivial_guard)
          | uu____162 ->
              let uu____169 = new_uvar_aux env k in
              (match uu____169 with
               | (t,u) ->
                   let g =
                     let uu___117_181 = FStar_TypeChecker_Rel.trivial_guard in
                     let uu____182 =
                       let uu____190 =
                         let uu____197 = as_uvar u in
                         (reason, env, uu____197, t, k, r) in
                       [uu____190] in
                     {
                       FStar_TypeChecker_Env.guard_f =
                         (uu___117_181.FStar_TypeChecker_Env.guard_f);
                       FStar_TypeChecker_Env.deferred =
                         (uu___117_181.FStar_TypeChecker_Env.deferred);
                       FStar_TypeChecker_Env.univ_ineqs =
                         (uu___117_181.FStar_TypeChecker_Env.univ_ineqs);
                       FStar_TypeChecker_Env.implicits = uu____182
                     } in
                   let uu____210 =
                     let uu____214 =
                       let uu____217 = as_uvar u in (uu____217, r) in
                     [uu____214] in
                   (t, uu____210, g))
let check_uvars: FStar_Range.range -> FStar_Syntax_Syntax.typ -> Prims.unit =
  fun r  ->
    fun t  ->
      let uvs = FStar_Syntax_Free.uvars t in
      let uu____235 =
        let uu____236 = FStar_Util.set_is_empty uvs in
        Prims.op_Negation uu____236 in
      if uu____235
      then
        let us =
          let uu____240 =
            let uu____242 = FStar_Util.set_elements uvs in
            FStar_List.map
              (fun uu____250  ->
                 match uu____250 with
                 | (x,uu____254) -> FStar_Syntax_Print.uvar_to_string x)
              uu____242 in
          FStar_All.pipe_right uu____240 (FStar_String.concat ", ") in
        (FStar_Options.push ();
         FStar_Options.set_option "hide_uvar_nums" (FStar_Options.Bool false);
         FStar_Options.set_option "print_implicits" (FStar_Options.Bool true);
         (let uu____260 =
            let uu____261 = FStar_Syntax_Print.term_to_string t in
            FStar_Util.format2
              "Unconstrained unification variables %s in type signature %s; please add an annotation"
              us uu____261 in
          FStar_Errors.err r uu____260);
         FStar_Options.pop ())
      else ()
let force_sort':
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax -> FStar_Syntax_Syntax.term'
  =
  fun s  ->
    let uu____270 = FStar_ST.read s.FStar_Syntax_Syntax.tk in
    match uu____270 with
    | None  ->
        let uu____275 =
          let uu____276 =
            FStar_Range.string_of_range s.FStar_Syntax_Syntax.pos in
          let uu____277 = FStar_Syntax_Print.term_to_string s in
          FStar_Util.format2 "(%s) Impossible: Forced tk not present on %s"
            uu____276 uu____277 in
        failwith uu____275
    | Some tk -> tk
let force_sort s =
  let uu____292 =
    let uu____295 = force_sort' s in FStar_Syntax_Syntax.mk uu____295 in
  uu____292 None s.FStar_Syntax_Syntax.pos
let extract_let_rec_annotation:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.letbinding ->
      (FStar_Syntax_Syntax.univ_name Prims.list* FStar_Syntax_Syntax.typ*
        Prims.bool)
  =
  fun env  ->
    fun uu____312  ->
      match uu____312 with
      | { FStar_Syntax_Syntax.lbname = lbname;
          FStar_Syntax_Syntax.lbunivs = univ_vars1;
          FStar_Syntax_Syntax.lbtyp = t;
          FStar_Syntax_Syntax.lbeff = uu____319;
          FStar_Syntax_Syntax.lbdef = e;_} ->
          let rng = FStar_Syntax_Syntax.range_of_lbname lbname in
          let t1 = FStar_Syntax_Subst.compress t in
          (match t1.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_unknown  ->
               (if univ_vars1 <> []
                then
                  failwith
                    "Impossible: non-empty universe variables but the type is unknown"
                else ();
                (let r = FStar_TypeChecker_Env.get_range env in
                 let mk_binder1 scope a =
                   let uu____351 =
                     let uu____352 =
                       FStar_Syntax_Subst.compress a.FStar_Syntax_Syntax.sort in
                     uu____352.FStar_Syntax_Syntax.n in
                   match uu____351 with
                   | FStar_Syntax_Syntax.Tm_unknown  ->
                       let uu____357 = FStar_Syntax_Util.type_u () in
                       (match uu____357 with
                        | (k,uu____363) ->
                            let t2 =
                              let uu____365 =
                                FStar_TypeChecker_Rel.new_uvar
                                  e.FStar_Syntax_Syntax.pos scope k in
                              FStar_All.pipe_right uu____365
                                FStar_Pervasives.fst in
                            ((let uu___118_370 = a in
                              {
                                FStar_Syntax_Syntax.ppname =
                                  (uu___118_370.FStar_Syntax_Syntax.ppname);
                                FStar_Syntax_Syntax.index =
                                  (uu___118_370.FStar_Syntax_Syntax.index);
                                FStar_Syntax_Syntax.sort = t2
                              }), false))
                   | uu____371 -> (a, true) in
                 let rec aux must_check_ty vars e1 =
                   let e2 = FStar_Syntax_Subst.compress e1 in
                   match e2.FStar_Syntax_Syntax.n with
                   | FStar_Syntax_Syntax.Tm_meta (e3,uu____396) ->
                       aux must_check_ty vars e3
                   | FStar_Syntax_Syntax.Tm_ascribed (e3,t2,uu____403) ->
                       ((fst t2), true)
                   | FStar_Syntax_Syntax.Tm_abs (bs,body,uu____449) ->
                       let uu____472 =
                         FStar_All.pipe_right bs
                           (FStar_List.fold_left
                              (fun uu____496  ->
                                 fun uu____497  ->
                                   match (uu____496, uu____497) with
                                   | ((scope,bs1,must_check_ty1),(a,imp)) ->
                                       let uu____539 =
                                         if must_check_ty1
                                         then (a, true)
                                         else mk_binder1 scope a in
                                       (match uu____539 with
                                        | (tb,must_check_ty2) ->
                                            let b = (tb, imp) in
                                            let bs2 =
                                              FStar_List.append bs1 [b] in
                                            let scope1 =
                                              FStar_List.append scope [b] in
                                            (scope1, bs2, must_check_ty2)))
                              (vars, [], must_check_ty)) in
                       (match uu____472 with
                        | (scope,bs1,must_check_ty1) ->
                            let uu____600 = aux must_check_ty1 scope body in
                            (match uu____600 with
                             | (res,must_check_ty2) ->
                                 let c =
                                   match res with
                                   | FStar_Util.Inl t2 ->
                                       let uu____617 =
                                         FStar_Options.ml_ish () in
                                       if uu____617
                                       then FStar_Syntax_Util.ml_comp t2 r
                                       else FStar_Syntax_Syntax.mk_Total t2
                                   | FStar_Util.Inr c -> c in
                                 let t2 = FStar_Syntax_Util.arrow bs1 c in
                                 ((let uu____624 =
                                     FStar_TypeChecker_Env.debug env
                                       FStar_Options.High in
                                   if uu____624
                                   then
                                     let uu____625 =
                                       FStar_Range.string_of_range r in
                                     let uu____626 =
                                       FStar_Syntax_Print.term_to_string t2 in
                                     let uu____627 =
                                       FStar_Util.string_of_bool
                                         must_check_ty2 in
                                     FStar_Util.print3
                                       "(%s) Using type %s .... must check = %s\n"
                                       uu____625 uu____626 uu____627
                                   else ());
                                  ((FStar_Util.Inl t2), must_check_ty2))))
                   | uu____635 ->
                       if must_check_ty
                       then ((FStar_Util.Inl FStar_Syntax_Syntax.tun), true)
                       else
                         (let uu____643 =
                            let uu____646 =
                              let uu____647 =
                                FStar_TypeChecker_Rel.new_uvar r vars
                                  FStar_Syntax_Util.ktype0 in
                              FStar_All.pipe_right uu____647
                                FStar_Pervasives.fst in
                            FStar_Util.Inl uu____646 in
                          (uu____643, false)) in
                 let uu____654 =
                   let uu____659 = t_binders env in aux false uu____659 e in
                 match uu____654 with
                 | (t2,b) ->
                     let t3 =
                       match t2 with
                       | FStar_Util.Inr c ->
                           let uu____676 =
                             FStar_Syntax_Util.is_tot_or_gtot_comp c in
                           if uu____676
                           then FStar_Syntax_Util.comp_result c
                           else
                             (let uu____680 =
                                let uu____681 =
                                  let uu____684 =
                                    let uu____685 =
                                      FStar_Syntax_Print.comp_to_string c in
                                    FStar_Util.format1
                                      "Expected a 'let rec' to be annotated with a value type; got a computation type %s"
                                      uu____685 in
                                  (uu____684, rng) in
                                FStar_Errors.Error uu____681 in
                              raise uu____680)
                       | FStar_Util.Inl t3 -> t3 in
                     ([], t3, b)))
           | uu____692 ->
               let uu____693 =
                 FStar_Syntax_Subst.open_univ_vars univ_vars1 t1 in
               (match uu____693 with
                | (univ_vars2,t2) -> (univ_vars2, t2, false)))
let pat_as_exp:
  Prims.bool ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.pat ->
        (FStar_Syntax_Syntax.bv Prims.list* FStar_Syntax_Syntax.term*
          FStar_Syntax_Syntax.pat)
  =
  fun allow_implicits  ->
    fun env  ->
      fun p  ->
        let rec pat_as_arg_with_env allow_wc_dependence env1 p1 =
          match p1.FStar_Syntax_Syntax.v with
          | FStar_Syntax_Syntax.Pat_constant c ->
              let e =
                (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_constant c))
                  None p1.FStar_Syntax_Syntax.p in
              ([], [], [], env1, e, p1)
          | FStar_Syntax_Syntax.Pat_dot_term (x,uu____774) ->
              let uu____779 = FStar_Syntax_Util.type_u () in
              (match uu____779 with
               | (k,uu____792) ->
                   let t = new_uvar env1 k in
                   let x1 =
                     let uu___119_795 = x in
                     {
                       FStar_Syntax_Syntax.ppname =
                         (uu___119_795.FStar_Syntax_Syntax.ppname);
                       FStar_Syntax_Syntax.index =
                         (uu___119_795.FStar_Syntax_Syntax.index);
                       FStar_Syntax_Syntax.sort = t
                     } in
                   let uu____796 =
                     let uu____799 = FStar_TypeChecker_Env.all_binders env1 in
                     FStar_TypeChecker_Rel.new_uvar p1.FStar_Syntax_Syntax.p
                       uu____799 t in
                   (match uu____796 with
                    | (e,u) ->
                        let p2 =
                          let uu___120_814 = p1 in
                          {
                            FStar_Syntax_Syntax.v =
                              (FStar_Syntax_Syntax.Pat_dot_term (x1, e));
                            FStar_Syntax_Syntax.ty =
                              (uu___120_814.FStar_Syntax_Syntax.ty);
                            FStar_Syntax_Syntax.p =
                              (uu___120_814.FStar_Syntax_Syntax.p)
                          } in
                        ([], [], [], env1, e, p2)))
          | FStar_Syntax_Syntax.Pat_wild x ->
              let uu____821 = FStar_Syntax_Util.type_u () in
              (match uu____821 with
               | (t,uu____834) ->
                   let x1 =
                     let uu___121_836 = x in
                     let uu____837 = new_uvar env1 t in
                     {
                       FStar_Syntax_Syntax.ppname =
                         (uu___121_836.FStar_Syntax_Syntax.ppname);
                       FStar_Syntax_Syntax.index =
                         (uu___121_836.FStar_Syntax_Syntax.index);
                       FStar_Syntax_Syntax.sort = uu____837
                     } in
                   let env2 =
                     if allow_wc_dependence
                     then FStar_TypeChecker_Env.push_bv env1 x1
                     else env1 in
                   let e =
                     (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_name x1))
                       None p1.FStar_Syntax_Syntax.p in
                   ([x1], [], [x1], env2, e, p1))
          | FStar_Syntax_Syntax.Pat_var x ->
              let uu____859 = FStar_Syntax_Util.type_u () in
              (match uu____859 with
               | (t,uu____872) ->
                   let x1 =
                     let uu___122_874 = x in
                     let uu____875 = new_uvar env1 t in
                     {
                       FStar_Syntax_Syntax.ppname =
                         (uu___122_874.FStar_Syntax_Syntax.ppname);
                       FStar_Syntax_Syntax.index =
                         (uu___122_874.FStar_Syntax_Syntax.index);
                       FStar_Syntax_Syntax.sort = uu____875
                     } in
                   let env2 = FStar_TypeChecker_Env.push_bv env1 x1 in
                   let e =
                     (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_name x1))
                       None p1.FStar_Syntax_Syntax.p in
                   ([x1], [x1], [], env2, e, p1))
          | FStar_Syntax_Syntax.Pat_cons (fv,pats) ->
              let uu____907 =
                FStar_All.pipe_right pats
                  (FStar_List.fold_left
                     (fun uu____963  ->
                        fun uu____964  ->
                          match (uu____963, uu____964) with
                          | ((b,a,w,env2,args,pats1),(p2,imp)) ->
                              let uu____1063 =
                                pat_as_arg_with_env allow_wc_dependence env2
                                  p2 in
                              (match uu____1063 with
                               | (b',a',w',env3,te,pat) ->
                                   let arg =
                                     if imp
                                     then FStar_Syntax_Syntax.iarg te
                                     else FStar_Syntax_Syntax.as_arg te in
                                   ((b' :: b), (a' :: a), (w' :: w), env3,
                                     (arg :: args), ((pat, imp) :: pats1))))
                     ([], [], [], env1, [], [])) in
              (match uu____907 with
               | (b,a,w,env2,args,pats1) ->
                   let e =
                     let uu____1171 =
                       let uu____1174 =
                         let uu____1175 =
                           let uu____1180 =
                             let uu____1183 =
                               let uu____1184 =
                                 FStar_Syntax_Syntax.fv_to_tm fv in
                               let uu____1185 =
                                 FStar_All.pipe_right args FStar_List.rev in
                               FStar_Syntax_Syntax.mk_Tm_app uu____1184
                                 uu____1185 in
                             uu____1183 None p1.FStar_Syntax_Syntax.p in
                           (uu____1180,
                             (FStar_Syntax_Syntax.Meta_desugared
                                FStar_Syntax_Syntax.Data_app)) in
                         FStar_Syntax_Syntax.Tm_meta uu____1175 in
                       FStar_Syntax_Syntax.mk uu____1174 in
                     uu____1171 None p1.FStar_Syntax_Syntax.p in
                   let uu____1202 =
                     FStar_All.pipe_right (FStar_List.rev b)
                       FStar_List.flatten in
                   let uu____1208 =
                     FStar_All.pipe_right (FStar_List.rev a)
                       FStar_List.flatten in
                   let uu____1214 =
                     FStar_All.pipe_right (FStar_List.rev w)
                       FStar_List.flatten in
                   (uu____1202, uu____1208, uu____1214, env2, e,
                     (let uu___123_1227 = p1 in
                      {
                        FStar_Syntax_Syntax.v =
                          (FStar_Syntax_Syntax.Pat_cons
                             (fv, (FStar_List.rev pats1)));
                        FStar_Syntax_Syntax.ty =
                          (uu___123_1227.FStar_Syntax_Syntax.ty);
                        FStar_Syntax_Syntax.p =
                          (uu___123_1227.FStar_Syntax_Syntax.p)
                      }))) in
        let rec elaborate_pat env1 p1 =
          let maybe_dot inaccessible a r =
            if allow_implicits && inaccessible
            then
              FStar_Syntax_Syntax.withinfo
                (FStar_Syntax_Syntax.Pat_dot_term
                   (a, FStar_Syntax_Syntax.tun))
                FStar_Syntax_Syntax.tun.FStar_Syntax_Syntax.n r
            else
              FStar_Syntax_Syntax.withinfo (FStar_Syntax_Syntax.Pat_var a)
                FStar_Syntax_Syntax.tun.FStar_Syntax_Syntax.n r in
          match p1.FStar_Syntax_Syntax.v with
          | FStar_Syntax_Syntax.Pat_cons (fv,pats) ->
              let pats1 =
                FStar_List.map
                  (fun uu____1289  ->
                     match uu____1289 with
                     | (p2,imp) ->
                         let uu____1304 = elaborate_pat env1 p2 in
                         (uu____1304, imp)) pats in
              let uu____1309 =
                FStar_TypeChecker_Env.lookup_datacon env1
                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
              (match uu____1309 with
               | (uu____1318,t) ->
                   let uu____1320 = FStar_Syntax_Util.arrow_formals t in
                   (match uu____1320 with
                    | (f,uu____1331) ->
                        let rec aux formals pats2 =
                          match (formals, pats2) with
                          | ([],[]) -> []
                          | ([],uu____1406::uu____1407) ->
                              raise
                                (FStar_Errors.Error
                                   ("Too many pattern arguments",
                                     (FStar_Ident.range_of_lid
                                        (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)))
                          | (uu____1442::uu____1443,[]) ->
                              FStar_All.pipe_right formals
                                (FStar_List.map
                                   (fun uu____1483  ->
                                      match uu____1483 with
                                      | (t1,imp) ->
                                          (match imp with
                                           | Some
                                               (FStar_Syntax_Syntax.Implicit
                                               inaccessible) ->
                                               let a =
                                                 let uu____1501 =
                                                   let uu____1503 =
                                                     FStar_Syntax_Syntax.range_of_bv
                                                       t1 in
                                                   Some uu____1503 in
                                                 FStar_Syntax_Syntax.new_bv
                                                   uu____1501
                                                   FStar_Syntax_Syntax.tun in
                                               let r =
                                                 FStar_Ident.range_of_lid
                                                   (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                                               let uu____1509 =
                                                 maybe_dot inaccessible a r in
                                               (uu____1509, true)
                                           | uu____1514 ->
                                               let uu____1516 =
                                                 let uu____1517 =
                                                   let uu____1520 =
                                                     let uu____1521 =
                                                       FStar_Syntax_Print.pat_to_string
                                                         p1 in
                                                     FStar_Util.format1
                                                       "Insufficient pattern arguments (%s)"
                                                       uu____1521 in
                                                   (uu____1520,
                                                     (FStar_Ident.range_of_lid
                                                        (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)) in
                                                 FStar_Errors.Error
                                                   uu____1517 in
                                               raise uu____1516)))
                          | (f1::formals',(p2,p_imp)::pats') ->
                              (match f1 with
                               | (uu____1572,Some
                                  (FStar_Syntax_Syntax.Implicit uu____1573))
                                   when p_imp ->
                                   let uu____1575 = aux formals' pats' in
                                   (p2, true) :: uu____1575
                               | (uu____1587,Some
                                  (FStar_Syntax_Syntax.Implicit
                                  inaccessible)) ->
                                   let a =
                                     FStar_Syntax_Syntax.new_bv
                                       (Some (p2.FStar_Syntax_Syntax.p))
                                       FStar_Syntax_Syntax.tun in
                                   let p3 =
                                     maybe_dot inaccessible a
                                       (FStar_Ident.range_of_lid
                                          (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v) in
                                   let uu____1598 = aux formals' pats2 in
                                   (p3, true) :: uu____1598
                               | (uu____1610,imp) ->
                                   let uu____1614 =
                                     let uu____1619 =
                                       FStar_Syntax_Syntax.is_implicit imp in
                                     (p2, uu____1619) in
                                   let uu____1622 = aux formals' pats' in
                                   uu____1614 :: uu____1622) in
                        let uu___124_1632 = p1 in
                        let uu____1635 =
                          let uu____1636 =
                            let uu____1644 = aux f pats1 in (fv, uu____1644) in
                          FStar_Syntax_Syntax.Pat_cons uu____1636 in
                        {
                          FStar_Syntax_Syntax.v = uu____1635;
                          FStar_Syntax_Syntax.ty =
                            (uu___124_1632.FStar_Syntax_Syntax.ty);
                          FStar_Syntax_Syntax.p =
                            (uu___124_1632.FStar_Syntax_Syntax.p)
                        }))
          | uu____1655 -> p1 in
        let one_pat allow_wc_dependence env1 p1 =
          let p2 = elaborate_pat env1 p1 in
          let uu____1681 = pat_as_arg_with_env allow_wc_dependence env1 p2 in
          match uu____1681 with
          | (b,a,w,env2,arg,p3) ->
              let uu____1711 =
                FStar_All.pipe_right b
                  (FStar_Util.find_dup FStar_Syntax_Syntax.bv_eq) in
              (match uu____1711 with
               | Some x ->
                   let uu____1724 =
                     let uu____1725 =
                       let uu____1728 =
                         FStar_TypeChecker_Err.nonlinear_pattern_variable x in
                       (uu____1728, (p3.FStar_Syntax_Syntax.p)) in
                     FStar_Errors.Error uu____1725 in
                   raise uu____1724
               | uu____1737 -> (b, a, w, arg, p3)) in
        let uu____1742 = one_pat true env p in
        match uu____1742 with
        | (b,uu____1756,uu____1757,tm,p1) -> (b, tm, p1)
let decorate_pattern:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.pat ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.pat
  =
  fun env  ->
    fun p  ->
      fun exp  ->
        let qq = p in
        let rec aux p1 e =
          let pkg q t =
            FStar_Syntax_Syntax.withinfo q t p1.FStar_Syntax_Syntax.p in
          let e1 = FStar_Syntax_Util.unmeta e in
          match ((p1.FStar_Syntax_Syntax.v), (e1.FStar_Syntax_Syntax.n)) with
          | (uu____1798,FStar_Syntax_Syntax.Tm_uinst (e2,uu____1800)) ->
              aux p1 e2
          | (FStar_Syntax_Syntax.Pat_constant
             uu____1805,FStar_Syntax_Syntax.Tm_constant uu____1806) ->
              let uu____1807 = force_sort' e1 in
              pkg p1.FStar_Syntax_Syntax.v uu____1807
          | (FStar_Syntax_Syntax.Pat_var x,FStar_Syntax_Syntax.Tm_name y) ->
              (if Prims.op_Negation (FStar_Syntax_Syntax.bv_eq x y)
               then
                 (let uu____1811 =
                    let uu____1812 = FStar_Syntax_Print.bv_to_string x in
                    let uu____1813 = FStar_Syntax_Print.bv_to_string y in
                    FStar_Util.format2 "Expected pattern variable %s; got %s"
                      uu____1812 uu____1813 in
                  failwith uu____1811)
               else ();
               (let uu____1816 =
                  FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                    (FStar_Options.Other "Pat") in
                if uu____1816
                then
                  let uu____1817 = FStar_Syntax_Print.bv_to_string x in
                  let uu____1818 =
                    FStar_TypeChecker_Normalize.term_to_string env
                      y.FStar_Syntax_Syntax.sort in
                  FStar_Util.print2
                    "Pattern variable %s introduced at type %s\n" uu____1817
                    uu____1818
                else ());
               (let s =
                  FStar_TypeChecker_Normalize.normalize
                    [FStar_TypeChecker_Normalize.Beta] env
                    y.FStar_Syntax_Syntax.sort in
                let x1 =
                  let uu___125_1822 = x in
                  {
                    FStar_Syntax_Syntax.ppname =
                      (uu___125_1822.FStar_Syntax_Syntax.ppname);
                    FStar_Syntax_Syntax.index =
                      (uu___125_1822.FStar_Syntax_Syntax.index);
                    FStar_Syntax_Syntax.sort = s
                  } in
                pkg (FStar_Syntax_Syntax.Pat_var x1) s.FStar_Syntax_Syntax.n))
          | (FStar_Syntax_Syntax.Pat_wild x,FStar_Syntax_Syntax.Tm_name y) ->
              ((let uu____1826 =
                  FStar_All.pipe_right (FStar_Syntax_Syntax.bv_eq x y)
                    Prims.op_Negation in
                if uu____1826
                then
                  let uu____1827 =
                    let uu____1828 = FStar_Syntax_Print.bv_to_string x in
                    let uu____1829 = FStar_Syntax_Print.bv_to_string y in
                    FStar_Util.format2 "Expected pattern variable %s; got %s"
                      uu____1828 uu____1829 in
                  failwith uu____1827
                else ());
               (let s =
                  FStar_TypeChecker_Normalize.normalize
                    [FStar_TypeChecker_Normalize.Beta] env
                    y.FStar_Syntax_Syntax.sort in
                let x1 =
                  let uu___126_1833 = x in
                  {
                    FStar_Syntax_Syntax.ppname =
                      (uu___126_1833.FStar_Syntax_Syntax.ppname);
                    FStar_Syntax_Syntax.index =
                      (uu___126_1833.FStar_Syntax_Syntax.index);
                    FStar_Syntax_Syntax.sort = s
                  } in
                pkg (FStar_Syntax_Syntax.Pat_wild x1) s.FStar_Syntax_Syntax.n))
          | (FStar_Syntax_Syntax.Pat_dot_term (x,uu____1835),uu____1836) ->
              let s = force_sort e1 in
              let x1 =
                let uu___127_1845 = x in
                {
                  FStar_Syntax_Syntax.ppname =
                    (uu___127_1845.FStar_Syntax_Syntax.ppname);
                  FStar_Syntax_Syntax.index =
                    (uu___127_1845.FStar_Syntax_Syntax.index);
                  FStar_Syntax_Syntax.sort = s
                } in
              pkg (FStar_Syntax_Syntax.Pat_dot_term (x1, e1))
                s.FStar_Syntax_Syntax.n
          | (FStar_Syntax_Syntax.Pat_cons (fv,[]),FStar_Syntax_Syntax.Tm_fvar
             fv') ->
              ((let uu____1858 =
                  let uu____1859 = FStar_Syntax_Syntax.fv_eq fv fv' in
                  Prims.op_Negation uu____1859 in
                if uu____1858
                then
                  let uu____1860 =
                    FStar_Util.format2
                      "Expected pattern constructor %s; got %s"
                      ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
                      ((fv'.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str in
                  failwith uu____1860
                else ());
               (let uu____1870 = force_sort' e1 in
                pkg (FStar_Syntax_Syntax.Pat_cons (fv', [])) uu____1870))
          | (FStar_Syntax_Syntax.Pat_cons
             (fv,argpats),FStar_Syntax_Syntax.Tm_app
             ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv';
                FStar_Syntax_Syntax.tk = uu____1883;
                FStar_Syntax_Syntax.pos = uu____1884;
                FStar_Syntax_Syntax.vars = uu____1885;_},args))
              ->
              ((let uu____1912 =
                  let uu____1913 = FStar_Syntax_Syntax.fv_eq fv fv' in
                  FStar_All.pipe_right uu____1913 Prims.op_Negation in
                if uu____1912
                then
                  let uu____1914 =
                    FStar_Util.format2
                      "Expected pattern constructor %s; got %s"
                      ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
                      ((fv'.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str in
                  failwith uu____1914
                else ());
               (let fv1 = fv' in
                let rec match_args matched_pats args1 argpats1 =
                  match (args1, argpats1) with
                  | ([],[]) ->
                      let uu____2002 = force_sort' e1 in
                      pkg
                        (FStar_Syntax_Syntax.Pat_cons
                           (fv1, (FStar_List.rev matched_pats))) uu____2002
                  | (arg::args2,(argpat,uu____2015)::argpats2) ->
                      (match (arg, (argpat.FStar_Syntax_Syntax.v)) with
                       | ((e2,Some (FStar_Syntax_Syntax.Implicit (true ))),FStar_Syntax_Syntax.Pat_dot_term
                          uu____2065) ->
                           let x =
                             let uu____2081 = force_sort e2 in
                             FStar_Syntax_Syntax.new_bv
                               (Some (p1.FStar_Syntax_Syntax.p)) uu____2081 in
                           let q =
                             FStar_Syntax_Syntax.withinfo
                               (FStar_Syntax_Syntax.Pat_dot_term (x, e2))
                               (x.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n
                               p1.FStar_Syntax_Syntax.p in
                           match_args ((q, true) :: matched_pats) args2
                             argpats2
                       | ((e2,imp),uu____2095) ->
                           let pat =
                             let uu____2110 = aux argpat e2 in
                             let uu____2111 =
                               FStar_Syntax_Syntax.is_implicit imp in
                             (uu____2110, uu____2111) in
                           match_args (pat :: matched_pats) args2 argpats2)
                  | uu____2114 ->
                      let uu____2128 =
                        let uu____2129 = FStar_Syntax_Print.pat_to_string p1 in
                        let uu____2130 = FStar_Syntax_Print.term_to_string e1 in
                        FStar_Util.format2
                          "Unexpected number of pattern arguments: \n\t%s\n\t%s\n"
                          uu____2129 uu____2130 in
                      failwith uu____2128 in
                match_args [] args argpats))
          | (FStar_Syntax_Syntax.Pat_cons
             (fv,argpats),FStar_Syntax_Syntax.Tm_app
             ({
                FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uinst
                  ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv';
                     FStar_Syntax_Syntax.tk = uu____2140;
                     FStar_Syntax_Syntax.pos = uu____2141;
                     FStar_Syntax_Syntax.vars = uu____2142;_},uu____2143);
                FStar_Syntax_Syntax.tk = uu____2144;
                FStar_Syntax_Syntax.pos = uu____2145;
                FStar_Syntax_Syntax.vars = uu____2146;_},args))
              ->
              ((let uu____2177 =
                  let uu____2178 = FStar_Syntax_Syntax.fv_eq fv fv' in
                  FStar_All.pipe_right uu____2178 Prims.op_Negation in
                if uu____2177
                then
                  let uu____2179 =
                    FStar_Util.format2
                      "Expected pattern constructor %s; got %s"
                      ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
                      ((fv'.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str in
                  failwith uu____2179
                else ());
               (let fv1 = fv' in
                let rec match_args matched_pats args1 argpats1 =
                  match (args1, argpats1) with
                  | ([],[]) ->
                      let uu____2267 = force_sort' e1 in
                      pkg
                        (FStar_Syntax_Syntax.Pat_cons
                           (fv1, (FStar_List.rev matched_pats))) uu____2267
                  | (arg::args2,(argpat,uu____2280)::argpats2) ->
                      (match (arg, (argpat.FStar_Syntax_Syntax.v)) with
                       | ((e2,Some (FStar_Syntax_Syntax.Implicit (true ))),FStar_Syntax_Syntax.Pat_dot_term
                          uu____2330) ->
                           let x =
                             let uu____2346 = force_sort e2 in
                             FStar_Syntax_Syntax.new_bv
                               (Some (p1.FStar_Syntax_Syntax.p)) uu____2346 in
                           let q =
                             FStar_Syntax_Syntax.withinfo
                               (FStar_Syntax_Syntax.Pat_dot_term (x, e2))
                               (x.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n
                               p1.FStar_Syntax_Syntax.p in
                           match_args ((q, true) :: matched_pats) args2
                             argpats2
                       | ((e2,imp),uu____2360) ->
                           let pat =
                             let uu____2375 = aux argpat e2 in
                             let uu____2376 =
                               FStar_Syntax_Syntax.is_implicit imp in
                             (uu____2375, uu____2376) in
                           match_args (pat :: matched_pats) args2 argpats2)
                  | uu____2379 ->
                      let uu____2393 =
                        let uu____2394 = FStar_Syntax_Print.pat_to_string p1 in
                        let uu____2395 = FStar_Syntax_Print.term_to_string e1 in
                        FStar_Util.format2
                          "Unexpected number of pattern arguments: \n\t%s\n\t%s\n"
                          uu____2394 uu____2395 in
                      failwith uu____2393 in
                match_args [] args argpats))
          | uu____2402 ->
              let uu____2405 =
                let uu____2406 =
                  FStar_Range.string_of_range qq.FStar_Syntax_Syntax.p in
                let uu____2407 = FStar_Syntax_Print.pat_to_string qq in
                let uu____2408 = FStar_Syntax_Print.term_to_string exp in
                FStar_Util.format3
                  "(%s) Impossible: pattern to decorate is %s; expression is %s\n"
                  uu____2406 uu____2407 uu____2408 in
              failwith uu____2405 in
        aux p exp
let rec decorated_pattern_as_term:
  FStar_Syntax_Syntax.pat ->
    (FStar_Syntax_Syntax.bv Prims.list* FStar_Syntax_Syntax.term)
  =
  fun pat  ->
    let topt = Some (pat.FStar_Syntax_Syntax.ty) in
    let mk1 f = (FStar_Syntax_Syntax.mk f) topt pat.FStar_Syntax_Syntax.p in
    let pat_as_arg uu____2442 =
      match uu____2442 with
      | (p,i) ->
          let uu____2452 = decorated_pattern_as_term p in
          (match uu____2452 with
           | (vars,te) ->
               let uu____2465 =
                 let uu____2468 = FStar_Syntax_Syntax.as_implicit i in
                 (te, uu____2468) in
               (vars, uu____2465)) in
    match pat.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_constant c ->
        let uu____2476 = mk1 (FStar_Syntax_Syntax.Tm_constant c) in
        ([], uu____2476)
    | FStar_Syntax_Syntax.Pat_wild x ->
        let uu____2479 = mk1 (FStar_Syntax_Syntax.Tm_name x) in
        ([x], uu____2479)
    | FStar_Syntax_Syntax.Pat_var x ->
        let uu____2482 = mk1 (FStar_Syntax_Syntax.Tm_name x) in
        ([x], uu____2482)
    | FStar_Syntax_Syntax.Pat_cons (fv,pats) ->
        let uu____2496 =
          let uu____2504 =
            FStar_All.pipe_right pats (FStar_List.map pat_as_arg) in
          FStar_All.pipe_right uu____2504 FStar_List.unzip in
        (match uu____2496 with
         | (vars,args) ->
             let vars1 = FStar_List.flatten vars in
             let uu____2562 =
               let uu____2563 =
                 let uu____2564 =
                   let uu____2574 = FStar_Syntax_Syntax.fv_to_tm fv in
                   (uu____2574, args) in
                 FStar_Syntax_Syntax.Tm_app uu____2564 in
               mk1 uu____2563 in
             (vars1, uu____2562))
    | FStar_Syntax_Syntax.Pat_dot_term (x,e) -> ([], e)
let destruct_comp:
  FStar_Syntax_Syntax.comp_typ ->
    (FStar_Syntax_Syntax.universe*
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax*
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax)
  =
  fun c  ->
    let wp =
      match c.FStar_Syntax_Syntax.effect_args with
      | (wp,uu____2603)::[] -> wp
      | uu____2616 ->
          let uu____2622 =
            let uu____2623 =
              let uu____2624 =
                FStar_List.map
                  (fun uu____2628  ->
                     match uu____2628 with
                     | (x,uu____2632) -> FStar_Syntax_Print.term_to_string x)
                  c.FStar_Syntax_Syntax.effect_args in
              FStar_All.pipe_right uu____2624 (FStar_String.concat ", ") in
            FStar_Util.format2
              "Impossible: Got a computation %s with effect args [%s]"
              (c.FStar_Syntax_Syntax.effect_name).FStar_Ident.str uu____2623 in
          failwith uu____2622 in
    let uu____2636 = FStar_List.hd c.FStar_Syntax_Syntax.comp_univs in
    (uu____2636, (c.FStar_Syntax_Syntax.result_typ), wp)
let lift_comp:
  FStar_Syntax_Syntax.comp_typ ->
    FStar_Ident.lident ->
      FStar_TypeChecker_Env.mlift -> FStar_Syntax_Syntax.comp_typ
  =
  fun c  ->
    fun m  ->
      fun lift  ->
        let uu____2650 = destruct_comp c in
        match uu____2650 with
        | (u,uu____2655,wp) ->
            let uu____2657 =
              let uu____2663 =
                let uu____2664 =
                  lift.FStar_TypeChecker_Env.mlift_wp
                    c.FStar_Syntax_Syntax.result_typ wp in
                FStar_Syntax_Syntax.as_arg uu____2664 in
              [uu____2663] in
            {
              FStar_Syntax_Syntax.comp_univs = [u];
              FStar_Syntax_Syntax.effect_name = m;
              FStar_Syntax_Syntax.result_typ =
                (c.FStar_Syntax_Syntax.result_typ);
              FStar_Syntax_Syntax.effect_args = uu____2657;
              FStar_Syntax_Syntax.flags = []
            }
let join_effects:
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident -> FStar_Ident.lident -> FStar_Ident.lident
  =
  fun env  ->
    fun l1  ->
      fun l2  ->
        let uu____2674 =
          let uu____2678 = FStar_TypeChecker_Env.norm_eff_name env l1 in
          let uu____2679 = FStar_TypeChecker_Env.norm_eff_name env l2 in
          FStar_TypeChecker_Env.join env uu____2678 uu____2679 in
        match uu____2674 with | (m,uu____2681,uu____2682) -> m
let join_lcomp:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.lcomp ->
      FStar_Syntax_Syntax.lcomp -> FStar_Ident.lident
  =
  fun env  ->
    fun c1  ->
      fun c2  ->
        let uu____2692 =
          (FStar_Syntax_Util.is_total_lcomp c1) &&
            (FStar_Syntax_Util.is_total_lcomp c2) in
        if uu____2692
        then FStar_Syntax_Const.effect_Tot_lid
        else
          join_effects env c1.FStar_Syntax_Syntax.eff_name
            c2.FStar_Syntax_Syntax.eff_name
let lift_and_destruct:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.comp ->
        ((FStar_Syntax_Syntax.eff_decl* FStar_Syntax_Syntax.bv*
          FStar_Syntax_Syntax.term)* (FStar_Syntax_Syntax.universe*
          FStar_Syntax_Syntax.typ* FStar_Syntax_Syntax.typ)*
          (FStar_Syntax_Syntax.universe* FStar_Syntax_Syntax.typ*
          FStar_Syntax_Syntax.typ))
  =
  fun env  ->
    fun c1  ->
      fun c2  ->
        let c11 = FStar_TypeChecker_Env.unfold_effect_abbrev env c1 in
        let c21 = FStar_TypeChecker_Env.unfold_effect_abbrev env c2 in
        let uu____2717 =
          FStar_TypeChecker_Env.join env c11.FStar_Syntax_Syntax.effect_name
            c21.FStar_Syntax_Syntax.effect_name in
        match uu____2717 with
        | (m,lift1,lift2) ->
            let m1 = lift_comp c11 m lift1 in
            let m2 = lift_comp c21 m lift2 in
            let md = FStar_TypeChecker_Env.get_effect_decl env m in
            let uu____2739 =
              FStar_TypeChecker_Env.wp_signature env
                md.FStar_Syntax_Syntax.mname in
            (match uu____2739 with
             | (a,kwp) ->
                 let uu____2756 = destruct_comp m1 in
                 let uu____2760 = destruct_comp m2 in
                 ((md, a, kwp), uu____2756, uu____2760))
let is_pure_effect:
  FStar_TypeChecker_Env.env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun l  ->
      let l1 = FStar_TypeChecker_Env.norm_eff_name env l in
      FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_PURE_lid
let is_pure_or_ghost_effect:
  FStar_TypeChecker_Env.env -> FStar_Ident.lident -> Prims.bool =
  fun env  ->
    fun l  ->
      let l1 = FStar_TypeChecker_Env.norm_eff_name env l in
      (FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_PURE_lid) ||
        (FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_GHOST_lid)
let mk_comp_l:
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.universe ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.cflags Prims.list -> FStar_Syntax_Syntax.comp
  =
  fun mname  ->
    fun u_result  ->
      fun result  ->
        fun wp  ->
          fun flags  ->
            let uu____2808 =
              let uu____2809 =
                let uu____2815 = FStar_Syntax_Syntax.as_arg wp in
                [uu____2815] in
              {
                FStar_Syntax_Syntax.comp_univs = [u_result];
                FStar_Syntax_Syntax.effect_name = mname;
                FStar_Syntax_Syntax.result_typ = result;
                FStar_Syntax_Syntax.effect_args = uu____2809;
                FStar_Syntax_Syntax.flags = flags
              } in
            FStar_Syntax_Syntax.mk_Comp uu____2808
let mk_comp:
  FStar_Syntax_Syntax.eff_decl ->
    FStar_Syntax_Syntax.universe ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.cflags Prims.list -> FStar_Syntax_Syntax.comp
  = fun md  -> mk_comp_l md.FStar_Syntax_Syntax.mname
let lax_mk_tot_or_comp_l:
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.universe ->
      FStar_Syntax_Syntax.typ ->
        FStar_Syntax_Syntax.cflags Prims.list -> FStar_Syntax_Syntax.comp
  =
  fun mname  ->
    fun u_result  ->
      fun result  ->
        fun flags  ->
          if FStar_Ident.lid_equals mname FStar_Syntax_Const.effect_Tot_lid
          then FStar_Syntax_Syntax.mk_Total' result (Some u_result)
          else mk_comp_l mname u_result result FStar_Syntax_Syntax.tun flags
let subst_lcomp:
  FStar_Syntax_Syntax.subst_t ->
    FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp
  =
  fun subst1  ->
    fun lc  ->
      let uu___128_2851 = lc in
      let uu____2852 =
        FStar_Syntax_Subst.subst subst1 lc.FStar_Syntax_Syntax.res_typ in
      {
        FStar_Syntax_Syntax.eff_name =
          (uu___128_2851.FStar_Syntax_Syntax.eff_name);
        FStar_Syntax_Syntax.res_typ = uu____2852;
        FStar_Syntax_Syntax.cflags =
          (uu___128_2851.FStar_Syntax_Syntax.cflags);
        FStar_Syntax_Syntax.comp =
          (fun uu____2855  ->
             let uu____2856 = lc.FStar_Syntax_Syntax.comp () in
             FStar_Syntax_Subst.subst_comp subst1 uu____2856)
      }
let is_function: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____2860 =
      let uu____2861 = FStar_Syntax_Subst.compress t in
      uu____2861.FStar_Syntax_Syntax.n in
    match uu____2860 with
    | FStar_Syntax_Syntax.Tm_arrow uu____2864 -> true
    | uu____2872 -> false
let close_comp:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.bv Prims.list ->
      FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp
  =
  fun env  ->
    fun bvs  ->
      fun c  ->
        let uu____2884 = FStar_Syntax_Util.is_ml_comp c in
        if uu____2884
        then c
        else
          (let uu____2886 =
             env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
           if uu____2886
           then c
           else
             (let close_wp u_res md res_t bvs1 wp0 =
                FStar_List.fold_right
                  (fun x  ->
                     fun wp  ->
                       let bs =
                         let uu____2916 = FStar_Syntax_Syntax.mk_binder x in
                         [uu____2916] in
                       let us =
                         let uu____2919 =
                           let uu____2921 =
                             env.FStar_TypeChecker_Env.universe_of env
                               x.FStar_Syntax_Syntax.sort in
                           [uu____2921] in
                         u_res :: uu____2919 in
                       let wp1 =
                         FStar_Syntax_Util.abs bs wp
                           (Some
                              (FStar_Util.Inr
                                 (FStar_Syntax_Const.effect_Tot_lid,
                                   [FStar_Syntax_Syntax.TOTAL]))) in
                       let uu____2932 =
                         let uu____2933 =
                           FStar_TypeChecker_Env.inst_effect_fun_with us env
                             md md.FStar_Syntax_Syntax.close_wp in
                         let uu____2934 =
                           let uu____2935 = FStar_Syntax_Syntax.as_arg res_t in
                           let uu____2936 =
                             let uu____2938 =
                               FStar_Syntax_Syntax.as_arg
                                 x.FStar_Syntax_Syntax.sort in
                             let uu____2939 =
                               let uu____2941 =
                                 FStar_Syntax_Syntax.as_arg wp1 in
                               [uu____2941] in
                             uu____2938 :: uu____2939 in
                           uu____2935 :: uu____2936 in
                         FStar_Syntax_Syntax.mk_Tm_app uu____2933 uu____2934 in
                       uu____2932 None wp0.FStar_Syntax_Syntax.pos) bvs1 wp0 in
              let c1 = FStar_TypeChecker_Env.unfold_effect_abbrev env c in
              let uu____2947 = destruct_comp c1 in
              match uu____2947 with
              | (u_res_t,res_t,wp) ->
                  let md =
                    FStar_TypeChecker_Env.get_effect_decl env
                      c1.FStar_Syntax_Syntax.effect_name in
                  let wp1 = close_wp u_res_t md res_t bvs wp in
                  mk_comp md u_res_t c1.FStar_Syntax_Syntax.result_typ wp1
                    c1.FStar_Syntax_Syntax.flags))
let close_lcomp:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.bv Prims.list ->
      FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp
  =
  fun env  ->
    fun bvs  ->
      fun lc  ->
        let close1 uu____2970 =
          let uu____2971 = lc.FStar_Syntax_Syntax.comp () in
          close_comp env bvs uu____2971 in
        let uu___129_2972 = lc in
        {
          FStar_Syntax_Syntax.eff_name =
            (uu___129_2972.FStar_Syntax_Syntax.eff_name);
          FStar_Syntax_Syntax.res_typ =
            (uu___129_2972.FStar_Syntax_Syntax.res_typ);
          FStar_Syntax_Syntax.cflags =
            (uu___129_2972.FStar_Syntax_Syntax.cflags);
          FStar_Syntax_Syntax.comp = close1
        }
let return_value:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.comp
  =
  fun env  ->
    fun t  ->
      fun v1  ->
        let c =
          let uu____2983 =
            let uu____2984 =
              FStar_TypeChecker_Env.lid_exists env
                FStar_Syntax_Const.effect_GTot_lid in
            FStar_All.pipe_left Prims.op_Negation uu____2984 in
          if uu____2983
          then FStar_Syntax_Syntax.mk_Total t
          else
            (let m =
               FStar_TypeChecker_Env.get_effect_decl env
                 FStar_Syntax_Const.effect_PURE_lid in
             let u_t = env.FStar_TypeChecker_Env.universe_of env t in
             let wp =
               let uu____2989 =
                 env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
               if uu____2989
               then FStar_Syntax_Syntax.tun
               else
                 (let uu____2991 =
                    FStar_TypeChecker_Env.wp_signature env
                      FStar_Syntax_Const.effect_PURE_lid in
                  match uu____2991 with
                  | (a,kwp) ->
                      let k =
                        FStar_Syntax_Subst.subst
                          [FStar_Syntax_Syntax.NT (a, t)] kwp in
                      let uu____2997 =
                        let uu____2998 =
                          let uu____2999 =
                            FStar_TypeChecker_Env.inst_effect_fun_with 
                              [u_t] env m m.FStar_Syntax_Syntax.ret_wp in
                          let uu____3000 =
                            let uu____3001 = FStar_Syntax_Syntax.as_arg t in
                            let uu____3002 =
                              let uu____3004 = FStar_Syntax_Syntax.as_arg v1 in
                              [uu____3004] in
                            uu____3001 :: uu____3002 in
                          FStar_Syntax_Syntax.mk_Tm_app uu____2999 uu____3000 in
                        uu____2998 (Some (k.FStar_Syntax_Syntax.n))
                          v1.FStar_Syntax_Syntax.pos in
                      FStar_TypeChecker_Normalize.normalize
                        [FStar_TypeChecker_Normalize.Beta] env uu____2997) in
             mk_comp m u_t t wp [FStar_Syntax_Syntax.RETURN]) in
        (let uu____3010 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "Return") in
         if uu____3010
         then
           let uu____3011 =
             FStar_Range.string_of_range v1.FStar_Syntax_Syntax.pos in
           let uu____3012 = FStar_Syntax_Print.term_to_string v1 in
           let uu____3013 = FStar_TypeChecker_Normalize.comp_to_string env c in
           FStar_Util.print3 "(%s) returning %s at comp type %s\n" uu____3011
             uu____3012 uu____3013
         else ());
        c
let bind:
  FStar_Range.range ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term option ->
        FStar_Syntax_Syntax.lcomp ->
          lcomp_with_binder -> FStar_Syntax_Syntax.lcomp
  =
  fun r1  ->
    fun env  ->
      fun e1opt  ->
        fun lc1  ->
          fun uu____3030  ->
            match uu____3030 with
            | (b,lc2) ->
                let lc11 =
                  FStar_TypeChecker_Normalize.ghost_to_pure_lcomp env lc1 in
                let lc21 =
                  FStar_TypeChecker_Normalize.ghost_to_pure_lcomp env lc2 in
                let joined_eff = join_lcomp env lc11 lc21 in
                ((let uu____3040 =
                    (FStar_TypeChecker_Env.debug env FStar_Options.Extreme)
                      ||
                      (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                         (FStar_Options.Other "bind")) in
                  if uu____3040
                  then
                    let bstr =
                      match b with
                      | None  -> "none"
                      | Some x -> FStar_Syntax_Print.bv_to_string x in
                    let uu____3043 =
                      match e1opt with
                      | None  -> "None"
                      | Some e -> FStar_Syntax_Print.term_to_string e in
                    let uu____3045 = FStar_Syntax_Print.lcomp_to_string lc11 in
                    let uu____3046 = FStar_Syntax_Print.lcomp_to_string lc21 in
                    FStar_Util.print4
                      "Before lift: Making bind (e1=%s)@c1=%s\nb=%s\t\tc2=%s\n"
                      uu____3043 uu____3045 bstr uu____3046
                  else ());
                 (let bind_it uu____3051 =
                    let uu____3052 =
                      env.FStar_TypeChecker_Env.lax &&
                        (FStar_Options.ml_ish ()) in
                    if uu____3052
                    then
                      let u_t =
                        env.FStar_TypeChecker_Env.universe_of env
                          lc21.FStar_Syntax_Syntax.res_typ in
                      lax_mk_tot_or_comp_l joined_eff u_t
                        lc21.FStar_Syntax_Syntax.res_typ []
                    else
                      (let c1 = lc11.FStar_Syntax_Syntax.comp () in
                       let c2 = lc21.FStar_Syntax_Syntax.comp () in
                       (let uu____3062 =
                          (FStar_TypeChecker_Env.debug env
                             FStar_Options.Extreme)
                            ||
                            (FStar_All.pipe_left
                               (FStar_TypeChecker_Env.debug env)
                               (FStar_Options.Other "bind")) in
                        if uu____3062
                        then
                          let uu____3063 =
                            match b with
                            | None  -> "none"
                            | Some x -> FStar_Syntax_Print.bv_to_string x in
                          let uu____3065 =
                            FStar_Syntax_Print.lcomp_to_string lc11 in
                          let uu____3066 =
                            FStar_Syntax_Print.comp_to_string c1 in
                          let uu____3067 =
                            FStar_Syntax_Print.lcomp_to_string lc21 in
                          let uu____3068 =
                            FStar_Syntax_Print.comp_to_string c2 in
                          FStar_Util.print5
                            "b=%s,Evaluated %s to %s\n And %s to %s\n"
                            uu____3063 uu____3065 uu____3066 uu____3067
                            uu____3068
                        else ());
                       (let try_simplify uu____3079 =
                          let aux uu____3089 =
                            let uu____3090 =
                              FStar_Syntax_Util.is_trivial_wp c1 in
                            if uu____3090
                            then
                              match b with
                              | None  ->
                                  FStar_Util.Inl (c2, "trivial no binder")
                              | Some uu____3109 ->
                                  let uu____3110 =
                                    FStar_Syntax_Util.is_ml_comp c2 in
                                  (if uu____3110
                                   then FStar_Util.Inl (c2, "trivial ml")
                                   else
                                     FStar_Util.Inr
                                       "c1 trivial; but c2 is not ML")
                            else
                              (let uu____3129 =
                                 (FStar_Syntax_Util.is_ml_comp c1) &&
                                   (FStar_Syntax_Util.is_ml_comp c2) in
                               if uu____3129
                               then FStar_Util.Inl (c2, "both ml")
                               else
                                 FStar_Util.Inr
                                   "c1 not trivial, and both are not ML") in
                          let subst_c2 reason =
                            match (e1opt, b) with
                            | (Some e,Some x) ->
                                let uu____3165 =
                                  let uu____3168 =
                                    FStar_Syntax_Subst.subst_comp
                                      [FStar_Syntax_Syntax.NT (x, e)] c2 in
                                  (uu____3168, reason) in
                                FStar_Util.Inl uu____3165
                            | uu____3171 -> aux () in
                          let rec maybe_close t x c =
                            let uu____3186 =
                              let uu____3187 =
                                FStar_TypeChecker_Normalize.unfold_whnf env t in
                              uu____3187.FStar_Syntax_Syntax.n in
                            match uu____3186 with
                            | FStar_Syntax_Syntax.Tm_refine (y,uu____3191) ->
                                maybe_close y.FStar_Syntax_Syntax.sort x c
                            | FStar_Syntax_Syntax.Tm_fvar fv when
                                FStar_Syntax_Syntax.fv_eq_lid fv
                                  FStar_Syntax_Const.unit_lid
                                -> close_comp env [x] c
                            | uu____3197 -> c in
                          let uu____3198 =
                            let uu____3199 =
                              FStar_TypeChecker_Env.try_lookup_effect_lid env
                                FStar_Syntax_Const.effect_GTot_lid in
                            FStar_Option.isNone uu____3199 in
                          if uu____3198
                          then
                            let uu____3207 =
                              (FStar_Syntax_Util.is_tot_or_gtot_comp c1) &&
                                (FStar_Syntax_Util.is_tot_or_gtot_comp c2) in
                            (if uu____3207
                             then
                               FStar_Util.Inl
                                 (c2,
                                   "Early in prims; we don't have bind yet")
                             else
                               (let uu____3221 =
                                  let uu____3222 =
                                    let uu____3225 =
                                      FStar_TypeChecker_Env.get_range env in
                                    ("Non-trivial pre-conditions very early in prims, even before we have defined the PURE monad",
                                      uu____3225) in
                                  FStar_Errors.Error uu____3222 in
                                raise uu____3221))
                          else
                            (let uu____3233 =
                               (FStar_Syntax_Util.is_total_comp c1) &&
                                 (FStar_Syntax_Util.is_total_comp c2) in
                             if uu____3233
                             then subst_c2 "both total"
                             else
                               (let uu____3241 =
                                  (FStar_Syntax_Util.is_tot_or_gtot_comp c1)
                                    &&
                                    (FStar_Syntax_Util.is_tot_or_gtot_comp c2) in
                                if uu____3241
                                then
                                  let uu____3248 =
                                    let uu____3251 =
                                      FStar_Syntax_Syntax.mk_GTotal
                                        (FStar_Syntax_Util.comp_result c2) in
                                    (uu____3251, "both gtot") in
                                  FStar_Util.Inl uu____3248
                                else
                                  (match (e1opt, b) with
                                   | (Some e,Some x) ->
                                       let uu____3267 =
                                         (FStar_Syntax_Util.is_total_comp c1)
                                           &&
                                           (let uu____3268 =
                                              FStar_Syntax_Syntax.is_null_bv
                                                x in
                                            Prims.op_Negation uu____3268) in
                                       if uu____3267
                                       then
                                         let c21 =
                                           FStar_Syntax_Subst.subst_comp
                                             [FStar_Syntax_Syntax.NT (x, e)]
                                             c2 in
                                         let x1 =
                                           let uu___130_3277 = x in
                                           {
                                             FStar_Syntax_Syntax.ppname =
                                               (uu___130_3277.FStar_Syntax_Syntax.ppname);
                                             FStar_Syntax_Syntax.index =
                                               (uu___130_3277.FStar_Syntax_Syntax.index);
                                             FStar_Syntax_Syntax.sort =
                                               (FStar_Syntax_Util.comp_result
                                                  c1)
                                           } in
                                         let uu____3278 =
                                           let uu____3281 =
                                             maybe_close
                                               x1.FStar_Syntax_Syntax.sort x1
                                               c21 in
                                           (uu____3281, "c1 Tot") in
                                         FStar_Util.Inl uu____3278
                                       else aux ()
                                   | uu____3285 -> aux ()))) in
                        let uu____3290 = try_simplify () in
                        match uu____3290 with
                        | FStar_Util.Inl (c,reason) ->
                            ((let uu____3308 =
                                (FStar_TypeChecker_Env.debug env
                                   FStar_Options.Extreme)
                                  ||
                                  (FStar_All.pipe_left
                                     (FStar_TypeChecker_Env.debug env)
                                     (FStar_Options.Other "bind")) in
                              if uu____3308
                              then
                                let uu____3309 =
                                  FStar_Syntax_Print.comp_to_string c1 in
                                let uu____3310 =
                                  FStar_Syntax_Print.comp_to_string c2 in
                                let uu____3311 =
                                  FStar_Syntax_Print.comp_to_string c in
                                FStar_Util.print4
                                  "Simplified (because %s) bind %s %s to %s\n"
                                  reason uu____3309 uu____3310 uu____3311
                              else ());
                             c)
                        | FStar_Util.Inr reason ->
                            let uu____3318 = lift_and_destruct env c1 c2 in
                            (match uu____3318 with
                             | ((md,a,kwp),(u_t1,t1,wp1),(u_t2,t2,wp2)) ->
                                 let bs =
                                   match b with
                                   | None  ->
                                       let uu____3352 =
                                         FStar_Syntax_Syntax.null_binder t1 in
                                       [uu____3352]
                                   | Some x ->
                                       let uu____3354 =
                                         FStar_Syntax_Syntax.mk_binder x in
                                       [uu____3354] in
                                 let mk_lam wp =
                                   FStar_Syntax_Util.abs bs wp
                                     (Some
                                        (FStar_Util.Inr
                                           (FStar_Syntax_Const.effect_Tot_lid,
                                             [FStar_Syntax_Syntax.TOTAL]))) in
                                 let r11 =
                                   FStar_Syntax_Syntax.mk
                                     (FStar_Syntax_Syntax.Tm_constant
                                        (FStar_Const.Const_range r1)) None r1 in
                                 let wp_args =
                                   let uu____3377 =
                                     FStar_Syntax_Syntax.as_arg r11 in
                                   let uu____3378 =
                                     let uu____3380 =
                                       FStar_Syntax_Syntax.as_arg t1 in
                                     let uu____3381 =
                                       let uu____3383 =
                                         FStar_Syntax_Syntax.as_arg t2 in
                                       let uu____3384 =
                                         let uu____3386 =
                                           FStar_Syntax_Syntax.as_arg wp1 in
                                         let uu____3387 =
                                           let uu____3389 =
                                             let uu____3390 = mk_lam wp2 in
                                             FStar_Syntax_Syntax.as_arg
                                               uu____3390 in
                                           [uu____3389] in
                                         uu____3386 :: uu____3387 in
                                       uu____3383 :: uu____3384 in
                                     uu____3380 :: uu____3381 in
                                   uu____3377 :: uu____3378 in
                                 let k =
                                   FStar_Syntax_Subst.subst
                                     [FStar_Syntax_Syntax.NT (a, t2)] kwp in
                                 let wp =
                                   let uu____3395 =
                                     let uu____3396 =
                                       FStar_TypeChecker_Env.inst_effect_fun_with
                                         [u_t1; u_t2] env md
                                         md.FStar_Syntax_Syntax.bind_wp in
                                     FStar_Syntax_Syntax.mk_Tm_app uu____3396
                                       wp_args in
                                   uu____3395 None t2.FStar_Syntax_Syntax.pos in
                                 mk_comp md u_t2 t2 wp []))) in
                  {
                    FStar_Syntax_Syntax.eff_name = joined_eff;
                    FStar_Syntax_Syntax.res_typ =
                      (lc21.FStar_Syntax_Syntax.res_typ);
                    FStar_Syntax_Syntax.cflags = [];
                    FStar_Syntax_Syntax.comp = bind_it
                  }))
let label:
  Prims.string ->
    FStar_Range.range ->
      FStar_Syntax_Syntax.typ ->
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
          FStar_Syntax_Syntax.syntax
  =
  fun reason  ->
    fun r  ->
      fun f  ->
        FStar_Syntax_Syntax.mk
          (FStar_Syntax_Syntax.Tm_meta
             (f, (FStar_Syntax_Syntax.Meta_labeled (reason, r, false)))) None
          f.FStar_Syntax_Syntax.pos
let label_opt:
  FStar_TypeChecker_Env.env ->
    (Prims.unit -> Prims.string) option ->
      FStar_Range.range -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ
  =
  fun env  ->
    fun reason  ->
      fun r  ->
        fun f  ->
          match reason with
          | None  -> f
          | Some reason1 ->
              let uu____3440 =
                let uu____3441 = FStar_TypeChecker_Env.should_verify env in
                FStar_All.pipe_left Prims.op_Negation uu____3441 in
              if uu____3440
              then f
              else (let uu____3443 = reason1 () in label uu____3443 r f)
let label_guard:
  FStar_Range.range ->
    Prims.string ->
      FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t
  =
  fun r  ->
    fun reason  ->
      fun g  ->
        match g.FStar_TypeChecker_Env.guard_f with
        | FStar_TypeChecker_Common.Trivial  -> g
        | FStar_TypeChecker_Common.NonTrivial f ->
            let uu___131_3454 = g in
            let uu____3455 =
              let uu____3456 = label reason r f in
              FStar_TypeChecker_Common.NonTrivial uu____3456 in
            {
              FStar_TypeChecker_Env.guard_f = uu____3455;
              FStar_TypeChecker_Env.deferred =
                (uu___131_3454.FStar_TypeChecker_Env.deferred);
              FStar_TypeChecker_Env.univ_ineqs =
                (uu___131_3454.FStar_TypeChecker_Env.univ_ineqs);
              FStar_TypeChecker_Env.implicits =
                (uu___131_3454.FStar_TypeChecker_Env.implicits)
            }
let weaken_guard:
  FStar_TypeChecker_Common.guard_formula ->
    FStar_TypeChecker_Common.guard_formula ->
      FStar_TypeChecker_Common.guard_formula
  =
  fun g1  ->
    fun g2  ->
      match (g1, g2) with
      | (FStar_TypeChecker_Common.NonTrivial
         f1,FStar_TypeChecker_Common.NonTrivial f2) ->
          let g = FStar_Syntax_Util.mk_imp f1 f2 in
          FStar_TypeChecker_Common.NonTrivial g
<<<<<<< HEAD
      | uu____3468 -> g2
=======
      | uu____3485 -> g2
>>>>>>> origin/master
let weaken_precondition:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.lcomp ->
      FStar_TypeChecker_Common.guard_formula -> FStar_Syntax_Syntax.lcomp
  =
  fun env  ->
    fun lc  ->
      fun f  ->
<<<<<<< HEAD
        let weaken uu____3485 =
          let c = lc.FStar_Syntax_Syntax.comp () in
          let uu____3489 =
            env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
          if uu____3489
=======
        let weaken uu____3502 =
          let c = lc.FStar_Syntax_Syntax.comp () in
          let uu____3506 =
            env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
          if uu____3506
>>>>>>> origin/master
          then c
          else
            (match f with
             | FStar_TypeChecker_Common.Trivial  -> c
             | FStar_TypeChecker_Common.NonTrivial f1 ->
<<<<<<< HEAD
                 let uu____3496 = FStar_Syntax_Util.is_ml_comp c in
                 if uu____3496
                 then c
                 else
                   (let c1 = FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                    let uu____3501 = destruct_comp c1 in
                    match uu____3501 with
=======
                 let uu____3513 = FStar_Syntax_Util.is_ml_comp c in
                 if uu____3513
                 then c
                 else
                   (let c1 = FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                    let uu____3518 = destruct_comp c1 in
                    match uu____3518 with
>>>>>>> origin/master
                    | (u_res_t,res_t,wp) ->
                        let md =
                          FStar_TypeChecker_Env.get_effect_decl env
                            c1.FStar_Syntax_Syntax.effect_name in
                        let wp1 =
<<<<<<< HEAD
                          let uu____3514 =
                            let uu____3515 =
                              FStar_TypeChecker_Env.inst_effect_fun_with
                                [u_res_t] env md
                                md.FStar_Syntax_Syntax.assume_p in
                            let uu____3516 =
                              let uu____3517 =
                                FStar_Syntax_Syntax.as_arg res_t in
                              let uu____3518 =
                                let uu____3520 =
                                  FStar_Syntax_Syntax.as_arg f1 in
                                let uu____3521 =
                                  let uu____3523 =
                                    FStar_Syntax_Syntax.as_arg wp in
                                  [uu____3523] in
                                uu____3520 :: uu____3521 in
                              uu____3517 :: uu____3518 in
                            FStar_Syntax_Syntax.mk_Tm_app uu____3515
                              uu____3516 in
                          uu____3514 None wp.FStar_Syntax_Syntax.pos in
                        mk_comp md u_res_t res_t wp1
                          c1.FStar_Syntax_Syntax.flags)) in
        let uu___132_3528 = lc in
        {
          FStar_Syntax_Syntax.eff_name =
            (uu___132_3528.FStar_Syntax_Syntax.eff_name);
          FStar_Syntax_Syntax.res_typ =
            (uu___132_3528.FStar_Syntax_Syntax.res_typ);
          FStar_Syntax_Syntax.cflags =
            (uu___132_3528.FStar_Syntax_Syntax.cflags);
=======
                          let uu____3531 =
                            let uu____3532 =
                              FStar_TypeChecker_Env.inst_effect_fun_with
                                [u_res_t] env md
                                md.FStar_Syntax_Syntax.assume_p in
                            let uu____3533 =
                              let uu____3534 =
                                FStar_Syntax_Syntax.as_arg res_t in
                              let uu____3535 =
                                let uu____3537 =
                                  FStar_Syntax_Syntax.as_arg f1 in
                                let uu____3538 =
                                  let uu____3540 =
                                    FStar_Syntax_Syntax.as_arg wp in
                                  [uu____3540] in
                                uu____3537 :: uu____3538 in
                              uu____3534 :: uu____3535 in
                            FStar_Syntax_Syntax.mk_Tm_app uu____3532
                              uu____3533 in
                          uu____3531 None wp.FStar_Syntax_Syntax.pos in
                        mk_comp md u_res_t res_t wp1
                          c1.FStar_Syntax_Syntax.flags)) in
        let uu___132_3545 = lc in
        {
          FStar_Syntax_Syntax.eff_name =
            (uu___132_3545.FStar_Syntax_Syntax.eff_name);
          FStar_Syntax_Syntax.res_typ =
            (uu___132_3545.FStar_Syntax_Syntax.res_typ);
          FStar_Syntax_Syntax.cflags =
            (uu___132_3545.FStar_Syntax_Syntax.cflags);
>>>>>>> origin/master
          FStar_Syntax_Syntax.comp = weaken
        }
let strengthen_precondition:
  (Prims.unit -> Prims.string) option ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.lcomp ->
          FStar_TypeChecker_Env.guard_t ->
            (FStar_Syntax_Syntax.lcomp* FStar_TypeChecker_Env.guard_t)
  =
  fun reason  ->
    fun env  ->
      fun e  ->
        fun lc  ->
          fun g0  ->
<<<<<<< HEAD
            let uu____3555 = FStar_TypeChecker_Rel.is_trivial g0 in
            if uu____3555
            then (lc, g0)
            else
              ((let uu____3560 =
                  FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                    FStar_Options.Extreme in
                if uu____3560
                then
                  let uu____3561 =
                    FStar_TypeChecker_Normalize.term_to_string env e in
                  let uu____3562 =
                    FStar_TypeChecker_Rel.guard_to_string env g0 in
                  FStar_Util.print2
                    "+++++++++++++Strengthening pre-condition of term %s with guard %s\n"
                    uu____3561 uu____3562
=======
            let uu____3572 = FStar_TypeChecker_Rel.is_trivial g0 in
            if uu____3572
            then (lc, g0)
            else
              ((let uu____3577 =
                  FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                    FStar_Options.Extreme in
                if uu____3577
                then
                  let uu____3578 =
                    FStar_TypeChecker_Normalize.term_to_string env e in
                  let uu____3579 =
                    FStar_TypeChecker_Rel.guard_to_string env g0 in
                  FStar_Util.print2
                    "+++++++++++++Strengthening pre-condition of term %s with guard %s\n"
                    uu____3578 uu____3579
>>>>>>> origin/master
                else ());
               (let flags =
                  FStar_All.pipe_right lc.FStar_Syntax_Syntax.cflags
                    (FStar_List.collect
<<<<<<< HEAD
                       (fun uu___98_3568  ->
                          match uu___98_3568 with
=======
                       (fun uu___98_3585  ->
                          match uu___98_3585 with
>>>>>>> origin/master
                          | FStar_Syntax_Syntax.RETURN  ->
                              [FStar_Syntax_Syntax.PARTIAL_RETURN]
                          | FStar_Syntax_Syntax.PARTIAL_RETURN  ->
                              [FStar_Syntax_Syntax.PARTIAL_RETURN]
<<<<<<< HEAD
                          | uu____3570 -> [])) in
                let strengthen uu____3576 =
=======
                          | uu____3587 -> [])) in
                let strengthen uu____3593 =
>>>>>>> origin/master
                  let c = lc.FStar_Syntax_Syntax.comp () in
                  if env.FStar_TypeChecker_Env.lax
                  then c
                  else
                    (let g01 = FStar_TypeChecker_Rel.simplify_guard env g0 in
<<<<<<< HEAD
                     let uu____3584 = FStar_TypeChecker_Rel.guard_form g01 in
                     match uu____3584 with
                     | FStar_TypeChecker_Common.Trivial  -> c
                     | FStar_TypeChecker_Common.NonTrivial f ->
                         let c1 =
                           let uu____3591 =
                             (FStar_Syntax_Util.is_pure_or_ghost_comp c) &&
                               (let uu____3592 =
                                  FStar_Syntax_Util.is_partial_return c in
                                Prims.op_Negation uu____3592) in
                           if uu____3591
=======
                     let uu____3601 = FStar_TypeChecker_Rel.guard_form g01 in
                     match uu____3601 with
                     | FStar_TypeChecker_Common.Trivial  -> c
                     | FStar_TypeChecker_Common.NonTrivial f ->
                         let c1 =
                           let uu____3608 =
                             (FStar_Syntax_Util.is_pure_or_ghost_comp c) &&
                               (let uu____3609 =
                                  FStar_Syntax_Util.is_partial_return c in
                                Prims.op_Negation uu____3609) in
                           if uu____3608
>>>>>>> origin/master
                           then
                             let x =
                               FStar_Syntax_Syntax.gen_bv "strengthen_pre_x"
                                 None (FStar_Syntax_Util.comp_result c) in
                             let xret =
<<<<<<< HEAD
                               let uu____3599 =
                                 let uu____3600 =
                                   FStar_Syntax_Syntax.bv_to_name x in
                                 return_value env x.FStar_Syntax_Syntax.sort
                                   uu____3600 in
                               FStar_Syntax_Util.comp_set_flags uu____3599
=======
                               let uu____3616 =
                                 let uu____3617 =
                                   FStar_Syntax_Syntax.bv_to_name x in
                                 return_value env x.FStar_Syntax_Syntax.sort
                                   uu____3617 in
                               FStar_Syntax_Util.comp_set_flags uu____3616
>>>>>>> origin/master
                                 [FStar_Syntax_Syntax.PARTIAL_RETURN] in
                             let lc1 =
                               bind e.FStar_Syntax_Syntax.pos env (Some e)
                                 (FStar_Syntax_Util.lcomp_of_comp c)
                                 ((Some x),
                                   (FStar_Syntax_Util.lcomp_of_comp xret)) in
                             lc1.FStar_Syntax_Syntax.comp ()
                           else c in
<<<<<<< HEAD
                         ((let uu____3605 =
                             FStar_All.pipe_left
                               (FStar_TypeChecker_Env.debug env)
                               FStar_Options.Extreme in
                           if uu____3605
                           then
                             let uu____3606 =
                               FStar_TypeChecker_Normalize.term_to_string env
                                 e in
                             let uu____3607 =
=======
                         ((let uu____3622 =
                             FStar_All.pipe_left
                               (FStar_TypeChecker_Env.debug env)
                               FStar_Options.Extreme in
                           if uu____3622
                           then
                             let uu____3623 =
                               FStar_TypeChecker_Normalize.term_to_string env
                                 e in
                             let uu____3624 =
>>>>>>> origin/master
                               FStar_TypeChecker_Normalize.term_to_string env
                                 f in
                             FStar_Util.print2
                               "-------------Strengthening pre-condition of term %s with guard %s\n"
<<<<<<< HEAD
                               uu____3606 uu____3607
=======
                               uu____3623 uu____3624
>>>>>>> origin/master
                           else ());
                          (let c2 =
                             FStar_TypeChecker_Env.unfold_effect_abbrev env
                               c1 in
<<<<<<< HEAD
                           let uu____3610 = destruct_comp c2 in
                           match uu____3610 with
=======
                           let uu____3627 = destruct_comp c2 in
                           match uu____3627 with
>>>>>>> origin/master
                           | (u_res_t,res_t,wp) ->
                               let md =
                                 FStar_TypeChecker_Env.get_effect_decl env
                                   c2.FStar_Syntax_Syntax.effect_name in
                               let wp1 =
<<<<<<< HEAD
                                 let uu____3623 =
                                   let uu____3624 =
                                     FStar_TypeChecker_Env.inst_effect_fun_with
                                       [u_res_t] env md
                                       md.FStar_Syntax_Syntax.assert_p in
                                   let uu____3625 =
                                     let uu____3626 =
                                       FStar_Syntax_Syntax.as_arg res_t in
                                     let uu____3627 =
                                       let uu____3629 =
                                         let uu____3630 =
                                           let uu____3631 =
                                             FStar_TypeChecker_Env.get_range
                                               env in
                                           label_opt env reason uu____3631 f in
                                         FStar_All.pipe_left
                                           FStar_Syntax_Syntax.as_arg
                                           uu____3630 in
                                       let uu____3632 =
                                         let uu____3634 =
                                           FStar_Syntax_Syntax.as_arg wp in
                                         [uu____3634] in
                                       uu____3629 :: uu____3632 in
                                     uu____3626 :: uu____3627 in
                                   FStar_Syntax_Syntax.mk_Tm_app uu____3624
                                     uu____3625 in
                                 uu____3623 None wp.FStar_Syntax_Syntax.pos in
                               ((let uu____3640 =
                                   FStar_All.pipe_left
                                     (FStar_TypeChecker_Env.debug env)
                                     FStar_Options.Extreme in
                                 if uu____3640
                                 then
                                   let uu____3641 =
                                     FStar_Syntax_Print.term_to_string wp1 in
                                   FStar_Util.print1
                                     "-------------Strengthened pre-condition is %s\n"
                                     uu____3641
                                 else ());
                                (let c21 = mk_comp md u_res_t res_t wp1 flags in
                                 c21))))) in
                let uu____3644 =
                  let uu___133_3645 = lc in
                  let uu____3646 =
                    FStar_TypeChecker_Env.norm_eff_name env
                      lc.FStar_Syntax_Syntax.eff_name in
                  let uu____3647 =
                    let uu____3649 =
                      (FStar_Syntax_Util.is_pure_lcomp lc) &&
                        (let uu____3650 =
                           FStar_Syntax_Util.is_function_typ
                             lc.FStar_Syntax_Syntax.res_typ in
                         FStar_All.pipe_left Prims.op_Negation uu____3650) in
                    if uu____3649 then flags else [] in
                  {
                    FStar_Syntax_Syntax.eff_name = uu____3646;
                    FStar_Syntax_Syntax.res_typ =
                      (uu___133_3645.FStar_Syntax_Syntax.res_typ);
                    FStar_Syntax_Syntax.cflags = uu____3647;
                    FStar_Syntax_Syntax.comp = strengthen
                  } in
                (uu____3644,
                  (let uu___134_3653 = g0 in
=======
                                 let uu____3640 =
                                   let uu____3641 =
                                     FStar_TypeChecker_Env.inst_effect_fun_with
                                       [u_res_t] env md
                                       md.FStar_Syntax_Syntax.assert_p in
                                   let uu____3642 =
                                     let uu____3643 =
                                       FStar_Syntax_Syntax.as_arg res_t in
                                     let uu____3644 =
                                       let uu____3646 =
                                         let uu____3647 =
                                           let uu____3648 =
                                             FStar_TypeChecker_Env.get_range
                                               env in
                                           label_opt env reason uu____3648 f in
                                         FStar_All.pipe_left
                                           FStar_Syntax_Syntax.as_arg
                                           uu____3647 in
                                       let uu____3649 =
                                         let uu____3651 =
                                           FStar_Syntax_Syntax.as_arg wp in
                                         [uu____3651] in
                                       uu____3646 :: uu____3649 in
                                     uu____3643 :: uu____3644 in
                                   FStar_Syntax_Syntax.mk_Tm_app uu____3641
                                     uu____3642 in
                                 uu____3640 None wp.FStar_Syntax_Syntax.pos in
                               ((let uu____3657 =
                                   FStar_All.pipe_left
                                     (FStar_TypeChecker_Env.debug env)
                                     FStar_Options.Extreme in
                                 if uu____3657
                                 then
                                   let uu____3658 =
                                     FStar_Syntax_Print.term_to_string wp1 in
                                   FStar_Util.print1
                                     "-------------Strengthened pre-condition is %s\n"
                                     uu____3658
                                 else ());
                                (let c21 = mk_comp md u_res_t res_t wp1 flags in
                                 c21))))) in
                let uu____3661 =
                  let uu___133_3662 = lc in
                  let uu____3663 =
                    FStar_TypeChecker_Env.norm_eff_name env
                      lc.FStar_Syntax_Syntax.eff_name in
                  let uu____3664 =
                    let uu____3666 =
                      (FStar_Syntax_Util.is_pure_lcomp lc) &&
                        (let uu____3667 =
                           FStar_Syntax_Util.is_function_typ
                             lc.FStar_Syntax_Syntax.res_typ in
                         FStar_All.pipe_left Prims.op_Negation uu____3667) in
                    if uu____3666 then flags else [] in
                  {
                    FStar_Syntax_Syntax.eff_name = uu____3663;
                    FStar_Syntax_Syntax.res_typ =
                      (uu___133_3662.FStar_Syntax_Syntax.res_typ);
                    FStar_Syntax_Syntax.cflags = uu____3664;
                    FStar_Syntax_Syntax.comp = strengthen
                  } in
                (uu____3661,
                  (let uu___134_3670 = g0 in
>>>>>>> origin/master
                   {
                     FStar_TypeChecker_Env.guard_f =
                       FStar_TypeChecker_Common.Trivial;
                     FStar_TypeChecker_Env.deferred =
<<<<<<< HEAD
                       (uu___134_3653.FStar_TypeChecker_Env.deferred);
                     FStar_TypeChecker_Env.univ_ineqs =
                       (uu___134_3653.FStar_TypeChecker_Env.univ_ineqs);
                     FStar_TypeChecker_Env.implicits =
                       (uu___134_3653.FStar_TypeChecker_Env.implicits)
=======
                       (uu___134_3670.FStar_TypeChecker_Env.deferred);
                     FStar_TypeChecker_Env.univ_ineqs =
                       (uu___134_3670.FStar_TypeChecker_Env.univ_ineqs);
                     FStar_TypeChecker_Env.implicits =
                       (uu___134_3670.FStar_TypeChecker_Env.implicits)
>>>>>>> origin/master
                   }))))
let add_equality_to_post_condition:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.typ ->
        (FStar_Syntax_Syntax.comp',Prims.unit) FStar_Syntax_Syntax.syntax
  =
  fun env  ->
    fun comp  ->
      fun res_t  ->
        let md_pure =
          FStar_TypeChecker_Env.get_effect_decl env
            FStar_Syntax_Const.effect_PURE_lid in
        let x = FStar_Syntax_Syntax.new_bv None res_t in
        let y = FStar_Syntax_Syntax.new_bv None res_t in
<<<<<<< HEAD
        let uu____3668 =
          let uu____3671 = FStar_Syntax_Syntax.bv_to_name x in
          let uu____3672 = FStar_Syntax_Syntax.bv_to_name y in
          (uu____3671, uu____3672) in
        match uu____3668 with
        | (xexp,yexp) ->
            let u_res_t = env.FStar_TypeChecker_Env.universe_of env res_t in
            let yret =
              let uu____3681 =
                let uu____3682 =
                  FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t] env
                    md_pure md_pure.FStar_Syntax_Syntax.ret_wp in
                let uu____3683 =
                  let uu____3684 = FStar_Syntax_Syntax.as_arg res_t in
                  let uu____3685 =
                    let uu____3687 = FStar_Syntax_Syntax.as_arg yexp in
                    [uu____3687] in
                  uu____3684 :: uu____3685 in
                FStar_Syntax_Syntax.mk_Tm_app uu____3682 uu____3683 in
              uu____3681 None res_t.FStar_Syntax_Syntax.pos in
            let x_eq_y_yret =
              let uu____3695 =
                let uu____3696 =
                  FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t] env
                    md_pure md_pure.FStar_Syntax_Syntax.assume_p in
                let uu____3697 =
                  let uu____3698 = FStar_Syntax_Syntax.as_arg res_t in
                  let uu____3699 =
                    let uu____3701 =
                      let uu____3702 =
                        FStar_Syntax_Util.mk_eq2 u_res_t res_t xexp yexp in
                      FStar_All.pipe_left FStar_Syntax_Syntax.as_arg
                        uu____3702 in
                    let uu____3703 =
                      let uu____3705 =
                        FStar_All.pipe_left FStar_Syntax_Syntax.as_arg yret in
                      [uu____3705] in
                    uu____3701 :: uu____3703 in
                  uu____3698 :: uu____3699 in
                FStar_Syntax_Syntax.mk_Tm_app uu____3696 uu____3697 in
              uu____3695 None res_t.FStar_Syntax_Syntax.pos in
            let forall_y_x_eq_y_yret =
              let uu____3713 =
                let uu____3714 =
                  FStar_TypeChecker_Env.inst_effect_fun_with
                    [u_res_t; u_res_t] env md_pure
                    md_pure.FStar_Syntax_Syntax.close_wp in
                let uu____3715 =
                  let uu____3716 = FStar_Syntax_Syntax.as_arg res_t in
                  let uu____3717 =
                    let uu____3719 = FStar_Syntax_Syntax.as_arg res_t in
                    let uu____3720 =
                      let uu____3722 =
                        let uu____3723 =
                          let uu____3724 =
                            let uu____3725 = FStar_Syntax_Syntax.mk_binder y in
                            [uu____3725] in
                          FStar_Syntax_Util.abs uu____3724 x_eq_y_yret
=======
        let uu____3685 =
          let uu____3688 = FStar_Syntax_Syntax.bv_to_name x in
          let uu____3689 = FStar_Syntax_Syntax.bv_to_name y in
          (uu____3688, uu____3689) in
        match uu____3685 with
        | (xexp,yexp) ->
            let u_res_t = env.FStar_TypeChecker_Env.universe_of env res_t in
            let yret =
              let uu____3698 =
                let uu____3699 =
                  FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t] env
                    md_pure md_pure.FStar_Syntax_Syntax.ret_wp in
                let uu____3700 =
                  let uu____3701 = FStar_Syntax_Syntax.as_arg res_t in
                  let uu____3702 =
                    let uu____3704 = FStar_Syntax_Syntax.as_arg yexp in
                    [uu____3704] in
                  uu____3701 :: uu____3702 in
                FStar_Syntax_Syntax.mk_Tm_app uu____3699 uu____3700 in
              uu____3698 None res_t.FStar_Syntax_Syntax.pos in
            let x_eq_y_yret =
              let uu____3712 =
                let uu____3713 =
                  FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t] env
                    md_pure md_pure.FStar_Syntax_Syntax.assume_p in
                let uu____3714 =
                  let uu____3715 = FStar_Syntax_Syntax.as_arg res_t in
                  let uu____3716 =
                    let uu____3718 =
                      let uu____3719 =
                        FStar_Syntax_Util.mk_eq2 u_res_t res_t xexp yexp in
                      FStar_All.pipe_left FStar_Syntax_Syntax.as_arg
                        uu____3719 in
                    let uu____3720 =
                      let uu____3722 =
                        FStar_All.pipe_left FStar_Syntax_Syntax.as_arg yret in
                      [uu____3722] in
                    uu____3718 :: uu____3720 in
                  uu____3715 :: uu____3716 in
                FStar_Syntax_Syntax.mk_Tm_app uu____3713 uu____3714 in
              uu____3712 None res_t.FStar_Syntax_Syntax.pos in
            let forall_y_x_eq_y_yret =
              let uu____3730 =
                let uu____3731 =
                  FStar_TypeChecker_Env.inst_effect_fun_with
                    [u_res_t; u_res_t] env md_pure
                    md_pure.FStar_Syntax_Syntax.close_wp in
                let uu____3732 =
                  let uu____3733 = FStar_Syntax_Syntax.as_arg res_t in
                  let uu____3734 =
                    let uu____3736 = FStar_Syntax_Syntax.as_arg res_t in
                    let uu____3737 =
                      let uu____3739 =
                        let uu____3740 =
                          let uu____3741 =
                            let uu____3742 = FStar_Syntax_Syntax.mk_binder y in
                            [uu____3742] in
                          FStar_Syntax_Util.abs uu____3741 x_eq_y_yret
>>>>>>> origin/master
                            (Some
                               (FStar_Util.Inr
                                  (FStar_Syntax_Const.effect_Tot_lid,
                                    [FStar_Syntax_Syntax.TOTAL]))) in
                        FStar_All.pipe_left FStar_Syntax_Syntax.as_arg
<<<<<<< HEAD
                          uu____3723 in
                      [uu____3722] in
                    uu____3719 :: uu____3720 in
                  uu____3716 :: uu____3717 in
                FStar_Syntax_Syntax.mk_Tm_app uu____3714 uu____3715 in
              uu____3713 None res_t.FStar_Syntax_Syntax.pos in
=======
                          uu____3740 in
                      [uu____3739] in
                    uu____3736 :: uu____3737 in
                  uu____3733 :: uu____3734 in
                FStar_Syntax_Syntax.mk_Tm_app uu____3731 uu____3732 in
              uu____3730 None res_t.FStar_Syntax_Syntax.pos in
>>>>>>> origin/master
            let lc2 =
              mk_comp md_pure u_res_t res_t forall_y_x_eq_y_yret
                [FStar_Syntax_Syntax.PARTIAL_RETURN] in
            let lc =
<<<<<<< HEAD
              let uu____3741 = FStar_TypeChecker_Env.get_range env in
              bind uu____3741 env None (FStar_Syntax_Util.lcomp_of_comp comp)
=======
              let uu____3758 = FStar_TypeChecker_Env.get_range env in
              bind uu____3758 env None (FStar_Syntax_Util.lcomp_of_comp comp)
>>>>>>> origin/master
                ((Some x), (FStar_Syntax_Util.lcomp_of_comp lc2)) in
            lc.FStar_Syntax_Syntax.comp ()
let ite:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.formula ->
      FStar_Syntax_Syntax.lcomp ->
        FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp
  =
  fun env  ->
    fun guard  ->
      fun lcomp_then  ->
        fun lcomp_else  ->
          let joined_eff = join_lcomp env lcomp_then lcomp_else in
<<<<<<< HEAD
          let comp uu____3759 =
            let uu____3760 =
              env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
            if uu____3760
=======
          let comp uu____3776 =
            let uu____3777 =
              env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
            if uu____3777
>>>>>>> origin/master
            then
              let u_t =
                env.FStar_TypeChecker_Env.universe_of env
                  lcomp_then.FStar_Syntax_Syntax.res_typ in
              lax_mk_tot_or_comp_l joined_eff u_t
                lcomp_then.FStar_Syntax_Syntax.res_typ []
            else
<<<<<<< HEAD
              (let uu____3763 =
                 let uu____3776 = lcomp_then.FStar_Syntax_Syntax.comp () in
                 let uu____3777 = lcomp_else.FStar_Syntax_Syntax.comp () in
                 lift_and_destruct env uu____3776 uu____3777 in
               match uu____3763 with
               | ((md,uu____3779,uu____3780),(u_res_t,res_t,wp_then),
                  (uu____3784,uu____3785,wp_else)) ->
                   let ifthenelse md1 res_t1 g wp_t wp_e =
                     let uu____3814 =
                       FStar_Range.union_ranges wp_t.FStar_Syntax_Syntax.pos
                         wp_e.FStar_Syntax_Syntax.pos in
                     let uu____3815 =
                       let uu____3816 =
                         FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t]
                           env md1 md1.FStar_Syntax_Syntax.if_then_else in
                       let uu____3817 =
                         let uu____3818 = FStar_Syntax_Syntax.as_arg res_t1 in
                         let uu____3819 =
                           let uu____3821 = FStar_Syntax_Syntax.as_arg g in
                           let uu____3822 =
                             let uu____3824 = FStar_Syntax_Syntax.as_arg wp_t in
                             let uu____3825 =
                               let uu____3827 =
                                 FStar_Syntax_Syntax.as_arg wp_e in
                               [uu____3827] in
                             uu____3824 :: uu____3825 in
                           uu____3821 :: uu____3822 in
                         uu____3818 :: uu____3819 in
                       FStar_Syntax_Syntax.mk_Tm_app uu____3816 uu____3817 in
                     uu____3815 None uu____3814 in
                   let wp = ifthenelse md res_t guard wp_then wp_else in
                   let uu____3835 =
                     let uu____3836 = FStar_Options.split_cases () in
                     uu____3836 > (Prims.parse_int "0") in
                   if uu____3835
=======
              (let uu____3780 =
                 let uu____3793 = lcomp_then.FStar_Syntax_Syntax.comp () in
                 let uu____3794 = lcomp_else.FStar_Syntax_Syntax.comp () in
                 lift_and_destruct env uu____3793 uu____3794 in
               match uu____3780 with
               | ((md,uu____3796,uu____3797),(u_res_t,res_t,wp_then),
                  (uu____3801,uu____3802,wp_else)) ->
                   let ifthenelse md1 res_t1 g wp_t wp_e =
                     let uu____3831 =
                       FStar_Range.union_ranges wp_t.FStar_Syntax_Syntax.pos
                         wp_e.FStar_Syntax_Syntax.pos in
                     let uu____3832 =
                       let uu____3833 =
                         FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t]
                           env md1 md1.FStar_Syntax_Syntax.if_then_else in
                       let uu____3834 =
                         let uu____3835 = FStar_Syntax_Syntax.as_arg res_t1 in
                         let uu____3836 =
                           let uu____3838 = FStar_Syntax_Syntax.as_arg g in
                           let uu____3839 =
                             let uu____3841 = FStar_Syntax_Syntax.as_arg wp_t in
                             let uu____3842 =
                               let uu____3844 =
                                 FStar_Syntax_Syntax.as_arg wp_e in
                               [uu____3844] in
                             uu____3841 :: uu____3842 in
                           uu____3838 :: uu____3839 in
                         uu____3835 :: uu____3836 in
                       FStar_Syntax_Syntax.mk_Tm_app uu____3833 uu____3834 in
                     uu____3832 None uu____3831 in
                   let wp = ifthenelse md res_t guard wp_then wp_else in
                   let uu____3852 =
                     let uu____3853 = FStar_Options.split_cases () in
                     uu____3853 > (Prims.parse_int "0") in
                   if uu____3852
>>>>>>> origin/master
                   then
                     let comp = mk_comp md u_res_t res_t wp [] in
                     add_equality_to_post_condition env comp res_t
                   else
                     (let wp1 =
<<<<<<< HEAD
                        let uu____3842 =
                          let uu____3843 =
                            FStar_TypeChecker_Env.inst_effect_fun_with
                              [u_res_t] env md md.FStar_Syntax_Syntax.ite_wp in
                          let uu____3844 =
                            let uu____3845 = FStar_Syntax_Syntax.as_arg res_t in
                            let uu____3846 =
                              let uu____3848 = FStar_Syntax_Syntax.as_arg wp in
                              [uu____3848] in
                            uu____3845 :: uu____3846 in
                          FStar_Syntax_Syntax.mk_Tm_app uu____3843 uu____3844 in
                        uu____3842 None wp.FStar_Syntax_Syntax.pos in
                      mk_comp md u_res_t res_t wp1 [])) in
          let uu____3853 =
            join_effects env lcomp_then.FStar_Syntax_Syntax.eff_name
              lcomp_else.FStar_Syntax_Syntax.eff_name in
          {
            FStar_Syntax_Syntax.eff_name = uu____3853;
=======
                        let uu____3859 =
                          let uu____3860 =
                            FStar_TypeChecker_Env.inst_effect_fun_with
                              [u_res_t] env md md.FStar_Syntax_Syntax.ite_wp in
                          let uu____3861 =
                            let uu____3862 = FStar_Syntax_Syntax.as_arg res_t in
                            let uu____3863 =
                              let uu____3865 = FStar_Syntax_Syntax.as_arg wp in
                              [uu____3865] in
                            uu____3862 :: uu____3863 in
                          FStar_Syntax_Syntax.mk_Tm_app uu____3860 uu____3861 in
                        uu____3859 None wp.FStar_Syntax_Syntax.pos in
                      mk_comp md u_res_t res_t wp1 [])) in
          let uu____3870 =
            join_effects env lcomp_then.FStar_Syntax_Syntax.eff_name
              lcomp_else.FStar_Syntax_Syntax.eff_name in
          {
            FStar_Syntax_Syntax.eff_name = uu____3870;
>>>>>>> origin/master
            FStar_Syntax_Syntax.res_typ =
              (lcomp_then.FStar_Syntax_Syntax.res_typ);
            FStar_Syntax_Syntax.cflags = [];
            FStar_Syntax_Syntax.comp = comp
          }
let fvar_const:
  FStar_TypeChecker_Env.env -> FStar_Ident.lident -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun lid  ->
<<<<<<< HEAD
      let uu____3860 =
        let uu____3861 = FStar_TypeChecker_Env.get_range env in
        FStar_Ident.set_lid_range lid uu____3861 in
      FStar_Syntax_Syntax.fvar uu____3860 FStar_Syntax_Syntax.Delta_constant
=======
      let uu____3877 =
        let uu____3878 = FStar_TypeChecker_Env.get_range env in
        FStar_Ident.set_lid_range lid uu____3878 in
      FStar_Syntax_Syntax.fvar uu____3877 FStar_Syntax_Syntax.Delta_constant
>>>>>>> origin/master
        None
let bind_cases:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      (FStar_Syntax_Syntax.formula* FStar_Syntax_Syntax.lcomp) Prims.list ->
        FStar_Syntax_Syntax.lcomp
  =
  fun env  ->
    fun res_t  ->
      fun lcases  ->
        let eff =
          FStar_List.fold_left
            (fun eff  ->
<<<<<<< HEAD
               fun uu____3881  ->
                 match uu____3881 with
                 | (uu____3884,lc) ->
                     join_effects env eff lc.FStar_Syntax_Syntax.eff_name)
            FStar_Syntax_Const.effect_PURE_lid lcases in
        let bind_cases uu____3889 =
          let u_res_t = env.FStar_TypeChecker_Env.universe_of env res_t in
          let uu____3891 =
            env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
          if uu____3891
          then lax_mk_tot_or_comp_l eff u_res_t res_t []
          else
            (let ifthenelse md res_t1 g wp_t wp_e =
               let uu____3911 =
                 FStar_Range.union_ranges wp_t.FStar_Syntax_Syntax.pos
                   wp_e.FStar_Syntax_Syntax.pos in
               let uu____3912 =
                 let uu____3913 =
                   FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t] env
                     md md.FStar_Syntax_Syntax.if_then_else in
                 let uu____3914 =
                   let uu____3915 = FStar_Syntax_Syntax.as_arg res_t1 in
                   let uu____3916 =
                     let uu____3918 = FStar_Syntax_Syntax.as_arg g in
                     let uu____3919 =
                       let uu____3921 = FStar_Syntax_Syntax.as_arg wp_t in
                       let uu____3922 =
                         let uu____3924 = FStar_Syntax_Syntax.as_arg wp_e in
                         [uu____3924] in
                       uu____3921 :: uu____3922 in
                     uu____3918 :: uu____3919 in
                   uu____3915 :: uu____3916 in
                 FStar_Syntax_Syntax.mk_Tm_app uu____3913 uu____3914 in
               uu____3912 None uu____3911 in
             let default_case =
               let post_k =
                 let uu____3933 =
                   let uu____3937 = FStar_Syntax_Syntax.null_binder res_t in
                   [uu____3937] in
                 let uu____3938 =
                   FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
                 FStar_Syntax_Util.arrow uu____3933 uu____3938 in
               let kwp =
                 let uu____3944 =
                   let uu____3948 = FStar_Syntax_Syntax.null_binder post_k in
                   [uu____3948] in
                 let uu____3949 =
                   FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
                 FStar_Syntax_Util.arrow uu____3944 uu____3949 in
               let post = FStar_Syntax_Syntax.new_bv None post_k in
               let wp =
                 let uu____3954 =
                   let uu____3955 = FStar_Syntax_Syntax.mk_binder post in
                   [uu____3955] in
                 let uu____3956 =
                   let uu____3957 =
                     let uu____3960 = FStar_TypeChecker_Env.get_range env in
                     label FStar_TypeChecker_Err.exhaustiveness_check
                       uu____3960 in
                   let uu____3961 =
                     fvar_const env FStar_Syntax_Const.false_lid in
                   FStar_All.pipe_left uu____3957 uu____3961 in
                 FStar_Syntax_Util.abs uu____3954 uu____3956
=======
               fun uu____3898  ->
                 match uu____3898 with
                 | (uu____3901,lc) ->
                     join_effects env eff lc.FStar_Syntax_Syntax.eff_name)
            FStar_Syntax_Const.effect_PURE_lid lcases in
        let bind_cases uu____3906 =
          let u_res_t = env.FStar_TypeChecker_Env.universe_of env res_t in
          let uu____3908 =
            env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
          if uu____3908
          then lax_mk_tot_or_comp_l eff u_res_t res_t []
          else
            (let ifthenelse md res_t1 g wp_t wp_e =
               let uu____3928 =
                 FStar_Range.union_ranges wp_t.FStar_Syntax_Syntax.pos
                   wp_e.FStar_Syntax_Syntax.pos in
               let uu____3929 =
                 let uu____3930 =
                   FStar_TypeChecker_Env.inst_effect_fun_with [u_res_t] env
                     md md.FStar_Syntax_Syntax.if_then_else in
                 let uu____3931 =
                   let uu____3932 = FStar_Syntax_Syntax.as_arg res_t1 in
                   let uu____3933 =
                     let uu____3935 = FStar_Syntax_Syntax.as_arg g in
                     let uu____3936 =
                       let uu____3938 = FStar_Syntax_Syntax.as_arg wp_t in
                       let uu____3939 =
                         let uu____3941 = FStar_Syntax_Syntax.as_arg wp_e in
                         [uu____3941] in
                       uu____3938 :: uu____3939 in
                     uu____3935 :: uu____3936 in
                   uu____3932 :: uu____3933 in
                 FStar_Syntax_Syntax.mk_Tm_app uu____3930 uu____3931 in
               uu____3929 None uu____3928 in
             let default_case =
               let post_k =
                 let uu____3950 =
                   let uu____3954 = FStar_Syntax_Syntax.null_binder res_t in
                   [uu____3954] in
                 let uu____3955 =
                   FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
                 FStar_Syntax_Util.arrow uu____3950 uu____3955 in
               let kwp =
                 let uu____3961 =
                   let uu____3965 = FStar_Syntax_Syntax.null_binder post_k in
                   [uu____3965] in
                 let uu____3966 =
                   FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
                 FStar_Syntax_Util.arrow uu____3961 uu____3966 in
               let post = FStar_Syntax_Syntax.new_bv None post_k in
               let wp =
                 let uu____3971 =
                   let uu____3972 = FStar_Syntax_Syntax.mk_binder post in
                   [uu____3972] in
                 let uu____3973 =
                   let uu____3974 =
                     let uu____3977 = FStar_TypeChecker_Env.get_range env in
                     label FStar_TypeChecker_Err.exhaustiveness_check
                       uu____3977 in
                   let uu____3978 =
                     fvar_const env FStar_Syntax_Const.false_lid in
                   FStar_All.pipe_left uu____3974 uu____3978 in
                 FStar_Syntax_Util.abs uu____3971 uu____3973
>>>>>>> origin/master
                   (Some
                      (FStar_Util.Inr
                         (FStar_Syntax_Const.effect_Tot_lid,
                           [FStar_Syntax_Syntax.TOTAL]))) in
               let md =
                 FStar_TypeChecker_Env.get_effect_decl env
                   FStar_Syntax_Const.effect_PURE_lid in
               mk_comp md u_res_t res_t wp [] in
             let comp =
               FStar_List.fold_right
<<<<<<< HEAD
                 (fun uu____3975  ->
                    fun celse  ->
                      match uu____3975 with
                      | (g,cthen) ->
                          let uu____3981 =
                            let uu____3994 =
                              cthen.FStar_Syntax_Syntax.comp () in
                            lift_and_destruct env uu____3994 celse in
                          (match uu____3981 with
                           | ((md,uu____3996,uu____3997),(uu____3998,uu____3999,wp_then),
                              (uu____4001,uu____4002,wp_else)) ->
                               let uu____4013 =
                                 ifthenelse md res_t g wp_then wp_else in
                               mk_comp md u_res_t res_t uu____4013 []))
                 lcases default_case in
             let uu____4014 =
               let uu____4015 = FStar_Options.split_cases () in
               uu____4015 > (Prims.parse_int "0") in
             if uu____4014
=======
                 (fun uu____3992  ->
                    fun celse  ->
                      match uu____3992 with
                      | (g,cthen) ->
                          let uu____3998 =
                            let uu____4011 =
                              cthen.FStar_Syntax_Syntax.comp () in
                            lift_and_destruct env uu____4011 celse in
                          (match uu____3998 with
                           | ((md,uu____4013,uu____4014),(uu____4015,uu____4016,wp_then),
                              (uu____4018,uu____4019,wp_else)) ->
                               let uu____4030 =
                                 ifthenelse md res_t g wp_then wp_else in
                               mk_comp md u_res_t res_t uu____4030 []))
                 lcases default_case in
             let uu____4031 =
               let uu____4032 = FStar_Options.split_cases () in
               uu____4032 > (Prims.parse_int "0") in
             if uu____4031
>>>>>>> origin/master
             then add_equality_to_post_condition env comp res_t
             else
               (let comp1 = FStar_TypeChecker_Env.comp_to_comp_typ env comp in
                let md =
                  FStar_TypeChecker_Env.get_effect_decl env
                    comp1.FStar_Syntax_Syntax.effect_name in
<<<<<<< HEAD
                let uu____4019 = destruct_comp comp1 in
                match uu____4019 with
                | (uu____4023,uu____4024,wp) ->
                    let wp1 =
                      let uu____4029 =
                        let uu____4030 =
                          FStar_TypeChecker_Env.inst_effect_fun_with
                            [u_res_t] env md md.FStar_Syntax_Syntax.ite_wp in
                        let uu____4031 =
                          let uu____4032 = FStar_Syntax_Syntax.as_arg res_t in
                          let uu____4033 =
                            let uu____4035 = FStar_Syntax_Syntax.as_arg wp in
                            [uu____4035] in
                          uu____4032 :: uu____4033 in
                        FStar_Syntax_Syntax.mk_Tm_app uu____4030 uu____4031 in
                      uu____4029 None wp.FStar_Syntax_Syntax.pos in
=======
                let uu____4036 = destruct_comp comp1 in
                match uu____4036 with
                | (uu____4040,uu____4041,wp) ->
                    let wp1 =
                      let uu____4046 =
                        let uu____4047 =
                          FStar_TypeChecker_Env.inst_effect_fun_with
                            [u_res_t] env md md.FStar_Syntax_Syntax.ite_wp in
                        let uu____4048 =
                          let uu____4049 = FStar_Syntax_Syntax.as_arg res_t in
                          let uu____4050 =
                            let uu____4052 = FStar_Syntax_Syntax.as_arg wp in
                            [uu____4052] in
                          uu____4049 :: uu____4050 in
                        FStar_Syntax_Syntax.mk_Tm_app uu____4047 uu____4048 in
                      uu____4046 None wp.FStar_Syntax_Syntax.pos in
>>>>>>> origin/master
                    mk_comp md u_res_t res_t wp1 [])) in
        {
          FStar_Syntax_Syntax.eff_name = eff;
          FStar_Syntax_Syntax.res_typ = res_t;
          FStar_Syntax_Syntax.cflags = [];
          FStar_Syntax_Syntax.comp = bind_cases
        }
let maybe_assume_result_eq_pure_term:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp
  =
  fun env  ->
    fun e  ->
      fun lc  ->
        let flags =
<<<<<<< HEAD
          let uu____4051 =
            ((let uu____4052 =
                FStar_Syntax_Util.is_function_typ
                  lc.FStar_Syntax_Syntax.res_typ in
              Prims.op_Negation uu____4052) &&
               (FStar_Syntax_Util.is_pure_or_ghost_lcomp lc))
              &&
              (let uu____4053 = FStar_Syntax_Util.is_lcomp_partial_return lc in
               Prims.op_Negation uu____4053) in
          if uu____4051
          then FStar_Syntax_Syntax.PARTIAL_RETURN ::
            (lc.FStar_Syntax_Syntax.cflags)
          else lc.FStar_Syntax_Syntax.cflags in
        let refine1 uu____4061 =
          let c = lc.FStar_Syntax_Syntax.comp () in
          let uu____4065 =
            (let uu____4066 =
               is_pure_or_ghost_effect env lc.FStar_Syntax_Syntax.eff_name in
             Prims.op_Negation uu____4066) || env.FStar_TypeChecker_Env.lax in
          if uu____4065
          then c
          else
            (let uu____4070 = FStar_Syntax_Util.is_partial_return c in
             if uu____4070
             then c
             else
               (let uu____4074 = FStar_Syntax_Util.is_tot_or_gtot_comp c in
                if uu____4074
                then
                  let uu____4077 =
                    let uu____4078 =
                      FStar_TypeChecker_Env.lid_exists env
                        FStar_Syntax_Const.effect_GTot_lid in
                    Prims.op_Negation uu____4078 in
                  (if uu____4077
                   then
                     let uu____4081 =
                       let uu____4082 =
                         FStar_Range.string_of_range
                           e.FStar_Syntax_Syntax.pos in
                       let uu____4083 = FStar_Syntax_Print.term_to_string e in
                       FStar_Util.format2 "%s: %s\n" uu____4082 uu____4083 in
                     failwith uu____4081
                   else
                     (let retc =
                        return_value env (FStar_Syntax_Util.comp_result c) e in
                      let uu____4088 =
                        let uu____4089 = FStar_Syntax_Util.is_pure_comp c in
                        Prims.op_Negation uu____4089 in
                      if uu____4088
                      then
                        let retc1 = FStar_Syntax_Util.comp_to_comp_typ retc in
                        let retc2 =
                          let uu___135_4094 = retc1 in
                          {
                            FStar_Syntax_Syntax.comp_univs =
                              (uu___135_4094.FStar_Syntax_Syntax.comp_univs);
                            FStar_Syntax_Syntax.effect_name =
                              FStar_Syntax_Const.effect_GHOST_lid;
                            FStar_Syntax_Syntax.result_typ =
                              (uu___135_4094.FStar_Syntax_Syntax.result_typ);
                            FStar_Syntax_Syntax.effect_args =
                              (uu___135_4094.FStar_Syntax_Syntax.effect_args);
=======
          let uu____4068 =
            ((let uu____4069 =
                FStar_Syntax_Util.is_function_typ
                  lc.FStar_Syntax_Syntax.res_typ in
              Prims.op_Negation uu____4069) &&
               (FStar_Syntax_Util.is_pure_or_ghost_lcomp lc))
              &&
              (let uu____4070 = FStar_Syntax_Util.is_lcomp_partial_return lc in
               Prims.op_Negation uu____4070) in
          if uu____4068
          then FStar_Syntax_Syntax.PARTIAL_RETURN ::
            (lc.FStar_Syntax_Syntax.cflags)
          else lc.FStar_Syntax_Syntax.cflags in
        let refine1 uu____4078 =
          let c = lc.FStar_Syntax_Syntax.comp () in
          let uu____4082 =
            (let uu____4083 =
               is_pure_or_ghost_effect env lc.FStar_Syntax_Syntax.eff_name in
             Prims.op_Negation uu____4083) || env.FStar_TypeChecker_Env.lax in
          if uu____4082
          then c
          else
            (let uu____4087 = FStar_Syntax_Util.is_partial_return c in
             if uu____4087
             then c
             else
               (let uu____4091 = FStar_Syntax_Util.is_tot_or_gtot_comp c in
                if uu____4091
                then
                  let uu____4094 =
                    let uu____4095 =
                      FStar_TypeChecker_Env.lid_exists env
                        FStar_Syntax_Const.effect_GTot_lid in
                    Prims.op_Negation uu____4095 in
                  (if uu____4094
                   then
                     let uu____4098 =
                       let uu____4099 =
                         FStar_Range.string_of_range
                           e.FStar_Syntax_Syntax.pos in
                       let uu____4100 = FStar_Syntax_Print.term_to_string e in
                       FStar_Util.format2 "%s: %s\n" uu____4099 uu____4100 in
                     failwith uu____4098
                   else
                     (let retc =
                        return_value env (FStar_Syntax_Util.comp_result c) e in
                      let uu____4105 =
                        let uu____4106 = FStar_Syntax_Util.is_pure_comp c in
                        Prims.op_Negation uu____4106 in
                      if uu____4105
                      then
                        let retc1 = FStar_Syntax_Util.comp_to_comp_typ retc in
                        let retc2 =
                          let uu___135_4111 = retc1 in
                          {
                            FStar_Syntax_Syntax.comp_univs =
                              (uu___135_4111.FStar_Syntax_Syntax.comp_univs);
                            FStar_Syntax_Syntax.effect_name =
                              FStar_Syntax_Const.effect_GHOST_lid;
                            FStar_Syntax_Syntax.result_typ =
                              (uu___135_4111.FStar_Syntax_Syntax.result_typ);
                            FStar_Syntax_Syntax.effect_args =
                              (uu___135_4111.FStar_Syntax_Syntax.effect_args);
>>>>>>> origin/master
                            FStar_Syntax_Syntax.flags = flags
                          } in
                        FStar_Syntax_Syntax.mk_Comp retc2
                      else FStar_Syntax_Util.comp_set_flags retc flags))
                else
                  (let c1 = FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                   let t = c1.FStar_Syntax_Syntax.result_typ in
                   let c2 = FStar_Syntax_Syntax.mk_Comp c1 in
                   let x =
                     FStar_Syntax_Syntax.new_bv
                       (Some (t.FStar_Syntax_Syntax.pos)) t in
                   let xexp = FStar_Syntax_Syntax.bv_to_name x in
                   let ret1 =
<<<<<<< HEAD
                     let uu____4105 =
                       let uu____4108 = return_value env t xexp in
                       FStar_Syntax_Util.comp_set_flags uu____4108
                         [FStar_Syntax_Syntax.PARTIAL_RETURN] in
                     FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp
                       uu____4105 in
                   let eq1 =
                     let uu____4112 =
                       env.FStar_TypeChecker_Env.universe_of env t in
                     FStar_Syntax_Util.mk_eq2 uu____4112 t xexp e in
                   let eq_ret =
                     weaken_precondition env ret1
                       (FStar_TypeChecker_Common.NonTrivial eq1) in
                   let uu____4114 =
                     let uu____4115 =
                       let uu____4120 =
                         bind e.FStar_Syntax_Syntax.pos env None
                           (FStar_Syntax_Util.lcomp_of_comp c2)
                           ((Some x), eq_ret) in
                       uu____4120.FStar_Syntax_Syntax.comp in
                     uu____4115 () in
                   FStar_Syntax_Util.comp_set_flags uu____4114 flags))) in
        let uu___136_4122 = lc in
        {
          FStar_Syntax_Syntax.eff_name =
            (uu___136_4122.FStar_Syntax_Syntax.eff_name);
          FStar_Syntax_Syntax.res_typ =
            (uu___136_4122.FStar_Syntax_Syntax.res_typ);
=======
                     let uu____4122 =
                       let uu____4125 = return_value env t xexp in
                       FStar_Syntax_Util.comp_set_flags uu____4125
                         [FStar_Syntax_Syntax.PARTIAL_RETURN] in
                     FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp
                       uu____4122 in
                   let eq1 =
                     let uu____4129 =
                       env.FStar_TypeChecker_Env.universe_of env t in
                     FStar_Syntax_Util.mk_eq2 uu____4129 t xexp e in
                   let eq_ret =
                     weaken_precondition env ret1
                       (FStar_TypeChecker_Common.NonTrivial eq1) in
                   let uu____4131 =
                     let uu____4132 =
                       let uu____4137 =
                         bind e.FStar_Syntax_Syntax.pos env None
                           (FStar_Syntax_Util.lcomp_of_comp c2)
                           ((Some x), eq_ret) in
                       uu____4137.FStar_Syntax_Syntax.comp in
                     uu____4132 () in
                   FStar_Syntax_Util.comp_set_flags uu____4131 flags))) in
        let uu___136_4139 = lc in
        {
          FStar_Syntax_Syntax.eff_name =
            (uu___136_4139.FStar_Syntax_Syntax.eff_name);
          FStar_Syntax_Syntax.res_typ =
            (uu___136_4139.FStar_Syntax_Syntax.res_typ);
>>>>>>> origin/master
          FStar_Syntax_Syntax.cflags = flags;
          FStar_Syntax_Syntax.comp = refine1
        }
let check_comp:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.comp ->
        FStar_Syntax_Syntax.comp ->
          (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.comp*
            FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun e  ->
      fun c  ->
        fun c'  ->
<<<<<<< HEAD
          let uu____4141 = FStar_TypeChecker_Rel.sub_comp env c c' in
          match uu____4141 with
          | None  ->
              let uu____4146 =
                let uu____4147 =
                  let uu____4150 =
                    FStar_TypeChecker_Err.computed_computation_type_does_not_match_annotation
                      env e c c' in
                  let uu____4151 = FStar_TypeChecker_Env.get_range env in
                  (uu____4150, uu____4151) in
                FStar_Errors.Error uu____4147 in
              raise uu____4146
=======
          let uu____4158 = FStar_TypeChecker_Rel.sub_comp env c c' in
          match uu____4158 with
          | None  ->
              let uu____4163 =
                let uu____4164 =
                  let uu____4167 =
                    FStar_TypeChecker_Err.computed_computation_type_does_not_match_annotation
                      env e c c' in
                  let uu____4168 = FStar_TypeChecker_Env.get_range env in
                  (uu____4167, uu____4168) in
                FStar_Errors.Error uu____4164 in
              raise uu____4163
>>>>>>> origin/master
          | Some g -> (e, c', g)
let maybe_coerce_bool_to_type:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.lcomp ->
        FStar_Syntax_Syntax.term ->
          (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.lcomp)
  =
  fun env  ->
    fun e  ->
      fun lc  ->
        fun t  ->
          let is_type1 t1 =
            let t2 = FStar_TypeChecker_Normalize.unfold_whnf env t1 in
<<<<<<< HEAD
            let uu____4177 =
              let uu____4178 = FStar_Syntax_Subst.compress t2 in
              uu____4178.FStar_Syntax_Syntax.n in
            match uu____4177 with
            | FStar_Syntax_Syntax.Tm_type uu____4181 -> true
            | uu____4182 -> false in
          let uu____4183 =
            let uu____4184 =
              FStar_Syntax_Subst.compress lc.FStar_Syntax_Syntax.res_typ in
            uu____4184.FStar_Syntax_Syntax.n in
          match uu____4183 with
=======
            let uu____4194 =
              let uu____4195 = FStar_Syntax_Subst.compress t2 in
              uu____4195.FStar_Syntax_Syntax.n in
            match uu____4194 with
            | FStar_Syntax_Syntax.Tm_type uu____4198 -> true
            | uu____4199 -> false in
          let uu____4200 =
            let uu____4201 =
              FStar_Syntax_Subst.compress lc.FStar_Syntax_Syntax.res_typ in
            uu____4201.FStar_Syntax_Syntax.n in
          match uu____4200 with
>>>>>>> origin/master
          | FStar_Syntax_Syntax.Tm_fvar fv when
              (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.bool_lid)
                && (is_type1 t)
              ->
<<<<<<< HEAD
              let uu____4190 =
=======
              let uu____4207 =
>>>>>>> origin/master
                FStar_TypeChecker_Env.lookup_lid env
                  FStar_Syntax_Const.b2t_lid in
              let b2t1 =
                FStar_Syntax_Syntax.fvar
                  (FStar_Ident.set_lid_range FStar_Syntax_Const.b2t_lid
                     e.FStar_Syntax_Syntax.pos)
                  (FStar_Syntax_Syntax.Delta_defined_at_level
                     (Prims.parse_int "1")) None in
              let lc1 =
<<<<<<< HEAD
                let uu____4197 =
                  let uu____4198 =
                    let uu____4199 =
                      FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
                    FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp
                      uu____4199 in
                  (None, uu____4198) in
                bind e.FStar_Syntax_Syntax.pos env (Some e) lc uu____4197 in
              let e1 =
                let uu____4208 =
                  let uu____4209 =
                    let uu____4210 = FStar_Syntax_Syntax.as_arg e in
                    [uu____4210] in
                  FStar_Syntax_Syntax.mk_Tm_app b2t1 uu____4209 in
                uu____4208
                  (Some (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
                  e.FStar_Syntax_Syntax.pos in
              (e1, lc1)
          | uu____4217 -> (e, lc)
=======
                let uu____4214 =
                  let uu____4215 =
                    let uu____4216 =
                      FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
                    FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp
                      uu____4216 in
                  (None, uu____4215) in
                bind e.FStar_Syntax_Syntax.pos env (Some e) lc uu____4214 in
              let e1 =
                let uu____4225 =
                  let uu____4226 =
                    let uu____4227 = FStar_Syntax_Syntax.as_arg e in
                    [uu____4227] in
                  FStar_Syntax_Syntax.mk_Tm_app b2t1 uu____4226 in
                uu____4225
                  (Some (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
                  e.FStar_Syntax_Syntax.pos in
              (e1, lc1)
          | uu____4234 -> (e, lc)
>>>>>>> origin/master
let weaken_result_typ:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.lcomp ->
        FStar_Syntax_Syntax.typ ->
          (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.lcomp*
            FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun e  ->
      fun lc  ->
        fun t  ->
          let use_eq =
            env.FStar_TypeChecker_Env.use_eq ||
<<<<<<< HEAD
              (let uu____4237 =
                 FStar_TypeChecker_Env.effect_decl_opt env
                   lc.FStar_Syntax_Syntax.eff_name in
               match uu____4237 with
               | Some (ed,qualifiers) ->
                   FStar_All.pipe_right qualifiers
                     (FStar_List.contains FStar_Syntax_Syntax.Reifiable)
               | uu____4250 -> false) in
          let gopt =
            if use_eq
            then
              let uu____4262 =
                FStar_TypeChecker_Rel.try_teq true env
                  lc.FStar_Syntax_Syntax.res_typ t in
              (uu____4262, false)
            else
              (let uu____4266 =
                 FStar_TypeChecker_Rel.try_subtype env
                   lc.FStar_Syntax_Syntax.res_typ t in
               (uu____4266, true)) in
          match gopt with
          | (None ,uu____4272) ->
              (FStar_TypeChecker_Rel.subtype_fail env e
                 lc.FStar_Syntax_Syntax.res_typ t;
               (e,
                 ((let uu___137_4275 = lc in
                   {
                     FStar_Syntax_Syntax.eff_name =
                       (uu___137_4275.FStar_Syntax_Syntax.eff_name);
                     FStar_Syntax_Syntax.res_typ = t;
                     FStar_Syntax_Syntax.cflags =
                       (uu___137_4275.FStar_Syntax_Syntax.cflags);
                     FStar_Syntax_Syntax.comp =
                       (uu___137_4275.FStar_Syntax_Syntax.comp)
                   })), FStar_TypeChecker_Rel.trivial_guard))
          | (Some g,apply_guard1) ->
              let uu____4279 = FStar_TypeChecker_Rel.guard_form g in
              (match uu____4279 with
               | FStar_TypeChecker_Common.Trivial  ->
                   let lc1 =
                     let uu___138_4284 = lc in
                     {
                       FStar_Syntax_Syntax.eff_name =
                         (uu___138_4284.FStar_Syntax_Syntax.eff_name);
                       FStar_Syntax_Syntax.res_typ = t;
                       FStar_Syntax_Syntax.cflags =
                         (uu___138_4284.FStar_Syntax_Syntax.cflags);
                       FStar_Syntax_Syntax.comp =
                         (uu___138_4284.FStar_Syntax_Syntax.comp)
=======
              (let uu____4254 =
                 FStar_TypeChecker_Env.effect_decl_opt env
                   lc.FStar_Syntax_Syntax.eff_name in
               match uu____4254 with
               | Some (ed,qualifiers) ->
                   FStar_All.pipe_right qualifiers
                     (FStar_List.contains FStar_Syntax_Syntax.Reifiable)
               | uu____4267 -> false) in
          let gopt =
            if use_eq
            then
              let uu____4279 =
                FStar_TypeChecker_Rel.try_teq true env
                  lc.FStar_Syntax_Syntax.res_typ t in
              (uu____4279, false)
            else
              (let uu____4283 =
                 FStar_TypeChecker_Rel.try_subtype env
                   lc.FStar_Syntax_Syntax.res_typ t in
               (uu____4283, true)) in
          match gopt with
          | (None ,uu____4289) ->
              (FStar_TypeChecker_Rel.subtype_fail env e
                 lc.FStar_Syntax_Syntax.res_typ t;
               (e,
                 ((let uu___137_4292 = lc in
                   {
                     FStar_Syntax_Syntax.eff_name =
                       (uu___137_4292.FStar_Syntax_Syntax.eff_name);
                     FStar_Syntax_Syntax.res_typ = t;
                     FStar_Syntax_Syntax.cflags =
                       (uu___137_4292.FStar_Syntax_Syntax.cflags);
                     FStar_Syntax_Syntax.comp =
                       (uu___137_4292.FStar_Syntax_Syntax.comp)
                   })), FStar_TypeChecker_Rel.trivial_guard))
          | (Some g,apply_guard1) ->
              let uu____4296 = FStar_TypeChecker_Rel.guard_form g in
              (match uu____4296 with
               | FStar_TypeChecker_Common.Trivial  ->
                   let lc1 =
                     let uu___138_4301 = lc in
                     {
                       FStar_Syntax_Syntax.eff_name =
                         (uu___138_4301.FStar_Syntax_Syntax.eff_name);
                       FStar_Syntax_Syntax.res_typ = t;
                       FStar_Syntax_Syntax.cflags =
                         (uu___138_4301.FStar_Syntax_Syntax.cflags);
                       FStar_Syntax_Syntax.comp =
                         (uu___138_4301.FStar_Syntax_Syntax.comp)
>>>>>>> origin/master
                     } in
                   (e, lc1, g)
               | FStar_TypeChecker_Common.NonTrivial f ->
                   let g1 =
<<<<<<< HEAD
                     let uu___139_4287 = g in
=======
                     let uu___139_4304 = g in
>>>>>>> origin/master
                     {
                       FStar_TypeChecker_Env.guard_f =
                         FStar_TypeChecker_Common.Trivial;
                       FStar_TypeChecker_Env.deferred =
<<<<<<< HEAD
                         (uu___139_4287.FStar_TypeChecker_Env.deferred);
                       FStar_TypeChecker_Env.univ_ineqs =
                         (uu___139_4287.FStar_TypeChecker_Env.univ_ineqs);
                       FStar_TypeChecker_Env.implicits =
                         (uu___139_4287.FStar_TypeChecker_Env.implicits)
                     } in
                   let strengthen uu____4293 =
                     let uu____4294 =
                       env.FStar_TypeChecker_Env.lax &&
                         (FStar_Options.ml_ish ()) in
                     if uu____4294
=======
                         (uu___139_4304.FStar_TypeChecker_Env.deferred);
                       FStar_TypeChecker_Env.univ_ineqs =
                         (uu___139_4304.FStar_TypeChecker_Env.univ_ineqs);
                       FStar_TypeChecker_Env.implicits =
                         (uu___139_4304.FStar_TypeChecker_Env.implicits)
                     } in
                   let strengthen uu____4310 =
                     let uu____4311 =
                       env.FStar_TypeChecker_Env.lax &&
                         (FStar_Options.ml_ish ()) in
                     if uu____4311
>>>>>>> origin/master
                     then lc.FStar_Syntax_Syntax.comp ()
                     else
                       (let f1 =
                          FStar_TypeChecker_Normalize.normalize
                            [FStar_TypeChecker_Normalize.Beta;
                            FStar_TypeChecker_Normalize.Eager_unfolding;
                            FStar_TypeChecker_Normalize.Simplify] env f in
<<<<<<< HEAD
                        let uu____4299 =
                          let uu____4300 = FStar_Syntax_Subst.compress f1 in
                          uu____4300.FStar_Syntax_Syntax.n in
                        match uu____4299 with
                        | FStar_Syntax_Syntax.Tm_abs
                            (uu____4305,{
                                          FStar_Syntax_Syntax.n =
                                            FStar_Syntax_Syntax.Tm_fvar fv;
                                          FStar_Syntax_Syntax.tk = uu____4307;
                                          FStar_Syntax_Syntax.pos =
                                            uu____4308;
                                          FStar_Syntax_Syntax.vars =
                                            uu____4309;_},uu____4310)
=======
                        let uu____4316 =
                          let uu____4317 = FStar_Syntax_Subst.compress f1 in
                          uu____4317.FStar_Syntax_Syntax.n in
                        match uu____4316 with
                        | FStar_Syntax_Syntax.Tm_abs
                            (uu____4322,{
                                          FStar_Syntax_Syntax.n =
                                            FStar_Syntax_Syntax.Tm_fvar fv;
                                          FStar_Syntax_Syntax.tk = uu____4324;
                                          FStar_Syntax_Syntax.pos =
                                            uu____4325;
                                          FStar_Syntax_Syntax.vars =
                                            uu____4326;_},uu____4327)
>>>>>>> origin/master
                            when
                            FStar_Syntax_Syntax.fv_eq_lid fv
                              FStar_Syntax_Const.true_lid
                            ->
                            let lc1 =
<<<<<<< HEAD
                              let uu___140_4334 = lc in
                              {
                                FStar_Syntax_Syntax.eff_name =
                                  (uu___140_4334.FStar_Syntax_Syntax.eff_name);
                                FStar_Syntax_Syntax.res_typ = t;
                                FStar_Syntax_Syntax.cflags =
                                  (uu___140_4334.FStar_Syntax_Syntax.cflags);
                                FStar_Syntax_Syntax.comp =
                                  (uu___140_4334.FStar_Syntax_Syntax.comp)
                              } in
                            lc1.FStar_Syntax_Syntax.comp ()
                        | uu____4335 ->
                            let c = lc.FStar_Syntax_Syntax.comp () in
                            ((let uu____4340 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  FStar_Options.Extreme in
                              if uu____4340
                              then
                                let uu____4341 =
                                  FStar_TypeChecker_Normalize.term_to_string
                                    env lc.FStar_Syntax_Syntax.res_typ in
                                let uu____4342 =
                                  FStar_TypeChecker_Normalize.term_to_string
                                    env t in
                                let uu____4343 =
                                  FStar_TypeChecker_Normalize.comp_to_string
                                    env c in
                                let uu____4344 =
=======
                              let uu___140_4351 = lc in
                              {
                                FStar_Syntax_Syntax.eff_name =
                                  (uu___140_4351.FStar_Syntax_Syntax.eff_name);
                                FStar_Syntax_Syntax.res_typ = t;
                                FStar_Syntax_Syntax.cflags =
                                  (uu___140_4351.FStar_Syntax_Syntax.cflags);
                                FStar_Syntax_Syntax.comp =
                                  (uu___140_4351.FStar_Syntax_Syntax.comp)
                              } in
                            lc1.FStar_Syntax_Syntax.comp ()
                        | uu____4352 ->
                            let c = lc.FStar_Syntax_Syntax.comp () in
                            ((let uu____4357 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  FStar_Options.Extreme in
                              if uu____4357
                              then
                                let uu____4358 =
                                  FStar_TypeChecker_Normalize.term_to_string
                                    env lc.FStar_Syntax_Syntax.res_typ in
                                let uu____4359 =
                                  FStar_TypeChecker_Normalize.term_to_string
                                    env t in
                                let uu____4360 =
                                  FStar_TypeChecker_Normalize.comp_to_string
                                    env c in
                                let uu____4361 =
>>>>>>> origin/master
                                  FStar_TypeChecker_Normalize.term_to_string
                                    env f1 in
                                FStar_Util.print4
                                  "Weakened from %s to %s\nStrengthening %s with guard %s\n"
<<<<<<< HEAD
                                  uu____4341 uu____4342 uu____4343 uu____4344
=======
                                  uu____4358 uu____4359 uu____4360 uu____4361
>>>>>>> origin/master
                              else ());
                             (let ct =
                                FStar_TypeChecker_Env.unfold_effect_abbrev
                                  env c in
<<<<<<< HEAD
                              let uu____4347 =
                                FStar_TypeChecker_Env.wp_signature env
                                  FStar_Syntax_Const.effect_PURE_lid in
                              match uu____4347 with
=======
                              let uu____4364 =
                                FStar_TypeChecker_Env.wp_signature env
                                  FStar_Syntax_Const.effect_PURE_lid in
                              match uu____4364 with
>>>>>>> origin/master
                              | (a,kwp) ->
                                  let k =
                                    FStar_Syntax_Subst.subst
                                      [FStar_Syntax_Syntax.NT (a, t)] kwp in
                                  let md =
                                    FStar_TypeChecker_Env.get_effect_decl env
                                      ct.FStar_Syntax_Syntax.effect_name in
                                  let x =
                                    FStar_Syntax_Syntax.new_bv
                                      (Some (t.FStar_Syntax_Syntax.pos)) t in
                                  let xexp = FStar_Syntax_Syntax.bv_to_name x in
<<<<<<< HEAD
                                  let uu____4358 = destruct_comp ct in
                                  (match uu____4358 with
                                   | (u_t,uu____4365,uu____4366) ->
                                       let wp =
                                         let uu____4370 =
                                           let uu____4371 =
                                             FStar_TypeChecker_Env.inst_effect_fun_with
                                               [u_t] env md
                                               md.FStar_Syntax_Syntax.ret_wp in
                                           let uu____4372 =
                                             let uu____4373 =
                                               FStar_Syntax_Syntax.as_arg t in
                                             let uu____4374 =
                                               let uu____4376 =
                                                 FStar_Syntax_Syntax.as_arg
                                                   xexp in
                                               [uu____4376] in
                                             uu____4373 :: uu____4374 in
                                           FStar_Syntax_Syntax.mk_Tm_app
                                             uu____4371 uu____4372 in
                                         uu____4370
                                           (Some (k.FStar_Syntax_Syntax.n))
                                           xexp.FStar_Syntax_Syntax.pos in
                                       let cret =
                                         let uu____4382 =
=======
                                  let uu____4375 = destruct_comp ct in
                                  (match uu____4375 with
                                   | (u_t,uu____4382,uu____4383) ->
                                       let wp =
                                         let uu____4387 =
                                           let uu____4388 =
                                             FStar_TypeChecker_Env.inst_effect_fun_with
                                               [u_t] env md
                                               md.FStar_Syntax_Syntax.ret_wp in
                                           let uu____4389 =
                                             let uu____4390 =
                                               FStar_Syntax_Syntax.as_arg t in
                                             let uu____4391 =
                                               let uu____4393 =
                                                 FStar_Syntax_Syntax.as_arg
                                                   xexp in
                                               [uu____4393] in
                                             uu____4390 :: uu____4391 in
                                           FStar_Syntax_Syntax.mk_Tm_app
                                             uu____4388 uu____4389 in
                                         uu____4387
                                           (Some (k.FStar_Syntax_Syntax.n))
                                           xexp.FStar_Syntax_Syntax.pos in
                                       let cret =
                                         let uu____4399 =
>>>>>>> origin/master
                                           mk_comp md u_t t wp
                                             [FStar_Syntax_Syntax.RETURN] in
                                         FStar_All.pipe_left
                                           FStar_Syntax_Util.lcomp_of_comp
<<<<<<< HEAD
                                           uu____4382 in
                                       let guard =
                                         if apply_guard1
                                         then
                                           let uu____4392 =
                                             let uu____4393 =
                                               let uu____4394 =
                                                 FStar_Syntax_Syntax.as_arg
                                                   xexp in
                                               [uu____4394] in
                                             FStar_Syntax_Syntax.mk_Tm_app f1
                                               uu____4393 in
                                           uu____4392
=======
                                           uu____4399 in
                                       let guard =
                                         if apply_guard1
                                         then
                                           let uu____4409 =
                                             let uu____4410 =
                                               let uu____4411 =
                                                 FStar_Syntax_Syntax.as_arg
                                                   xexp in
                                               [uu____4411] in
                                             FStar_Syntax_Syntax.mk_Tm_app f1
                                               uu____4410 in
                                           uu____4409
>>>>>>> origin/master
                                             (Some
                                                (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
                                             f1.FStar_Syntax_Syntax.pos
                                         else f1 in
<<<<<<< HEAD
                                       let uu____4400 =
                                         let uu____4403 =
=======
                                       let uu____4417 =
                                         let uu____4420 =
>>>>>>> origin/master
                                           FStar_All.pipe_left
                                             (fun _0_29  -> Some _0_29)
                                             (FStar_TypeChecker_Err.subtyping_failed
                                                env
                                                lc.FStar_Syntax_Syntax.res_typ
                                                t) in
<<<<<<< HEAD
                                         let uu____4414 =
                                           FStar_TypeChecker_Env.set_range
                                             env e.FStar_Syntax_Syntax.pos in
                                         let uu____4415 =
=======
                                         let uu____4431 =
                                           FStar_TypeChecker_Env.set_range
                                             env e.FStar_Syntax_Syntax.pos in
                                         let uu____4432 =
>>>>>>> origin/master
                                           FStar_All.pipe_left
                                             FStar_TypeChecker_Rel.guard_of_guard_formula
                                             (FStar_TypeChecker_Common.NonTrivial
                                                guard) in
<<<<<<< HEAD
                                         strengthen_precondition uu____4403
                                           uu____4414 e cret uu____4415 in
                                       (match uu____4400 with
                                        | (eq_ret,_trivial_so_ok_to_discard)
                                            ->
                                            let x1 =
                                              let uu___141_4421 = x in
                                              {
                                                FStar_Syntax_Syntax.ppname =
                                                  (uu___141_4421.FStar_Syntax_Syntax.ppname);
                                                FStar_Syntax_Syntax.index =
                                                  (uu___141_4421.FStar_Syntax_Syntax.index);
=======
                                         strengthen_precondition uu____4420
                                           uu____4431 e cret uu____4432 in
                                       (match uu____4417 with
                                        | (eq_ret,_trivial_so_ok_to_discard)
                                            ->
                                            let x1 =
                                              let uu___141_4438 = x in
                                              {
                                                FStar_Syntax_Syntax.ppname =
                                                  (uu___141_4438.FStar_Syntax_Syntax.ppname);
                                                FStar_Syntax_Syntax.index =
                                                  (uu___141_4438.FStar_Syntax_Syntax.index);
>>>>>>> origin/master
                                                FStar_Syntax_Syntax.sort =
                                                  (lc.FStar_Syntax_Syntax.res_typ)
                                              } in
                                            let c1 =
<<<<<<< HEAD
                                              let uu____4423 =
                                                let uu____4424 =
=======
                                              let uu____4440 =
                                                let uu____4441 =
>>>>>>> origin/master
                                                  FStar_Syntax_Syntax.mk_Comp
                                                    ct in
                                                FStar_All.pipe_left
                                                  FStar_Syntax_Util.lcomp_of_comp
<<<<<<< HEAD
                                                  uu____4424 in
                                              bind e.FStar_Syntax_Syntax.pos
                                                env (Some e) uu____4423
                                                ((Some x1), eq_ret) in
                                            let c2 =
                                              c1.FStar_Syntax_Syntax.comp () in
                                            ((let uu____4434 =
=======
                                                  uu____4441 in
                                              bind e.FStar_Syntax_Syntax.pos
                                                env (Some e) uu____4440
                                                ((Some x1), eq_ret) in
                                            let c2 =
                                              c1.FStar_Syntax_Syntax.comp () in
                                            ((let uu____4451 =
>>>>>>> origin/master
                                                FStar_All.pipe_left
                                                  (FStar_TypeChecker_Env.debug
                                                     env)
                                                  FStar_Options.Extreme in
<<<<<<< HEAD
                                              if uu____4434
                                              then
                                                let uu____4435 =
=======
                                              if uu____4451
                                              then
                                                let uu____4452 =
>>>>>>> origin/master
                                                  FStar_TypeChecker_Normalize.comp_to_string
                                                    env c2 in
                                                FStar_Util.print1
                                                  "Strengthened to %s\n"
<<<<<<< HEAD
                                                  uu____4435
=======
                                                  uu____4452
>>>>>>> origin/master
                                              else ());
                                             c2)))))) in
                   let flags =
                     FStar_All.pipe_right lc.FStar_Syntax_Syntax.cflags
                       (FStar_List.collect
<<<<<<< HEAD
                          (fun uu___99_4441  ->
                             match uu___99_4441 with
=======
                          (fun uu___99_4458  ->
                             match uu___99_4458 with
>>>>>>> origin/master
                             | FStar_Syntax_Syntax.RETURN  ->
                                 [FStar_Syntax_Syntax.PARTIAL_RETURN]
                             | FStar_Syntax_Syntax.PARTIAL_RETURN  ->
                                 [FStar_Syntax_Syntax.PARTIAL_RETURN]
                             | FStar_Syntax_Syntax.CPS  ->
                                 [FStar_Syntax_Syntax.CPS]
<<<<<<< HEAD
                             | uu____4443 -> [])) in
                   let lc1 =
                     let uu___142_4445 = lc in
                     let uu____4446 =
                       FStar_TypeChecker_Env.norm_eff_name env
                         lc.FStar_Syntax_Syntax.eff_name in
                     {
                       FStar_Syntax_Syntax.eff_name = uu____4446;
=======
                             | uu____4460 -> [])) in
                   let lc1 =
                     let uu___142_4462 = lc in
                     let uu____4463 =
                       FStar_TypeChecker_Env.norm_eff_name env
                         lc.FStar_Syntax_Syntax.eff_name in
                     {
                       FStar_Syntax_Syntax.eff_name = uu____4463;
>>>>>>> origin/master
                       FStar_Syntax_Syntax.res_typ = t;
                       FStar_Syntax_Syntax.cflags = flags;
                       FStar_Syntax_Syntax.comp = strengthen
                     } in
                   let g2 =
<<<<<<< HEAD
                     let uu___143_4448 = g1 in
=======
                     let uu___143_4465 = g1 in
>>>>>>> origin/master
                     {
                       FStar_TypeChecker_Env.guard_f =
                         FStar_TypeChecker_Common.Trivial;
                       FStar_TypeChecker_Env.deferred =
<<<<<<< HEAD
                         (uu___143_4448.FStar_TypeChecker_Env.deferred);
                       FStar_TypeChecker_Env.univ_ineqs =
                         (uu___143_4448.FStar_TypeChecker_Env.univ_ineqs);
                       FStar_TypeChecker_Env.implicits =
                         (uu___143_4448.FStar_TypeChecker_Env.implicits)
=======
                         (uu___143_4465.FStar_TypeChecker_Env.deferred);
                       FStar_TypeChecker_Env.univ_ineqs =
                         (uu___143_4465.FStar_TypeChecker_Env.univ_ineqs);
                       FStar_TypeChecker_Env.implicits =
                         (uu___143_4465.FStar_TypeChecker_Env.implicits)
>>>>>>> origin/master
                     } in
                   (e, lc1, g2))
let pure_or_ghost_pre_and_post:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      (FStar_Syntax_Syntax.typ option* FStar_Syntax_Syntax.typ)
  =
  fun env  ->
    fun comp  ->
      let mk_post_type res_t ens =
        let x = FStar_Syntax_Syntax.new_bv None res_t in
<<<<<<< HEAD
        let uu____4468 =
          let uu____4469 =
            let uu____4470 =
              let uu____4471 =
                let uu____4472 = FStar_Syntax_Syntax.bv_to_name x in
                FStar_Syntax_Syntax.as_arg uu____4472 in
              [uu____4471] in
            FStar_Syntax_Syntax.mk_Tm_app ens uu____4470 in
          uu____4469 None res_t.FStar_Syntax_Syntax.pos in
        FStar_Syntax_Util.refine x uu____4468 in
=======
        let uu____4485 =
          let uu____4486 =
            let uu____4487 =
              let uu____4488 =
                let uu____4489 = FStar_Syntax_Syntax.bv_to_name x in
                FStar_Syntax_Syntax.as_arg uu____4489 in
              [uu____4488] in
            FStar_Syntax_Syntax.mk_Tm_app ens uu____4487 in
          uu____4486 None res_t.FStar_Syntax_Syntax.pos in
        FStar_Syntax_Util.refine x uu____4485 in
>>>>>>> origin/master
      let norm t =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Normalize.Beta;
          FStar_TypeChecker_Normalize.Eager_unfolding;
          FStar_TypeChecker_Normalize.EraseUniverses] env t in
<<<<<<< HEAD
      let uu____4481 = FStar_Syntax_Util.is_tot_or_gtot_comp comp in
      if uu____4481
      then (None, (FStar_Syntax_Util.comp_result comp))
      else
        (match comp.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.GTotal uu____4492 -> failwith "Impossible"
         | FStar_Syntax_Syntax.Total uu____4501 -> failwith "Impossible"
=======
      let uu____4498 = FStar_Syntax_Util.is_tot_or_gtot_comp comp in
      if uu____4498
      then (None, (FStar_Syntax_Util.comp_result comp))
      else
        (match comp.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.GTotal uu____4509 -> failwith "Impossible"
         | FStar_Syntax_Syntax.Total uu____4518 -> failwith "Impossible"
>>>>>>> origin/master
         | FStar_Syntax_Syntax.Comp ct ->
             if
               (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
                  FStar_Syntax_Const.effect_Pure_lid)
                 ||
                 (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
                    FStar_Syntax_Const.effect_Ghost_lid)
             then
               (match ct.FStar_Syntax_Syntax.effect_args with
<<<<<<< HEAD
                | (req,uu____4518)::(ens,uu____4520)::uu____4521 ->
                    let uu____4543 =
                      let uu____4545 = norm req in Some uu____4545 in
                    let uu____4546 =
                      let uu____4547 =
                        mk_post_type ct.FStar_Syntax_Syntax.result_typ ens in
                      FStar_All.pipe_left norm uu____4547 in
                    (uu____4543, uu____4546)
                | uu____4549 ->
                    let uu____4555 =
                      let uu____4556 =
                        let uu____4559 =
                          let uu____4560 =
                            FStar_Syntax_Print.comp_to_string comp in
                          FStar_Util.format1
                            "Effect constructor is not fully applied; got %s"
                            uu____4560 in
                        (uu____4559, (comp.FStar_Syntax_Syntax.pos)) in
                      FStar_Errors.Error uu____4556 in
                    raise uu____4555)
             else
               (let ct1 = FStar_TypeChecker_Env.unfold_effect_abbrev env comp in
                match ct1.FStar_Syntax_Syntax.effect_args with
                | (wp,uu____4570)::uu____4571 ->
                    let uu____4585 =
                      let uu____4588 =
                        FStar_TypeChecker_Env.lookup_lid env
                          FStar_Syntax_Const.as_requires in
                      FStar_All.pipe_left FStar_Pervasives.fst uu____4588 in
                    (match uu____4585 with
                     | (us_r,uu____4605) ->
                         let uu____4606 =
                           let uu____4609 =
                             FStar_TypeChecker_Env.lookup_lid env
                               FStar_Syntax_Const.as_ensures in
                           FStar_All.pipe_left FStar_Pervasives.fst
                             uu____4609 in
                         (match uu____4606 with
                          | (us_e,uu____4626) ->
                              let r =
                                (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let as_req =
                                let uu____4629 =
=======
                | (req,uu____4535)::(ens,uu____4537)::uu____4538 ->
                    let uu____4560 =
                      let uu____4562 = norm req in Some uu____4562 in
                    let uu____4563 =
                      let uu____4564 =
                        mk_post_type ct.FStar_Syntax_Syntax.result_typ ens in
                      FStar_All.pipe_left norm uu____4564 in
                    (uu____4560, uu____4563)
                | uu____4566 ->
                    let uu____4572 =
                      let uu____4573 =
                        let uu____4576 =
                          let uu____4577 =
                            FStar_Syntax_Print.comp_to_string comp in
                          FStar_Util.format1
                            "Effect constructor is not fully applied; got %s"
                            uu____4577 in
                        (uu____4576, (comp.FStar_Syntax_Syntax.pos)) in
                      FStar_Errors.Error uu____4573 in
                    raise uu____4572)
             else
               (let ct1 = FStar_TypeChecker_Env.unfold_effect_abbrev env comp in
                match ct1.FStar_Syntax_Syntax.effect_args with
                | (wp,uu____4587)::uu____4588 ->
                    let uu____4602 =
                      let uu____4605 =
                        FStar_TypeChecker_Env.lookup_lid env
                          FStar_Syntax_Const.as_requires in
                      FStar_All.pipe_left FStar_Pervasives.fst uu____4605 in
                    (match uu____4602 with
                     | (us_r,uu____4622) ->
                         let uu____4623 =
                           let uu____4626 =
                             FStar_TypeChecker_Env.lookup_lid env
                               FStar_Syntax_Const.as_ensures in
                           FStar_All.pipe_left FStar_Pervasives.fst
                             uu____4626 in
                         (match uu____4623 with
                          | (us_e,uu____4643) ->
                              let r =
                                (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let as_req =
                                let uu____4646 =
>>>>>>> origin/master
                                  FStar_Syntax_Syntax.fvar
                                    (FStar_Ident.set_lid_range
                                       FStar_Syntax_Const.as_requires r)
                                    FStar_Syntax_Syntax.Delta_equational None in
<<<<<<< HEAD
                                FStar_Syntax_Syntax.mk_Tm_uinst uu____4629
                                  us_r in
                              let as_ens =
                                let uu____4631 =
=======
                                FStar_Syntax_Syntax.mk_Tm_uinst uu____4646
                                  us_r in
                              let as_ens =
                                let uu____4648 =
>>>>>>> origin/master
                                  FStar_Syntax_Syntax.fvar
                                    (FStar_Ident.set_lid_range
                                       FStar_Syntax_Const.as_ensures r)
                                    FStar_Syntax_Syntax.Delta_equational None in
<<<<<<< HEAD
                                FStar_Syntax_Syntax.mk_Tm_uinst uu____4631
                                  us_e in
                              let req =
                                let uu____4635 =
                                  let uu____4636 =
                                    let uu____4637 =
                                      let uu____4644 =
                                        FStar_Syntax_Syntax.as_arg wp in
                                      [uu____4644] in
                                    ((ct1.FStar_Syntax_Syntax.result_typ),
                                      (Some FStar_Syntax_Syntax.imp_tag)) ::
                                      uu____4637 in
                                  FStar_Syntax_Syntax.mk_Tm_app as_req
                                    uu____4636 in
                                uu____4635
=======
                                FStar_Syntax_Syntax.mk_Tm_uinst uu____4648
                                  us_e in
                              let req =
                                let uu____4652 =
                                  let uu____4653 =
                                    let uu____4654 =
                                      let uu____4661 =
                                        FStar_Syntax_Syntax.as_arg wp in
                                      [uu____4661] in
                                    ((ct1.FStar_Syntax_Syntax.result_typ),
                                      (Some FStar_Syntax_Syntax.imp_tag)) ::
                                      uu____4654 in
                                  FStar_Syntax_Syntax.mk_Tm_app as_req
                                    uu____4653 in
                                uu____4652
>>>>>>> origin/master
                                  (Some
                                     (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
                                  (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let ens =
<<<<<<< HEAD
                                let uu____4660 =
                                  let uu____4661 =
                                    let uu____4662 =
                                      let uu____4669 =
                                        FStar_Syntax_Syntax.as_arg wp in
                                      [uu____4669] in
                                    ((ct1.FStar_Syntax_Syntax.result_typ),
                                      (Some FStar_Syntax_Syntax.imp_tag)) ::
                                      uu____4662 in
                                  FStar_Syntax_Syntax.mk_Tm_app as_ens
                                    uu____4661 in
                                uu____4660 None
                                  (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let uu____4682 =
                                let uu____4684 = norm req in Some uu____4684 in
                              let uu____4685 =
                                let uu____4686 =
                                  mk_post_type
                                    ct1.FStar_Syntax_Syntax.result_typ ens in
                                norm uu____4686 in
                              (uu____4682, uu____4685)))
                | uu____4688 -> failwith "Impossible"))
=======
                                let uu____4677 =
                                  let uu____4678 =
                                    let uu____4679 =
                                      let uu____4686 =
                                        FStar_Syntax_Syntax.as_arg wp in
                                      [uu____4686] in
                                    ((ct1.FStar_Syntax_Syntax.result_typ),
                                      (Some FStar_Syntax_Syntax.imp_tag)) ::
                                      uu____4679 in
                                  FStar_Syntax_Syntax.mk_Tm_app as_ens
                                    uu____4678 in
                                uu____4677 None
                                  (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let uu____4699 =
                                let uu____4701 = norm req in Some uu____4701 in
                              let uu____4702 =
                                let uu____4703 =
                                  mk_post_type
                                    ct1.FStar_Syntax_Syntax.result_typ ens in
                                norm uu____4703 in
                              (uu____4699, uu____4702)))
                | uu____4705 -> failwith "Impossible"))
>>>>>>> origin/master
let reify_body:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun t  ->
      let tm = FStar_Syntax_Util.mk_reify t in
      let tm' =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Normalize.Beta;
          FStar_TypeChecker_Normalize.Reify;
          FStar_TypeChecker_Normalize.Eager_unfolding;
          FStar_TypeChecker_Normalize.EraseUniverses;
          FStar_TypeChecker_Normalize.AllowUnboundUniverses] env tm in
<<<<<<< HEAD
      (let uu____4708 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
           (FStar_Options.Other "SMTEncodingReify") in
       if uu____4708
       then
         let uu____4709 = FStar_Syntax_Print.term_to_string tm in
         let uu____4710 = FStar_Syntax_Print.term_to_string tm' in
         FStar_Util.print2 "Reified body %s \nto %s\n" uu____4709 uu____4710
=======
      (let uu____4725 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
           (FStar_Options.Other "SMTEncodingReify") in
       if uu____4725
       then
         let uu____4726 = FStar_Syntax_Print.term_to_string tm in
         let uu____4727 = FStar_Syntax_Print.term_to_string tm' in
         FStar_Util.print2 "Reified body %s \nto %s\n" uu____4726 uu____4727
>>>>>>> origin/master
       else ());
      tm'
let reify_body_with_arg:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.arg -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun head1  ->
      fun arg  ->
        let tm =
          FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (head1, [arg]))
            None head1.FStar_Syntax_Syntax.pos in
        let tm' =
          FStar_TypeChecker_Normalize.normalize
            [FStar_TypeChecker_Normalize.Beta;
            FStar_TypeChecker_Normalize.Reify;
            FStar_TypeChecker_Normalize.Eager_unfolding;
            FStar_TypeChecker_Normalize.EraseUniverses;
            FStar_TypeChecker_Normalize.AllowUnboundUniverses] env tm in
<<<<<<< HEAD
        (let uu____4731 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "SMTEncodingReify") in
         if uu____4731
         then
           let uu____4732 = FStar_Syntax_Print.term_to_string tm in
           let uu____4733 = FStar_Syntax_Print.term_to_string tm' in
           FStar_Util.print2 "Reified body %s \nto %s\n" uu____4732
             uu____4733
=======
        (let uu____4748 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "SMTEncodingReify") in
         if uu____4748
         then
           let uu____4749 = FStar_Syntax_Print.term_to_string tm in
           let uu____4750 = FStar_Syntax_Print.term_to_string tm' in
           FStar_Util.print2 "Reified body %s \nto %s\n" uu____4749
             uu____4750
>>>>>>> origin/master
         else ());
        tm'
let remove_reify: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun t  ->
<<<<<<< HEAD
    let uu____4738 =
      let uu____4739 =
        let uu____4740 = FStar_Syntax_Subst.compress t in
        uu____4740.FStar_Syntax_Syntax.n in
      match uu____4739 with
      | FStar_Syntax_Syntax.Tm_app uu____4743 -> false
      | uu____4753 -> true in
    if uu____4738
    then t
    else
      (let uu____4755 = FStar_Syntax_Util.head_and_args t in
       match uu____4755 with
       | (head1,args) ->
           let uu____4781 =
             let uu____4782 =
               let uu____4783 = FStar_Syntax_Subst.compress head1 in
               uu____4783.FStar_Syntax_Syntax.n in
             match uu____4782 with
             | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reify ) ->
                 true
             | uu____4786 -> false in
           if uu____4781
           then
             (match args with
              | x::[] -> fst x
              | uu____4802 ->
=======
    let uu____4755 =
      let uu____4756 =
        let uu____4757 = FStar_Syntax_Subst.compress t in
        uu____4757.FStar_Syntax_Syntax.n in
      match uu____4756 with
      | FStar_Syntax_Syntax.Tm_app uu____4760 -> false
      | uu____4770 -> true in
    if uu____4755
    then t
    else
      (let uu____4772 = FStar_Syntax_Util.head_and_args t in
       match uu____4772 with
       | (head1,args) ->
           let uu____4798 =
             let uu____4799 =
               let uu____4800 = FStar_Syntax_Subst.compress head1 in
               uu____4800.FStar_Syntax_Syntax.n in
             match uu____4799 with
             | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reify ) ->
                 true
             | uu____4803 -> false in
           if uu____4798
           then
             (match args with
              | x::[] -> fst x
              | uu____4819 ->
>>>>>>> origin/master
                  failwith
                    "Impossible : Reify applied to multiple arguments after normalization.")
           else t)
let maybe_instantiate:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.typ ->
        (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.typ*
          FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun e  ->
      fun t  ->
        let torig = FStar_Syntax_Subst.compress t in
        if Prims.op_Negation env.FStar_TypeChecker_Env.instantiate_imp
        then (e, torig, FStar_TypeChecker_Rel.trivial_guard)
        else
          (let number_of_implicits t1 =
<<<<<<< HEAD
             let uu____4830 = FStar_Syntax_Util.arrow_formals t1 in
             match uu____4830 with
             | (formals,uu____4839) ->
                 let n_implicits =
                   let uu____4851 =
                     FStar_All.pipe_right formals
                       (FStar_Util.prefix_until
                          (fun uu____4888  ->
                             match uu____4888 with
                             | (uu____4892,imp) ->
                                 (imp = None) ||
                                   (imp = (Some FStar_Syntax_Syntax.Equality)))) in
                   match uu____4851 with
=======
             let uu____4847 = FStar_Syntax_Util.arrow_formals t1 in
             match uu____4847 with
             | (formals,uu____4856) ->
                 let n_implicits =
                   let uu____4868 =
                     FStar_All.pipe_right formals
                       (FStar_Util.prefix_until
                          (fun uu____4905  ->
                             match uu____4905 with
                             | (uu____4909,imp) ->
                                 (imp = None) ||
                                   (imp = (Some FStar_Syntax_Syntax.Equality)))) in
                   match uu____4868 with
>>>>>>> origin/master
                   | None  -> FStar_List.length formals
                   | Some (implicits,_first_explicit,_rest) ->
                       FStar_List.length implicits in
                 n_implicits in
           let inst_n_binders t1 =
<<<<<<< HEAD
             let uu____4964 = FStar_TypeChecker_Env.expected_typ env in
             match uu____4964 with
=======
             let uu____4981 = FStar_TypeChecker_Env.expected_typ env in
             match uu____4981 with
>>>>>>> origin/master
             | None  -> None
             | Some expected_t ->
                 let n_expected = number_of_implicits expected_t in
                 let n_available = number_of_implicits t1 in
                 if n_available < n_expected
                 then
<<<<<<< HEAD
                   let uu____4978 =
                     let uu____4979 =
                       let uu____4982 =
                         let uu____4983 = FStar_Util.string_of_int n_expected in
                         let uu____4987 = FStar_Syntax_Print.term_to_string e in
                         let uu____4988 =
                           FStar_Util.string_of_int n_available in
                         FStar_Util.format3
                           "Expected a term with %s implicit arguments, but %s has only %s"
                           uu____4983 uu____4987 uu____4988 in
                       let uu____4992 = FStar_TypeChecker_Env.get_range env in
                       (uu____4982, uu____4992) in
                     FStar_Errors.Error uu____4979 in
                   raise uu____4978
                 else Some (n_available - n_expected) in
           let decr_inst uu___100_5005 =
             match uu___100_5005 with
=======
                   let uu____4995 =
                     let uu____4996 =
                       let uu____4999 =
                         let uu____5000 = FStar_Util.string_of_int n_expected in
                         let uu____5004 = FStar_Syntax_Print.term_to_string e in
                         let uu____5005 =
                           FStar_Util.string_of_int n_available in
                         FStar_Util.format3
                           "Expected a term with %s implicit arguments, but %s has only %s"
                           uu____5000 uu____5004 uu____5005 in
                       let uu____5009 = FStar_TypeChecker_Env.get_range env in
                       (uu____4999, uu____5009) in
                     FStar_Errors.Error uu____4996 in
                   raise uu____4995
                 else Some (n_available - n_expected) in
           let decr_inst uu___100_5022 =
             match uu___100_5022 with
>>>>>>> origin/master
             | None  -> None
             | Some i -> Some (i - (Prims.parse_int "1")) in
           match torig.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
<<<<<<< HEAD
               let uu____5024 = FStar_Syntax_Subst.open_comp bs c in
               (match uu____5024 with
                | (bs1,c1) ->
                    let rec aux subst1 inst_n bs2 =
                      match (inst_n, bs2) with
                      | (Some _0_30,uu____5085) when
                          _0_30 = (Prims.parse_int "0") ->
                          ([], bs2, subst1,
                            FStar_TypeChecker_Rel.trivial_guard)
                      | (uu____5107,(x,Some (FStar_Syntax_Syntax.Implicit
=======
               let uu____5041 = FStar_Syntax_Subst.open_comp bs c in
               (match uu____5041 with
                | (bs1,c1) ->
                    let rec aux subst1 inst_n bs2 =
                      match (inst_n, bs2) with
                      | (Some _0_30,uu____5102) when
                          _0_30 = (Prims.parse_int "0") ->
                          ([], bs2, subst1,
                            FStar_TypeChecker_Rel.trivial_guard)
                      | (uu____5124,(x,Some (FStar_Syntax_Syntax.Implicit
>>>>>>> origin/master
                                     dot))::rest)
                          ->
                          let t1 =
                            FStar_Syntax_Subst.subst subst1
                              x.FStar_Syntax_Syntax.sort in
<<<<<<< HEAD
                          let uu____5126 =
                            new_implicit_var
                              "Instantiation of implicit argument"
                              e.FStar_Syntax_Syntax.pos env t1 in
                          (match uu____5126 with
                           | (v1,uu____5147,g) ->
                               let subst2 = (FStar_Syntax_Syntax.NT (x, v1))
                                 :: subst1 in
                               let uu____5157 =
                                 aux subst2 (decr_inst inst_n) rest in
                               (match uu____5157 with
                                | (args,bs3,subst3,g') ->
                                    let uu____5206 =
=======
                          let uu____5143 =
                            new_implicit_var
                              "Instantiation of implicit argument"
                              e.FStar_Syntax_Syntax.pos env t1 in
                          (match uu____5143 with
                           | (v1,uu____5164,g) ->
                               let subst2 = (FStar_Syntax_Syntax.NT (x, v1))
                                 :: subst1 in
                               let uu____5174 =
                                 aux subst2 (decr_inst inst_n) rest in
                               (match uu____5174 with
                                | (args,bs3,subst3,g') ->
                                    let uu____5223 =
>>>>>>> origin/master
                                      FStar_TypeChecker_Rel.conj_guard g g' in
                                    (((v1,
                                        (Some
                                           (FStar_Syntax_Syntax.Implicit dot)))
<<<<<<< HEAD
                                      :: args), bs3, subst3, uu____5206)))
                      | (uu____5220,bs3) ->
                          ([], bs3, subst1,
                            FStar_TypeChecker_Rel.trivial_guard) in
                    let uu____5244 =
                      let uu____5258 = inst_n_binders t in
                      aux [] uu____5258 bs1 in
                    (match uu____5244 with
                     | (args,bs2,subst1,guard) ->
                         (match (args, bs2) with
                          | ([],uu____5296) -> (e, torig, guard)
                          | (uu____5312,[]) when
                              let uu____5328 =
                                FStar_Syntax_Util.is_total_comp c1 in
                              Prims.op_Negation uu____5328 ->
                              (e, torig, FStar_TypeChecker_Rel.trivial_guard)
                          | uu____5329 ->
                              let t1 =
                                match bs2 with
                                | [] -> FStar_Syntax_Util.comp_result c1
                                | uu____5348 ->
=======
                                      :: args), bs3, subst3, uu____5223)))
                      | (uu____5237,bs3) ->
                          ([], bs3, subst1,
                            FStar_TypeChecker_Rel.trivial_guard) in
                    let uu____5261 =
                      let uu____5275 = inst_n_binders t in
                      aux [] uu____5275 bs1 in
                    (match uu____5261 with
                     | (args,bs2,subst1,guard) ->
                         (match (args, bs2) with
                          | ([],uu____5313) -> (e, torig, guard)
                          | (uu____5329,[]) when
                              let uu____5345 =
                                FStar_Syntax_Util.is_total_comp c1 in
                              Prims.op_Negation uu____5345 ->
                              (e, torig, FStar_TypeChecker_Rel.trivial_guard)
                          | uu____5346 ->
                              let t1 =
                                match bs2 with
                                | [] -> FStar_Syntax_Util.comp_result c1
                                | uu____5365 ->
>>>>>>> origin/master
                                    FStar_Syntax_Util.arrow bs2 c1 in
                              let t2 = FStar_Syntax_Subst.subst subst1 t1 in
                              let e1 =
                                (FStar_Syntax_Syntax.mk_Tm_app e args)
                                  (Some (t2.FStar_Syntax_Syntax.n))
                                  e.FStar_Syntax_Syntax.pos in
                              (e1, t2, guard))))
<<<<<<< HEAD
           | uu____5363 -> (e, t, FStar_TypeChecker_Rel.trivial_guard))
let string_of_univs:
  FStar_Syntax_Syntax.universe_uvar FStar_Util.set -> Prims.string =
  fun univs1  ->
    let uu____5369 =
      let uu____5371 = FStar_Util.set_elements univs1 in
      FStar_All.pipe_right uu____5371
        (FStar_List.map
           (fun u  ->
              let uu____5376 = FStar_Syntax_Unionfind.univ_uvar_id u in
              FStar_All.pipe_right uu____5376 FStar_Util.string_of_int)) in
    FStar_All.pipe_right uu____5369 (FStar_String.concat ", ")
=======
           | uu____5380 -> (e, t, FStar_TypeChecker_Rel.trivial_guard))
let string_of_univs univs1 =
  let uu____5392 =
    let uu____5394 = FStar_Util.set_elements univs1 in
    FStar_All.pipe_right uu____5394
      (FStar_List.map
         (fun u  ->
            let uu____5404 = FStar_Unionfind.uvar_id u in
            FStar_All.pipe_right uu____5404 FStar_Util.string_of_int)) in
  FStar_All.pipe_right uu____5392 (FStar_String.concat ", ")
>>>>>>> origin/master
let gen_univs:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.universe_uvar FStar_Util.set ->
      FStar_Syntax_Syntax.univ_name Prims.list
  =
  fun env  ->
    fun x  ->
<<<<<<< HEAD
      let uu____5388 = FStar_Util.set_is_empty x in
      if uu____5388
      then []
      else
        (let s =
           let uu____5393 =
             let uu____5395 = FStar_TypeChecker_Env.univ_vars env in
             FStar_Util.set_difference x uu____5395 in
           FStar_All.pipe_right uu____5393 FStar_Util.set_elements in
         (let uu____5400 =
            FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
              (FStar_Options.Other "Gen") in
          if uu____5400
          then
            let uu____5401 =
              let uu____5402 = FStar_TypeChecker_Env.univ_vars env in
              string_of_univs uu____5402 in
            FStar_Util.print1 "univ_vars in env: %s\n" uu____5401
          else ());
         (let r =
            let uu____5407 = FStar_TypeChecker_Env.get_range env in
            Some uu____5407 in
=======
      let uu____5416 = FStar_Util.set_is_empty x in
      if uu____5416
      then []
      else
        (let s =
           let uu____5421 =
             let uu____5423 = FStar_TypeChecker_Env.univ_vars env in
             FStar_Util.set_difference x uu____5423 in
           FStar_All.pipe_right uu____5421 FStar_Util.set_elements in
         (let uu____5428 =
            FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
              (FStar_Options.Other "Gen") in
          if uu____5428
          then
            let uu____5429 =
              let uu____5430 = FStar_TypeChecker_Env.univ_vars env in
              string_of_univs uu____5430 in
            FStar_Util.print1 "univ_vars in env: %s\n" uu____5429
          else ());
         (let r =
            let uu____5438 = FStar_TypeChecker_Env.get_range env in
            Some uu____5438 in
>>>>>>> origin/master
          let u_names =
            FStar_All.pipe_right s
              (FStar_List.map
                 (fun u  ->
                    let u_name = FStar_Syntax_Syntax.new_univ_name r in
<<<<<<< HEAD
                    (let uu____5415 =
                       FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                         (FStar_Options.Other "Gen") in
                     if uu____5415
                     then
                       let uu____5416 =
                         let uu____5417 =
                           FStar_Syntax_Unionfind.univ_uvar_id u in
                         FStar_All.pipe_left FStar_Util.string_of_int
                           uu____5417 in
                       let uu____5418 =
                         FStar_Syntax_Print.univ_to_string
                           (FStar_Syntax_Syntax.U_unif u) in
                       let uu____5419 =
                         FStar_Syntax_Print.univ_to_string
                           (FStar_Syntax_Syntax.U_name u_name) in
                       FStar_Util.print3 "Setting ?%s (%s) to %s\n"
                         uu____5416 uu____5418 uu____5419
=======
                    (let uu____5450 =
                       FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                         (FStar_Options.Other "Gen") in
                     if uu____5450
                     then
                       let uu____5451 =
                         let uu____5452 = FStar_Unionfind.uvar_id u in
                         FStar_All.pipe_left FStar_Util.string_of_int
                           uu____5452 in
                       let uu____5454 =
                         FStar_Syntax_Print.univ_to_string
                           (FStar_Syntax_Syntax.U_unif u) in
                       let uu____5455 =
                         FStar_Syntax_Print.univ_to_string
                           (FStar_Syntax_Syntax.U_name u_name) in
                       FStar_Util.print3 "Setting ?%s (%s) to %s\n"
                         uu____5451 uu____5454 uu____5455
>>>>>>> origin/master
                     else ());
                    FStar_Syntax_Unionfind.univ_change u
                      (FStar_Syntax_Syntax.U_name u_name);
                    u_name)) in
          u_names))
let gather_free_univnames:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.univ_name Prims.list
  =
  fun env  ->
    fun t  ->
      let ctx_univnames = FStar_TypeChecker_Env.univnames env in
      let tm_univnames = FStar_Syntax_Free.univnames t in
      let univnames1 =
<<<<<<< HEAD
        let uu____5436 =
          FStar_Util.fifo_set_difference tm_univnames ctx_univnames in
        FStar_All.pipe_right uu____5436 FStar_Util.fifo_set_elements in
      univnames1
let maybe_set_tk ts uu___101_5463 =
  match uu___101_5463 with
=======
        let uu____5473 =
          FStar_Util.fifo_set_difference tm_univnames ctx_univnames in
        FStar_All.pipe_right uu____5473 FStar_Util.fifo_set_elements in
      univnames1
let maybe_set_tk ts uu___101_5500 =
  match uu___101_5500 with
>>>>>>> origin/master
  | None  -> ts
  | Some t ->
      let t1 = FStar_Syntax_Syntax.mk t None FStar_Range.dummyRange in
      let t2 = FStar_Syntax_Subst.close_univ_vars (fst ts) t1 in
      (FStar_ST.write (snd ts).FStar_Syntax_Syntax.tk
         (Some (t2.FStar_Syntax_Syntax.n));
       ts)
let check_universe_generalization:
  FStar_Syntax_Syntax.univ_name Prims.list ->
    FStar_Syntax_Syntax.univ_name Prims.list ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.univ_name Prims.list
  =
  fun explicit_univ_names  ->
    fun generalized_univ_names  ->
      fun t  ->
        match (explicit_univ_names, generalized_univ_names) with
<<<<<<< HEAD
        | ([],uu____5504) -> generalized_univ_names
        | (uu____5508,[]) -> explicit_univ_names
        | uu____5512 ->
            let uu____5517 =
              let uu____5518 =
                let uu____5521 =
                  let uu____5522 = FStar_Syntax_Print.term_to_string t in
                  Prims.strcat
                    "Generalized universe in a term containing explicit universe annotation : "
                    uu____5522 in
                (uu____5521, (t.FStar_Syntax_Syntax.pos)) in
              FStar_Errors.Error uu____5518 in
            raise uu____5517
=======
        | ([],uu____5541) -> generalized_univ_names
        | (uu____5545,[]) -> explicit_univ_names
        | uu____5549 ->
            let uu____5554 =
              let uu____5555 =
                let uu____5558 =
                  let uu____5559 = FStar_Syntax_Print.term_to_string t in
                  Prims.strcat
                    "Generalized universe in a term containing explicit universe annotation : "
                    uu____5559 in
                (uu____5558, (t.FStar_Syntax_Syntax.pos)) in
              FStar_Errors.Error uu____5555 in
            raise uu____5554
>>>>>>> origin/master
let generalize_universes:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.univ_names*
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax)
  =
  fun env  ->
    fun t0  ->
      let t =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Normalize.NoFullNorm;
          FStar_TypeChecker_Normalize.Beta] env t0 in
      let univnames1 = gather_free_univnames env t in
      let univs1 = FStar_Syntax_Free.univs t in
<<<<<<< HEAD
      (let uu____5536 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
           (FStar_Options.Other "Gen") in
       if uu____5536
       then
         let uu____5537 = string_of_univs univs1 in
         FStar_Util.print1 "univs to gen : %s\n" uu____5537
       else ());
      (let gen1 = gen_univs env univs1 in
       (let uu____5542 =
          FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
            (FStar_Options.Other "Gen") in
        if uu____5542
        then
          let uu____5543 = FStar_Syntax_Print.term_to_string t in
          FStar_Util.print1 "After generalization: %s\n" uu____5543
        else ());
       (let univs2 = check_universe_generalization univnames1 gen1 t0 in
        let t1 = FStar_TypeChecker_Normalize.reduce_uvar_solutions env t in
        let ts = FStar_Syntax_Subst.close_univ_vars univs2 t1 in
        let uu____5549 = FStar_ST.read t0.FStar_Syntax_Syntax.tk in
        maybe_set_tk (univs2, ts) uu____5549))
=======
      (let uu____5573 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
           (FStar_Options.Other "Gen") in
       if uu____5573
       then
         let uu____5574 = string_of_univs univs1 in
         FStar_Util.print1 "univs to gen : %s\n" uu____5574
       else ());
      (let gen1 = gen_univs env univs1 in
       (let uu____5580 =
          FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
            (FStar_Options.Other "Gen") in
        if uu____5580
        then
          let uu____5581 = FStar_Syntax_Print.term_to_string t in
          FStar_Util.print1 "After generalization: %s\n" uu____5581
        else ());
       (let univs2 = check_universe_generalization univnames1 gen1 t0 in
        let ts = FStar_Syntax_Subst.close_univ_vars univs2 t in
        let uu____5586 = FStar_ST.read t0.FStar_Syntax_Syntax.tk in
        maybe_set_tk (univs2, ts) uu____5586))
>>>>>>> origin/master
let gen:
  FStar_TypeChecker_Env.env ->
    (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.comp) Prims.list ->
      (FStar_Syntax_Syntax.univ_name Prims.list* FStar_Syntax_Syntax.term*
        FStar_Syntax_Syntax.comp) Prims.list option
  =
  fun env  ->
    fun ecs  ->
<<<<<<< HEAD
      let uu____5579 =
        let uu____5580 =
          FStar_Util.for_all
            (fun uu____5585  ->
               match uu____5585 with
               | (uu____5590,c) -> FStar_Syntax_Util.is_pure_or_ghost_comp c)
            ecs in
        FStar_All.pipe_left Prims.op_Negation uu____5580 in
      if uu____5579
      then None
      else
        (let norm c =
           (let uu____5613 =
              FStar_TypeChecker_Env.debug env FStar_Options.Medium in
            if uu____5613
            then
              let uu____5614 = FStar_Syntax_Print.comp_to_string c in
              FStar_Util.print1 "Normalizing before generalizing:\n\t %s\n"
                uu____5614
            else ());
           (let c1 =
              let uu____5617 = FStar_TypeChecker_Env.should_verify env in
              if uu____5617
=======
      let uu____5616 =
        let uu____5617 =
          FStar_Util.for_all
            (fun uu____5622  ->
               match uu____5622 with
               | (uu____5627,c) -> FStar_Syntax_Util.is_pure_or_ghost_comp c)
            ecs in
        FStar_All.pipe_left Prims.op_Negation uu____5617 in
      if uu____5616
      then None
      else
        (let norm c =
           (let uu____5650 =
              FStar_TypeChecker_Env.debug env FStar_Options.Medium in
            if uu____5650
            then
              let uu____5651 = FStar_Syntax_Print.comp_to_string c in
              FStar_Util.print1 "Normalizing before generalizing:\n\t %s\n"
                uu____5651
            else ());
           (let c1 =
              let uu____5654 = FStar_TypeChecker_Env.should_verify env in
              if uu____5654
>>>>>>> origin/master
              then
                FStar_TypeChecker_Normalize.normalize_comp
                  [FStar_TypeChecker_Normalize.Beta;
                  FStar_TypeChecker_Normalize.Eager_unfolding;
                  FStar_TypeChecker_Normalize.NoFullNorm] env c
              else
                FStar_TypeChecker_Normalize.normalize_comp
                  [FStar_TypeChecker_Normalize.Beta;
                  FStar_TypeChecker_Normalize.NoFullNorm] env c in
<<<<<<< HEAD
            (let uu____5620 =
               FStar_TypeChecker_Env.debug env FStar_Options.Medium in
             if uu____5620
             then
               let uu____5621 = FStar_Syntax_Print.comp_to_string c1 in
               FStar_Util.print1 "Normalized to:\n\t %s\n" uu____5621
=======
            (let uu____5657 =
               FStar_TypeChecker_Env.debug env FStar_Options.Medium in
             if uu____5657
             then
               let uu____5658 = FStar_Syntax_Print.comp_to_string c1 in
               FStar_Util.print1 "Normalized to:\n\t %s\n" uu____5658
>>>>>>> origin/master
             else ());
            c1) in
         let env_uvars = FStar_TypeChecker_Env.uvars_in_env env in
         let gen_uvars uvs =
<<<<<<< HEAD
           let uu____5661 = FStar_Util.set_difference uvs env_uvars in
           FStar_All.pipe_right uu____5661 FStar_Util.set_elements in
         let uu____5715 =
           let uu____5735 =
             FStar_All.pipe_right ecs
               (FStar_List.map
                  (fun uu____5796  ->
                     match uu____5796 with
=======
           let uu____5692 = FStar_Util.set_difference uvs env_uvars in
           FStar_All.pipe_right uu____5692 FStar_Util.set_elements in
         let uu____5736 =
           let uu____5754 =
             FStar_All.pipe_right ecs
               (FStar_List.map
                  (fun uu____5809  ->
                     match uu____5809 with
>>>>>>> origin/master
                     | (e,c) ->
                         let t =
                           FStar_All.pipe_right
                             (FStar_Syntax_Util.comp_result c)
                             FStar_Syntax_Subst.compress in
                         let c1 = norm c in
                         let t1 = FStar_Syntax_Util.comp_result c1 in
                         let univs1 = FStar_Syntax_Free.univs t1 in
                         let uvt = FStar_Syntax_Free.uvars t1 in
                         let uvs = gen_uvars uvt in (univs1, (uvs, e, c1)))) in
<<<<<<< HEAD
           FStar_All.pipe_right uu____5735 FStar_List.unzip in
         match uu____5715 with
=======
           FStar_All.pipe_right uu____5754 FStar_List.unzip in
         match uu____5736 with
>>>>>>> origin/master
         | (univs1,uvars1) ->
             let univs2 =
               let uu____5971 = FStar_Syntax_Free.new_universe_uvar_set () in
               FStar_List.fold_left FStar_Util.set_union uu____5971 univs1 in
             let gen_univs1 = gen_univs env univs2 in
<<<<<<< HEAD
             ((let uu____5978 =
                 FStar_TypeChecker_Env.debug env FStar_Options.Medium in
               if uu____5978
=======
             ((let uu____5971 =
                 FStar_TypeChecker_Env.debug env FStar_Options.Medium in
               if uu____5971
>>>>>>> origin/master
               then
                 FStar_All.pipe_right gen_univs1
                   (FStar_List.iter
                      (fun x  ->
                         FStar_Util.print1 "Generalizing uvar %s\n"
                           x.FStar_Ident.idText))
               else ());
              (let ecs1 =
                 FStar_All.pipe_right uvars1
                   (FStar_List.map
<<<<<<< HEAD
                      (fun uu____6018  ->
                         match uu____6018 with
=======
                      (fun uu____6013  ->
                         match uu____6013 with
>>>>>>> origin/master
                         | (uvs,e,c) ->
                             let tvars =
                               FStar_All.pipe_right uvs
                                 (FStar_List.map
<<<<<<< HEAD
                                    (fun uu____6055  ->
                                       match uu____6055 with
                                       | (u,k) ->
                                           let uu____6063 =
                                             FStar_Syntax_Unionfind.find u in
                                           (match uu____6063 with
                                            | Some
=======
                                    (fun uu____6070  ->
                                       match uu____6070 with
                                       | (u,k) ->
                                           let uu____6090 =
                                             FStar_Unionfind.find u in
                                           (match uu____6090 with
                                            | FStar_Syntax_Syntax.Fixed
>>>>>>> origin/master
                                                {
                                                  FStar_Syntax_Syntax.n =
                                                    FStar_Syntax_Syntax.Tm_name
                                                    a;
                                                  FStar_Syntax_Syntax.tk =
<<<<<<< HEAD
                                                    uu____6069;
                                                  FStar_Syntax_Syntax.pos =
                                                    uu____6070;
                                                  FStar_Syntax_Syntax.vars =
                                                    uu____6071;_}
=======
                                                    uu____6101;
                                                  FStar_Syntax_Syntax.pos =
                                                    uu____6102;
                                                  FStar_Syntax_Syntax.vars =
                                                    uu____6103;_}
>>>>>>> origin/master
                                                ->
                                                (a,
                                                  (Some
                                                     FStar_Syntax_Syntax.imp_tag))
                                            | Some
                                                {
                                                  FStar_Syntax_Syntax.n =
                                                    FStar_Syntax_Syntax.Tm_abs
<<<<<<< HEAD
                                                    (uu____6077,{
=======
                                                    (uu____6109,{
>>>>>>> origin/master
                                                                  FStar_Syntax_Syntax.n
                                                                    =
                                                                    FStar_Syntax_Syntax.Tm_name
                                                                    a;
                                                                  FStar_Syntax_Syntax.tk
                                                                    =
<<<<<<< HEAD
                                                                    uu____6079;
                                                                  FStar_Syntax_Syntax.pos
                                                                    =
                                                                    uu____6080;
                                                                  FStar_Syntax_Syntax.vars
                                                                    =
                                                                    uu____6081;_},uu____6082);
                                                  FStar_Syntax_Syntax.tk =
                                                    uu____6083;
                                                  FStar_Syntax_Syntax.pos =
                                                    uu____6084;
                                                  FStar_Syntax_Syntax.vars =
                                                    uu____6085;_}
=======
                                                                    uu____6111;
                                                                  FStar_Syntax_Syntax.pos
                                                                    =
                                                                    uu____6112;
                                                                  FStar_Syntax_Syntax.vars
                                                                    =
                                                                    uu____6113;_},uu____6114);
                                                  FStar_Syntax_Syntax.tk =
                                                    uu____6115;
                                                  FStar_Syntax_Syntax.pos =
                                                    uu____6116;
                                                  FStar_Syntax_Syntax.vars =
                                                    uu____6117;_}
>>>>>>> origin/master
                                                ->
                                                (a,
                                                  (Some
                                                     FStar_Syntax_Syntax.imp_tag))
<<<<<<< HEAD
                                            | Some uu____6113 ->
                                                failwith
                                                  "Unexpected instantiation of mutually recursive uvar"
                                            | uu____6117 ->
=======
                                            | FStar_Syntax_Syntax.Fixed
                                                uu____6145 ->
                                                failwith
                                                  "Unexpected instantiation of mutually recursive uvar"
                                            | uu____6153 ->
>>>>>>> origin/master
                                                let k1 =
                                                  FStar_TypeChecker_Normalize.normalize
                                                    [FStar_TypeChecker_Normalize.Beta]
                                                    env k in
<<<<<<< HEAD
                                                let uu____6120 =
                                                  FStar_Syntax_Util.arrow_formals
                                                    k1 in
                                                (match uu____6120 with
                                                 | (bs,kres) ->
                                                     let a =
                                                       let uu____6144 =
                                                         let uu____6146 =
=======
                                                let uu____6158 =
                                                  FStar_Syntax_Util.arrow_formals
                                                    k1 in
                                                (match uu____6158 with
                                                 | (bs,kres) ->
                                                     let a =
                                                       let uu____6182 =
                                                         let uu____6184 =
>>>>>>> origin/master
                                                           FStar_TypeChecker_Env.get_range
                                                             env in
                                                         FStar_All.pipe_left
                                                           (fun _0_31  ->
                                                              Some _0_31)
<<<<<<< HEAD
                                                           uu____6146 in
                                                       FStar_Syntax_Syntax.new_bv
                                                         uu____6144 kres in
                                                     let t =
                                                       let uu____6149 =
                                                         FStar_Syntax_Syntax.bv_to_name
                                                           a in
                                                       let uu____6150 =
                                                         let uu____6157 =
                                                           let uu____6163 =
                                                             let uu____6164 =
                                                               FStar_Syntax_Syntax.mk_Total
                                                                 kres in
                                                             FStar_Syntax_Util.lcomp_of_comp
                                                               uu____6164 in
                                                           FStar_Util.Inl
                                                             uu____6163 in
                                                         Some uu____6157 in
                                                       FStar_Syntax_Util.abs
                                                         bs uu____6149
                                                         uu____6150 in
=======
                                                           uu____6184 in
                                                       FStar_Syntax_Syntax.new_bv
                                                         uu____6182 kres in
                                                     let t =
                                                       let uu____6187 =
                                                         FStar_Syntax_Syntax.bv_to_name
                                                           a in
                                                       let uu____6188 =
                                                         let uu____6195 =
                                                           let uu____6201 =
                                                             let uu____6202 =
                                                               FStar_Syntax_Syntax.mk_Total
                                                                 kres in
                                                             FStar_Syntax_Util.lcomp_of_comp
                                                               uu____6202 in
                                                           FStar_Util.Inl
                                                             uu____6201 in
                                                         Some uu____6195 in
                                                       FStar_Syntax_Util.abs
                                                         bs uu____6187
                                                         uu____6188 in
>>>>>>> origin/master
                                                     (FStar_Syntax_Util.set_uvar
                                                        u t;
                                                      (a,
                                                        (Some
                                                           FStar_Syntax_Syntax.imp_tag))))))) in
<<<<<<< HEAD
                             let uu____6177 =
                               match (tvars, gen_univs1) with
                               | ([],[]) ->
=======
                             let uu____6217 =
                               match (tvars, gen_univs1) with
                               | ([],[]) ->
                                   let uu____6235 =
                                     FStar_TypeChecker_Normalize.reduce_uvar_solutions
                                       env e in
                                   (uu____6235, c)
                               | ([],uu____6236) ->
>>>>>>> origin/master
                                   let c1 =
                                     FStar_TypeChecker_Normalize.normalize_comp
                                       [FStar_TypeChecker_Normalize.Beta;
                                       FStar_TypeChecker_Normalize.NoDeltaSteps;
                                       FStar_TypeChecker_Normalize.NoFullNorm;
                                       FStar_TypeChecker_Normalize.CompressUvars]
                                       env c in
                                   let e1 =
                                     FStar_TypeChecker_Normalize.reduce_uvar_solutions
                                       env e in
                                   (e1, c1)
<<<<<<< HEAD
                               | uu____6197 ->
                                   let uu____6205 = (e, c) in
                                   (match uu____6205 with
=======
                               | uu____6248 ->
                                   let uu____6256 = (e, c) in
                                   (match uu____6256 with
>>>>>>> origin/master
                                    | (e0,c0) ->
                                        let c1 =
                                          FStar_TypeChecker_Normalize.normalize_comp
                                            [FStar_TypeChecker_Normalize.Beta;
                                            FStar_TypeChecker_Normalize.NoDeltaSteps;
                                            FStar_TypeChecker_Normalize.CompressUvars;
                                            FStar_TypeChecker_Normalize.NoFullNorm]
                                            env c in
                                        let e1 =
                                          FStar_TypeChecker_Normalize.reduce_uvar_solutions
                                            env e in
                                        let t =
<<<<<<< HEAD
                                          let uu____6217 =
                                            let uu____6218 =
                                              FStar_Syntax_Subst.compress
                                                (FStar_Syntax_Util.comp_result
                                                   c1) in
                                            uu____6218.FStar_Syntax_Syntax.n in
                                          match uu____6217 with
                                          | FStar_Syntax_Syntax.Tm_arrow
                                              (bs,cod) ->
                                              let uu____6235 =
                                                FStar_Syntax_Subst.open_comp
                                                  bs cod in
                                              (match uu____6235 with
=======
                                          let uu____6268 =
                                            let uu____6269 =
                                              FStar_Syntax_Subst.compress
                                                (FStar_Syntax_Util.comp_result
                                                   c1) in
                                            uu____6269.FStar_Syntax_Syntax.n in
                                          match uu____6268 with
                                          | FStar_Syntax_Syntax.Tm_arrow
                                              (bs,cod) ->
                                              let uu____6286 =
                                                FStar_Syntax_Subst.open_comp
                                                  bs cod in
                                              (match uu____6286 with
>>>>>>> origin/master
                                               | (bs1,cod1) ->
                                                   FStar_Syntax_Util.arrow
                                                     (FStar_List.append tvars
                                                        bs1) cod1)
<<<<<<< HEAD
                                          | uu____6245 ->
=======
                                          | uu____6296 ->
>>>>>>> origin/master
                                              FStar_Syntax_Util.arrow tvars
                                                c1 in
                                        let e' =
                                          FStar_Syntax_Util.abs tvars e1
                                            (Some
                                               (FStar_Util.Inl
                                                  (FStar_Syntax_Util.lcomp_of_comp
                                                     c1))) in
<<<<<<< HEAD
                                        let uu____6255 =
                                          FStar_Syntax_Syntax.mk_Total t in
                                        (e', uu____6255)) in
                             (match uu____6177 with
=======
                                        let uu____6306 =
                                          FStar_Syntax_Syntax.mk_Total t in
                                        (e', uu____6306)) in
                             (match uu____6217 with
>>>>>>> origin/master
                              | (e1,c1) -> (gen_univs1, e1, c1)))) in
               Some ecs1)))
let generalize:
  FStar_TypeChecker_Env.env ->
    (FStar_Syntax_Syntax.lbname* FStar_Syntax_Syntax.term*
      FStar_Syntax_Syntax.comp) Prims.list ->
      (FStar_Syntax_Syntax.lbname* FStar_Syntax_Syntax.univ_name Prims.list*
        FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.comp) Prims.list
  =
  fun env  ->
    fun lecs  ->
<<<<<<< HEAD
      (let uu____6293 = FStar_TypeChecker_Env.debug env FStar_Options.Low in
       if uu____6293
       then
         let uu____6294 =
           let uu____6295 =
             FStar_List.map
               (fun uu____6300  ->
                  match uu____6300 with
                  | (lb,uu____6305,uu____6306) ->
                      FStar_Syntax_Print.lbname_to_string lb) lecs in
           FStar_All.pipe_right uu____6295 (FStar_String.concat ", ") in
         FStar_Util.print1 "Generalizing: %s\n" uu____6294
       else ());
      (let univnames_lecs =
         FStar_List.map
           (fun uu____6316  ->
              match uu____6316 with | (l,t,c) -> gather_free_univnames env t)
           lecs in
       let generalized_lecs =
         let uu____6331 =
           let uu____6338 =
             FStar_All.pipe_right lecs
               (FStar_List.map
                  (fun uu____6354  ->
                     match uu____6354 with | (uu____6360,e,c) -> (e, c))) in
           gen env uu____6338 in
         match uu____6331 with
         | None  ->
             FStar_All.pipe_right lecs
               (FStar_List.map
                  (fun uu____6392  ->
                     match uu____6392 with | (l,t,c) -> (l, [], t, c)))
         | Some ecs ->
             FStar_List.map2
               (fun uu____6436  ->
                  fun uu____6437  ->
                    match (uu____6436, uu____6437) with
                    | ((l,uu____6470,uu____6471),(us,e,c)) ->
                        ((let uu____6497 =
                            FStar_TypeChecker_Env.debug env
                              FStar_Options.Medium in
                          if uu____6497
                          then
                            let uu____6498 =
                              FStar_Range.string_of_range
                                e.FStar_Syntax_Syntax.pos in
                            let uu____6499 =
                              FStar_Syntax_Print.lbname_to_string l in
                            let uu____6500 =
                              FStar_Syntax_Print.term_to_string
                                (FStar_Syntax_Util.comp_result c) in
                            let uu____6501 =
                              FStar_Syntax_Print.term_to_string e in
                            FStar_Util.print4
                              "(%s) Generalized %s at type %s\n%s\n"
                              uu____6498 uu____6499 uu____6500 uu____6501
=======
      (let uu____6344 = FStar_TypeChecker_Env.debug env FStar_Options.Low in
       if uu____6344
       then
         let uu____6345 =
           let uu____6346 =
             FStar_List.map
               (fun uu____6351  ->
                  match uu____6351 with
                  | (lb,uu____6356,uu____6357) ->
                      FStar_Syntax_Print.lbname_to_string lb) lecs in
           FStar_All.pipe_right uu____6346 (FStar_String.concat ", ") in
         FStar_Util.print1 "Generalizing: %s\n" uu____6345
       else ());
      (let univnames_lecs =
         FStar_List.map
           (fun uu____6367  ->
              match uu____6367 with | (l,t,c) -> gather_free_univnames env t)
           lecs in
       let generalized_lecs =
         let uu____6382 =
           let uu____6389 =
             FStar_All.pipe_right lecs
               (FStar_List.map
                  (fun uu____6405  ->
                     match uu____6405 with | (uu____6411,e,c) -> (e, c))) in
           gen env uu____6389 in
         match uu____6382 with
         | None  ->
             FStar_All.pipe_right lecs
               (FStar_List.map
                  (fun uu____6443  ->
                     match uu____6443 with | (l,t,c) -> (l, [], t, c)))
         | Some ecs ->
             FStar_List.map2
               (fun uu____6487  ->
                  fun uu____6488  ->
                    match (uu____6487, uu____6488) with
                    | ((l,uu____6521,uu____6522),(us,e,c)) ->
                        ((let uu____6548 =
                            FStar_TypeChecker_Env.debug env
                              FStar_Options.Medium in
                          if uu____6548
                          then
                            let uu____6549 =
                              FStar_Range.string_of_range
                                e.FStar_Syntax_Syntax.pos in
                            let uu____6550 =
                              FStar_Syntax_Print.lbname_to_string l in
                            let uu____6551 =
                              FStar_Syntax_Print.term_to_string
                                (FStar_Syntax_Util.comp_result c) in
                            let uu____6552 =
                              FStar_Syntax_Print.term_to_string e in
                            FStar_Util.print4
                              "(%s) Generalized %s at type %s\n%s\n"
                              uu____6549 uu____6550 uu____6551 uu____6552
>>>>>>> origin/master
                          else ());
                         (l, us, e, c))) lecs ecs in
       FStar_List.map2
         (fun univnames1  ->
<<<<<<< HEAD
            fun uu____6520  ->
              match uu____6520 with
              | (l,generalized_univs,t,c) ->
                  let uu____6538 =
                    check_universe_generalization univnames1
                      generalized_univs t in
                  (l, uu____6538, t, c)) univnames_lecs generalized_lecs)
=======
            fun uu____6571  ->
              match uu____6571 with
              | (l,generalized_univs,t,c) ->
                  let uu____6589 =
                    check_universe_generalization univnames1
                      generalized_univs t in
                  (l, uu____6589, t, c)) univnames_lecs generalized_lecs)
>>>>>>> origin/master
let check_and_ascribe:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.typ ->
        FStar_Syntax_Syntax.typ ->
          (FStar_Syntax_Syntax.term* FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun e  ->
      fun t1  ->
        fun t2  ->
          let env1 =
            FStar_TypeChecker_Env.set_range env e.FStar_Syntax_Syntax.pos in
          let check env2 t11 t21 =
            if env2.FStar_TypeChecker_Env.use_eq
            then FStar_TypeChecker_Rel.try_teq true env2 t11 t21
            else
<<<<<<< HEAD
              (let uu____6571 =
                 FStar_TypeChecker_Rel.try_subtype env2 t11 t21 in
               match uu____6571 with
               | None  -> None
               | Some f ->
                   let uu____6575 = FStar_TypeChecker_Rel.apply_guard f e in
                   FStar_All.pipe_left (fun _0_32  -> Some _0_32) uu____6575) in
          let is_var e1 =
            let uu____6581 =
              let uu____6582 = FStar_Syntax_Subst.compress e1 in
              uu____6582.FStar_Syntax_Syntax.n in
            match uu____6581 with
            | FStar_Syntax_Syntax.Tm_name uu____6585 -> true
            | uu____6586 -> false in
=======
              (let uu____6622 =
                 FStar_TypeChecker_Rel.try_subtype env2 t11 t21 in
               match uu____6622 with
               | None  -> None
               | Some f ->
                   let uu____6626 = FStar_TypeChecker_Rel.apply_guard f e in
                   FStar_All.pipe_left (fun _0_32  -> Some _0_32) uu____6626) in
          let is_var e1 =
            let uu____6632 =
              let uu____6633 = FStar_Syntax_Subst.compress e1 in
              uu____6633.FStar_Syntax_Syntax.n in
            match uu____6632 with
            | FStar_Syntax_Syntax.Tm_name uu____6636 -> true
            | uu____6637 -> false in
>>>>>>> origin/master
          let decorate e1 t =
            let e2 = FStar_Syntax_Subst.compress e1 in
            match e2.FStar_Syntax_Syntax.n with
            | FStar_Syntax_Syntax.Tm_name x ->
                FStar_Syntax_Syntax.mk
                  (FStar_Syntax_Syntax.Tm_name
<<<<<<< HEAD
                     (let uu___144_6604 = x in
                      {
                        FStar_Syntax_Syntax.ppname =
                          (uu___144_6604.FStar_Syntax_Syntax.ppname);
                        FStar_Syntax_Syntax.index =
                          (uu___144_6604.FStar_Syntax_Syntax.index);
                        FStar_Syntax_Syntax.sort = t2
                      })) (Some (t2.FStar_Syntax_Syntax.n))
                  e2.FStar_Syntax_Syntax.pos
            | uu____6605 ->
                let uu___145_6606 = e2 in
                let uu____6607 =
                  FStar_Util.mk_ref (Some (t2.FStar_Syntax_Syntax.n)) in
                {
                  FStar_Syntax_Syntax.n =
                    (uu___145_6606.FStar_Syntax_Syntax.n);
                  FStar_Syntax_Syntax.tk = uu____6607;
                  FStar_Syntax_Syntax.pos =
                    (uu___145_6606.FStar_Syntax_Syntax.pos);
                  FStar_Syntax_Syntax.vars =
                    (uu___145_6606.FStar_Syntax_Syntax.vars)
                } in
          let env2 =
            let uu___146_6616 = env1 in
            let uu____6617 =
=======
                     (let uu___144_6655 = x in
                      {
                        FStar_Syntax_Syntax.ppname =
                          (uu___144_6655.FStar_Syntax_Syntax.ppname);
                        FStar_Syntax_Syntax.index =
                          (uu___144_6655.FStar_Syntax_Syntax.index);
                        FStar_Syntax_Syntax.sort = t2
                      })) (Some (t2.FStar_Syntax_Syntax.n))
                  e2.FStar_Syntax_Syntax.pos
            | uu____6656 ->
                let uu___145_6657 = e2 in
                let uu____6658 =
                  FStar_Util.mk_ref (Some (t2.FStar_Syntax_Syntax.n)) in
                {
                  FStar_Syntax_Syntax.n =
                    (uu___145_6657.FStar_Syntax_Syntax.n);
                  FStar_Syntax_Syntax.tk = uu____6658;
                  FStar_Syntax_Syntax.pos =
                    (uu___145_6657.FStar_Syntax_Syntax.pos);
                  FStar_Syntax_Syntax.vars =
                    (uu___145_6657.FStar_Syntax_Syntax.vars)
                } in
          let env2 =
            let uu___146_6667 = env1 in
            let uu____6668 =
>>>>>>> origin/master
              env1.FStar_TypeChecker_Env.use_eq ||
                (env1.FStar_TypeChecker_Env.is_pattern && (is_var e)) in
            {
              FStar_TypeChecker_Env.solver =
<<<<<<< HEAD
                (uu___146_6616.FStar_TypeChecker_Env.solver);
              FStar_TypeChecker_Env.range =
                (uu___146_6616.FStar_TypeChecker_Env.range);
              FStar_TypeChecker_Env.curmodule =
                (uu___146_6616.FStar_TypeChecker_Env.curmodule);
              FStar_TypeChecker_Env.gamma =
                (uu___146_6616.FStar_TypeChecker_Env.gamma);
              FStar_TypeChecker_Env.gamma_cache =
                (uu___146_6616.FStar_TypeChecker_Env.gamma_cache);
              FStar_TypeChecker_Env.modules =
                (uu___146_6616.FStar_TypeChecker_Env.modules);
              FStar_TypeChecker_Env.expected_typ =
                (uu___146_6616.FStar_TypeChecker_Env.expected_typ);
              FStar_TypeChecker_Env.sigtab =
                (uu___146_6616.FStar_TypeChecker_Env.sigtab);
              FStar_TypeChecker_Env.is_pattern =
                (uu___146_6616.FStar_TypeChecker_Env.is_pattern);
              FStar_TypeChecker_Env.instantiate_imp =
                (uu___146_6616.FStar_TypeChecker_Env.instantiate_imp);
              FStar_TypeChecker_Env.effects =
                (uu___146_6616.FStar_TypeChecker_Env.effects);
              FStar_TypeChecker_Env.generalize =
                (uu___146_6616.FStar_TypeChecker_Env.generalize);
              FStar_TypeChecker_Env.letrecs =
                (uu___146_6616.FStar_TypeChecker_Env.letrecs);
              FStar_TypeChecker_Env.top_level =
                (uu___146_6616.FStar_TypeChecker_Env.top_level);
              FStar_TypeChecker_Env.check_uvars =
                (uu___146_6616.FStar_TypeChecker_Env.check_uvars);
              FStar_TypeChecker_Env.use_eq = uu____6617;
              FStar_TypeChecker_Env.is_iface =
                (uu___146_6616.FStar_TypeChecker_Env.is_iface);
              FStar_TypeChecker_Env.admit =
                (uu___146_6616.FStar_TypeChecker_Env.admit);
              FStar_TypeChecker_Env.lax =
                (uu___146_6616.FStar_TypeChecker_Env.lax);
              FStar_TypeChecker_Env.lax_universes =
                (uu___146_6616.FStar_TypeChecker_Env.lax_universes);
              FStar_TypeChecker_Env.type_of =
                (uu___146_6616.FStar_TypeChecker_Env.type_of);
              FStar_TypeChecker_Env.universe_of =
                (uu___146_6616.FStar_TypeChecker_Env.universe_of);
              FStar_TypeChecker_Env.use_bv_sorts =
                (uu___146_6616.FStar_TypeChecker_Env.use_bv_sorts);
              FStar_TypeChecker_Env.qname_and_index =
                (uu___146_6616.FStar_TypeChecker_Env.qname_and_index)
            } in
          let uu____6618 = check env2 t1 t2 in
          match uu____6618 with
          | None  ->
              let uu____6622 =
                let uu____6623 =
                  let uu____6626 =
                    FStar_TypeChecker_Err.expected_expression_of_type env2 t2
                      e t1 in
                  let uu____6627 = FStar_TypeChecker_Env.get_range env2 in
                  (uu____6626, uu____6627) in
                FStar_Errors.Error uu____6623 in
              raise uu____6622
          | Some g ->
              ((let uu____6632 =
                  FStar_All.pipe_left (FStar_TypeChecker_Env.debug env2)
                    (FStar_Options.Other "Rel") in
                if uu____6632
                then
                  let uu____6633 =
                    FStar_TypeChecker_Rel.guard_to_string env2 g in
                  FStar_All.pipe_left
                    (FStar_Util.print1 "Applied guard is %s\n") uu____6633
                else ());
               (let uu____6635 = decorate e t2 in (uu____6635, g)))
=======
                (uu___146_6667.FStar_TypeChecker_Env.solver);
              FStar_TypeChecker_Env.range =
                (uu___146_6667.FStar_TypeChecker_Env.range);
              FStar_TypeChecker_Env.curmodule =
                (uu___146_6667.FStar_TypeChecker_Env.curmodule);
              FStar_TypeChecker_Env.gamma =
                (uu___146_6667.FStar_TypeChecker_Env.gamma);
              FStar_TypeChecker_Env.gamma_cache =
                (uu___146_6667.FStar_TypeChecker_Env.gamma_cache);
              FStar_TypeChecker_Env.modules =
                (uu___146_6667.FStar_TypeChecker_Env.modules);
              FStar_TypeChecker_Env.expected_typ =
                (uu___146_6667.FStar_TypeChecker_Env.expected_typ);
              FStar_TypeChecker_Env.sigtab =
                (uu___146_6667.FStar_TypeChecker_Env.sigtab);
              FStar_TypeChecker_Env.is_pattern =
                (uu___146_6667.FStar_TypeChecker_Env.is_pattern);
              FStar_TypeChecker_Env.instantiate_imp =
                (uu___146_6667.FStar_TypeChecker_Env.instantiate_imp);
              FStar_TypeChecker_Env.effects =
                (uu___146_6667.FStar_TypeChecker_Env.effects);
              FStar_TypeChecker_Env.generalize =
                (uu___146_6667.FStar_TypeChecker_Env.generalize);
              FStar_TypeChecker_Env.letrecs =
                (uu___146_6667.FStar_TypeChecker_Env.letrecs);
              FStar_TypeChecker_Env.top_level =
                (uu___146_6667.FStar_TypeChecker_Env.top_level);
              FStar_TypeChecker_Env.check_uvars =
                (uu___146_6667.FStar_TypeChecker_Env.check_uvars);
              FStar_TypeChecker_Env.use_eq = uu____6668;
              FStar_TypeChecker_Env.is_iface =
                (uu___146_6667.FStar_TypeChecker_Env.is_iface);
              FStar_TypeChecker_Env.admit =
                (uu___146_6667.FStar_TypeChecker_Env.admit);
              FStar_TypeChecker_Env.lax =
                (uu___146_6667.FStar_TypeChecker_Env.lax);
              FStar_TypeChecker_Env.lax_universes =
                (uu___146_6667.FStar_TypeChecker_Env.lax_universes);
              FStar_TypeChecker_Env.type_of =
                (uu___146_6667.FStar_TypeChecker_Env.type_of);
              FStar_TypeChecker_Env.universe_of =
                (uu___146_6667.FStar_TypeChecker_Env.universe_of);
              FStar_TypeChecker_Env.use_bv_sorts =
                (uu___146_6667.FStar_TypeChecker_Env.use_bv_sorts);
              FStar_TypeChecker_Env.qname_and_index =
                (uu___146_6667.FStar_TypeChecker_Env.qname_and_index)
            } in
          let uu____6669 = check env2 t1 t2 in
          match uu____6669 with
          | None  ->
              let uu____6673 =
                let uu____6674 =
                  let uu____6677 =
                    FStar_TypeChecker_Err.expected_expression_of_type env2 t2
                      e t1 in
                  let uu____6678 = FStar_TypeChecker_Env.get_range env2 in
                  (uu____6677, uu____6678) in
                FStar_Errors.Error uu____6674 in
              raise uu____6673
          | Some g ->
              ((let uu____6683 =
                  FStar_All.pipe_left (FStar_TypeChecker_Env.debug env2)
                    (FStar_Options.Other "Rel") in
                if uu____6683
                then
                  let uu____6684 =
                    FStar_TypeChecker_Rel.guard_to_string env2 g in
                  FStar_All.pipe_left
                    (FStar_Util.print1 "Applied guard is %s\n") uu____6684
                else ());
               (let uu____6686 = decorate e t2 in (uu____6686, g)))
>>>>>>> origin/master
let check_top_level:
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Env.guard_t ->
      FStar_Syntax_Syntax.lcomp -> (Prims.bool* FStar_Syntax_Syntax.comp)
  =
  fun env  ->
    fun g  ->
      fun lc  ->
        let discharge g1 =
          FStar_TypeChecker_Rel.force_trivial_guard env g1;
          FStar_Syntax_Util.is_pure_lcomp lc in
        let g1 = FStar_TypeChecker_Rel.solve_deferred_constraints env g in
<<<<<<< HEAD
        let uu____6659 = FStar_Syntax_Util.is_total_lcomp lc in
        if uu____6659
        then
          let uu____6662 = discharge g1 in
          let uu____6663 = lc.FStar_Syntax_Syntax.comp () in
          (uu____6662, uu____6663)
=======
        let uu____6710 = FStar_Syntax_Util.is_total_lcomp lc in
        if uu____6710
        then
          let uu____6713 = discharge g1 in
          let uu____6714 = lc.FStar_Syntax_Syntax.comp () in
          (uu____6713, uu____6714)
>>>>>>> origin/master
        else
          (let c = lc.FStar_Syntax_Syntax.comp () in
           let steps = [FStar_TypeChecker_Normalize.Beta] in
           let c1 =
<<<<<<< HEAD
             let uu____6675 =
               let uu____6676 =
                 let uu____6677 =
                   FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                 FStar_All.pipe_right uu____6677 FStar_Syntax_Syntax.mk_Comp in
               FStar_All.pipe_right uu____6676
                 (FStar_TypeChecker_Normalize.normalize_comp steps env) in
             FStar_All.pipe_right uu____6675
=======
             let uu____6726 =
               let uu____6727 =
                 let uu____6728 =
                   FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                 FStar_All.pipe_right uu____6728 FStar_Syntax_Syntax.mk_Comp in
               FStar_All.pipe_right uu____6727
                 (FStar_TypeChecker_Normalize.normalize_comp steps env) in
             FStar_All.pipe_right uu____6726
>>>>>>> origin/master
               (FStar_TypeChecker_Env.comp_to_comp_typ env) in
           let md =
             FStar_TypeChecker_Env.get_effect_decl env
               c1.FStar_Syntax_Syntax.effect_name in
<<<<<<< HEAD
           let uu____6679 = destruct_comp c1 in
           match uu____6679 with
           | (u_t,t,wp) ->
               let vc =
                 let uu____6691 = FStar_TypeChecker_Env.get_range env in
                 let uu____6692 =
                   let uu____6693 =
                     FStar_TypeChecker_Env.inst_effect_fun_with [u_t] env md
                       md.FStar_Syntax_Syntax.trivial in
                   let uu____6694 =
                     let uu____6695 = FStar_Syntax_Syntax.as_arg t in
                     let uu____6696 =
                       let uu____6698 = FStar_Syntax_Syntax.as_arg wp in
                       [uu____6698] in
                     uu____6695 :: uu____6696 in
                   FStar_Syntax_Syntax.mk_Tm_app uu____6693 uu____6694 in
                 uu____6692
                   (Some (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
                   uu____6691 in
               ((let uu____6704 =
                   FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                     (FStar_Options.Other "Simplification") in
                 if uu____6704
                 then
                   let uu____6705 = FStar_Syntax_Print.term_to_string vc in
                   FStar_Util.print1 "top-level VC: %s\n" uu____6705
                 else ());
                (let g2 =
                   let uu____6708 =
                     FStar_All.pipe_left
                       FStar_TypeChecker_Rel.guard_of_guard_formula
                       (FStar_TypeChecker_Common.NonTrivial vc) in
                   FStar_TypeChecker_Rel.conj_guard g1 uu____6708 in
                 let uu____6709 = discharge g2 in
                 let uu____6710 = FStar_Syntax_Syntax.mk_Comp c1 in
                 (uu____6709, uu____6710))))
=======
           let uu____6730 = destruct_comp c1 in
           match uu____6730 with
           | (u_t,t,wp) ->
               let vc =
                 let uu____6742 = FStar_TypeChecker_Env.get_range env in
                 let uu____6743 =
                   let uu____6744 =
                     FStar_TypeChecker_Env.inst_effect_fun_with [u_t] env md
                       md.FStar_Syntax_Syntax.trivial in
                   let uu____6745 =
                     let uu____6746 = FStar_Syntax_Syntax.as_arg t in
                     let uu____6747 =
                       let uu____6749 = FStar_Syntax_Syntax.as_arg wp in
                       [uu____6749] in
                     uu____6746 :: uu____6747 in
                   FStar_Syntax_Syntax.mk_Tm_app uu____6744 uu____6745 in
                 uu____6743
                   (Some (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
                   uu____6742 in
               ((let uu____6755 =
                   FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                     (FStar_Options.Other "Simplification") in
                 if uu____6755
                 then
                   let uu____6756 = FStar_Syntax_Print.term_to_string vc in
                   FStar_Util.print1 "top-level VC: %s\n" uu____6756
                 else ());
                (let g2 =
                   let uu____6759 =
                     FStar_All.pipe_left
                       FStar_TypeChecker_Rel.guard_of_guard_formula
                       (FStar_TypeChecker_Common.NonTrivial vc) in
                   FStar_TypeChecker_Rel.conj_guard g1 uu____6759 in
                 let uu____6760 = discharge g2 in
                 let uu____6761 = FStar_Syntax_Syntax.mk_Comp c1 in
                 (uu____6760, uu____6761))))
>>>>>>> origin/master
let short_circuit:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.args -> FStar_TypeChecker_Common.guard_formula
  =
  fun head1  ->
    fun seen_args  ->
<<<<<<< HEAD
      let short_bin_op f uu___102_6734 =
        match uu___102_6734 with
        | [] -> FStar_TypeChecker_Common.Trivial
        | (fst1,uu____6740)::[] -> f fst1
        | uu____6753 -> failwith "Unexpexted args to binary operator" in
      let op_and_e e =
        let uu____6758 = FStar_Syntax_Util.b2t e in
        FStar_All.pipe_right uu____6758
          (fun _0_33  -> FStar_TypeChecker_Common.NonTrivial _0_33) in
      let op_or_e e =
        let uu____6767 =
          let uu____6770 = FStar_Syntax_Util.b2t e in
          FStar_Syntax_Util.mk_neg uu____6770 in
        FStar_All.pipe_right uu____6767
=======
      let short_bin_op f uu___102_6785 =
        match uu___102_6785 with
        | [] -> FStar_TypeChecker_Common.Trivial
        | (fst1,uu____6791)::[] -> f fst1
        | uu____6804 -> failwith "Unexpexted args to binary operator" in
      let op_and_e e =
        let uu____6809 = FStar_Syntax_Util.b2t e in
        FStar_All.pipe_right uu____6809
          (fun _0_33  -> FStar_TypeChecker_Common.NonTrivial _0_33) in
      let op_or_e e =
        let uu____6818 =
          let uu____6821 = FStar_Syntax_Util.b2t e in
          FStar_Syntax_Util.mk_neg uu____6821 in
        FStar_All.pipe_right uu____6818
>>>>>>> origin/master
          (fun _0_34  -> FStar_TypeChecker_Common.NonTrivial _0_34) in
      let op_and_t t =
        FStar_All.pipe_right t
          (fun _0_35  -> FStar_TypeChecker_Common.NonTrivial _0_35) in
      let op_or_t t =
<<<<<<< HEAD
        let uu____6781 = FStar_All.pipe_right t FStar_Syntax_Util.mk_neg in
        FStar_All.pipe_right uu____6781
=======
        let uu____6832 = FStar_All.pipe_right t FStar_Syntax_Util.mk_neg in
        FStar_All.pipe_right uu____6832
>>>>>>> origin/master
          (fun _0_36  -> FStar_TypeChecker_Common.NonTrivial _0_36) in
      let op_imp_t t =
        FStar_All.pipe_right t
          (fun _0_37  -> FStar_TypeChecker_Common.NonTrivial _0_37) in
<<<<<<< HEAD
      let short_op_ite uu___103_6795 =
        match uu___103_6795 with
        | [] -> FStar_TypeChecker_Common.Trivial
        | (guard,uu____6801)::[] -> FStar_TypeChecker_Common.NonTrivial guard
        | _then::(guard,uu____6816)::[] ->
            let uu____6837 = FStar_Syntax_Util.mk_neg guard in
            FStar_All.pipe_right uu____6837
              (fun _0_38  -> FStar_TypeChecker_Common.NonTrivial _0_38)
        | uu____6842 -> failwith "Unexpected args to ITE" in
      let table =
        let uu____6849 =
          let uu____6854 = short_bin_op op_and_e in
          (FStar_Syntax_Const.op_And, uu____6854) in
        let uu____6859 =
          let uu____6865 =
            let uu____6870 = short_bin_op op_or_e in
            (FStar_Syntax_Const.op_Or, uu____6870) in
          let uu____6875 =
            let uu____6881 =
              let uu____6886 = short_bin_op op_and_t in
              (FStar_Syntax_Const.and_lid, uu____6886) in
            let uu____6891 =
              let uu____6897 =
                let uu____6902 = short_bin_op op_or_t in
                (FStar_Syntax_Const.or_lid, uu____6902) in
              let uu____6907 =
                let uu____6913 =
                  let uu____6918 = short_bin_op op_imp_t in
                  (FStar_Syntax_Const.imp_lid, uu____6918) in
                [uu____6913; (FStar_Syntax_Const.ite_lid, short_op_ite)] in
              uu____6897 :: uu____6907 in
            uu____6881 :: uu____6891 in
          uu____6865 :: uu____6875 in
        uu____6849 :: uu____6859 in
      match head1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let lid = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          let uu____6959 =
            FStar_Util.find_map table
              (fun uu____6965  ->
                 match uu____6965 with
                 | (x,mk1) ->
                     if FStar_Ident.lid_equals x lid
                     then let uu____6978 = mk1 seen_args in Some uu____6978
                     else None) in
          (match uu____6959 with
           | None  -> FStar_TypeChecker_Common.Trivial
           | Some g -> g)
      | uu____6981 -> FStar_TypeChecker_Common.Trivial
let short_circuit_head: FStar_Syntax_Syntax.term -> Prims.bool =
  fun l  ->
    let uu____6985 =
      let uu____6986 = FStar_Syntax_Util.un_uinst l in
      uu____6986.FStar_Syntax_Syntax.n in
    match uu____6985 with
=======
      let short_op_ite uu___103_6846 =
        match uu___103_6846 with
        | [] -> FStar_TypeChecker_Common.Trivial
        | (guard,uu____6852)::[] -> FStar_TypeChecker_Common.NonTrivial guard
        | _then::(guard,uu____6867)::[] ->
            let uu____6888 = FStar_Syntax_Util.mk_neg guard in
            FStar_All.pipe_right uu____6888
              (fun _0_38  -> FStar_TypeChecker_Common.NonTrivial _0_38)
        | uu____6893 -> failwith "Unexpected args to ITE" in
      let table =
        let uu____6900 =
          let uu____6905 = short_bin_op op_and_e in
          (FStar_Syntax_Const.op_And, uu____6905) in
        let uu____6910 =
          let uu____6916 =
            let uu____6921 = short_bin_op op_or_e in
            (FStar_Syntax_Const.op_Or, uu____6921) in
          let uu____6926 =
            let uu____6932 =
              let uu____6937 = short_bin_op op_and_t in
              (FStar_Syntax_Const.and_lid, uu____6937) in
            let uu____6942 =
              let uu____6948 =
                let uu____6953 = short_bin_op op_or_t in
                (FStar_Syntax_Const.or_lid, uu____6953) in
              let uu____6958 =
                let uu____6964 =
                  let uu____6969 = short_bin_op op_imp_t in
                  (FStar_Syntax_Const.imp_lid, uu____6969) in
                [uu____6964; (FStar_Syntax_Const.ite_lid, short_op_ite)] in
              uu____6948 :: uu____6958 in
            uu____6932 :: uu____6942 in
          uu____6916 :: uu____6926 in
        uu____6900 :: uu____6910 in
      match head1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let lid = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          let uu____7010 =
            FStar_Util.find_map table
              (fun uu____7016  ->
                 match uu____7016 with
                 | (x,mk1) ->
                     if FStar_Ident.lid_equals x lid
                     then let uu____7029 = mk1 seen_args in Some uu____7029
                     else None) in
          (match uu____7010 with
           | None  -> FStar_TypeChecker_Common.Trivial
           | Some g -> g)
      | uu____7032 -> FStar_TypeChecker_Common.Trivial
let short_circuit_head: FStar_Syntax_Syntax.term -> Prims.bool =
  fun l  ->
    let uu____7036 =
      let uu____7037 = FStar_Syntax_Util.un_uinst l in
      uu____7037.FStar_Syntax_Syntax.n in
    match uu____7036 with
>>>>>>> origin/master
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Util.for_some (FStar_Syntax_Syntax.fv_eq_lid fv)
          [FStar_Syntax_Const.op_And;
          FStar_Syntax_Const.op_Or;
          FStar_Syntax_Const.and_lid;
          FStar_Syntax_Const.or_lid;
          FStar_Syntax_Const.imp_lid;
          FStar_Syntax_Const.ite_lid]
<<<<<<< HEAD
    | uu____6990 -> false
=======
    | uu____7041 -> false
>>>>>>> origin/master
let maybe_add_implicit_binders:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.binders
  =
  fun env  ->
    fun bs  ->
      let pos bs1 =
        match bs1 with
<<<<<<< HEAD
        | (hd1,uu____7008)::uu____7009 -> FStar_Syntax_Syntax.range_of_bv hd1
        | uu____7015 -> FStar_TypeChecker_Env.get_range env in
      match bs with
      | (uu____7019,Some (FStar_Syntax_Syntax.Implicit uu____7020))::uu____7021
          -> bs
      | uu____7030 ->
          let uu____7031 = FStar_TypeChecker_Env.expected_typ env in
          (match uu____7031 with
           | None  -> bs
           | Some t ->
               let uu____7034 =
                 let uu____7035 = FStar_Syntax_Subst.compress t in
                 uu____7035.FStar_Syntax_Syntax.n in
               (match uu____7034 with
                | FStar_Syntax_Syntax.Tm_arrow (bs',uu____7039) ->
                    let uu____7050 =
                      FStar_Util.prefix_until
                        (fun uu___104_7069  ->
                           match uu___104_7069 with
                           | (uu____7073,Some (FStar_Syntax_Syntax.Implicit
                              uu____7074)) -> false
                           | uu____7076 -> true) bs' in
                    (match uu____7050 with
                     | None  -> bs
                     | Some ([],uu____7094,uu____7095) -> bs
                     | Some (imps,uu____7132,uu____7133) ->
                         let uu____7170 =
                           FStar_All.pipe_right imps
                             (FStar_Util.for_all
                                (fun uu____7178  ->
                                   match uu____7178 with
                                   | (x,uu____7183) ->
                                       FStar_Util.starts_with
                                         (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                         "'")) in
                         if uu____7170
=======
        | (hd1,uu____7059)::uu____7060 -> FStar_Syntax_Syntax.range_of_bv hd1
        | uu____7066 -> FStar_TypeChecker_Env.get_range env in
      match bs with
      | (uu____7070,Some (FStar_Syntax_Syntax.Implicit uu____7071))::uu____7072
          -> bs
      | uu____7081 ->
          let uu____7082 = FStar_TypeChecker_Env.expected_typ env in
          (match uu____7082 with
           | None  -> bs
           | Some t ->
               let uu____7085 =
                 let uu____7086 = FStar_Syntax_Subst.compress t in
                 uu____7086.FStar_Syntax_Syntax.n in
               (match uu____7085 with
                | FStar_Syntax_Syntax.Tm_arrow (bs',uu____7090) ->
                    let uu____7101 =
                      FStar_Util.prefix_until
                        (fun uu___104_7120  ->
                           match uu___104_7120 with
                           | (uu____7124,Some (FStar_Syntax_Syntax.Implicit
                              uu____7125)) -> false
                           | uu____7127 -> true) bs' in
                    (match uu____7101 with
                     | None  -> bs
                     | Some ([],uu____7145,uu____7146) -> bs
                     | Some (imps,uu____7183,uu____7184) ->
                         let uu____7221 =
                           FStar_All.pipe_right imps
                             (FStar_Util.for_all
                                (fun uu____7229  ->
                                   match uu____7229 with
                                   | (x,uu____7234) ->
                                       FStar_Util.starts_with
                                         (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                         "'")) in
                         if uu____7221
>>>>>>> origin/master
                         then
                           let r = pos bs in
                           let imps1 =
                             FStar_All.pipe_right imps
                               (FStar_List.map
<<<<<<< HEAD
                                  (fun uu____7206  ->
                                     match uu____7206 with
                                     | (x,i) ->
                                         let uu____7217 =
                                           FStar_Syntax_Syntax.set_range_of_bv
                                             x r in
                                         (uu____7217, i))) in
                           FStar_List.append imps1 bs
                         else bs)
                | uu____7223 -> bs))
=======
                                  (fun uu____7257  ->
                                     match uu____7257 with
                                     | (x,i) ->
                                         let uu____7268 =
                                           FStar_Syntax_Syntax.set_range_of_bv
                                             x r in
                                         (uu____7268, i))) in
                           FStar_List.append imps1 bs
                         else bs)
                | uu____7274 -> bs))
>>>>>>> origin/master
let maybe_lift:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Ident.lident ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun e  ->
      fun c1  ->
        fun c2  ->
          fun t  ->
            let m1 = FStar_TypeChecker_Env.norm_eff_name env c1 in
            let m2 = FStar_TypeChecker_Env.norm_eff_name env c2 in
            if
              ((FStar_Ident.lid_equals m1 m2) ||
                 ((FStar_Syntax_Util.is_pure_effect c1) &&
                    (FStar_Syntax_Util.is_ghost_effect c2)))
                ||
                ((FStar_Syntax_Util.is_pure_effect c2) &&
                   (FStar_Syntax_Util.is_ghost_effect c1))
            then e
            else
<<<<<<< HEAD
              (let uu____7242 = FStar_ST.read e.FStar_Syntax_Syntax.tk in
               FStar_Syntax_Syntax.mk
                 (FStar_Syntax_Syntax.Tm_meta
                    (e, (FStar_Syntax_Syntax.Meta_monadic_lift (m1, m2, t))))
                 uu____7242 e.FStar_Syntax_Syntax.pos)
=======
              (let uu____7293 = FStar_ST.read e.FStar_Syntax_Syntax.tk in
               FStar_Syntax_Syntax.mk
                 (FStar_Syntax_Syntax.Tm_meta
                    (e, (FStar_Syntax_Syntax.Meta_monadic_lift (m1, m2, t))))
                 uu____7293 e.FStar_Syntax_Syntax.pos)
>>>>>>> origin/master
let maybe_monadic:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun e  ->
      fun c  ->
        fun t  ->
          let m = FStar_TypeChecker_Env.norm_eff_name env c in
<<<<<<< HEAD
          let uu____7264 =
=======
          let uu____7315 =
>>>>>>> origin/master
            ((is_pure_or_ghost_effect env m) ||
               (FStar_Ident.lid_equals m FStar_Syntax_Const.effect_Tot_lid))
              ||
              (FStar_Ident.lid_equals m FStar_Syntax_Const.effect_GTot_lid) in
<<<<<<< HEAD
          if uu____7264
          then e
          else
            (let uu____7266 = FStar_ST.read e.FStar_Syntax_Syntax.tk in
             FStar_Syntax_Syntax.mk
               (FStar_Syntax_Syntax.Tm_meta
                  (e, (FStar_Syntax_Syntax.Meta_monadic (m, t)))) uu____7266
=======
          if uu____7315
          then e
          else
            (let uu____7317 = FStar_ST.read e.FStar_Syntax_Syntax.tk in
             FStar_Syntax_Syntax.mk
               (FStar_Syntax_Syntax.Tm_meta
                  (e, (FStar_Syntax_Syntax.Meta_monadic (m, t)))) uu____7317
>>>>>>> origin/master
               e.FStar_Syntax_Syntax.pos)
let d: Prims.string -> Prims.unit =
  fun s  -> FStar_Util.print1 "\\x1b[01;36m%s\\x1b[00m\n" s
let mk_toplevel_definition:
  FStar_TypeChecker_Env.env_t ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.term ->
        (FStar_Syntax_Syntax.sigelt*
          (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
          FStar_Syntax_Syntax.syntax)
  =
  fun env  ->
    fun lident  ->
      fun def  ->
<<<<<<< HEAD
        (let uu____7292 =
           FStar_TypeChecker_Env.debug env (FStar_Options.Other "ED") in
         if uu____7292
         then
           (d (FStar_Ident.text_of_lid lident);
            (let uu____7294 = FStar_Syntax_Print.term_to_string def in
             FStar_Util.print2 "Registering top-level definition: %s\n%s\n"
               (FStar_Ident.text_of_lid lident) uu____7294))
         else ());
        (let fv =
           let uu____7297 = FStar_Syntax_Util.incr_delta_qualifier def in
           FStar_Syntax_Syntax.lid_as_fv lident uu____7297 None in
=======
        (let uu____7343 =
           FStar_TypeChecker_Env.debug env (FStar_Options.Other "ED") in
         if uu____7343
         then
           (d (FStar_Ident.text_of_lid lident);
            (let uu____7345 = FStar_Syntax_Print.term_to_string def in
             FStar_Util.print2 "Registering top-level definition: %s\n%s\n"
               (FStar_Ident.text_of_lid lident) uu____7345))
         else ());
        (let fv =
           let uu____7348 = FStar_Syntax_Util.incr_delta_qualifier def in
           FStar_Syntax_Syntax.lid_as_fv lident uu____7348 None in
>>>>>>> origin/master
         let lbname = FStar_Util.Inr fv in
         let lb =
           (false,
             [{
                FStar_Syntax_Syntax.lbname = lbname;
                FStar_Syntax_Syntax.lbunivs = [];
                FStar_Syntax_Syntax.lbtyp = FStar_Syntax_Syntax.tun;
                FStar_Syntax_Syntax.lbeff = FStar_Syntax_Const.effect_Tot_lid;
                FStar_Syntax_Syntax.lbdef = def
              }]) in
         let sig_ctx =
           FStar_Syntax_Syntax.mk_sigelt
             (FStar_Syntax_Syntax.Sig_let (lb, [lident], [])) in
<<<<<<< HEAD
         let uu____7304 =
           FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_fvar fv) None
             FStar_Range.dummyRange in
         ((let uu___147_7313 = sig_ctx in
           {
             FStar_Syntax_Syntax.sigel =
               (uu___147_7313.FStar_Syntax_Syntax.sigel);
             FStar_Syntax_Syntax.sigrng =
               (uu___147_7313.FStar_Syntax_Syntax.sigrng);
             FStar_Syntax_Syntax.sigquals =
               [FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen];
             FStar_Syntax_Syntax.sigmeta =
               (uu___147_7313.FStar_Syntax_Syntax.sigmeta)
           }), uu____7304))
=======
         let uu____7355 =
           FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_fvar fv) None
             FStar_Range.dummyRange in
         ((let uu___147_7364 = sig_ctx in
           {
             FStar_Syntax_Syntax.sigel =
               (uu___147_7364.FStar_Syntax_Syntax.sigel);
             FStar_Syntax_Syntax.sigrng =
               (uu___147_7364.FStar_Syntax_Syntax.sigrng);
             FStar_Syntax_Syntax.sigquals =
               [FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen];
             FStar_Syntax_Syntax.sigmeta =
               (uu___147_7364.FStar_Syntax_Syntax.sigmeta)
           }), uu____7355))
>>>>>>> origin/master
let check_sigelt_quals:
  FStar_TypeChecker_Env.env -> FStar_Syntax_Syntax.sigelt -> Prims.unit =
  fun env  ->
    fun se  ->
<<<<<<< HEAD
      let visibility uu___105_7323 =
        match uu___105_7323 with
        | FStar_Syntax_Syntax.Private  -> true
        | uu____7324 -> false in
      let reducibility uu___106_7328 =
        match uu___106_7328 with
=======
      let visibility uu___105_7374 =
        match uu___105_7374 with
        | FStar_Syntax_Syntax.Private  -> true
        | uu____7375 -> false in
      let reducibility uu___106_7379 =
        match uu___106_7379 with
>>>>>>> origin/master
        | FStar_Syntax_Syntax.Abstract  -> true
        | FStar_Syntax_Syntax.Irreducible  -> true
        | FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen  -> true
        | FStar_Syntax_Syntax.Visible_default  -> true
        | FStar_Syntax_Syntax.Inline_for_extraction  -> true
<<<<<<< HEAD
        | uu____7329 -> false in
      let assumption uu___107_7333 =
        match uu___107_7333 with
        | FStar_Syntax_Syntax.Assumption  -> true
        | FStar_Syntax_Syntax.New  -> true
        | uu____7334 -> false in
      let reification uu___108_7338 =
        match uu___108_7338 with
        | FStar_Syntax_Syntax.Reifiable  -> true
        | FStar_Syntax_Syntax.Reflectable uu____7339 -> true
        | uu____7340 -> false in
      let inferred uu___109_7344 =
        match uu___109_7344 with
        | FStar_Syntax_Syntax.Discriminator uu____7345 -> true
        | FStar_Syntax_Syntax.Projector uu____7346 -> true
        | FStar_Syntax_Syntax.RecordType uu____7349 -> true
        | FStar_Syntax_Syntax.RecordConstructor uu____7354 -> true
        | FStar_Syntax_Syntax.ExceptionConstructor  -> true
        | FStar_Syntax_Syntax.HasMaskedEffect  -> true
        | FStar_Syntax_Syntax.Effect  -> true
        | uu____7359 -> false in
      let has_eq uu___110_7363 =
        match uu___110_7363 with
        | FStar_Syntax_Syntax.Noeq  -> true
        | FStar_Syntax_Syntax.Unopteq  -> true
        | uu____7364 -> false in
=======
        | uu____7380 -> false in
      let assumption uu___107_7384 =
        match uu___107_7384 with
        | FStar_Syntax_Syntax.Assumption  -> true
        | FStar_Syntax_Syntax.New  -> true
        | uu____7385 -> false in
      let reification uu___108_7389 =
        match uu___108_7389 with
        | FStar_Syntax_Syntax.Reifiable  -> true
        | FStar_Syntax_Syntax.Reflectable uu____7390 -> true
        | uu____7391 -> false in
      let inferred uu___109_7395 =
        match uu___109_7395 with
        | FStar_Syntax_Syntax.Discriminator uu____7396 -> true
        | FStar_Syntax_Syntax.Projector uu____7397 -> true
        | FStar_Syntax_Syntax.RecordType uu____7400 -> true
        | FStar_Syntax_Syntax.RecordConstructor uu____7405 -> true
        | FStar_Syntax_Syntax.ExceptionConstructor  -> true
        | FStar_Syntax_Syntax.HasMaskedEffect  -> true
        | FStar_Syntax_Syntax.Effect  -> true
        | uu____7410 -> false in
      let has_eq uu___110_7414 =
        match uu___110_7414 with
        | FStar_Syntax_Syntax.Noeq  -> true
        | FStar_Syntax_Syntax.Unopteq  -> true
        | uu____7415 -> false in
>>>>>>> origin/master
      let quals_combo_ok quals q =
        match q with
        | FStar_Syntax_Syntax.Assumption  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    (((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                         (inferred x))
                        || (visibility x))
                       || (assumption x))
                      ||
                      (env.FStar_TypeChecker_Env.is_iface &&
                         (x = FStar_Syntax_Syntax.Inline_for_extraction))))
        | FStar_Syntax_Syntax.New  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    (((x = q) || (inferred x)) || (visibility x)) ||
                      (assumption x)))
        | FStar_Syntax_Syntax.Inline_for_extraction  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (visibility x))
                         || (reducibility x))
                        || (reification x))
                       || (inferred x))
                      ||
                      (env.FStar_TypeChecker_Env.is_iface &&
                         (x = FStar_Syntax_Syntax.Assumption))))
        | FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (x = FStar_Syntax_Syntax.Abstract))
                         || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                        || (has_eq x))
                       || (inferred x))
                      || (visibility x)))
        | FStar_Syntax_Syntax.Visible_default  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (x = FStar_Syntax_Syntax.Abstract))
                         || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                        || (has_eq x))
                       || (inferred x))
                      || (visibility x)))
        | FStar_Syntax_Syntax.Irreducible  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (x = FStar_Syntax_Syntax.Abstract))
                         || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                        || (has_eq x))
                       || (inferred x))
                      || (visibility x)))
        | FStar_Syntax_Syntax.Abstract  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (x = FStar_Syntax_Syntax.Abstract))
                         || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                        || (has_eq x))
                       || (inferred x))
                      || (visibility x)))
        | FStar_Syntax_Syntax.Noeq  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (x = FStar_Syntax_Syntax.Abstract))
                         || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                        || (has_eq x))
                       || (inferred x))
                      || (visibility x)))
        | FStar_Syntax_Syntax.Unopteq  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (x = FStar_Syntax_Syntax.Abstract))
                         || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                        || (has_eq x))
                       || (inferred x))
                      || (visibility x)))
        | FStar_Syntax_Syntax.TotalEffect  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    (((x = q) || (inferred x)) || (visibility x)) ||
                      (reification x)))
        | FStar_Syntax_Syntax.Logic  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    ((((x = q) || (x = FStar_Syntax_Syntax.Assumption)) ||
                        (inferred x))
                       || (visibility x))
                      || (reducibility x)))
        | FStar_Syntax_Syntax.Reifiable  ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    (((reification x) || (inferred x)) || (visibility x)) ||
                      (x = FStar_Syntax_Syntax.TotalEffect)))
<<<<<<< HEAD
        | FStar_Syntax_Syntax.Reflectable uu____7398 ->
=======
        | FStar_Syntax_Syntax.Reflectable uu____7449 ->
>>>>>>> origin/master
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x  ->
                    (((reification x) || (inferred x)) || (visibility x)) ||
                      (x = FStar_Syntax_Syntax.TotalEffect)))
        | FStar_Syntax_Syntax.Private  -> true
<<<<<<< HEAD
        | uu____7401 -> true in
      let quals = FStar_Syntax_Util.quals_of_sigelt se in
      let uu____7404 =
        let uu____7405 =
          FStar_All.pipe_right quals
            (FStar_Util.for_some
               (fun uu___111_7407  ->
                  match uu___111_7407 with
                  | FStar_Syntax_Syntax.OnlyName  -> true
                  | uu____7408 -> false)) in
        FStar_All.pipe_right uu____7405 Prims.op_Negation in
      if uu____7404
=======
        | uu____7452 -> true in
      let quals = FStar_Syntax_Util.quals_of_sigelt se in
      let uu____7455 =
        let uu____7456 =
          FStar_All.pipe_right quals
            (FStar_Util.for_some
               (fun uu___111_7458  ->
                  match uu___111_7458 with
                  | FStar_Syntax_Syntax.OnlyName  -> true
                  | uu____7459 -> false)) in
        FStar_All.pipe_right uu____7456 Prims.op_Negation in
      if uu____7455
>>>>>>> origin/master
      then
        let r = FStar_Syntax_Util.range_of_sigelt se in
        let no_dup_quals =
          FStar_Util.remove_dups (fun x  -> fun y  -> x = y) quals in
        let err' msg =
<<<<<<< HEAD
          let uu____7418 =
            let uu____7419 =
              let uu____7422 =
                let uu____7423 = FStar_Syntax_Print.quals_to_string quals in
                FStar_Util.format2
                  "The qualifier list \"[%s]\" is not permissible for this element%s"
                  uu____7423 msg in
              (uu____7422, r) in
            FStar_Errors.Error uu____7419 in
          raise uu____7418 in
        let err1 msg = err' (Prims.strcat ": " msg) in
        let err'1 uu____7431 = err' "" in
        (if (FStar_List.length quals) <> (FStar_List.length no_dup_quals)
         then err1 "duplicate qualifiers"
         else ();
         (let uu____7439 =
            let uu____7440 =
              FStar_All.pipe_right quals
                (FStar_List.for_all (quals_combo_ok quals)) in
            Prims.op_Negation uu____7440 in
          if uu____7439 then err1 "ill-formed combination" else ());
         (match se.FStar_Syntax_Syntax.sigel with
          | FStar_Syntax_Syntax.Sig_let
              ((is_rec,uu____7444),uu____7445,uu____7446) ->
              ((let uu____7457 =
=======
          let uu____7469 =
            let uu____7470 =
              let uu____7473 =
                let uu____7474 = FStar_Syntax_Print.quals_to_string quals in
                FStar_Util.format2
                  "The qualifier list \"[%s]\" is not permissible for this element%s"
                  uu____7474 msg in
              (uu____7473, r) in
            FStar_Errors.Error uu____7470 in
          raise uu____7469 in
        let err1 msg = err' (Prims.strcat ": " msg) in
        let err'1 uu____7482 = err' "" in
        (if (FStar_List.length quals) <> (FStar_List.length no_dup_quals)
         then err1 "duplicate qualifiers"
         else ();
         (let uu____7490 =
            let uu____7491 =
              FStar_All.pipe_right quals
                (FStar_List.for_all (quals_combo_ok quals)) in
            Prims.op_Negation uu____7491 in
          if uu____7490 then err1 "ill-formed combination" else ());
         (match se.FStar_Syntax_Syntax.sigel with
          | FStar_Syntax_Syntax.Sig_let
              ((is_rec,uu____7495),uu____7496,uu____7497) ->
              ((let uu____7508 =
>>>>>>> origin/master
                  is_rec &&
                    (FStar_All.pipe_right quals
                       (FStar_List.contains
                          FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen)) in
<<<<<<< HEAD
                if uu____7457
                then err1 "recursive definitions cannot be marked inline"
                else ());
               (let uu____7460 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_some
                       (fun x  -> (assumption x) || (has_eq x))) in
                if uu____7460
=======
                if uu____7508
                then err1 "recursive definitions cannot be marked inline"
                else ());
               (let uu____7511 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_some
                       (fun x  -> (assumption x) || (has_eq x))) in
                if uu____7511
>>>>>>> origin/master
                then
                  err1
                    "definitions cannot be assumed or marked with equality qualifiers"
                else ()))
<<<<<<< HEAD
          | FStar_Syntax_Syntax.Sig_bundle uu____7464 ->
              let uu____7469 =
                let uu____7470 =
=======
          | FStar_Syntax_Syntax.Sig_bundle uu____7515 ->
              let uu____7520 =
                let uu____7521 =
>>>>>>> origin/master
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x  ->
                          (((x = FStar_Syntax_Syntax.Abstract) ||
                              (inferred x))
                             || (visibility x))
                            || (has_eq x))) in
<<<<<<< HEAD
                Prims.op_Negation uu____7470 in
              if uu____7469 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_declare_typ uu____7474 ->
              let uu____7478 =
                FStar_All.pipe_right quals (FStar_Util.for_some has_eq) in
              if uu____7478 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_assume uu____7481 ->
              let uu____7485 =
                let uu____7486 =
=======
                Prims.op_Negation uu____7521 in
              if uu____7520 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_declare_typ uu____7525 ->
              let uu____7529 =
                FStar_All.pipe_right quals (FStar_Util.for_some has_eq) in
              if uu____7529 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_assume uu____7532 ->
              let uu____7535 =
                let uu____7536 =
>>>>>>> origin/master
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x  ->
                          (visibility x) ||
                            (x = FStar_Syntax_Syntax.Assumption))) in
<<<<<<< HEAD
                Prims.op_Negation uu____7486 in
              if uu____7485 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_new_effect uu____7490 ->
              let uu____7491 =
                let uu____7492 =
=======
                Prims.op_Negation uu____7536 in
              if uu____7535 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_new_effect uu____7540 ->
              let uu____7541 =
                let uu____7542 =
>>>>>>> origin/master
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x  ->
                          (((x = FStar_Syntax_Syntax.TotalEffect) ||
                              (inferred x))
                             || (visibility x))
                            || (reification x))) in
<<<<<<< HEAD
                Prims.op_Negation uu____7492 in
              if uu____7491 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_new_effect_for_free uu____7496 ->
              let uu____7497 =
                let uu____7498 =
=======
                Prims.op_Negation uu____7542 in
              if uu____7541 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_new_effect_for_free uu____7546 ->
              let uu____7547 =
                let uu____7548 =
>>>>>>> origin/master
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x  ->
                          (((x = FStar_Syntax_Syntax.TotalEffect) ||
                              (inferred x))
                             || (visibility x))
                            || (reification x))) in
<<<<<<< HEAD
                Prims.op_Negation uu____7498 in
              if uu____7497 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_effect_abbrev uu____7502 ->
              let uu____7509 =
                let uu____7510 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x  -> (inferred x) || (visibility x))) in
                Prims.op_Negation uu____7510 in
              if uu____7509 then err'1 () else ()
          | uu____7514 -> ()))
=======
                Prims.op_Negation uu____7548 in
              if uu____7547 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_effect_abbrev uu____7552 ->
              let uu____7559 =
                let uu____7560 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x  -> (inferred x) || (visibility x))) in
                Prims.op_Negation uu____7560 in
              if uu____7559 then err'1 () else ()
          | uu____7564 -> ()))
>>>>>>> origin/master
      else ()
let mk_discriminator_and_indexed_projectors:
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_Syntax.fv_qual ->
      Prims.bool ->
        FStar_TypeChecker_Env.env ->
          FStar_Ident.lident ->
            FStar_Ident.lident ->
              FStar_Syntax_Syntax.univ_names ->
                FStar_Syntax_Syntax.binders ->
                  FStar_Syntax_Syntax.binders ->
                    FStar_Syntax_Syntax.binders ->
                      FStar_Syntax_Syntax.sigelt Prims.list
  =
  fun iquals  ->
    fun fvq  ->
      fun refine_domain  ->
        fun env  ->
          fun tc  ->
            fun lid  ->
              fun uvs  ->
                fun inductive_tps  ->
                  fun indices  ->
                    fun fields  ->
                      let p = FStar_Ident.range_of_lid lid in
                      let pos q =
                        FStar_Syntax_Syntax.withinfo q
                          FStar_Syntax_Syntax.tun.FStar_Syntax_Syntax.n p in
                      let projectee ptyp =
                        FStar_Syntax_Syntax.gen_bv "projectee" (Some p) ptyp in
                      let inst_univs =
                        FStar_List.map
                          (fun u  -> FStar_Syntax_Syntax.U_name u) uvs in
                      let tps = inductive_tps in
                      let arg_typ =
                        let inst_tc =
<<<<<<< HEAD
                          let uu____7571 =
                            let uu____7574 =
                              let uu____7575 =
                                let uu____7580 =
                                  let uu____7581 =
                                    FStar_Syntax_Syntax.lid_as_fv tc
                                      FStar_Syntax_Syntax.Delta_constant None in
                                  FStar_Syntax_Syntax.fv_to_tm uu____7581 in
                                (uu____7580, inst_univs) in
                              FStar_Syntax_Syntax.Tm_uinst uu____7575 in
                            FStar_Syntax_Syntax.mk uu____7574 in
                          uu____7571 None p in
=======
                          let uu____7621 =
                            let uu____7624 =
                              let uu____7625 =
                                let uu____7630 =
                                  let uu____7631 =
                                    FStar_Syntax_Syntax.lid_as_fv tc
                                      FStar_Syntax_Syntax.Delta_constant None in
                                  FStar_Syntax_Syntax.fv_to_tm uu____7631 in
                                (uu____7630, inst_univs) in
                              FStar_Syntax_Syntax.Tm_uinst uu____7625 in
                            FStar_Syntax_Syntax.mk uu____7624 in
                          uu____7621 None p in
>>>>>>> origin/master
                        let args =
                          FStar_All.pipe_right
                            (FStar_List.append tps indices)
                            (FStar_List.map
<<<<<<< HEAD
                               (fun uu____7607  ->
                                  match uu____7607 with
                                  | (x,imp) ->
                                      let uu____7614 =
                                        FStar_Syntax_Syntax.bv_to_name x in
                                      (uu____7614, imp))) in
                        FStar_Syntax_Syntax.mk_Tm_app inst_tc args None p in
                      let unrefined_arg_binder =
                        let uu____7618 = projectee arg_typ in
                        FStar_Syntax_Syntax.mk_binder uu____7618 in
=======
                               (fun uu____7657  ->
                                  match uu____7657 with
                                  | (x,imp) ->
                                      let uu____7664 =
                                        FStar_Syntax_Syntax.bv_to_name x in
                                      (uu____7664, imp))) in
                        FStar_Syntax_Syntax.mk_Tm_app inst_tc args None p in
                      let unrefined_arg_binder =
                        let uu____7668 = projectee arg_typ in
                        FStar_Syntax_Syntax.mk_binder uu____7668 in
>>>>>>> origin/master
                      let arg_binder =
                        if Prims.op_Negation refine_domain
                        then unrefined_arg_binder
                        else
                          (let disc_name =
                             FStar_Syntax_Util.mk_discriminator lid in
                           let x =
                             FStar_Syntax_Syntax.new_bv (Some p) arg_typ in
                           let sort =
                             let disc_fvar =
                               FStar_Syntax_Syntax.fvar
                                 (FStar_Ident.set_lid_range disc_name p)
                                 FStar_Syntax_Syntax.Delta_equational None in
<<<<<<< HEAD
                             let uu____7627 =
                               let uu____7628 =
                                 let uu____7629 =
                                   let uu____7630 =
                                     FStar_Syntax_Syntax.mk_Tm_uinst
                                       disc_fvar inst_univs in
                                   let uu____7631 =
                                     let uu____7632 =
                                       let uu____7633 =
                                         FStar_Syntax_Syntax.bv_to_name x in
                                       FStar_All.pipe_left
                                         FStar_Syntax_Syntax.as_arg
                                         uu____7633 in
                                     [uu____7632] in
                                   FStar_Syntax_Syntax.mk_Tm_app uu____7630
                                     uu____7631 in
                                 uu____7629 None p in
                               FStar_Syntax_Util.b2t uu____7628 in
                             FStar_Syntax_Util.refine x uu____7627 in
                           let uu____7638 =
                             let uu___148_7639 = projectee arg_typ in
                             {
                               FStar_Syntax_Syntax.ppname =
                                 (uu___148_7639.FStar_Syntax_Syntax.ppname);
                               FStar_Syntax_Syntax.index =
                                 (uu___148_7639.FStar_Syntax_Syntax.index);
                               FStar_Syntax_Syntax.sort = sort
                             } in
                           FStar_Syntax_Syntax.mk_binder uu____7638) in
                      let ntps = FStar_List.length tps in
                      let all_params =
                        let uu____7649 =
                          FStar_List.map
                            (fun uu____7659  ->
                               match uu____7659 with
                               | (x,uu____7666) ->
                                   (x, (Some FStar_Syntax_Syntax.imp_tag)))
                            tps in
                        FStar_List.append uu____7649 fields in
                      let imp_binders =
                        FStar_All.pipe_right (FStar_List.append tps indices)
                          (FStar_List.map
                             (fun uu____7690  ->
                                match uu____7690 with
                                | (x,uu____7697) ->
=======
                             let uu____7677 =
                               let uu____7678 =
                                 let uu____7679 =
                                   let uu____7680 =
                                     FStar_Syntax_Syntax.mk_Tm_uinst
                                       disc_fvar inst_univs in
                                   let uu____7681 =
                                     let uu____7682 =
                                       let uu____7683 =
                                         FStar_Syntax_Syntax.bv_to_name x in
                                       FStar_All.pipe_left
                                         FStar_Syntax_Syntax.as_arg
                                         uu____7683 in
                                     [uu____7682] in
                                   FStar_Syntax_Syntax.mk_Tm_app uu____7680
                                     uu____7681 in
                                 uu____7679 None p in
                               FStar_Syntax_Util.b2t uu____7678 in
                             FStar_Syntax_Util.refine x uu____7677 in
                           let uu____7688 =
                             let uu___148_7689 = projectee arg_typ in
                             {
                               FStar_Syntax_Syntax.ppname =
                                 (uu___148_7689.FStar_Syntax_Syntax.ppname);
                               FStar_Syntax_Syntax.index =
                                 (uu___148_7689.FStar_Syntax_Syntax.index);
                               FStar_Syntax_Syntax.sort = sort
                             } in
                           FStar_Syntax_Syntax.mk_binder uu____7688) in
                      let ntps = FStar_List.length tps in
                      let all_params =
                        let uu____7699 =
                          FStar_List.map
                            (fun uu____7709  ->
                               match uu____7709 with
                               | (x,uu____7716) ->
                                   (x, (Some FStar_Syntax_Syntax.imp_tag)))
                            tps in
                        FStar_List.append uu____7699 fields in
                      let imp_binders =
                        FStar_All.pipe_right (FStar_List.append tps indices)
                          (FStar_List.map
                             (fun uu____7740  ->
                                match uu____7740 with
                                | (x,uu____7747) ->
>>>>>>> origin/master
                                    (x, (Some FStar_Syntax_Syntax.imp_tag)))) in
                      let discriminator_ses =
                        if fvq <> FStar_Syntax_Syntax.Data_ctor
                        then []
                        else
                          (let discriminator_name =
                             FStar_Syntax_Util.mk_discriminator lid in
                           let no_decl = false in
                           let only_decl =
<<<<<<< HEAD
                             (let uu____7706 =
                                FStar_TypeChecker_Env.current_module env in
                              FStar_Ident.lid_equals
                                FStar_Syntax_Const.prims_lid uu____7706)
                               ||
                               (let uu____7707 =
                                  let uu____7708 =
                                    FStar_TypeChecker_Env.current_module env in
                                  uu____7708.FStar_Ident.str in
                                FStar_Options.dont_gen_projectors uu____7707) in
                           let quals =
                             let uu____7711 =
                               let uu____7713 =
                                 let uu____7715 =
=======
                             (let uu____7756 =
                                FStar_TypeChecker_Env.current_module env in
                              FStar_Ident.lid_equals
                                FStar_Syntax_Const.prims_lid uu____7756)
                               ||
                               (let uu____7757 =
                                  let uu____7758 =
                                    FStar_TypeChecker_Env.current_module env in
                                  uu____7758.FStar_Ident.str in
                                FStar_Options.dont_gen_projectors uu____7757) in
                           let quals =
                             let uu____7761 =
                               let uu____7763 =
                                 let uu____7765 =
>>>>>>> origin/master
                                   only_decl &&
                                     ((FStar_All.pipe_left Prims.op_Negation
                                         env.FStar_TypeChecker_Env.is_iface)
                                        || env.FStar_TypeChecker_Env.admit) in
<<<<<<< HEAD
                                 if uu____7715
                                 then [FStar_Syntax_Syntax.Assumption]
                                 else [] in
                               let uu____7718 =
                                 FStar_List.filter
                                   (fun uu___112_7720  ->
                                      match uu___112_7720 with
                                      | FStar_Syntax_Syntax.Abstract  ->
                                          Prims.op_Negation only_decl
                                      | FStar_Syntax_Syntax.Private  -> true
                                      | uu____7721 -> false) iquals in
                               FStar_List.append uu____7713 uu____7718 in
=======
                                 if uu____7765
                                 then [FStar_Syntax_Syntax.Assumption]
                                 else [] in
                               let uu____7768 =
                                 FStar_List.filter
                                   (fun uu___112_7770  ->
                                      match uu___112_7770 with
                                      | FStar_Syntax_Syntax.Abstract  ->
                                          Prims.op_Negation only_decl
                                      | FStar_Syntax_Syntax.Private  -> true
                                      | uu____7771 -> false) iquals in
                               FStar_List.append uu____7763 uu____7768 in
>>>>>>> origin/master
                             FStar_List.append
                               ((FStar_Syntax_Syntax.Discriminator lid) ::
                               (if only_decl
                                then [FStar_Syntax_Syntax.Logic]
<<<<<<< HEAD
                                else [])) uu____7711 in
=======
                                else [])) uu____7761 in
>>>>>>> origin/master
                           let binders =
                             FStar_List.append imp_binders
                               [unrefined_arg_binder] in
                           let t =
                             let bool_typ =
<<<<<<< HEAD
                               let uu____7734 =
                                 let uu____7735 =
                                   FStar_Syntax_Syntax.lid_as_fv
                                     FStar_Syntax_Const.bool_lid
                                     FStar_Syntax_Syntax.Delta_constant None in
                                 FStar_Syntax_Syntax.fv_to_tm uu____7735 in
                               FStar_Syntax_Syntax.mk_Total uu____7734 in
                             let uu____7736 =
                               FStar_Syntax_Util.arrow binders bool_typ in
                             FStar_All.pipe_left
                               (FStar_Syntax_Subst.close_univ_vars uvs)
                               uu____7736 in
=======
                               let uu____7784 =
                                 let uu____7785 =
                                   FStar_Syntax_Syntax.lid_as_fv
                                     FStar_Syntax_Const.bool_lid
                                     FStar_Syntax_Syntax.Delta_constant None in
                                 FStar_Syntax_Syntax.fv_to_tm uu____7785 in
                               FStar_Syntax_Syntax.mk_Total uu____7784 in
                             let uu____7786 =
                               FStar_Syntax_Util.arrow binders bool_typ in
                             FStar_All.pipe_left
                               (FStar_Syntax_Subst.close_univ_vars uvs)
                               uu____7786 in
>>>>>>> origin/master
                           let decl =
                             {
                               FStar_Syntax_Syntax.sigel =
                                 (FStar_Syntax_Syntax.Sig_declare_typ
                                    (discriminator_name, uvs, t));
                               FStar_Syntax_Syntax.sigrng =
                                 (FStar_Ident.range_of_lid discriminator_name);
                               FStar_Syntax_Syntax.sigquals = quals;
                               FStar_Syntax_Syntax.sigmeta =
                                 FStar_Syntax_Syntax.default_sigmeta
                             } in
<<<<<<< HEAD
                           (let uu____7739 =
                              FStar_TypeChecker_Env.debug env
                                (FStar_Options.Other "LogTypes") in
                            if uu____7739
                            then
                              let uu____7740 =
                                FStar_Syntax_Print.sigelt_to_string decl in
                              FStar_Util.print1
                                "Declaration of a discriminator %s\n"
                                uu____7740
=======
                           (let uu____7789 =
                              FStar_TypeChecker_Env.debug env
                                (FStar_Options.Other "LogTypes") in
                            if uu____7789
                            then
                              let uu____7790 =
                                FStar_Syntax_Print.sigelt_to_string decl in
                              FStar_Util.print1
                                "Declaration of a discriminator %s\n"
                                uu____7790
>>>>>>> origin/master
                            else ());
                           if only_decl
                           then [decl]
                           else
                             (let body =
                                if Prims.op_Negation refine_domain
                                then FStar_Syntax_Const.exp_true_bool
                                else
                                  (let arg_pats =
                                     FStar_All.pipe_right all_params
                                       (FStar_List.mapi
                                          (fun j  ->
<<<<<<< HEAD
                                             fun uu____7768  ->
                                               match uu____7768 with
=======
                                             fun uu____7818  ->
                                               match uu____7818 with
>>>>>>> origin/master
                                               | (x,imp) ->
                                                   let b =
                                                     FStar_Syntax_Syntax.is_implicit
                                                       imp in
                                                   if b && (j < ntps)
                                                   then
<<<<<<< HEAD
                                                     let uu____7784 =
                                                       let uu____7787 =
                                                         let uu____7788 =
                                                           let uu____7793 =
=======
                                                     let uu____7834 =
                                                       let uu____7837 =
                                                         let uu____7838 =
                                                           let uu____7843 =
>>>>>>> origin/master
                                                             FStar_Syntax_Syntax.gen_bv
                                                               (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                               None
                                                               FStar_Syntax_Syntax.tun in
<<<<<<< HEAD
                                                           (uu____7793,
                                                             FStar_Syntax_Syntax.tun) in
                                                         FStar_Syntax_Syntax.Pat_dot_term
                                                           uu____7788 in
                                                       pos uu____7787 in
                                                     (uu____7784, b)
                                                   else
                                                     (let uu____7797 =
                                                        let uu____7800 =
                                                          let uu____7801 =
=======
                                                           (uu____7843,
                                                             FStar_Syntax_Syntax.tun) in
                                                         FStar_Syntax_Syntax.Pat_dot_term
                                                           uu____7838 in
                                                       pos uu____7837 in
                                                     (uu____7834, b)
                                                   else
                                                     (let uu____7847 =
                                                        let uu____7850 =
                                                          let uu____7851 =
>>>>>>> origin/master
                                                            FStar_Syntax_Syntax.gen_bv
                                                              (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                              None
                                                              FStar_Syntax_Syntax.tun in
                                                          FStar_Syntax_Syntax.Pat_wild
<<<<<<< HEAD
                                                            uu____7801 in
                                                        pos uu____7800 in
                                                      (uu____7797, b)))) in
                                   let pat_true =
                                     let uu____7813 =
                                       let uu____7816 =
                                         let uu____7817 =
                                           let uu____7825 =
=======
                                                            uu____7851 in
                                                        pos uu____7850 in
                                                      (uu____7847, b)))) in
                                   let pat_true =
                                     let uu____7863 =
                                       let uu____7866 =
                                         let uu____7867 =
                                           let uu____7875 =
>>>>>>> origin/master
                                             FStar_Syntax_Syntax.lid_as_fv
                                               lid
                                               FStar_Syntax_Syntax.Delta_constant
                                               (Some fvq) in
<<<<<<< HEAD
                                           (uu____7825, arg_pats) in
                                         FStar_Syntax_Syntax.Pat_cons
                                           uu____7817 in
                                       pos uu____7816 in
                                     (uu____7813, None,
                                       FStar_Syntax_Const.exp_true_bool) in
                                   let pat_false =
                                     let uu____7847 =
                                       let uu____7850 =
                                         let uu____7851 =
                                           FStar_Syntax_Syntax.new_bv None
                                             FStar_Syntax_Syntax.tun in
                                         FStar_Syntax_Syntax.Pat_wild
                                           uu____7851 in
                                       pos uu____7850 in
                                     (uu____7847, None,
=======
                                           (uu____7875, arg_pats) in
                                         FStar_Syntax_Syntax.Pat_cons
                                           uu____7867 in
                                       pos uu____7866 in
                                     (uu____7863, None,
                                       FStar_Syntax_Const.exp_true_bool) in
                                   let pat_false =
                                     let uu____7897 =
                                       let uu____7900 =
                                         let uu____7901 =
                                           FStar_Syntax_Syntax.new_bv None
                                             FStar_Syntax_Syntax.tun in
                                         FStar_Syntax_Syntax.Pat_wild
                                           uu____7901 in
                                       pos uu____7900 in
                                     (uu____7897, None,
>>>>>>> origin/master
                                       FStar_Syntax_Const.exp_false_bool) in
                                   let arg_exp =
                                     FStar_Syntax_Syntax.bv_to_name
                                       (fst unrefined_arg_binder) in
<<<<<<< HEAD
                                   let uu____7860 =
                                     let uu____7863 =
                                       let uu____7864 =
                                         let uu____7880 =
                                           let uu____7882 =
                                             FStar_Syntax_Util.branch
                                               pat_true in
                                           let uu____7883 =
                                             let uu____7885 =
                                               FStar_Syntax_Util.branch
                                                 pat_false in
                                             [uu____7885] in
                                           uu____7882 :: uu____7883 in
                                         (arg_exp, uu____7880) in
                                       FStar_Syntax_Syntax.Tm_match
                                         uu____7864 in
                                     FStar_Syntax_Syntax.mk uu____7863 in
                                   uu____7860 None p) in
                              let dd =
                                let uu____7896 =
                                  FStar_All.pipe_right quals
                                    (FStar_List.contains
                                       FStar_Syntax_Syntax.Abstract) in
                                if uu____7896
=======
                                   let uu____7910 =
                                     let uu____7913 =
                                       let uu____7914 =
                                         let uu____7930 =
                                           let uu____7932 =
                                             FStar_Syntax_Util.branch
                                               pat_true in
                                           let uu____7933 =
                                             let uu____7935 =
                                               FStar_Syntax_Util.branch
                                                 pat_false in
                                             [uu____7935] in
                                           uu____7932 :: uu____7933 in
                                         (arg_exp, uu____7930) in
                                       FStar_Syntax_Syntax.Tm_match
                                         uu____7914 in
                                     FStar_Syntax_Syntax.mk uu____7913 in
                                   uu____7910 None p) in
                              let dd =
                                let uu____7946 =
                                  FStar_All.pipe_right quals
                                    (FStar_List.contains
                                       FStar_Syntax_Syntax.Abstract) in
                                if uu____7946
>>>>>>> origin/master
                                then
                                  FStar_Syntax_Syntax.Delta_abstract
                                    FStar_Syntax_Syntax.Delta_equational
                                else FStar_Syntax_Syntax.Delta_equational in
                              let imp =
                                FStar_Syntax_Util.abs binders body None in
                              let lbtyp =
                                if no_decl
                                then t
                                else FStar_Syntax_Syntax.tun in
                              let lb =
<<<<<<< HEAD
                                let uu____7908 =
                                  let uu____7911 =
                                    FStar_Syntax_Syntax.lid_as_fv
                                      discriminator_name dd None in
                                  FStar_Util.Inr uu____7911 in
                                let uu____7912 =
                                  FStar_Syntax_Subst.close_univ_vars uvs imp in
                                {
                                  FStar_Syntax_Syntax.lbname = uu____7908;
=======
                                let uu____7958 =
                                  let uu____7961 =
                                    FStar_Syntax_Syntax.lid_as_fv
                                      discriminator_name dd None in
                                  FStar_Util.Inr uu____7961 in
                                let uu____7962 =
                                  FStar_Syntax_Subst.close_univ_vars uvs imp in
                                {
                                  FStar_Syntax_Syntax.lbname = uu____7958;
>>>>>>> origin/master
                                  FStar_Syntax_Syntax.lbunivs = uvs;
                                  FStar_Syntax_Syntax.lbtyp = lbtyp;
                                  FStar_Syntax_Syntax.lbeff =
                                    FStar_Syntax_Const.effect_Tot_lid;
<<<<<<< HEAD
                                  FStar_Syntax_Syntax.lbdef = uu____7912
                                } in
                              let impl =
                                let uu____7916 =
                                  let uu____7917 =
                                    let uu____7923 =
                                      let uu____7925 =
                                        let uu____7926 =
                                          FStar_All.pipe_right
                                            lb.FStar_Syntax_Syntax.lbname
                                            FStar_Util.right in
                                        FStar_All.pipe_right uu____7926
                                          (fun fv  ->
                                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v) in
                                      [uu____7925] in
                                    ((false, [lb]), uu____7923, []) in
                                  FStar_Syntax_Syntax.Sig_let uu____7917 in
                                {
                                  FStar_Syntax_Syntax.sigel = uu____7916;
=======
                                  FStar_Syntax_Syntax.lbdef = uu____7962
                                } in
                              let impl =
                                let uu____7966 =
                                  let uu____7967 =
                                    let uu____7973 =
                                      let uu____7975 =
                                        let uu____7976 =
                                          FStar_All.pipe_right
                                            lb.FStar_Syntax_Syntax.lbname
                                            FStar_Util.right in
                                        FStar_All.pipe_right uu____7976
                                          (fun fv  ->
                                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v) in
                                      [uu____7975] in
                                    ((false, [lb]), uu____7973, []) in
                                  FStar_Syntax_Syntax.Sig_let uu____7967 in
                                {
                                  FStar_Syntax_Syntax.sigel = uu____7966;
>>>>>>> origin/master
                                  FStar_Syntax_Syntax.sigrng = p;
                                  FStar_Syntax_Syntax.sigquals = quals;
                                  FStar_Syntax_Syntax.sigmeta =
                                    FStar_Syntax_Syntax.default_sigmeta
                                } in
<<<<<<< HEAD
                              (let uu____7941 =
                                 FStar_TypeChecker_Env.debug env
                                   (FStar_Options.Other "LogTypes") in
                               if uu____7941
                               then
                                 let uu____7942 =
                                   FStar_Syntax_Print.sigelt_to_string impl in
                                 FStar_Util.print1
                                   "Implementation of a discriminator %s\n"
                                   uu____7942
=======
                              (let uu____7991 =
                                 FStar_TypeChecker_Env.debug env
                                   (FStar_Options.Other "LogTypes") in
                               if uu____7991
                               then
                                 let uu____7992 =
                                   FStar_Syntax_Print.sigelt_to_string impl in
                                 FStar_Util.print1
                                   "Implementation of a discriminator %s\n"
                                   uu____7992
>>>>>>> origin/master
                               else ());
                              [decl; impl])) in
                      let arg_exp =
                        FStar_Syntax_Syntax.bv_to_name (fst arg_binder) in
                      let binders =
                        FStar_List.append imp_binders [arg_binder] in
                      let arg =
                        FStar_Syntax_Util.arg_of_non_null_binder arg_binder in
                      let subst1 =
                        FStar_All.pipe_right fields
                          (FStar_List.mapi
                             (fun i  ->
<<<<<<< HEAD
                                fun uu____7962  ->
                                  match uu____7962 with
                                  | (a,uu____7966) ->
                                      let uu____7967 =
                                        FStar_Syntax_Util.mk_field_projector_name
                                          lid a i in
                                      (match uu____7967 with
                                       | (field_name,uu____7971) ->
                                           let field_proj_tm =
                                             let uu____7973 =
                                               let uu____7974 =
=======
                                fun uu____8012  ->
                                  match uu____8012 with
                                  | (a,uu____8016) ->
                                      let uu____8017 =
                                        FStar_Syntax_Util.mk_field_projector_name
                                          lid a i in
                                      (match uu____8017 with
                                       | (field_name,uu____8021) ->
                                           let field_proj_tm =
                                             let uu____8023 =
                                               let uu____8024 =
>>>>>>> origin/master
                                                 FStar_Syntax_Syntax.lid_as_fv
                                                   field_name
                                                   FStar_Syntax_Syntax.Delta_equational
                                                   None in
                                               FStar_Syntax_Syntax.fv_to_tm
<<<<<<< HEAD
                                                 uu____7974 in
                                             FStar_Syntax_Syntax.mk_Tm_uinst
                                               uu____7973 inst_univs in
=======
                                                 uu____8024 in
                                             FStar_Syntax_Syntax.mk_Tm_uinst
                                               uu____8023 inst_univs in
>>>>>>> origin/master
                                           let proj =
                                             FStar_Syntax_Syntax.mk_Tm_app
                                               field_proj_tm [arg] None p in
                                           FStar_Syntax_Syntax.NT (a, proj)))) in
                      let projectors_ses =
<<<<<<< HEAD
                        let uu____7988 =
                          FStar_All.pipe_right fields
                            (FStar_List.mapi
                               (fun i  ->
                                  fun uu____7997  ->
                                    match uu____7997 with
                                    | (x,uu____8002) ->
                                        let p1 =
                                          FStar_Syntax_Syntax.range_of_bv x in
                                        let uu____8004 =
                                          FStar_Syntax_Util.mk_field_projector_name
                                            lid x i in
                                        (match uu____8004 with
                                         | (field_name,uu____8009) ->
                                             let t =
                                               let uu____8011 =
                                                 let uu____8012 =
                                                   let uu____8015 =
=======
                        let uu____8038 =
                          FStar_All.pipe_right fields
                            (FStar_List.mapi
                               (fun i  ->
                                  fun uu____8047  ->
                                    match uu____8047 with
                                    | (x,uu____8052) ->
                                        let p1 =
                                          FStar_Syntax_Syntax.range_of_bv x in
                                        let uu____8054 =
                                          FStar_Syntax_Util.mk_field_projector_name
                                            lid x i in
                                        (match uu____8054 with
                                         | (field_name,uu____8059) ->
                                             let t =
                                               let uu____8061 =
                                                 let uu____8062 =
                                                   let uu____8065 =
>>>>>>> origin/master
                                                     FStar_Syntax_Subst.subst
                                                       subst1
                                                       x.FStar_Syntax_Syntax.sort in
                                                   FStar_Syntax_Syntax.mk_Total
<<<<<<< HEAD
                                                     uu____8015 in
                                                 FStar_Syntax_Util.arrow
                                                   binders uu____8012 in
                                               FStar_All.pipe_left
                                                 (FStar_Syntax_Subst.close_univ_vars
                                                    uvs) uu____8011 in
                                             let only_decl =
                                               ((let uu____8017 =
=======
                                                     uu____8065 in
                                                 FStar_Syntax_Util.arrow
                                                   binders uu____8062 in
                                               FStar_All.pipe_left
                                                 (FStar_Syntax_Subst.close_univ_vars
                                                    uvs) uu____8061 in
                                             let only_decl =
                                               ((let uu____8067 =
>>>>>>> origin/master
                                                   FStar_TypeChecker_Env.current_module
                                                     env in
                                                 FStar_Ident.lid_equals
                                                   FStar_Syntax_Const.prims_lid
<<<<<<< HEAD
                                                   uu____8017)
=======
                                                   uu____8067)
>>>>>>> origin/master
                                                  ||
                                                  (fvq <>
                                                     FStar_Syntax_Syntax.Data_ctor))
                                                 ||
<<<<<<< HEAD
                                                 (let uu____8018 =
                                                    let uu____8019 =
                                                      FStar_TypeChecker_Env.current_module
                                                        env in
                                                    uu____8019.FStar_Ident.str in
                                                  FStar_Options.dont_gen_projectors
                                                    uu____8018) in
=======
                                                 (let uu____8068 =
                                                    let uu____8069 =
                                                      FStar_TypeChecker_Env.current_module
                                                        env in
                                                    uu____8069.FStar_Ident.str in
                                                  FStar_Options.dont_gen_projectors
                                                    uu____8068) in
>>>>>>> origin/master
                                             let no_decl = false in
                                             let quals q =
                                               if only_decl
                                               then
<<<<<<< HEAD
                                                 let uu____8029 =
                                                   FStar_List.filter
                                                     (fun uu___113_8031  ->
                                                        match uu___113_8031
                                                        with
                                                        | FStar_Syntax_Syntax.Abstract
                                                             -> false
                                                        | uu____8032 -> true)
                                                     q in
                                                 FStar_Syntax_Syntax.Assumption
                                                   :: uu____8029
=======
                                                 let uu____8079 =
                                                   FStar_List.filter
                                                     (fun uu___113_8081  ->
                                                        match uu___113_8081
                                                        with
                                                        | FStar_Syntax_Syntax.Abstract
                                                             -> false
                                                        | uu____8082 -> true)
                                                     q in
                                                 FStar_Syntax_Syntax.Assumption
                                                   :: uu____8079
>>>>>>> origin/master
                                               else q in
                                             let quals1 =
                                               let iquals1 =
                                                 FStar_All.pipe_right iquals
                                                   (FStar_List.filter
<<<<<<< HEAD
                                                      (fun uu___114_8040  ->
                                                         match uu___114_8040
=======
                                                      (fun uu___114_8090  ->
                                                         match uu___114_8090
>>>>>>> origin/master
                                                         with
                                                         | FStar_Syntax_Syntax.Abstract
                                                              -> true
                                                         | FStar_Syntax_Syntax.Private
                                                              -> true
<<<<<<< HEAD
                                                         | uu____8041 ->
=======
                                                         | uu____8091 ->
>>>>>>> origin/master
                                                             false)) in
                                               quals
                                                 ((FStar_Syntax_Syntax.Projector
                                                     (lid,
                                                       (x.FStar_Syntax_Syntax.ppname)))
                                                 :: iquals1) in
                                             let decl =
                                               {
                                                 FStar_Syntax_Syntax.sigel =
                                                   (FStar_Syntax_Syntax.Sig_declare_typ
                                                      (field_name, uvs, t));
                                                 FStar_Syntax_Syntax.sigrng =
                                                   (FStar_Ident.range_of_lid
                                                      field_name);
                                                 FStar_Syntax_Syntax.sigquals
                                                   = quals1;
                                                 FStar_Syntax_Syntax.sigmeta
                                                   =
                                                   FStar_Syntax_Syntax.default_sigmeta
                                               } in
<<<<<<< HEAD
                                             ((let uu____8044 =
=======
                                             ((let uu____8094 =
>>>>>>> origin/master
                                                 FStar_TypeChecker_Env.debug
                                                   env
                                                   (FStar_Options.Other
                                                      "LogTypes") in
<<<<<<< HEAD
                                               if uu____8044
                                               then
                                                 let uu____8045 =
=======
                                               if uu____8094
                                               then
                                                 let uu____8095 =
>>>>>>> origin/master
                                                   FStar_Syntax_Print.sigelt_to_string
                                                     decl in
                                                 FStar_Util.print1
                                                   "Declaration of a projector %s\n"
<<<<<<< HEAD
                                                   uu____8045
=======
                                                   uu____8095
>>>>>>> origin/master
                                               else ());
                                              if only_decl
                                              then [decl]
                                              else
                                                (let projection =
                                                   FStar_Syntax_Syntax.gen_bv
                                                     (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                     None
                                                     FStar_Syntax_Syntax.tun in
                                                 let arg_pats =
                                                   FStar_All.pipe_right
                                                     all_params
                                                     (FStar_List.mapi
                                                        (fun j  ->
<<<<<<< HEAD
                                                           fun uu____8072  ->
                                                             match uu____8072
=======
                                                           fun uu____8122  ->
                                                             match uu____8122
>>>>>>> origin/master
                                                             with
                                                             | (x1,imp) ->
                                                                 let b =
                                                                   FStar_Syntax_Syntax.is_implicit
                                                                    imp in
                                                                 if
                                                                   (i + ntps)
                                                                    = j
                                                                 then
<<<<<<< HEAD
                                                                   let uu____8088
=======
                                                                   let uu____8138
>>>>>>> origin/master
                                                                    =
                                                                    pos
                                                                    (FStar_Syntax_Syntax.Pat_var
                                                                    projection) in
<<<<<<< HEAD
                                                                   (uu____8088,
=======
                                                                   (uu____8138,
>>>>>>> origin/master
                                                                    b)
                                                                 else
                                                                   if
                                                                    b &&
                                                                    (j < ntps)
                                                                   then
<<<<<<< HEAD
                                                                    (let uu____8100
                                                                    =
                                                                    let uu____8103
                                                                    =
                                                                    let uu____8104
                                                                    =
                                                                    let uu____8109
=======
                                                                    (let uu____8150
                                                                    =
                                                                    let uu____8153
                                                                    =
                                                                    let uu____8154
                                                                    =
                                                                    let uu____8159
>>>>>>> origin/master
                                                                    =
                                                                    FStar_Syntax_Syntax.gen_bv
                                                                    (x1.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                                    None
                                                                    FStar_Syntax_Syntax.tun in
<<<<<<< HEAD
                                                                    (uu____8109,
                                                                    FStar_Syntax_Syntax.tun) in
                                                                    FStar_Syntax_Syntax.Pat_dot_term
                                                                    uu____8104 in
                                                                    pos
                                                                    uu____8103 in
                                                                    (uu____8100,
                                                                    b))
                                                                   else
                                                                    (let uu____8113
                                                                    =
                                                                    let uu____8116
                                                                    =
                                                                    let uu____8117
=======
                                                                    (uu____8159,
                                                                    FStar_Syntax_Syntax.tun) in
                                                                    FStar_Syntax_Syntax.Pat_dot_term
                                                                    uu____8154 in
                                                                    pos
                                                                    uu____8153 in
                                                                    (uu____8150,
                                                                    b))
                                                                   else
                                                                    (let uu____8163
                                                                    =
                                                                    let uu____8166
                                                                    =
                                                                    let uu____8167
>>>>>>> origin/master
                                                                    =
                                                                    FStar_Syntax_Syntax.gen_bv
                                                                    (x1.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                                    None
                                                                    FStar_Syntax_Syntax.tun in
                                                                    FStar_Syntax_Syntax.Pat_wild
<<<<<<< HEAD
                                                                    uu____8117 in
                                                                    pos
                                                                    uu____8116 in
                                                                    (uu____8113,
                                                                    b)))) in
                                                 let pat =
                                                   let uu____8129 =
                                                     let uu____8132 =
                                                       let uu____8133 =
                                                         let uu____8141 =
=======
                                                                    uu____8167 in
                                                                    pos
                                                                    uu____8166 in
                                                                    (uu____8163,
                                                                    b)))) in
                                                 let pat =
                                                   let uu____8179 =
                                                     let uu____8182 =
                                                       let uu____8183 =
                                                         let uu____8191 =
>>>>>>> origin/master
                                                           FStar_Syntax_Syntax.lid_as_fv
                                                             lid
                                                             FStar_Syntax_Syntax.Delta_constant
                                                             (Some fvq) in
<<<<<<< HEAD
                                                         (uu____8141,
                                                           arg_pats) in
                                                       FStar_Syntax_Syntax.Pat_cons
                                                         uu____8133 in
                                                     pos uu____8132 in
                                                   let uu____8147 =
                                                     FStar_Syntax_Syntax.bv_to_name
                                                       projection in
                                                   (uu____8129, None,
                                                     uu____8147) in
                                                 let body =
                                                   let uu____8158 =
                                                     let uu____8161 =
                                                       let uu____8162 =
                                                         let uu____8178 =
                                                           let uu____8180 =
                                                             FStar_Syntax_Util.branch
                                                               pat in
                                                           [uu____8180] in
                                                         (arg_exp,
                                                           uu____8178) in
                                                       FStar_Syntax_Syntax.Tm_match
                                                         uu____8162 in
                                                     FStar_Syntax_Syntax.mk
                                                       uu____8161 in
                                                   uu____8158 None p1 in
=======
                                                         (uu____8191,
                                                           arg_pats) in
                                                       FStar_Syntax_Syntax.Pat_cons
                                                         uu____8183 in
                                                     pos uu____8182 in
                                                   let uu____8197 =
                                                     FStar_Syntax_Syntax.bv_to_name
                                                       projection in
                                                   (uu____8179, None,
                                                     uu____8197) in
                                                 let body =
                                                   let uu____8208 =
                                                     let uu____8211 =
                                                       let uu____8212 =
                                                         let uu____8228 =
                                                           let uu____8230 =
                                                             FStar_Syntax_Util.branch
                                                               pat in
                                                           [uu____8230] in
                                                         (arg_exp,
                                                           uu____8228) in
                                                       FStar_Syntax_Syntax.Tm_match
                                                         uu____8212 in
                                                     FStar_Syntax_Syntax.mk
                                                       uu____8211 in
                                                   uu____8208 None p1 in
>>>>>>> origin/master
                                                 let imp =
                                                   FStar_Syntax_Util.abs
                                                     binders body None in
                                                 let dd =
<<<<<<< HEAD
                                                   let uu____8197 =
=======
                                                   let uu____8247 =
>>>>>>> origin/master
                                                     FStar_All.pipe_right
                                                       quals1
                                                       (FStar_List.contains
                                                          FStar_Syntax_Syntax.Abstract) in
<<<<<<< HEAD
                                                   if uu____8197
=======
                                                   if uu____8247
>>>>>>> origin/master
                                                   then
                                                     FStar_Syntax_Syntax.Delta_abstract
                                                       FStar_Syntax_Syntax.Delta_equational
                                                   else
                                                     FStar_Syntax_Syntax.Delta_equational in
                                                 let lbtyp =
                                                   if no_decl
                                                   then t
                                                   else
                                                     FStar_Syntax_Syntax.tun in
                                                 let lb =
<<<<<<< HEAD
                                                   let uu____8203 =
                                                     let uu____8206 =
                                                       FStar_Syntax_Syntax.lid_as_fv
                                                         field_name dd None in
                                                     FStar_Util.Inr
                                                       uu____8206 in
                                                   let uu____8207 =
=======
                                                   let uu____8253 =
                                                     let uu____8256 =
                                                       FStar_Syntax_Syntax.lid_as_fv
                                                         field_name dd None in
                                                     FStar_Util.Inr
                                                       uu____8256 in
                                                   let uu____8257 =
>>>>>>> origin/master
                                                     FStar_Syntax_Subst.close_univ_vars
                                                       uvs imp in
                                                   {
                                                     FStar_Syntax_Syntax.lbname
<<<<<<< HEAD
                                                       = uu____8203;
=======
                                                       = uu____8253;
>>>>>>> origin/master
                                                     FStar_Syntax_Syntax.lbunivs
                                                       = uvs;
                                                     FStar_Syntax_Syntax.lbtyp
                                                       = lbtyp;
                                                     FStar_Syntax_Syntax.lbeff
                                                       =
                                                       FStar_Syntax_Const.effect_Tot_lid;
                                                     FStar_Syntax_Syntax.lbdef
<<<<<<< HEAD
                                                       = uu____8207
                                                   } in
                                                 let impl =
                                                   let uu____8211 =
                                                     let uu____8212 =
                                                       let uu____8218 =
                                                         let uu____8220 =
                                                           let uu____8221 =
=======
                                                       = uu____8257
                                                   } in
                                                 let impl =
                                                   let uu____8261 =
                                                     let uu____8262 =
                                                       let uu____8268 =
                                                         let uu____8270 =
                                                           let uu____8271 =
>>>>>>> origin/master
                                                             FStar_All.pipe_right
                                                               lb.FStar_Syntax_Syntax.lbname
                                                               FStar_Util.right in
                                                           FStar_All.pipe_right
<<<<<<< HEAD
                                                             uu____8221
                                                             (fun fv  ->
                                                                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v) in
                                                         [uu____8220] in
                                                       ((false, [lb]),
                                                         uu____8218, []) in
                                                     FStar_Syntax_Syntax.Sig_let
                                                       uu____8212 in
                                                   {
                                                     FStar_Syntax_Syntax.sigel
                                                       = uu____8211;
=======
                                                             uu____8271
                                                             (fun fv  ->
                                                                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v) in
                                                         [uu____8270] in
                                                       ((false, [lb]),
                                                         uu____8268, []) in
                                                     FStar_Syntax_Syntax.Sig_let
                                                       uu____8262 in
                                                   {
                                                     FStar_Syntax_Syntax.sigel
                                                       = uu____8261;
>>>>>>> origin/master
                                                     FStar_Syntax_Syntax.sigrng
                                                       = p1;
                                                     FStar_Syntax_Syntax.sigquals
                                                       = quals1;
                                                     FStar_Syntax_Syntax.sigmeta
                                                       =
                                                       FStar_Syntax_Syntax.default_sigmeta
                                                   } in
<<<<<<< HEAD
                                                 (let uu____8236 =
=======
                                                 (let uu____8286 =
>>>>>>> origin/master
                                                    FStar_TypeChecker_Env.debug
                                                      env
                                                      (FStar_Options.Other
                                                         "LogTypes") in
<<<<<<< HEAD
                                                  if uu____8236
                                                  then
                                                    let uu____8237 =
=======
                                                  if uu____8286
                                                  then
                                                    let uu____8287 =
>>>>>>> origin/master
                                                      FStar_Syntax_Print.sigelt_to_string
                                                        impl in
                                                    FStar_Util.print1
                                                      "Implementation of a projector %s\n"
<<<<<<< HEAD
                                                      uu____8237
=======
                                                      uu____8287
>>>>>>> origin/master
                                                  else ());
                                                 if no_decl
                                                 then [impl]
                                                 else [decl; impl]))))) in
<<<<<<< HEAD
                        FStar_All.pipe_right uu____7988 FStar_List.flatten in
=======
                        FStar_All.pipe_right uu____8038 FStar_List.flatten in
>>>>>>> origin/master
                      FStar_List.append discriminator_ses projectors_ses
let mk_data_operations:
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.sigelt Prims.list ->
        FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt Prims.list
  =
  fun iquals  ->
    fun env  ->
      fun tcs  ->
        fun se  ->
          match se.FStar_Syntax_Syntax.sigel with
          | FStar_Syntax_Syntax.Sig_datacon
<<<<<<< HEAD
              (constr_lid,uvs,t,typ_lid,n_typars,uu____8267) when
=======
              (constr_lid,uvs,t,typ_lid,n_typars,uu____8317) when
>>>>>>> origin/master
              Prims.op_Negation
                (FStar_Ident.lid_equals constr_lid
                   FStar_Syntax_Const.lexcons_lid)
              ->
<<<<<<< HEAD
              let uu____8270 = FStar_Syntax_Subst.univ_var_opening uvs in
              (match uu____8270 with
               | (univ_opening,uvs1) ->
                   let t1 = FStar_Syntax_Subst.subst univ_opening t in
                   let uu____8283 = FStar_Syntax_Util.arrow_formals t1 in
                   (match uu____8283 with
                    | (formals,uu____8293) ->
                        let uu____8304 =
                          let tps_opt =
                            FStar_Util.find_map tcs
                              (fun se1  ->
                                 let uu____8317 =
                                   let uu____8318 =
                                     let uu____8319 =
                                       FStar_Syntax_Util.lid_of_sigelt se1 in
                                     FStar_Util.must uu____8319 in
                                   FStar_Ident.lid_equals typ_lid uu____8318 in
                                 if uu____8317
                                 then
                                   match se1.FStar_Syntax_Syntax.sigel with
                                   | FStar_Syntax_Syntax.Sig_inductive_typ
                                       (uu____8329,uvs',tps,typ0,uu____8333,constrs)
=======
              let uu____8320 = FStar_Syntax_Subst.univ_var_opening uvs in
              (match uu____8320 with
               | (univ_opening,uvs1) ->
                   let t1 = FStar_Syntax_Subst.subst univ_opening t in
                   let uu____8333 = FStar_Syntax_Util.arrow_formals t1 in
                   (match uu____8333 with
                    | (formals,uu____8343) ->
                        let uu____8354 =
                          let tps_opt =
                            FStar_Util.find_map tcs
                              (fun se1  ->
                                 let uu____8367 =
                                   let uu____8368 =
                                     let uu____8369 =
                                       FStar_Syntax_Util.lid_of_sigelt se1 in
                                     FStar_Util.must uu____8369 in
                                   FStar_Ident.lid_equals typ_lid uu____8368 in
                                 if uu____8367
                                 then
                                   match se1.FStar_Syntax_Syntax.sigel with
                                   | FStar_Syntax_Syntax.Sig_inductive_typ
                                       (uu____8379,uvs',tps,typ0,uu____8383,constrs)
>>>>>>> origin/master
                                       ->
                                       Some
                                         (tps, typ0,
                                           ((FStar_List.length constrs) >
                                              (Prims.parse_int "1")))
<<<<<<< HEAD
                                   | uu____8346 -> failwith "Impossible"
=======
                                   | uu____8396 -> failwith "Impossible"
>>>>>>> origin/master
                                 else None) in
                          match tps_opt with
                          | Some x -> x
                          | None  ->
                              if
                                FStar_Ident.lid_equals typ_lid
                                  FStar_Syntax_Const.exn_lid
                              then ([], FStar_Syntax_Util.ktype0, true)
                              else
                                raise
                                  (FStar_Errors.Error
                                     ("Unexpected data constructor",
                                       (se.FStar_Syntax_Syntax.sigrng))) in
<<<<<<< HEAD
                        (match uu____8304 with
=======
                        (match uu____8354 with
>>>>>>> origin/master
                         | (inductive_tps,typ0,should_refine) ->
                             let inductive_tps1 =
                               FStar_Syntax_Subst.subst_binders univ_opening
                                 inductive_tps in
                             let typ01 =
                               FStar_Syntax_Subst.subst univ_opening typ0 in
<<<<<<< HEAD
                             let uu____8388 =
                               FStar_Syntax_Util.arrow_formals typ01 in
                             (match uu____8388 with
                              | (indices,uu____8398) ->
                                  let refine_domain =
                                    let uu____8410 =
                                      FStar_All.pipe_right
                                        se.FStar_Syntax_Syntax.sigquals
                                        (FStar_Util.for_some
                                           (fun uu___115_8412  ->
                                              match uu___115_8412 with
                                              | FStar_Syntax_Syntax.RecordConstructor
                                                  uu____8413 -> true
                                              | uu____8418 -> false)) in
                                    if uu____8410
                                    then false
                                    else should_refine in
                                  let fv_qual =
                                    let filter_records uu___116_8425 =
                                      match uu___116_8425 with
                                      | FStar_Syntax_Syntax.RecordConstructor
                                          (uu____8427,fns) ->
                                          Some
                                            (FStar_Syntax_Syntax.Record_ctor
                                               (constr_lid, fns))
                                      | uu____8434 -> None in
                                    let uu____8435 =
                                      FStar_Util.find_map
                                        se.FStar_Syntax_Syntax.sigquals
                                        filter_records in
                                    match uu____8435 with
=======
                             let uu____8438 =
                               FStar_Syntax_Util.arrow_formals typ01 in
                             (match uu____8438 with
                              | (indices,uu____8448) ->
                                  let refine_domain =
                                    let uu____8460 =
                                      FStar_All.pipe_right
                                        se.FStar_Syntax_Syntax.sigquals
                                        (FStar_Util.for_some
                                           (fun uu___115_8462  ->
                                              match uu___115_8462 with
                                              | FStar_Syntax_Syntax.RecordConstructor
                                                  uu____8463 -> true
                                              | uu____8468 -> false)) in
                                    if uu____8460
                                    then false
                                    else should_refine in
                                  let fv_qual =
                                    let filter_records uu___116_8475 =
                                      match uu___116_8475 with
                                      | FStar_Syntax_Syntax.RecordConstructor
                                          (uu____8477,fns) ->
                                          Some
                                            (FStar_Syntax_Syntax.Record_ctor
                                               (constr_lid, fns))
                                      | uu____8484 -> None in
                                    let uu____8485 =
                                      FStar_Util.find_map
                                        se.FStar_Syntax_Syntax.sigquals
                                        filter_records in
                                    match uu____8485 with
>>>>>>> origin/master
                                    | None  -> FStar_Syntax_Syntax.Data_ctor
                                    | Some q -> q in
                                  let iquals1 =
                                    if
                                      FStar_List.contains
                                        FStar_Syntax_Syntax.Abstract iquals
                                    then FStar_Syntax_Syntax.Private ::
                                      iquals
                                    else iquals in
                                  let fields =
<<<<<<< HEAD
                                    let uu____8443 =
                                      FStar_Util.first_N n_typars formals in
                                    match uu____8443 with
                                    | (imp_tps,fields) ->
                                        let rename =
                                          FStar_List.map2
                                            (fun uu____8474  ->
                                               fun uu____8475  ->
                                                 match (uu____8474,
                                                         uu____8475)
                                                 with
                                                 | ((x,uu____8485),(x',uu____8487))
                                                     ->
                                                     let uu____8492 =
                                                       let uu____8497 =
                                                         FStar_Syntax_Syntax.bv_to_name
                                                           x' in
                                                       (x, uu____8497) in
                                                     FStar_Syntax_Syntax.NT
                                                       uu____8492) imp_tps
=======
                                    let uu____8493 =
                                      FStar_Util.first_N n_typars formals in
                                    match uu____8493 with
                                    | (imp_tps,fields) ->
                                        let rename =
                                          FStar_List.map2
                                            (fun uu____8524  ->
                                               fun uu____8525  ->
                                                 match (uu____8524,
                                                         uu____8525)
                                                 with
                                                 | ((x,uu____8535),(x',uu____8537))
                                                     ->
                                                     let uu____8542 =
                                                       let uu____8547 =
                                                         FStar_Syntax_Syntax.bv_to_name
                                                           x' in
                                                       (x, uu____8547) in
                                                     FStar_Syntax_Syntax.NT
                                                       uu____8542) imp_tps
>>>>>>> origin/master
                                            inductive_tps1 in
                                        FStar_Syntax_Subst.subst_binders
                                          rename fields in
                                  mk_discriminator_and_indexed_projectors
                                    iquals1 fv_qual refine_domain env typ_lid
                                    constr_lid uvs1 inductive_tps1 indices
                                    fields))))
<<<<<<< HEAD
          | uu____8498 -> []
=======
          | uu____8548 -> []
>>>>>>> origin/master
