
open Prims
# 56 "FStar.Syntax.Subst.fst"
let rec force_uvar : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_uvar (uv, _31_11) -> begin
(match ((FStar_Unionfind.find uv)) with
| FStar_Syntax_Syntax.Fixed (t') -> begin
(force_uvar t')
end
| _31_17 -> begin
t
end)
end
| _31_19 -> begin
t
end))

# 65 "FStar.Syntax.Subst.fst"
let rec force_delayed_thunk : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (f, m) -> begin
(match ((FStar_ST.read m)) with
| None -> begin
(match (f) with
| FStar_Util.Inr (c) -> begin
(
# 70 "FStar.Syntax.Subst.fst"
let t' = (let _113_8 = (c ())
in (force_delayed_thunk _113_8))
in (
# 70 "FStar.Syntax.Subst.fst"
let _31_29 = (FStar_ST.op_Colon_Equals m (Some (t')))
in t'))
end
| _31_32 -> begin
t
end)
end
| Some (t') -> begin
(
# 73 "FStar.Syntax.Subst.fst"
let t' = (force_delayed_thunk t')
in (
# 73 "FStar.Syntax.Subst.fst"
let _31_36 = (FStar_ST.op_Colon_Equals m (Some (t')))
in t'))
end)
end
| _31_39 -> begin
t
end))

# 76 "FStar.Syntax.Subst.fst"
let rec compress_univ : FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun u -> (match (u) with
| FStar_Syntax_Syntax.U_unif (u') -> begin
(match ((FStar_Unionfind.find u')) with
| Some (u) -> begin
(compress_univ u)
end
| _31_46 -> begin
u
end)
end
| _31_48 -> begin
u
end))

# 88 "FStar.Syntax.Subst.fst"
let subst_to_string = (fun s -> (let _113_15 = (FStar_All.pipe_right s (FStar_List.map (fun _31_53 -> (match (_31_53) with
| (b, _31_52) -> begin
b.FStar_Syntax_Syntax.ppname.FStar_Ident.idText
end))))
in (FStar_All.pipe_right _113_15 (FStar_String.concat ", "))))

# 91 "FStar.Syntax.Subst.fst"
let subst_bv : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term Prims.option = (fun a s -> (FStar_Util.find_map s (fun _31_1 -> (match (_31_1) with
| FStar_Syntax_Syntax.DB (i, x) when (i = a.FStar_Syntax_Syntax.index) -> begin
(let _113_23 = (let _113_22 = (let _113_21 = (FStar_Syntax_Syntax.range_of_bv a)
in (FStar_Syntax_Syntax.set_range_of_bv x _113_21))
in (FStar_Syntax_Syntax.bv_to_name _113_22))
in Some (_113_23))
end
| _31_62 -> begin
None
end))))

# 95 "FStar.Syntax.Subst.fst"
let subst_nm : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term Prims.option = (fun a s -> (FStar_Util.find_map s (fun _31_2 -> (match (_31_2) with
| FStar_Syntax_Syntax.NM (x, i) when (FStar_Syntax_Syntax.bv_eq a x) -> begin
(let _113_29 = (FStar_Syntax_Syntax.bv_to_tm (
# 96 "FStar.Syntax.Subst.fst"
let _31_70 = a
in {FStar_Syntax_Syntax.ppname = _31_70.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = i; FStar_Syntax_Syntax.sort = _31_70.FStar_Syntax_Syntax.sort}))
in Some (_113_29))
end
| FStar_Syntax_Syntax.NT (x, t) when (FStar_Syntax_Syntax.bv_eq a x) -> begin
Some (t)
end
| _31_77 -> begin
None
end))))

# 99 "FStar.Syntax.Subst.fst"
let subst_univ_bv : Prims.int  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.universe Prims.option = (fun x s -> (FStar_Util.find_map s (fun _31_3 -> (match (_31_3) with
| FStar_Syntax_Syntax.UN (y, t) when (x = y) -> begin
Some (t)
end
| _31_86 -> begin
None
end))))

# 102 "FStar.Syntax.Subst.fst"
let subst_univ_nm : FStar_Syntax_Syntax.univ_name  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.universe Prims.option = (fun x s -> (FStar_Util.find_map s (fun _31_4 -> (match (_31_4) with
| FStar_Syntax_Syntax.UD (y, i) when (x.FStar_Ident.idText = y.FStar_Ident.idText) -> begin
Some (FStar_Syntax_Syntax.U_bvar (i))
end
| _31_95 -> begin
None
end))))

# 109 "FStar.Syntax.Subst.fst"
let rec apply_until_some = (fun f s -> (match (s) with
| [] -> begin
None
end
| s0::rest -> begin
(match ((f s0)) with
| None -> begin
(apply_until_some f rest)
end
| Some (st) -> begin
Some ((rest, st))
end)
end))

# 116 "FStar.Syntax.Subst.fst"
let map_some_curry = (fun f x _31_5 -> (match (_31_5) with
| None -> begin
x
end
| Some (a, b) -> begin
(f a b)
end))

# 120 "FStar.Syntax.Subst.fst"
let apply_until_some_then_map = (fun f s g t -> (let _113_67 = (apply_until_some f s)
in (FStar_All.pipe_right _113_67 (map_some_curry g t))))

# 124 "FStar.Syntax.Subst.fst"
let rec subst_univ : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun s u -> (
# 125 "FStar.Syntax.Subst.fst"
let u = (compress_univ u)
in (match (u) with
| FStar_Syntax_Syntax.U_bvar (x) -> begin
(apply_until_some_then_map (subst_univ_bv x) s subst_univ u)
end
| FStar_Syntax_Syntax.U_name (x) -> begin
(apply_until_some_then_map (subst_univ_nm x) s subst_univ u)
end
| (FStar_Syntax_Syntax.U_zero) | (FStar_Syntax_Syntax.U_unknown) | (FStar_Syntax_Syntax.U_unif (_)) -> begin
u
end
| FStar_Syntax_Syntax.U_succ (u) -> begin
(let _113_72 = (subst_univ s u)
in FStar_Syntax_Syntax.U_succ (_113_72))
end
| FStar_Syntax_Syntax.U_max (us) -> begin
(let _113_73 = (FStar_List.map (subst_univ s) us)
in FStar_Syntax_Syntax.U_max (_113_73))
end)))

# 140 "FStar.Syntax.Subst.fst"
let rec subst' : FStar_Syntax_Syntax.subst_ts  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun s t -> (match (s) with
| ([]) | ([]::[]) -> begin
t
end
| _31_139 -> begin
(
# 144 "FStar.Syntax.Subst.fst"
let t0 = (force_delayed_thunk t)
in (match (t0.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_uvar (_)) -> begin
t0
end
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t', s'), m) -> begin
(FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl ((t', (FStar_List.append s' s)))) t.FStar_Syntax_Syntax.pos)
end
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inr (_31_158), _31_161) -> begin
(FStar_All.failwith "Impossible: force_delayed_thunk removes lazy delayed nodes")
end
| FStar_Syntax_Syntax.Tm_bvar (a) -> begin
(apply_until_some_then_map (subst_bv a) s subst' t0)
end
| FStar_Syntax_Syntax.Tm_name (a) -> begin
(apply_until_some_then_map (subst_nm a) s subst' t0)
end
| FStar_Syntax_Syntax.Tm_type (u) -> begin
(let _113_89 = (let _113_88 = (subst_univ s u)
in FStar_Syntax_Syntax.Tm_type (_113_88))
in (FStar_Syntax_Syntax.mk _113_89 None t0.FStar_Syntax_Syntax.pos))
end
| _31_171 -> begin
(FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl ((t0, s))) t.FStar_Syntax_Syntax.pos)
end))
end))
and subst_flags' : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.cflags Prims.list  ->  FStar_Syntax_Syntax.cflags Prims.list = (fun s flags -> (FStar_All.pipe_right flags (FStar_List.map (fun _31_6 -> (match (_31_6) with
| FStar_Syntax_Syntax.DECREASES (a) -> begin
(let _113_94 = (subst' s a)
in FStar_Syntax_Syntax.DECREASES (_113_94))
end
| f -> begin
f
end)))))
and subst_comp_typ' : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  FStar_Syntax_Syntax.comp_typ  ->  FStar_Syntax_Syntax.comp_typ = (fun s t -> (match (s) with
| ([]) | ([]::[]) -> begin
t
end
| _31_184 -> begin
(
# 180 "FStar.Syntax.Subst.fst"
let _31_185 = t
in (let _113_101 = (subst' s t.FStar_Syntax_Syntax.result_typ)
in (let _113_100 = (FStar_List.map (fun _31_189 -> (match (_31_189) with
| (t, imp) -> begin
(let _113_98 = (subst' s t)
in (_113_98, imp))
end)) t.FStar_Syntax_Syntax.effect_args)
in (let _113_99 = (subst_flags' s t.FStar_Syntax_Syntax.flags)
in {FStar_Syntax_Syntax.effect_name = _31_185.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = _113_101; FStar_Syntax_Syntax.effect_args = _113_100; FStar_Syntax_Syntax.flags = _113_99}))))
end))
and subst_comp' : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax = (fun s t -> (match (s) with
| ([]) | ([]::[]) -> begin
t
end
| _31_196 -> begin
(match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (t) -> begin
(let _113_104 = (subst' s t)
in (FStar_Syntax_Syntax.mk_Total _113_104))
end
| FStar_Syntax_Syntax.GTotal (t) -> begin
(let _113_105 = (subst' s t)
in (FStar_Syntax_Syntax.mk_GTotal _113_105))
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(let _113_106 = (subst_comp_typ' s ct)
in (FStar_Syntax_Syntax.mk_Comp _113_106))
end)
end))
and compose_subst : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.subst_elt Prims.list Prims.list = (fun s1 s2 -> (FStar_List.append s1 s2))

# 195 "FStar.Syntax.Subst.fst"
let shift : Prims.int  ->  FStar_Syntax_Syntax.subst_elt  ->  FStar_Syntax_Syntax.subst_elt = (fun n s -> (match (s) with
| FStar_Syntax_Syntax.DB (i, t) -> begin
FStar_Syntax_Syntax.DB (((i + n), t))
end
| FStar_Syntax_Syntax.UN (i, t) -> begin
FStar_Syntax_Syntax.UN (((i + n), t))
end
| FStar_Syntax_Syntax.NM (x, i) -> begin
FStar_Syntax_Syntax.NM ((x, (i + n)))
end
| FStar_Syntax_Syntax.UD (x, i) -> begin
FStar_Syntax_Syntax.UD ((x, (i + n)))
end
| FStar_Syntax_Syntax.NT (_31_224) -> begin
s
end))

# 201 "FStar.Syntax.Subst.fst"
let shift_subst : Prims.int  ->  FStar_Syntax_Syntax.subst_t  ->  FStar_Syntax_Syntax.subst_t = (fun n s -> (FStar_List.map (shift n) s))

# 202 "FStar.Syntax.Subst.fst"
let shift_subst' : Prims.int  ->  FStar_Syntax_Syntax.subst_t Prims.list  ->  FStar_Syntax_Syntax.subst_t Prims.list = (fun n s -> (FStar_All.pipe_right s (FStar_List.map (shift_subst n))))

# 203 "FStar.Syntax.Subst.fst"
let subst_binder' = (fun s _31_233 -> (match (_31_233) with
| (x, imp) -> begin
(let _113_124 = (
# 203 "FStar.Syntax.Subst.fst"
let _31_234 = x
in (let _113_123 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_234.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_234.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_123}))
in (_113_124, imp))
end))

# 204 "FStar.Syntax.Subst.fst"
let subst_binders' = (fun s bs -> (FStar_All.pipe_right bs (FStar_List.mapi (fun i b -> if (i = 0) then begin
(subst_binder' s b)
end else begin
(let _113_129 = (shift_subst' i s)
in (subst_binder' _113_129 b))
end))))

# 208 "FStar.Syntax.Subst.fst"
let subst_arg' = (fun s _31_243 -> (match (_31_243) with
| (t, imp) -> begin
(let _113_132 = (subst' s t)
in (_113_132, imp))
end))

# 209 "FStar.Syntax.Subst.fst"
let subst_args' = (fun s -> (FStar_List.map (subst_arg' s)))

# 210 "FStar.Syntax.Subst.fst"
let subst_pat' : FStar_Syntax_Syntax.subst_t Prims.list  ->  (FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t  ->  (FStar_Syntax_Syntax.pat * Prims.int) = (fun s p -> (
# 211 "FStar.Syntax.Subst.fst"
let rec aux = (fun n p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_31_253) -> begin
(p, n)
end
| FStar_Syntax_Syntax.Pat_disj (p::ps) -> begin
(
# 217 "FStar.Syntax.Subst.fst"
let _31_261 = (aux n p)
in (match (_31_261) with
| (p, m) -> begin
(
# 218 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (fun p -> (let _113_145 = (aux n p)
in (Prims.fst _113_145))) ps)
in ((
# 219 "FStar.Syntax.Subst.fst"
let _31_264 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _31_264.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_264.FStar_Syntax_Syntax.p}), m))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 222 "FStar.Syntax.Subst.fst"
let _31_281 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _31_272 _31_275 -> (match ((_31_272, _31_275)) with
| ((pats, n), (p, imp)) -> begin
(
# 223 "FStar.Syntax.Subst.fst"
let _31_278 = (aux n p)
in (match (_31_278) with
| (p, m) -> begin
(((p, imp))::pats, m)
end))
end)) ([], n)))
in (match (_31_281) with
| (pats, n) -> begin
((
# 225 "FStar.Syntax.Subst.fst"
let _31_282 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons ((fv, (FStar_List.rev pats))); FStar_Syntax_Syntax.ty = _31_282.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_282.FStar_Syntax_Syntax.p}), n)
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 228 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 229 "FStar.Syntax.Subst.fst"
let x = (
# 229 "FStar.Syntax.Subst.fst"
let _31_287 = x
in (let _113_148 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_287.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_287.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_148}))
in ((
# 230 "FStar.Syntax.Subst.fst"
let _31_290 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x); FStar_Syntax_Syntax.ty = _31_290.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_290.FStar_Syntax_Syntax.p}), (n + 1))))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 233 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 234 "FStar.Syntax.Subst.fst"
let x = (
# 234 "FStar.Syntax.Subst.fst"
let _31_295 = x
in (let _113_149 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_295.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_295.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_149}))
in ((
# 235 "FStar.Syntax.Subst.fst"
let _31_298 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x); FStar_Syntax_Syntax.ty = _31_298.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_298.FStar_Syntax_Syntax.p}), (n + 1))))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 238 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 239 "FStar.Syntax.Subst.fst"
let x = (
# 239 "FStar.Syntax.Subst.fst"
let _31_305 = x
in (let _113_150 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_305.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_305.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_150}))
in (
# 240 "FStar.Syntax.Subst.fst"
let t0 = (subst' s t0)
in ((
# 241 "FStar.Syntax.Subst.fst"
let _31_309 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_309.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_309.FStar_Syntax_Syntax.p}), n))))
end))
in (aux 0 p)))

# 244 "FStar.Syntax.Subst.fst"
let push_subst_lcomp : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.lcomp Prims.option  ->  FStar_Syntax_Syntax.lcomp Prims.option = (fun s lopt -> (match (lopt) with
| None -> begin
None
end
| Some (l) -> begin
(let _113_158 = (
# 247 "FStar.Syntax.Subst.fst"
let _31_316 = l
in (let _113_157 = (subst' s l.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _31_316.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _113_157; FStar_Syntax_Syntax.cflags = _31_316.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _31_318 -> (match (()) with
| () -> begin
(let _113_156 = (l.FStar_Syntax_Syntax.comp ())
in (subst_comp' s _113_156))
end))}))
in Some (_113_158))
end))

# 250 "FStar.Syntax.Subst.fst"
let push_subst : FStar_Syntax_Syntax.subst_ts  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun s t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (_31_322) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_unknown) | (FStar_Syntax_Syntax.Tm_uvar (_)) -> begin
t
end
| (FStar_Syntax_Syntax.Tm_type (_)) | (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_name (_)) -> begin
(subst' s t)
end
| FStar_Syntax_Syntax.Tm_uinst (t', us) -> begin
(
# 266 "FStar.Syntax.Subst.fst"
let us = (FStar_List.map (subst_univ s) us)
in (FStar_Syntax_Syntax.mk_Tm_uinst t' us))
end
| FStar_Syntax_Syntax.Tm_app (t0, args) -> begin
(let _113_169 = (let _113_168 = (let _113_167 = (subst' s t0)
in (let _113_166 = (subst_args' s args)
in (_113_167, _113_166)))
in FStar_Syntax_Syntax.Tm_app (_113_168))
in (FStar_Syntax_Syntax.mk _113_169 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_ascribed (t0, t1, lopt) -> begin
(let _113_173 = (let _113_172 = (let _113_171 = (subst' s t0)
in (let _113_170 = (subst' s t1)
in (_113_171, _113_170, lopt)))
in FStar_Syntax_Syntax.Tm_ascribed (_113_172))
in (FStar_Syntax_Syntax.mk _113_173 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_abs (bs, body, lopt) -> begin
(
# 274 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length bs)
in (
# 275 "FStar.Syntax.Subst.fst"
let s' = (shift_subst' n s)
in (let _113_178 = (let _113_177 = (let _113_176 = (subst_binders' s bs)
in (let _113_175 = (subst' s' body)
in (let _113_174 = (push_subst_lcomp s' lopt)
in (_113_176, _113_175, _113_174))))
in FStar_Syntax_Syntax.Tm_abs (_113_177))
in (FStar_Syntax_Syntax.mk _113_178 None t.FStar_Syntax_Syntax.pos))))
end
| FStar_Syntax_Syntax.Tm_arrow (bs, comp) -> begin
(
# 279 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length bs)
in (let _113_183 = (let _113_182 = (let _113_181 = (subst_binders' s bs)
in (let _113_180 = (let _113_179 = (shift_subst' n s)
in (subst_comp' _113_179 comp))
in (_113_181, _113_180)))
in FStar_Syntax_Syntax.Tm_arrow (_113_182))
in (FStar_Syntax_Syntax.mk _113_183 None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_refine (x, phi) -> begin
(
# 283 "FStar.Syntax.Subst.fst"
let x = (
# 283 "FStar.Syntax.Subst.fst"
let _31_373 = x
in (let _113_184 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_373.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_373.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_184}))
in (
# 284 "FStar.Syntax.Subst.fst"
let phi = (let _113_185 = (shift_subst' 1 s)
in (subst' _113_185 phi))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_refine ((x, phi))) None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_match (t0, pats) -> begin
(
# 288 "FStar.Syntax.Subst.fst"
let t0 = (subst' s t0)
in (
# 289 "FStar.Syntax.Subst.fst"
let pats = (FStar_All.pipe_right pats (FStar_List.map (fun _31_385 -> (match (_31_385) with
| (pat, wopt, branch) -> begin
(
# 290 "FStar.Syntax.Subst.fst"
let _31_388 = (subst_pat' s pat)
in (match (_31_388) with
| (pat, n) -> begin
(
# 291 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 292 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _113_187 = (subst' s w)
in Some (_113_187))
end)
in (
# 295 "FStar.Syntax.Subst.fst"
let branch = (subst' s branch)
in (pat, wopt, branch))))
end))
end))))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_match ((t0, pats))) None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_let ((is_rec, lbs), body) -> begin
(
# 300 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length lbs)
in (
# 301 "FStar.Syntax.Subst.fst"
let sn = (shift_subst' n s)
in (
# 302 "FStar.Syntax.Subst.fst"
let body = (subst' sn body)
in (
# 303 "FStar.Syntax.Subst.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (fun lb -> (
# 304 "FStar.Syntax.Subst.fst"
let lbt = (subst' s lb.FStar_Syntax_Syntax.lbtyp)
in (
# 305 "FStar.Syntax.Subst.fst"
let lbd = if (is_rec && (FStar_Util.is_left lb.FStar_Syntax_Syntax.lbname)) then begin
(subst' sn lb.FStar_Syntax_Syntax.lbdef)
end else begin
(subst' s lb.FStar_Syntax_Syntax.lbdef)
end
in (
# 308 "FStar.Syntax.Subst.fst"
let _31_408 = lb
in {FStar_Syntax_Syntax.lbname = _31_408.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _31_408.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = lbt; FStar_Syntax_Syntax.lbeff = _31_408.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = lbd}))))))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_let (((is_rec, lbs), body))) None t.FStar_Syntax_Syntax.pos)))))
end
| FStar_Syntax_Syntax.Tm_meta (t0, FStar_Syntax_Syntax.Meta_pattern (ps)) -> begin
(let _113_193 = (let _113_192 = (let _113_191 = (subst' s t0)
in (let _113_190 = (let _113_189 = (FStar_All.pipe_right ps (FStar_List.map (subst_args' s)))
in FStar_Syntax_Syntax.Meta_pattern (_113_189))
in (_113_191, _113_190)))
in FStar_Syntax_Syntax.Tm_meta (_113_192))
in (FStar_Syntax_Syntax.mk _113_193 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_meta (t, m) -> begin
(let _113_196 = (let _113_195 = (let _113_194 = (subst' s t)
in (_113_194, m))
in FStar_Syntax_Syntax.Tm_meta (_113_195))
in (FStar_Syntax_Syntax.mk _113_196 None t.FStar_Syntax_Syntax.pos))
end))

# 317 "FStar.Syntax.Subst.fst"
let rec compress : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun t -> (
# 318 "FStar.Syntax.Subst.fst"
let t = (force_delayed_thunk t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t, s), memo) -> begin
(
# 321 "FStar.Syntax.Subst.fst"
let t' = (let _113_199 = (push_subst s t)
in (compress _113_199))
in (
# 322 "FStar.Syntax.Subst.fst"
let _31_430 = (FStar_Unionfind.update_in_tx memo (Some (t')))
in t'))
end
| _31_433 -> begin
(force_uvar t)
end)))

# 328 "FStar.Syntax.Subst.fst"
let subst : FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun s t -> (subst' ((s)::[]) t))

# 329 "FStar.Syntax.Subst.fst"
let subst_comp : FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun s t -> (subst_comp' ((s)::[]) t))

# 330 "FStar.Syntax.Subst.fst"
let closing_subst = (fun bs -> (let _113_211 = (FStar_List.fold_right (fun _31_442 _31_445 -> (match ((_31_442, _31_445)) with
| ((x, _31_441), (subst, n)) -> begin
((FStar_Syntax_Syntax.NM ((x, n)))::subst, (n + 1))
end)) bs ([], 0))
in (FStar_All.pipe_right _113_211 Prims.fst)))

# 332 "FStar.Syntax.Subst.fst"
let open_binders' = (fun bs -> (
# 333 "FStar.Syntax.Subst.fst"
let rec aux = (fun bs o -> (match (bs) with
| [] -> begin
([], o)
end
| (x, imp)::bs' -> begin
(
# 336 "FStar.Syntax.Subst.fst"
let x' = (
# 336 "FStar.Syntax.Subst.fst"
let _31_456 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_217 = (subst o x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_456.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_456.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_217}))
in (
# 337 "FStar.Syntax.Subst.fst"
let o = (let _113_218 = (shift_subst 1 o)
in (FStar_Syntax_Syntax.DB ((0, x')))::_113_218)
in (
# 338 "FStar.Syntax.Subst.fst"
let _31_462 = (aux bs' o)
in (match (_31_462) with
| (bs', o) -> begin
(((x', imp))::bs', o)
end))))
end))
in (aux bs [])))

# 341 "FStar.Syntax.Subst.fst"
let open_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun bs -> (let _113_221 = (open_binders' bs)
in (Prims.fst _113_221)))

# 342 "FStar.Syntax.Subst.fst"
let open_term' : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.subst_t) = (fun bs t -> (
# 343 "FStar.Syntax.Subst.fst"
let _31_468 = (open_binders' bs)
in (match (_31_468) with
| (bs', opening) -> begin
(let _113_226 = (subst opening t)
in (bs', _113_226, opening))
end)))

# 345 "FStar.Syntax.Subst.fst"
let open_term : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.term) = (fun bs t -> (
# 346 "FStar.Syntax.Subst.fst"
let _31_475 = (open_term' bs t)
in (match (_31_475) with
| (b, t, _31_474) -> begin
(b, t)
end)))

# 348 "FStar.Syntax.Subst.fst"
let open_comp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.comp) = (fun bs t -> (
# 349 "FStar.Syntax.Subst.fst"
let _31_480 = (open_binders' bs)
in (match (_31_480) with
| (bs', opening) -> begin
(let _113_235 = (subst_comp opening t)
in (bs', _113_235))
end)))

# 353 "FStar.Syntax.Subst.fst"
let open_pat : FStar_Syntax_Syntax.pat  ->  (FStar_Syntax_Syntax.pat * FStar_Syntax_Syntax.subst_t) = (fun p -> (
# 354 "FStar.Syntax.Subst.fst"
let rec aux_disj = (fun sub renaming p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj (_31_487) -> begin
(FStar_All.failwith "impossible")
end
| FStar_Syntax_Syntax.Pat_constant (_31_490) -> begin
p
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 361 "FStar.Syntax.Subst.fst"
let _31_496 = p
in (let _113_248 = (let _113_247 = (let _113_246 = (FStar_All.pipe_right pats (FStar_List.map (fun _31_500 -> (match (_31_500) with
| (p, b) -> begin
(let _113_245 = (aux_disj sub renaming p)
in (_113_245, b))
end))))
in (fv, _113_246))
in FStar_Syntax_Syntax.Pat_cons (_113_247))
in {FStar_Syntax_Syntax.v = _113_248; FStar_Syntax_Syntax.ty = _31_496.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_496.FStar_Syntax_Syntax.p}))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 365 "FStar.Syntax.Subst.fst"
let yopt = (FStar_Util.find_map renaming (fun _31_7 -> (match (_31_7) with
| (x', y) when (x.FStar_Syntax_Syntax.ppname.FStar_Ident.idText = x'.FStar_Syntax_Syntax.ppname.FStar_Ident.idText) -> begin
Some (y)
end
| _31_508 -> begin
None
end)))
in (
# 368 "FStar.Syntax.Subst.fst"
let y = (match (yopt) with
| None -> begin
(
# 369 "FStar.Syntax.Subst.fst"
let _31_511 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_250 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_511.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_511.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_250}))
end
| Some (y) -> begin
y
end)
in (
# 371 "FStar.Syntax.Subst.fst"
let _31_516 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (y); FStar_Syntax_Syntax.ty = _31_516.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_516.FStar_Syntax_Syntax.p})))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 374 "FStar.Syntax.Subst.fst"
let x' = (
# 374 "FStar.Syntax.Subst.fst"
let _31_520 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_251 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_520.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_520.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_251}))
in (
# 375 "FStar.Syntax.Subst.fst"
let _31_523 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x'); FStar_Syntax_Syntax.ty = _31_523.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_523.FStar_Syntax_Syntax.p}))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 378 "FStar.Syntax.Subst.fst"
let x = (
# 378 "FStar.Syntax.Subst.fst"
let _31_529 = x
in (let _113_252 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_529.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_529.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_252}))
in (
# 379 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in (
# 380 "FStar.Syntax.Subst.fst"
let _31_533 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_533.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_533.FStar_Syntax_Syntax.p})))
end))
in (
# 382 "FStar.Syntax.Subst.fst"
let rec aux = (fun sub renaming p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_31_542) -> begin
(p, sub, renaming)
end
| FStar_Syntax_Syntax.Pat_disj (p::ps) -> begin
(
# 388 "FStar.Syntax.Subst.fst"
let _31_551 = (aux sub renaming p)
in (match (_31_551) with
| (p, sub, renaming) -> begin
(
# 389 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (aux_disj sub renaming) ps)
in ((
# 390 "FStar.Syntax.Subst.fst"
let _31_553 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _31_553.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_553.FStar_Syntax_Syntax.p}), sub, renaming))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 393 "FStar.Syntax.Subst.fst"
let _31_573 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _31_562 _31_565 -> (match ((_31_562, _31_565)) with
| ((pats, sub, renaming), (p, imp)) -> begin
(
# 394 "FStar.Syntax.Subst.fst"
let _31_569 = (aux sub renaming p)
in (match (_31_569) with
| (p, sub, renaming) -> begin
(((p, imp))::pats, sub, renaming)
end))
end)) ([], sub, renaming)))
in (match (_31_573) with
| (pats, sub, renaming) -> begin
((
# 396 "FStar.Syntax.Subst.fst"
let _31_574 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons ((fv, (FStar_List.rev pats))); FStar_Syntax_Syntax.ty = _31_574.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_574.FStar_Syntax_Syntax.p}), sub, renaming)
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 399 "FStar.Syntax.Subst.fst"
let x' = (
# 399 "FStar.Syntax.Subst.fst"
let _31_578 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_261 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_578.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_578.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_261}))
in (
# 400 "FStar.Syntax.Subst.fst"
let sub = (let _113_262 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.DB ((0, x')))::_113_262)
in ((
# 401 "FStar.Syntax.Subst.fst"
let _31_582 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x'); FStar_Syntax_Syntax.ty = _31_582.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_582.FStar_Syntax_Syntax.p}), sub, ((x, x'))::renaming)))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 404 "FStar.Syntax.Subst.fst"
let x' = (
# 404 "FStar.Syntax.Subst.fst"
let _31_586 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _113_263 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_586.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_586.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_263}))
in (
# 405 "FStar.Syntax.Subst.fst"
let sub = (let _113_264 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.DB ((0, x')))::_113_264)
in ((
# 406 "FStar.Syntax.Subst.fst"
let _31_590 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x'); FStar_Syntax_Syntax.ty = _31_590.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_590.FStar_Syntax_Syntax.p}), sub, ((x, x'))::renaming)))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 409 "FStar.Syntax.Subst.fst"
let x = (
# 409 "FStar.Syntax.Subst.fst"
let _31_596 = x
in (let _113_265 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_596.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_596.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_265}))
in (
# 410 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in ((
# 411 "FStar.Syntax.Subst.fst"
let _31_600 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_600.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_600.FStar_Syntax_Syntax.p}), sub, renaming)))
end))
in (
# 413 "FStar.Syntax.Subst.fst"
let _31_606 = (aux [] [] p)
in (match (_31_606) with
| (p, sub, _31_605) -> begin
(p, sub)
end)))))

# 416 "FStar.Syntax.Subst.fst"
let open_branch : FStar_Syntax_Syntax.branch  ->  FStar_Syntax_Syntax.branch = (fun _31_610 -> (match (_31_610) with
| (p, wopt, e) -> begin
(
# 417 "FStar.Syntax.Subst.fst"
let _31_613 = (open_pat p)
in (match (_31_613) with
| (p, opening) -> begin
(
# 418 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _113_268 = (subst opening w)
in Some (_113_268))
end)
in (
# 421 "FStar.Syntax.Subst.fst"
let e = (subst opening e)
in (p, wopt, e)))
end))
end))

# 424 "FStar.Syntax.Subst.fst"
let close : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun bs t -> (let _113_273 = (closing_subst bs)
in (subst _113_273 t)))

# 425 "FStar.Syntax.Subst.fst"
let close_comp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun bs c -> (let _113_278 = (closing_subst bs)
in (subst_comp _113_278 c)))

# 426 "FStar.Syntax.Subst.fst"
let close_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun bs -> (
# 427 "FStar.Syntax.Subst.fst"
let rec aux = (fun s bs -> (match (bs) with
| [] -> begin
[]
end
| (x, imp)::tl -> begin
(
# 430 "FStar.Syntax.Subst.fst"
let x = (
# 430 "FStar.Syntax.Subst.fst"
let _31_633 = x
in (let _113_285 = (subst s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_633.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_633.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_285}))
in (
# 431 "FStar.Syntax.Subst.fst"
let s' = (let _113_286 = (shift_subst 1 s)
in (FStar_Syntax_Syntax.NM ((x, 0)))::_113_286)
in (let _113_287 = (aux s' tl)
in ((x, imp))::_113_287)))
end))
in (aux [] bs)))

# 435 "FStar.Syntax.Subst.fst"
let close_lcomp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.lcomp  ->  FStar_Syntax_Syntax.lcomp = (fun bs lc -> (
# 436 "FStar.Syntax.Subst.fst"
let s = (closing_subst bs)
in (
# 437 "FStar.Syntax.Subst.fst"
let _31_640 = lc
in (let _113_294 = (subst s lc.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _31_640.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _113_294; FStar_Syntax_Syntax.cflags = _31_640.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _31_642 -> (match (()) with
| () -> begin
(let _113_293 = (lc.FStar_Syntax_Syntax.comp ())
in (subst_comp s _113_293))
end))}))))

# 440 "FStar.Syntax.Subst.fst"
let close_pat : (FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t  ->  ((FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t * FStar_Syntax_Syntax.subst_elt Prims.list) = (fun p -> (
# 441 "FStar.Syntax.Subst.fst"
let rec aux = (fun sub p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_31_650) -> begin
(p, sub)
end
| FStar_Syntax_Syntax.Pat_disj (p::ps) -> begin
(
# 447 "FStar.Syntax.Subst.fst"
let _31_658 = (aux sub p)
in (match (_31_658) with
| (p, sub) -> begin
(
# 448 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (fun p -> (let _113_302 = (aux sub p)
in (Prims.fst _113_302))) ps)
in ((
# 449 "FStar.Syntax.Subst.fst"
let _31_661 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _31_661.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_661.FStar_Syntax_Syntax.p}), sub))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 452 "FStar.Syntax.Subst.fst"
let _31_678 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _31_669 _31_672 -> (match ((_31_669, _31_672)) with
| ((pats, sub), (p, imp)) -> begin
(
# 453 "FStar.Syntax.Subst.fst"
let _31_675 = (aux sub p)
in (match (_31_675) with
| (p, sub) -> begin
(((p, imp))::pats, sub)
end))
end)) ([], sub)))
in (match (_31_678) with
| (pats, sub) -> begin
((
# 455 "FStar.Syntax.Subst.fst"
let _31_679 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons ((fv, (FStar_List.rev pats))); FStar_Syntax_Syntax.ty = _31_679.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_679.FStar_Syntax_Syntax.p}), sub)
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 458 "FStar.Syntax.Subst.fst"
let x = (
# 458 "FStar.Syntax.Subst.fst"
let _31_683 = x
in (let _113_305 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_683.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_683.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_305}))
in (
# 459 "FStar.Syntax.Subst.fst"
let sub = (let _113_306 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.NM ((x, 0)))::_113_306)
in ((
# 460 "FStar.Syntax.Subst.fst"
let _31_687 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x); FStar_Syntax_Syntax.ty = _31_687.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_687.FStar_Syntax_Syntax.p}), sub)))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 463 "FStar.Syntax.Subst.fst"
let x = (
# 463 "FStar.Syntax.Subst.fst"
let _31_691 = x
in (let _113_307 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_691.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_691.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_307}))
in (
# 464 "FStar.Syntax.Subst.fst"
let sub = (let _113_308 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.NM ((x, 0)))::_113_308)
in ((
# 465 "FStar.Syntax.Subst.fst"
let _31_695 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x); FStar_Syntax_Syntax.ty = _31_695.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_695.FStar_Syntax_Syntax.p}), sub)))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 468 "FStar.Syntax.Subst.fst"
let x = (
# 468 "FStar.Syntax.Subst.fst"
let _31_701 = x
in (let _113_309 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _31_701.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _31_701.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _113_309}))
in (
# 469 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in ((
# 470 "FStar.Syntax.Subst.fst"
let _31_705 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t0)); FStar_Syntax_Syntax.ty = _31_705.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _31_705.FStar_Syntax_Syntax.p}), sub)))
end))
in (aux [] p)))

# 473 "FStar.Syntax.Subst.fst"
let close_branch : FStar_Syntax_Syntax.branch  ->  FStar_Syntax_Syntax.branch = (fun _31_710 -> (match (_31_710) with
| (p, wopt, e) -> begin
(
# 474 "FStar.Syntax.Subst.fst"
let _31_713 = (close_pat p)
in (match (_31_713) with
| (p, closing) -> begin
(
# 475 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _113_312 = (subst closing w)
in Some (_113_312))
end)
in (
# 478 "FStar.Syntax.Subst.fst"
let e = (subst closing e)
in (p, wopt, e)))
end))
end))

# 481 "FStar.Syntax.Subst.fst"
let univ_var_opening : FStar_Syntax_Syntax.univ_names  ->  (FStar_Syntax_Syntax.subst_elt Prims.list * FStar_Syntax_Syntax.univ_name Prims.list) = (fun us -> (
# 482 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 483 "FStar.Syntax.Subst.fst"
let _31_726 = (let _113_317 = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> (
# 484 "FStar.Syntax.Subst.fst"
let u' = (FStar_Syntax_Syntax.new_univ_name (Some (u.FStar_Ident.idRange)))
in (FStar_Syntax_Syntax.UN (((n - i), FStar_Syntax_Syntax.U_name (u'))), u')))))
in (FStar_All.pipe_right _113_317 FStar_List.unzip))
in (match (_31_726) with
| (s, us') -> begin
(s, us')
end))))

# 488 "FStar.Syntax.Subst.fst"
let open_univ_vars : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.term) = (fun us t -> (
# 489 "FStar.Syntax.Subst.fst"
let _31_731 = (univ_var_opening us)
in (match (_31_731) with
| (s, us') -> begin
(
# 490 "FStar.Syntax.Subst.fst"
let t = (subst s t)
in (us', t))
end)))

# 493 "FStar.Syntax.Subst.fst"
let open_univ_vars_comp : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.comp) = (fun us c -> (
# 494 "FStar.Syntax.Subst.fst"
let _31_737 = (univ_var_opening us)
in (match (_31_737) with
| (s, us') -> begin
(let _113_326 = (subst_comp s c)
in (us', _113_326))
end)))

# 497 "FStar.Syntax.Subst.fst"
let close_univ_vars : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun us t -> (
# 498 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 499 "FStar.Syntax.Subst.fst"
let s = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UD ((u, (n - i))))))
in (subst s t))))

# 502 "FStar.Syntax.Subst.fst"
let close_univ_vars_comp : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun us c -> (
# 503 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 504 "FStar.Syntax.Subst.fst"
let s = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UD ((u, (n - i))))))
in (subst_comp s c))))

# 507 "FStar.Syntax.Subst.fst"
let open_let_rec : FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.letbinding Prims.list * FStar_Syntax_Syntax.term) = (fun lbs t -> if (FStar_Syntax_Syntax.is_top_level lbs) then begin
(lbs, t)
end else begin
(
# 524 "FStar.Syntax.Subst.fst"
let _31_763 = (FStar_List.fold_right (fun lb _31_756 -> (match (_31_756) with
| (i, lbs, out) -> begin
(
# 526 "FStar.Syntax.Subst.fst"
let x = (let _113_345 = (FStar_Util.left lb.FStar_Syntax_Syntax.lbname)
in (FStar_Syntax_Syntax.freshen_bv _113_345))
in ((i + 1), ((
# 527 "FStar.Syntax.Subst.fst"
let _31_758 = lb
in {FStar_Syntax_Syntax.lbname = FStar_Util.Inl (x); FStar_Syntax_Syntax.lbunivs = _31_758.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _31_758.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _31_758.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _31_758.FStar_Syntax_Syntax.lbdef}))::lbs, (FStar_Syntax_Syntax.DB ((i, x)))::out))
end)) lbs (0, [], []))
in (match (_31_763) with
| (n_let_recs, lbs, let_rec_opening) -> begin
(
# 529 "FStar.Syntax.Subst.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (fun lb -> (
# 530 "FStar.Syntax.Subst.fst"
let _31_775 = (FStar_List.fold_right (fun u _31_769 -> (match (_31_769) with
| (i, us, out) -> begin
(
# 532 "FStar.Syntax.Subst.fst"
let u = (FStar_Syntax_Syntax.new_univ_name None)
in ((i + 1), (u)::us, (FStar_Syntax_Syntax.UN ((i, FStar_Syntax_Syntax.U_name (u))))::out))
end)) lb.FStar_Syntax_Syntax.lbunivs (n_let_recs, [], let_rec_opening))
in (match (_31_775) with
| (_31_772, us, u_let_rec_opening) -> begin
(
# 535 "FStar.Syntax.Subst.fst"
let _31_776 = lb
in (let _113_349 = (subst u_let_rec_opening lb.FStar_Syntax_Syntax.lbdef)
in {FStar_Syntax_Syntax.lbname = _31_776.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = us; FStar_Syntax_Syntax.lbtyp = _31_776.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _31_776.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _113_349}))
end)))))
in (
# 537 "FStar.Syntax.Subst.fst"
let t = (subst let_rec_opening t)
in (lbs, t)))
end))
end)

# 540 "FStar.Syntax.Subst.fst"
let close_let_rec : FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.letbinding Prims.list * FStar_Syntax_Syntax.term) = (fun lbs t -> if (FStar_Syntax_Syntax.is_top_level lbs) then begin
(lbs, t)
end else begin
(
# 542 "FStar.Syntax.Subst.fst"
let _31_788 = (FStar_List.fold_right (fun lb _31_785 -> (match (_31_785) with
| (i, out) -> begin
(let _113_359 = (let _113_358 = (let _113_357 = (let _113_356 = (FStar_Util.left lb.FStar_Syntax_Syntax.lbname)
in (_113_356, i))
in FStar_Syntax_Syntax.NM (_113_357))
in (_113_358)::out)
in ((i + 1), _113_359))
end)) lbs (0, []))
in (match (_31_788) with
| (n_let_recs, let_rec_closing) -> begin
(
# 544 "FStar.Syntax.Subst.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (fun lb -> (
# 545 "FStar.Syntax.Subst.fst"
let _31_797 = (FStar_List.fold_right (fun u _31_793 -> (match (_31_793) with
| (i, out) -> begin
((i + 1), (FStar_Syntax_Syntax.UD ((u, i)))::out)
end)) lb.FStar_Syntax_Syntax.lbunivs (n_let_recs, let_rec_closing))
in (match (_31_797) with
| (_31_795, u_let_rec_closing) -> begin
(
# 546 "FStar.Syntax.Subst.fst"
let _31_798 = lb
in (let _113_363 = (subst u_let_rec_closing lb.FStar_Syntax_Syntax.lbdef)
in {FStar_Syntax_Syntax.lbname = _31_798.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _31_798.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _31_798.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _31_798.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _113_363}))
end)))))
in (
# 547 "FStar.Syntax.Subst.fst"
let t = (subst let_rec_closing t)
in (lbs, t)))
end))
end)

# 550 "FStar.Syntax.Subst.fst"
let close_tscheme : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.tscheme = (fun binders _31_805 -> (match (_31_805) with
| (us, t) -> begin
(
# 551 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length binders) - 1)
in (
# 552 "FStar.Syntax.Subst.fst"
let k = (FStar_List.length us)
in (
# 553 "FStar.Syntax.Subst.fst"
let s = (FStar_List.mapi (fun i _31_812 -> (match (_31_812) with
| (x, _31_811) -> begin
FStar_Syntax_Syntax.NM ((x, (k + (n - i))))
end)) binders)
in (
# 554 "FStar.Syntax.Subst.fst"
let t = (subst s t)
in (us, t)))))
end))

# 557 "FStar.Syntax.Subst.fst"
let close_univ_vars_tscheme : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.tscheme = (fun us _31_818 -> (match (_31_818) with
| (us', t) -> begin
(
# 558 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 559 "FStar.Syntax.Subst.fst"
let k = (FStar_List.length us')
in (
# 560 "FStar.Syntax.Subst.fst"
let s = (FStar_List.mapi (fun i x -> FStar_Syntax_Syntax.UD ((x, (k + (n - i))))) us)
in (let _113_376 = (subst s t)
in (us', _113_376)))))
end))

# 563 "FStar.Syntax.Subst.fst"
let opening_of_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.subst_t = (fun bs -> (
# 564 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length bs) - 1)
in (FStar_All.pipe_right bs (FStar_List.mapi (fun i _31_830 -> (match (_31_830) with
| (x, _31_829) -> begin
FStar_Syntax_Syntax.DB (((n - i), x))
end))))))




