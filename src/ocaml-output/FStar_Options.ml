
open Prims
open FStar_Pervasives
type debug_level_t =
| Low
| Medium
| High
| Extreme
| Other of Prims.string


let uu___is_Low : debug_level_t  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Low -> begin
true
end
| uu____8 -> begin
false
end))


let uu___is_Medium : debug_level_t  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Medium -> begin
true
end
| uu____12 -> begin
false
end))


let uu___is_High : debug_level_t  ->  Prims.bool = (fun projectee -> (match (projectee) with
| High -> begin
true
end
| uu____16 -> begin
false
end))


let uu___is_Extreme : debug_level_t  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Extreme -> begin
true
end
| uu____20 -> begin
false
end))


let uu___is_Other : debug_level_t  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Other (_0) -> begin
true
end
| uu____25 -> begin
false
end))


let __proj__Other__item___0 : debug_level_t  ->  Prims.string = (fun projectee -> (match (projectee) with
| Other (_0) -> begin
_0
end))

type option_val =
| Bool of Prims.bool
| String of Prims.string
| Path of Prims.string
| Int of Prims.int
| List of option_val Prims.list
| Unset


let uu___is_Bool : option_val  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Bool (_0) -> begin
true
end
| uu____58 -> begin
false
end))


let __proj__Bool__item___0 : option_val  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Bool (_0) -> begin
_0
end))


let uu___is_String : option_val  ->  Prims.bool = (fun projectee -> (match (projectee) with
| String (_0) -> begin
true
end
| uu____70 -> begin
false
end))


let __proj__String__item___0 : option_val  ->  Prims.string = (fun projectee -> (match (projectee) with
| String (_0) -> begin
_0
end))


let uu___is_Path : option_val  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Path (_0) -> begin
true
end
| uu____82 -> begin
false
end))


let __proj__Path__item___0 : option_val  ->  Prims.string = (fun projectee -> (match (projectee) with
| Path (_0) -> begin
_0
end))


let uu___is_Int : option_val  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Int (_0) -> begin
true
end
| uu____94 -> begin
false
end))


let __proj__Int__item___0 : option_val  ->  Prims.int = (fun projectee -> (match (projectee) with
| Int (_0) -> begin
_0
end))


let uu___is_List : option_val  ->  Prims.bool = (fun projectee -> (match (projectee) with
| List (_0) -> begin
true
end
| uu____107 -> begin
false
end))


let __proj__List__item___0 : option_val  ->  option_val Prims.list = (fun projectee -> (match (projectee) with
| List (_0) -> begin
_0
end))


let uu___is_Unset : option_val  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Unset -> begin
true
end
| uu____121 -> begin
false
end))

type options =
| Set
| Reset
| Restore


let uu___is_Set : options  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Set -> begin
true
end
| uu____125 -> begin
false
end))


let uu___is_Reset : options  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Reset -> begin
true
end
| uu____129 -> begin
false
end))


let uu___is_Restore : options  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Restore -> begin
true
end
| uu____133 -> begin
false
end))

type solver =
| Z3
| CVC4


let uu___is_Z3 : solver  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Z3 -> begin
true
end
| uu____137 -> begin
false
end))


let uu___is_CVC4 : solver  ->  Prims.bool = (fun projectee -> (match (projectee) with
| CVC4 -> begin
true
end
| uu____141 -> begin
false
end))


let __unit_tests__ : Prims.bool FStar_ST.ref = (FStar_Util.mk_ref false)


let __unit_tests : Prims.unit  ->  Prims.bool = (fun uu____147 -> (FStar_ST.read __unit_tests__))


let __set_unit_tests : Prims.unit  ->  Prims.unit = (fun uu____152 -> (FStar_ST.write __unit_tests__ true))


let __clear_unit_tests : Prims.unit  ->  Prims.unit = (fun uu____157 -> (FStar_ST.write __unit_tests__ false))


let as_bool : option_val  ->  Prims.bool = (fun uu___49_162 -> (match (uu___49_162) with
| Bool (b) -> begin
b
end
| uu____164 -> begin
(failwith "Impos: expected Bool")
end))


let as_int : option_val  ->  Prims.int = (fun uu___50_167 -> (match (uu___50_167) with
| Int (b) -> begin
b
end
| uu____169 -> begin
(failwith "Impos: expected Int")
end))


let as_string : option_val  ->  Prims.string = (fun uu___51_172 -> (match (uu___51_172) with
| String (b) -> begin
b
end
| Path (b) -> begin
(FStar_Common.try_convert_file_name_to_mixed b)
end
| uu____175 -> begin
(failwith "Impos: expected String")
end))


let as_list = (fun as_t uu___52_191 -> (match (uu___52_191) with
| List (ts) -> begin
(FStar_All.pipe_right ts (FStar_List.map as_t))
end
| uu____198 -> begin
(failwith "Impos: expected List")
end))


let as_option = (fun as_t uu___53_215 -> (match (uu___53_215) with
| Unset -> begin
FStar_Pervasives_Native.None
end
| v1 -> begin
(

let uu____219 = (as_t v1)
in FStar_Pervasives_Native.Some (uu____219))
end))


let fstar_options : option_val FStar_Util.smap Prims.list FStar_ST.ref = (FStar_Util.mk_ref [])


let peek : Prims.unit  ->  option_val FStar_Util.smap = (fun uu____231 -> (

let uu____232 = (FStar_ST.read fstar_options)
in (FStar_List.hd uu____232)))


let pop : Prims.unit  ->  Prims.unit = (fun uu____242 -> (

let uu____243 = (FStar_ST.read fstar_options)
in (match (uu____243) with
| [] -> begin
(failwith "TOO MANY POPS!")
end
| (uu____251)::[] -> begin
(failwith "TOO MANY POPS!")
end
| (uu____255)::tl1 -> begin
(FStar_ST.write fstar_options tl1)
end)))


let push : Prims.unit  ->  Prims.unit = (fun uu____267 -> (

let uu____268 = (

let uu____271 = (

let uu____273 = (peek ())
in (FStar_Util.smap_copy uu____273))
in (

let uu____275 = (FStar_ST.read fstar_options)
in (uu____271)::uu____275))
in (FStar_ST.write fstar_options uu____268)))


let set_option : Prims.string  ->  option_val  ->  Prims.unit = (fun k v1 -> (

let uu____293 = (peek ())
in (FStar_Util.smap_add uu____293 k v1)))


let set_option' : (Prims.string * option_val)  ->  Prims.unit = (fun uu____299 -> (match (uu____299) with
| (k, v1) -> begin
(set_option k v1)
end))


let with_saved_options = (fun f -> ((push ());
(

let retv = (f ())
in ((pop ());
retv;
));
))


let light_off_files : Prims.string Prims.list FStar_ST.ref = (FStar_Util.mk_ref [])


let add_light_off_file : Prims.string  ->  Prims.unit = (fun filename -> (

let uu____327 = (

let uu____329 = (FStar_ST.read light_off_files)
in (filename)::uu____329)
in (FStar_ST.write light_off_files uu____327)))


let defaults : (Prims.string * option_val) Prims.list = ((("__temp_no_proj"), (List ([]))))::((("_fstar_home"), (String (""))))::((("_include_path"), (List ([]))))::((("admit_smt_queries"), (Bool (false))))::((("check_hints"), (Bool (false))))::((("codegen"), (Unset)))::((("codegen-lib"), (List ([]))))::((("debug"), (List ([]))))::((("debug_level"), (List ([]))))::((("dep"), (Unset)))::((("detail_errors"), (Bool (false))))::((("doc"), (Bool (false))))::((("dump_module"), (List ([]))))::((("eager_inference"), (Bool (false))))::((("explicit_deps"), (Bool (false))))::((("extract_all"), (Bool (false))))::((("extract_module"), (List ([]))))::((("extract_namespace"), (List ([]))))::((("fs_typ_app"), (Bool (false))))::((("fstar_home"), (Unset)))::((("full_context_dependency"), (Bool (true))))::((("hide_genident_nums"), (Bool (false))))::((("hide_uvar_nums"), (Bool (false))))::((("hint_info"), (Bool (false))))::((("hint_file"), (Unset)))::((("in"), (Bool (false))))::((("ide"), (Bool (false))))::((("include"), (List ([]))))::((("indent"), (Bool (false))))::((("initial_fuel"), (Int ((Prims.parse_int "2")))))::((("initial_ifuel"), (Int ((Prims.parse_int "1")))))::((("lax"), (Bool (false))))::((("lax_except"), (Unset)))::((("log_queries"), (Bool (false))))::((("log_types"), (Bool (false))))::((("max_fuel"), (Int ((Prims.parse_int "8")))))::((("max_ifuel"), (Int ((Prims.parse_int "2")))))::((("min_fuel"), (Int ((Prims.parse_int "1")))))::((("MLish"), (Bool (false))))::((("n_cores"), (Int ((Prims.parse_int "1")))))::((("no_default_includes"), (Bool (false))))::((("no_extract"), (List ([]))))::((("no_location_info"), (Bool (false))))::((("odir"), (Unset)))::((("prims"), (Unset)))::((("pretype"), (Bool (true))))::((("prims_ref"), (Unset)))::((("print_bound_var_types"), (Bool (false))))::((("print_effect_args"), (Bool (false))))::((("print_fuels"), (Bool (false))))::((("print_full_names"), (Bool (false))))::((("print_implicits"), (Bool (false))))::((("print_universes"), (Bool (false))))::((("print_z3_statistics"), (Bool (false))))::((("prn"), (Bool (false))))::((("record_hints"), (Bool (false))))::((("reuse_hint_for"), (Unset)))::((("show_signatures"), (List ([]))))::((("silent"), (Bool (false))))::((("smt"), (Unset)))::((("smtencoding.elim_box"), (Bool (false))))::((("smtencoding.nl_arith_repr"), (String ("boxwrap"))))::((("smtencoding.l_arith_repr"), (String ("boxwrap"))))::((("smt_solver"), (String ("z3"))))::((("split_cases"), (Int ((Prims.parse_int "0")))))::((("timing"), (Bool (false))))::((("trace_error"), (Bool (false))))::((("ugly"), (Bool (false))))::((("unthrottle_inductives"), (Bool (false))))::((("use_eq_at_higher_order"), (Bool (false))))::((("use_hints"), (Bool (false))))::((("no_tactics"), (Bool (false))))::((("using_facts_from"), (Unset)))::((("verify"), (Bool (true))))::((("verify_all"), (Bool (false))))::((("verify_module"), (List ([]))))::((("warn_default_effects"), (Bool (false))))::((("z3refresh"), (Bool (false))))::((("z3rlimit"), (Int ((Prims.parse_int "5")))))::((("z3rlimit_factor"), (Int ((Prims.parse_int "1")))))::((("z3seed"), (Int ((Prims.parse_int "0")))))::((("z3timeout"), (Int ((Prims.parse_int "5")))))::((("z3cliopt"), (List ([]))))::((("__no_positivity"), (Bool (false))))::[]


let init : Prims.unit  ->  Prims.unit = (fun uu____512 -> (

let o = (peek ())
in ((FStar_Util.smap_clear o);
(FStar_All.pipe_right defaults (FStar_List.iter set_option'));
)))


let clear : Prims.unit  ->  Prims.unit = (fun uu____523 -> (

let o = (FStar_Util.smap_create (Prims.parse_int "50"))
in ((FStar_ST.write fstar_options ((o)::[]));
(FStar_ST.write light_off_files []);
(init ());
)))


let _run : Prims.unit = (clear ())


let get_option : Prims.string  ->  option_val = (fun s -> (

let uu____540 = (

let uu____542 = (peek ())
in (FStar_Util.smap_try_find uu____542 s))
in (match (uu____540) with
| FStar_Pervasives_Native.None -> begin
(failwith (Prims.strcat "Impossible: option " (Prims.strcat s " not found")))
end
| FStar_Pervasives_Native.Some (s1) -> begin
s1
end)))


let lookup_opt = (fun s c -> (c (get_option s)))


let get_admit_smt_queries : Prims.unit  ->  Prims.bool = (fun uu____564 -> (lookup_opt "admit_smt_queries" as_bool))


let get_check_hints : Prims.unit  ->  Prims.bool = (fun uu____567 -> (lookup_opt "check_hints" as_bool))


let get_codegen : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____571 -> (lookup_opt "codegen" (as_option as_string)))


let get_codegen_lib : Prims.unit  ->  Prims.string Prims.list = (fun uu____576 -> (lookup_opt "codegen-lib" (as_list as_string)))


let get_debug : Prims.unit  ->  Prims.string Prims.list = (fun uu____581 -> (lookup_opt "debug" (as_list as_string)))


let get_debug_level : Prims.unit  ->  Prims.string Prims.list = (fun uu____586 -> (lookup_opt "debug_level" (as_list as_string)))


let get_dep : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____591 -> (lookup_opt "dep" (as_option as_string)))


let get_detail_errors : Prims.unit  ->  Prims.bool = (fun uu____595 -> (lookup_opt "detail_errors" as_bool))


let get_doc : Prims.unit  ->  Prims.bool = (fun uu____598 -> (lookup_opt "doc" as_bool))


let get_dump_module : Prims.unit  ->  Prims.string Prims.list = (fun uu____602 -> (lookup_opt "dump_module" (as_list as_string)))


let get_eager_inference : Prims.unit  ->  Prims.bool = (fun uu____606 -> (lookup_opt "eager_inference" as_bool))


let get_explicit_deps : Prims.unit  ->  Prims.bool = (fun uu____609 -> (lookup_opt "explicit_deps" as_bool))


let get_extract_all : Prims.unit  ->  Prims.bool = (fun uu____612 -> (lookup_opt "extract_all" as_bool))


let get_extract_module : Prims.unit  ->  Prims.string Prims.list = (fun uu____616 -> (lookup_opt "extract_module" (as_list as_string)))


let get_extract_namespace : Prims.unit  ->  Prims.string Prims.list = (fun uu____621 -> (lookup_opt "extract_namespace" (as_list as_string)))


let get_fs_typ_app : Prims.unit  ->  Prims.bool = (fun uu____625 -> (lookup_opt "fs_typ_app" as_bool))


let get_fstar_home : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____629 -> (lookup_opt "fstar_home" (as_option as_string)))


let get_hide_genident_nums : Prims.unit  ->  Prims.bool = (fun uu____633 -> (lookup_opt "hide_genident_nums" as_bool))


let get_hide_uvar_nums : Prims.unit  ->  Prims.bool = (fun uu____636 -> (lookup_opt "hide_uvar_nums" as_bool))


let get_hint_info : Prims.unit  ->  Prims.bool = (fun uu____639 -> (lookup_opt "hint_info" as_bool))


let get_hint_file : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____643 -> (lookup_opt "hint_file" (as_option as_string)))


let get_in : Prims.unit  ->  Prims.bool = (fun uu____647 -> (lookup_opt "in" as_bool))


let get_ide : Prims.unit  ->  Prims.bool = (fun uu____650 -> (lookup_opt "ide" as_bool))


let get_include : Prims.unit  ->  Prims.string Prims.list = (fun uu____654 -> (lookup_opt "include" (as_list as_string)))


let get_indent : Prims.unit  ->  Prims.bool = (fun uu____658 -> (lookup_opt "indent" as_bool))


let get_initial_fuel : Prims.unit  ->  Prims.int = (fun uu____661 -> (lookup_opt "initial_fuel" as_int))


let get_initial_ifuel : Prims.unit  ->  Prims.int = (fun uu____664 -> (lookup_opt "initial_ifuel" as_int))


let get_lax : Prims.unit  ->  Prims.bool = (fun uu____667 -> (lookup_opt "lax" as_bool))


let get_lax_except : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____671 -> (lookup_opt "lax_except" (as_option as_string)))


let get_log_queries : Prims.unit  ->  Prims.bool = (fun uu____675 -> (lookup_opt "log_queries" as_bool))


let get_log_types : Prims.unit  ->  Prims.bool = (fun uu____678 -> (lookup_opt "log_types" as_bool))


let get_max_fuel : Prims.unit  ->  Prims.int = (fun uu____681 -> (lookup_opt "max_fuel" as_int))


let get_max_ifuel : Prims.unit  ->  Prims.int = (fun uu____684 -> (lookup_opt "max_ifuel" as_int))


let get_min_fuel : Prims.unit  ->  Prims.int = (fun uu____687 -> (lookup_opt "min_fuel" as_int))


let get_MLish : Prims.unit  ->  Prims.bool = (fun uu____690 -> (lookup_opt "MLish" as_bool))


let get_n_cores : Prims.unit  ->  Prims.int = (fun uu____693 -> (lookup_opt "n_cores" as_int))


let get_no_default_includes : Prims.unit  ->  Prims.bool = (fun uu____696 -> (lookup_opt "no_default_includes" as_bool))


let get_no_extract : Prims.unit  ->  Prims.string Prims.list = (fun uu____700 -> (lookup_opt "no_extract" (as_list as_string)))


let get_no_location_info : Prims.unit  ->  Prims.bool = (fun uu____704 -> (lookup_opt "no_location_info" as_bool))


let get_odir : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____708 -> (lookup_opt "odir" (as_option as_string)))


let get_ugly : Prims.unit  ->  Prims.bool = (fun uu____712 -> (lookup_opt "ugly" as_bool))


let get_prims : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____716 -> (lookup_opt "prims" (as_option as_string)))


let get_print_bound_var_types : Prims.unit  ->  Prims.bool = (fun uu____720 -> (lookup_opt "print_bound_var_types" as_bool))


let get_print_effect_args : Prims.unit  ->  Prims.bool = (fun uu____723 -> (lookup_opt "print_effect_args" as_bool))


let get_print_fuels : Prims.unit  ->  Prims.bool = (fun uu____726 -> (lookup_opt "print_fuels" as_bool))


let get_print_full_names : Prims.unit  ->  Prims.bool = (fun uu____729 -> (lookup_opt "print_full_names" as_bool))


let get_print_implicits : Prims.unit  ->  Prims.bool = (fun uu____732 -> (lookup_opt "print_implicits" as_bool))


let get_print_universes : Prims.unit  ->  Prims.bool = (fun uu____735 -> (lookup_opt "print_universes" as_bool))


let get_print_z3_statistics : Prims.unit  ->  Prims.bool = (fun uu____738 -> (lookup_opt "print_z3_statistics" as_bool))


let get_prn : Prims.unit  ->  Prims.bool = (fun uu____741 -> (lookup_opt "prn" as_bool))


let get_record_hints : Prims.unit  ->  Prims.bool = (fun uu____744 -> (lookup_opt "record_hints" as_bool))


let get_reuse_hint_for : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____748 -> (lookup_opt "reuse_hint_for" (as_option as_string)))


let get_show_signatures : Prims.unit  ->  Prims.string Prims.list = (fun uu____753 -> (lookup_opt "show_signatures" (as_list as_string)))


let get_silent : Prims.unit  ->  Prims.bool = (fun uu____757 -> (lookup_opt "silent" as_bool))


let get_smt : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____761 -> (lookup_opt "smt" (as_option as_string)))


let get_smtencoding_elim_box : Prims.unit  ->  Prims.bool = (fun uu____765 -> (lookup_opt "smtencoding.elim_box" as_bool))


let get_smtencoding_nl_arith_repr : Prims.unit  ->  Prims.string = (fun uu____768 -> (lookup_opt "smtencoding.nl_arith_repr" as_string))


let get_smtencoding_l_arith_repr : Prims.unit  ->  Prims.string = (fun uu____771 -> (lookup_opt "smtencoding.l_arith_repr" as_string))


let get_smtsolver : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____775 -> (lookup_opt "smt_solver" (as_option as_string)))


let get_split_cases : Prims.unit  ->  Prims.int = (fun uu____779 -> (lookup_opt "split_cases" as_int))


let get_timing : Prims.unit  ->  Prims.bool = (fun uu____782 -> (lookup_opt "timing" as_bool))


let get_trace_error : Prims.unit  ->  Prims.bool = (fun uu____785 -> (lookup_opt "trace_error" as_bool))


let get_unthrottle_inductives : Prims.unit  ->  Prims.bool = (fun uu____788 -> (lookup_opt "unthrottle_inductives" as_bool))


let get_use_eq_at_higher_order : Prims.unit  ->  Prims.bool = (fun uu____791 -> (lookup_opt "use_eq_at_higher_order" as_bool))


let get_use_hints : Prims.unit  ->  Prims.bool = (fun uu____794 -> (lookup_opt "use_hints" as_bool))


let get_use_tactics : Prims.unit  ->  Prims.bool = (fun uu____797 -> (

let uu____798 = (lookup_opt "no_tactics" as_bool)
in (not (uu____798))))


let get_using_facts_from : Prims.unit  ->  Prims.string Prims.list FStar_Pervasives_Native.option = (fun uu____803 -> (lookup_opt "using_facts_from" (as_option (as_list as_string))))


let get_verify_all : Prims.unit  ->  Prims.bool = (fun uu____809 -> (lookup_opt "verify_all" as_bool))


let get_verify_module : Prims.unit  ->  Prims.string Prims.list = (fun uu____813 -> (lookup_opt "verify_module" (as_list as_string)))


let get___temp_no_proj : Prims.unit  ->  Prims.string Prims.list = (fun uu____818 -> (lookup_opt "__temp_no_proj" (as_list as_string)))


let get_version : Prims.unit  ->  Prims.bool = (fun uu____822 -> (lookup_opt "version" as_bool))


let get_warn_default_effects : Prims.unit  ->  Prims.bool = (fun uu____825 -> (lookup_opt "warn_default_effects" as_bool))


let get_z3cliopt : Prims.unit  ->  Prims.string Prims.list = (fun uu____829 -> (lookup_opt "z3cliopt" (as_list as_string)))


let get_z3refresh : Prims.unit  ->  Prims.bool = (fun uu____833 -> (lookup_opt "z3refresh" as_bool))


let get_z3rlimit : Prims.unit  ->  Prims.int = (fun uu____836 -> (lookup_opt "z3rlimit" as_int))


let get_z3rlimit_factor : Prims.unit  ->  Prims.int = (fun uu____839 -> (lookup_opt "z3rlimit_factor" as_int))


let get_z3seed : Prims.unit  ->  Prims.int = (fun uu____842 -> (lookup_opt "z3seed" as_int))


let get_z3timeout : Prims.unit  ->  Prims.int = (fun uu____845 -> (lookup_opt "z3timeout" as_int))


let get_no_positivity : Prims.unit  ->  Prims.bool = (fun uu____848 -> (lookup_opt "__no_positivity" as_bool))


let dlevel : Prims.string  ->  debug_level_t = (fun uu___54_851 -> (match (uu___54_851) with
| "Low" -> begin
Low
end
| "Medium" -> begin
Medium
end
| "High" -> begin
High
end
| "Extreme" -> begin
Extreme
end
| s -> begin
Other (s)
end))


let one_debug_level_geq : debug_level_t  ->  debug_level_t  ->  Prims.bool = (fun l1 l2 -> (match (l1) with
| Other (uu____859) -> begin
(l1 = l2)
end
| Low -> begin
(l1 = l2)
end
| Medium -> begin
((l2 = Low) || (l2 = Medium))
end
| High -> begin
(((l2 = Low) || (l2 = Medium)) || (l2 = High))
end
| Extreme -> begin
((((l2 = Low) || (l2 = Medium)) || (l2 = High)) || (l2 = Extreme))
end))


let debug_level_geq : debug_level_t  ->  Prims.bool = (fun l2 -> (

let uu____863 = (get_debug_level ())
in (FStar_All.pipe_right uu____863 (FStar_Util.for_some (fun l1 -> (one_debug_level_geq (dlevel l1) l2))))))


let universe_include_path_base_dirs : Prims.string Prims.list = ("/ulib")::("/lib/fstar")::[]


let _version : Prims.string FStar_ST.ref = (FStar_Util.mk_ref "")


let _platform : Prims.string FStar_ST.ref = (FStar_Util.mk_ref "")


let _compiler : Prims.string FStar_ST.ref = (FStar_Util.mk_ref "")


let _date : Prims.string FStar_ST.ref = (FStar_Util.mk_ref "")


let _commit : Prims.string FStar_ST.ref = (FStar_Util.mk_ref "")


let display_version : Prims.unit  ->  Prims.unit = (fun uu____890 -> (

let uu____891 = (

let uu____892 = (FStar_ST.read _version)
in (

let uu____895 = (FStar_ST.read _platform)
in (

let uu____898 = (FStar_ST.read _compiler)
in (

let uu____901 = (FStar_ST.read _date)
in (

let uu____904 = (FStar_ST.read _commit)
in (FStar_Util.format5 "F* %s\nplatform=%s\ncompiler=%s\ndate=%s\ncommit=%s\n" uu____892 uu____895 uu____898 uu____901 uu____904))))))
in (FStar_Util.print_string uu____891)))


let display_usage_aux = (fun specs -> ((FStar_Util.print_string "fstar.exe [options] file[s]\n");
(FStar_List.iter (fun uu____934 -> (match (uu____934) with
| (uu____940, flag, p, doc) -> begin
(match (p) with
| FStar_Getopt.ZeroArgs (ig) -> begin
(match ((doc = "")) with
| true -> begin
(

let uu____949 = (

let uu____950 = (FStar_Util.colorize_bold flag)
in (FStar_Util.format1 "  --%s\n" uu____950))
in (FStar_Util.print_string uu____949))
end
| uu____951 -> begin
(

let uu____952 = (

let uu____953 = (FStar_Util.colorize_bold flag)
in (FStar_Util.format2 "  --%s  %s\n" uu____953 doc))
in (FStar_Util.print_string uu____952))
end)
end
| FStar_Getopt.OneArg (uu____954, argname) -> begin
(match ((doc = "")) with
| true -> begin
(

let uu____960 = (

let uu____961 = (FStar_Util.colorize_bold flag)
in (

let uu____962 = (FStar_Util.colorize_bold argname)
in (FStar_Util.format2 "  --%s %s\n" uu____961 uu____962)))
in (FStar_Util.print_string uu____960))
end
| uu____963 -> begin
(

let uu____964 = (

let uu____965 = (FStar_Util.colorize_bold flag)
in (

let uu____966 = (FStar_Util.colorize_bold argname)
in (FStar_Util.format3 "  --%s %s  %s\n" uu____965 uu____966 doc)))
in (FStar_Util.print_string uu____964))
end)
end)
end)) specs);
))


let mk_spec : (FStar_BaseTypes.char * Prims.string * option_val FStar_Getopt.opt_variant * Prims.string)  ->  FStar_Getopt.opt = (fun o -> (

let uu____980 = o
in (match (uu____980) with
| (ns, name, arg, desc) -> begin
(

let arg1 = (match (arg) with
| FStar_Getopt.ZeroArgs (f) -> begin
(

let g = (fun uu____1001 -> (

let uu____1002 = (

let uu____1005 = (f ())
in ((name), (uu____1005)))
in (set_option' uu____1002)))
in FStar_Getopt.ZeroArgs (g))
end
| FStar_Getopt.OneArg (f, d) -> begin
(

let g = (fun x -> (

let uu____1016 = (

let uu____1019 = (f x)
in ((name), (uu____1019)))
in (set_option' uu____1016)))
in FStar_Getopt.OneArg (((g), (d))))
end)
in ((ns), (name), (arg1), (desc)))
end)))


let cons_extract_module : Prims.string  ->  option_val = (fun s -> (

let uu____1026 = (

let uu____1028 = (

let uu____1030 = (get_extract_module ())
in ((FStar_String.lowercase s))::uu____1030)
in (FStar_All.pipe_right uu____1028 (FStar_List.map (fun _0_26 -> String (_0_26)))))
in List (uu____1026)))


let cons_extract_namespace : Prims.string  ->  option_val = (fun s -> (

let uu____1037 = (

let uu____1039 = (

let uu____1041 = (get_extract_namespace ())
in ((FStar_String.lowercase s))::uu____1041)
in (FStar_All.pipe_right uu____1039 (FStar_List.map (fun _0_27 -> String (_0_27)))))
in List (uu____1037)))


let add_extract_module : Prims.string  ->  Prims.unit = (fun s -> (

let uu____1048 = (cons_extract_module s)
in (set_option "extract_module" uu____1048)))


let add_extract_namespace : Prims.string  ->  Prims.unit = (fun s -> (

let uu____1052 = (cons_extract_namespace s)
in (set_option "extract_namespace" uu____1052)))


let cons_verify_module : Prims.string  ->  option_val = (fun s -> (

let uu____1056 = (

let uu____1058 = (

let uu____1060 = (get_verify_module ())
in ((FStar_String.lowercase s))::uu____1060)
in (FStar_All.pipe_right uu____1058 (FStar_List.map (fun _0_28 -> String (_0_28)))))
in List (uu____1056)))


let cons_using_facts_from : Prims.string  ->  option_val = (fun s -> ((set_option "z3refresh" (Bool (true)));
(

let uu____1068 = (get_using_facts_from ())
in (match (uu____1068) with
| FStar_Pervasives_Native.None -> begin
List ((String (s))::[])
end
| FStar_Pervasives_Native.Some (l) -> begin
(

let uu____1075 = (FStar_List.map (fun _0_29 -> String (_0_29)) ((s)::l))
in List (uu____1075))
end));
))


let add_verify_module : Prims.string  ->  Prims.unit = (fun s -> (

let uu____1080 = (cons_verify_module s)
in (set_option "verify_module" uu____1080)))


let rec specs : Prims.unit  ->  FStar_Getopt.opt Prims.list = (fun uu____1094 -> (

let specs1 = (((FStar_Getopt.noshort), ("admit_smt_queries"), (FStar_Getopt.OneArg ((((fun s -> (match ((s = "true")) with
| true -> begin
Bool (true)
end
| uu____1112 -> begin
(match ((s = "false")) with
| true -> begin
Bool (false)
end
| uu____1113 -> begin
(failwith "Invalid argument to --admit_smt_queries")
end)
end))), ("[true|false]")))), ("Admit SMT queries, unsafe! (default \'false\')")))::(((FStar_Getopt.noshort), ("codegen"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1123 = (parse_codegen s)
in String (uu____1123)))), ("[OCaml|FSharp|Kremlin]")))), ("Generate code for execution")))::(((FStar_Getopt.noshort), ("codegen-lib"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1133 = (

let uu____1135 = (

let uu____1137 = (get_codegen_lib ())
in (s)::uu____1137)
in (FStar_All.pipe_right uu____1135 (FStar_List.map (fun _0_30 -> String (_0_30)))))
in List (uu____1133)))), ("[namespace]")))), ("External runtime library (i.e. M.N.x extracts to M.N.X instead of M_N.x)")))::(((FStar_Getopt.noshort), ("debug"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1150 = (

let uu____1152 = (

let uu____1154 = (get_debug ())
in (x)::uu____1154)
in (FStar_All.pipe_right uu____1152 (FStar_List.map (fun _0_31 -> String (_0_31)))))
in List (uu____1150)))), ("[module name]")))), ("Print lots of debugging information while checking module")))::(((FStar_Getopt.noshort), ("debug_level"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1167 = (

let uu____1169 = (

let uu____1171 = (get_debug_level ())
in (x)::uu____1171)
in (FStar_All.pipe_right uu____1169 (FStar_List.map (fun _0_32 -> String (_0_32)))))
in List (uu____1167)))), ("[Low|Medium|High|Extreme|...]")))), ("Control the verbosity of debugging info")))::(((FStar_Getopt.noshort), ("dep"), (FStar_Getopt.OneArg ((((fun x -> (match (((x = "make") || (x = "graph"))) with
| true -> begin
String (x)
end
| uu____1184 -> begin
(failwith "invalid argument to \'dep\'")
end))), ("[make|graph]")))), ("Output the transitive closure of the dependency graph in a format suitable for the given tool")))::(((FStar_Getopt.noshort), ("detail_errors"), (FStar_Getopt.ZeroArgs ((fun uu____1191 -> Bool (true)))), ("Emit a detailed error report by asking the SMT solver many queries; will take longer;\n         implies n_cores=1")))::(((FStar_Getopt.noshort), ("doc"), (FStar_Getopt.ZeroArgs ((fun uu____1198 -> Bool (true)))), ("Extract Markdown documentation files for the input modules, as well as an index. Output is written to --odir directory.")))::(((FStar_Getopt.noshort), ("dump_module"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1208 = (

let uu____1210 = (

let uu____1212 = (get_dump_module ())
in (x)::uu____1212)
in (FStar_All.pipe_right uu____1210 (FStar_List.map (fun _0_33 -> String (_0_33)))))
in (FStar_All.pipe_right uu____1208 (fun _0_34 -> List (_0_34)))))), ("[module name]")))), ("")))::(((FStar_Getopt.noshort), ("eager_inference"), (FStar_Getopt.ZeroArgs ((fun uu____1223 -> Bool (true)))), ("Solve all type-inference constraints eagerly; more efficient but at the cost of generality")))::(((FStar_Getopt.noshort), ("explicit_deps"), (FStar_Getopt.ZeroArgs ((fun uu____1230 -> Bool (true)))), ("Do not find dependencies automatically, the user provides them on the command-line")))::(((FStar_Getopt.noshort), ("extract_all"), (FStar_Getopt.ZeroArgs ((fun uu____1237 -> Bool (true)))), ("Discover the complete dependency graph and do not stop at interface boundaries")))::(((FStar_Getopt.noshort), ("extract_module"), (FStar_Getopt.OneArg (((cons_extract_module), ("[module name]")))), ("Only extract the specified modules (instead of the possibly-partial dependency graph)")))::(((FStar_Getopt.noshort), ("extract_namespace"), (FStar_Getopt.OneArg (((cons_extract_namespace), ("[namespace name]")))), ("Only extract modules in the specified namespace")))::(((FStar_Getopt.noshort), ("fstar_home"), (FStar_Getopt.OneArg ((((fun _0_35 -> Path (_0_35))), ("[dir]")))), ("Set the FSTAR_HOME variable to [dir]")))::(((FStar_Getopt.noshort), ("hide_genident_nums"), (FStar_Getopt.ZeroArgs ((fun uu____1268 -> Bool (true)))), ("Don\'t print generated identifier numbers")))::(((FStar_Getopt.noshort), ("hide_uvar_nums"), (FStar_Getopt.ZeroArgs ((fun uu____1275 -> Bool (true)))), ("Don\'t print unification variable numbers")))::(((FStar_Getopt.noshort), ("hint_info"), (FStar_Getopt.ZeroArgs ((fun uu____1282 -> Bool (true)))), ("Print information regarding hints")))::(((FStar_Getopt.noshort), ("hint_file"), (FStar_Getopt.OneArg ((((fun _0_36 -> Path (_0_36))), ("[path]")))), ("Read/write hints to <path> (instead of module-specific hints files)")))::(((FStar_Getopt.noshort), ("in"), (FStar_Getopt.ZeroArgs ((fun uu____1297 -> Bool (true)))), ("Legacy interactive mode; reads input from stdin")))::(((FStar_Getopt.noshort), ("ide"), (FStar_Getopt.ZeroArgs ((fun uu____1304 -> Bool (true)))), ("JSON-based interactive mode for IDEs")))::(((FStar_Getopt.noshort), ("include"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1314 = (

let uu____1316 = (

let uu____1318 = (get_include ())
in (FStar_List.map (fun _0_37 -> String (_0_37)) uu____1318))
in (FStar_List.append uu____1316 ((Path (s))::[])))
in List (uu____1314)))), ("[path]")))), ("A directory in which to search for files included on the command line")))::(((FStar_Getopt.noshort), ("indent"), (FStar_Getopt.ZeroArgs ((fun uu____1326 -> Bool (true)))), ("Parses and outputs the files on the command line")))::(((FStar_Getopt.noshort), ("initial_fuel"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1336 = (FStar_Util.int_of_string x)
in Int (uu____1336)))), ("[non-negative integer]")))), ("Number of unrolling of recursive functions to try initially (default 2)")))::(((FStar_Getopt.noshort), ("initial_ifuel"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1346 = (FStar_Util.int_of_string x)
in Int (uu____1346)))), ("[non-negative integer]")))), ("Number of unrolling of inductive datatypes to try at first (default 1)")))::(((FStar_Getopt.noshort), ("inline_arith"), (FStar_Getopt.ZeroArgs ((fun uu____1353 -> Bool (true)))), ("Inline definitions of arithmetic functions in the SMT encoding")))::(((FStar_Getopt.noshort), ("lax"), (FStar_Getopt.ZeroArgs ((fun uu____1360 -> Bool (true)))), ("Run the lax-type checker only (admit all verification conditions)")))::(((FStar_Getopt.noshort), ("lax_except"), (FStar_Getopt.OneArg ((((fun _0_38 -> String (_0_38))), ("[id]")))), ("Run the lax-type checker only (admit all verification conditions), except on the query labelled <id>")))::(((FStar_Getopt.noshort), ("log_types"), (FStar_Getopt.ZeroArgs ((fun uu____1375 -> Bool (true)))), ("Print types computed for data/val/let-bindings")))::(((FStar_Getopt.noshort), ("log_queries"), (FStar_Getopt.ZeroArgs ((fun uu____1382 -> Bool (true)))), ("Log the Z3 queries in several queries-*.smt2 files, as we go")))::(((FStar_Getopt.noshort), ("max_fuel"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1392 = (FStar_Util.int_of_string x)
in Int (uu____1392)))), ("[non-negative integer]")))), ("Number of unrolling of recursive functions to try at most (default 8)")))::(((FStar_Getopt.noshort), ("max_ifuel"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1402 = (FStar_Util.int_of_string x)
in Int (uu____1402)))), ("[non-negative integer]")))), ("Number of unrolling of inductive datatypes to try at most (default 2)")))::(((FStar_Getopt.noshort), ("min_fuel"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1412 = (FStar_Util.int_of_string x)
in Int (uu____1412)))), ("[non-negative integer]")))), ("Minimum number of unrolling of recursive functions to try (default 1)")))::(((FStar_Getopt.noshort), ("MLish"), (FStar_Getopt.ZeroArgs ((fun uu____1419 -> Bool (true)))), ("Trigger various specializations for compiling the F* compiler itself (not meant for user code)")))::(((FStar_Getopt.noshort), ("n_cores"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1429 = (FStar_Util.int_of_string x)
in Int (uu____1429)))), ("[positive integer]")))), ("Maximum number of cores to use for the solver (implies detail_errors = false) (default 1)")))::(((FStar_Getopt.noshort), ("no_default_includes"), (FStar_Getopt.ZeroArgs ((fun uu____1436 -> Bool (true)))), ("Ignore the default module search paths")))::(((FStar_Getopt.noshort), ("no_extract"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1446 = (

let uu____1448 = (

let uu____1450 = (get_no_extract ())
in (x)::uu____1450)
in (FStar_All.pipe_right uu____1448 (FStar_List.map (fun _0_39 -> String (_0_39)))))
in List (uu____1446)))), ("[module name]")))), ("Do not extract code from this module")))::(((FStar_Getopt.noshort), ("no_location_info"), (FStar_Getopt.ZeroArgs ((fun uu____1460 -> Bool (true)))), ("Suppress location information in the generated OCaml output (only relevant with --codegen OCaml)")))::(((FStar_Getopt.noshort), ("odir"), (FStar_Getopt.OneArg ((((fun p -> (

let uu____1470 = (validate_dir p)
in Path (uu____1470)))), ("[dir]")))), ("Place output in directory [dir]")))::(((FStar_Getopt.noshort), ("prims"), (FStar_Getopt.OneArg ((((fun _0_40 -> String (_0_40))), ("file")))), ("")))::(((FStar_Getopt.noshort), ("print_bound_var_types"), (FStar_Getopt.ZeroArgs ((fun uu____1485 -> Bool (true)))), ("Print the types of bound variables")))::(((FStar_Getopt.noshort), ("print_effect_args"), (FStar_Getopt.ZeroArgs ((fun uu____1492 -> Bool (true)))), ("Print inferred predicate transformers for all computation types")))::(((FStar_Getopt.noshort), ("print_fuels"), (FStar_Getopt.ZeroArgs ((fun uu____1499 -> Bool (true)))), ("Print the fuel amounts used for each successful query")))::(((FStar_Getopt.noshort), ("print_full_names"), (FStar_Getopt.ZeroArgs ((fun uu____1506 -> Bool (true)))), ("Print full names of variables")))::(((FStar_Getopt.noshort), ("print_implicits"), (FStar_Getopt.ZeroArgs ((fun uu____1513 -> Bool (true)))), ("Print implicit arguments")))::(((FStar_Getopt.noshort), ("print_universes"), (FStar_Getopt.ZeroArgs ((fun uu____1520 -> Bool (true)))), ("Print universes")))::(((FStar_Getopt.noshort), ("print_z3_statistics"), (FStar_Getopt.ZeroArgs ((fun uu____1527 -> Bool (true)))), ("Print Z3 statistics for each SMT query")))::(((FStar_Getopt.noshort), ("prn"), (FStar_Getopt.ZeroArgs ((fun uu____1534 -> Bool (true)))), ("Print full names (deprecated; use --print_full_names instead)")))::(((FStar_Getopt.noshort), ("record_hints"), (FStar_Getopt.ZeroArgs ((fun uu____1541 -> Bool (true)))), ("Record a database of hints for efficient proof replay")))::(((FStar_Getopt.noshort), ("check_hints"), (FStar_Getopt.ZeroArgs ((fun uu____1548 -> Bool (true)))), ("Check new hints for replayability")))::(((FStar_Getopt.noshort), ("reuse_hint_for"), (FStar_Getopt.OneArg ((((fun _0_41 -> String (_0_41))), ("top-level name in the current module")))), ("Optimistically, attempt using the recorded hint for \'f\' when trying to verify some other term \'g\'")))::(((FStar_Getopt.noshort), ("show_signatures"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1566 = (

let uu____1568 = (

let uu____1570 = (get_show_signatures ())
in (x)::uu____1570)
in (FStar_All.pipe_right uu____1568 (FStar_List.map (fun _0_42 -> String (_0_42)))))
in List (uu____1566)))), ("[module name]")))), ("Show the checked signatures for all top-level symbols in the module")))::(((FStar_Getopt.noshort), ("silent"), (FStar_Getopt.ZeroArgs ((fun uu____1580 -> Bool (true)))), (" ")))::(((FStar_Getopt.noshort), ("smt"), (FStar_Getopt.OneArg ((((fun _0_43 -> Path (_0_43))), ("[path]")))), ("Path to the Z3 SMT solver (we could eventually support other solvers)")))::(((FStar_Getopt.noshort), ("smtencoding.elim_box"), (FStar_Getopt.OneArg ((((string_as_bool "smtencoding.elim_box")), ("true|false")))), ("Toggle a peephole optimization that eliminates redundant uses of boxing/unboxing in the SMT encoding (default \'false\')")))::(((FStar_Getopt.noshort), ("smtencoding.nl_arith_repr"), (FStar_Getopt.OneArg ((((fun _0_44 -> String (_0_44))), ("native|wrapped|boxwrap")))), ("Control the representation of non-linear arithmetic functions in the SMT encoding:\n\t\ti.e., if \'boxwrap\' use \'Prims.op_Multiply, Prims.op_Division, Prims.op_Modulus\'; \n\t\tif \'native\' use \'*, div, mod\';\n\t\tif \'wrapped\' use \'_mul, _div, _mod : Int*Int -> Int\'; \n\t\t(default \'boxwrap\')")))::(((FStar_Getopt.noshort), ("smtencoding.l_arith_repr"), (FStar_Getopt.OneArg ((((fun _0_45 -> String (_0_45))), ("native|boxwrap")))), ("Toggle the representation of linear arithmetic functions in the SMT encoding:\n\t\ti.e., if \'boxwrap\', use \'Prims.op_Addition, Prims.op_Subtraction, Prims.op_Minus\'; \n\t\tif \'native\', use \'+, -, -\'; \n\t\t(default \'boxwrap\')")))::(((FStar_Getopt.noshort), ("smt_solver"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1622 = (parse_solver s)
in String (uu____1622)))), ("[Z3|CVC4]")))), ("SMT solver in use (usually Z3, but could be CVC4)")))::(((FStar_Getopt.noshort), ("split_cases"), (FStar_Getopt.OneArg ((((fun n1 -> (

let uu____1632 = (FStar_Util.int_of_string n1)
in Int (uu____1632)))), ("[positive integer]")))), ("Partition VC of a match into groups of [n] cases")))::(((FStar_Getopt.noshort), ("timing"), (FStar_Getopt.ZeroArgs ((fun uu____1639 -> Bool (true)))), ("Print the time it takes to verify each top-level definition")))::(((FStar_Getopt.noshort), ("trace_error"), (FStar_Getopt.ZeroArgs ((fun uu____1646 -> Bool (true)))), ("Don\'t print an error message; show an exception trace instead")))::(((FStar_Getopt.noshort), ("ugly"), (FStar_Getopt.ZeroArgs ((fun uu____1653 -> Bool (true)))), ("Emit output formatted for debugging")))::(((FStar_Getopt.noshort), ("unthrottle_inductives"), (FStar_Getopt.ZeroArgs ((fun uu____1660 -> Bool (true)))), ("Let the SMT solver unfold inductive types to arbitrary depths (may affect verifier performance)")))::(((FStar_Getopt.noshort), ("use_eq_at_higher_order"), (FStar_Getopt.ZeroArgs ((fun uu____1667 -> Bool (true)))), ("Use equality constraints when comparing higher-order types (Temporary)")))::(((FStar_Getopt.noshort), ("use_hints"), (FStar_Getopt.ZeroArgs ((fun uu____1674 -> Bool (true)))), ("Use a previously recorded hints database for proof replay")))::(((FStar_Getopt.noshort), ("no_tactics"), (FStar_Getopt.ZeroArgs ((fun uu____1681 -> Bool (true)))), ("Do not run the tactic engine before discharging a VC")))::(((FStar_Getopt.noshort), ("using_facts_from"), (FStar_Getopt.OneArg (((cons_using_facts_from), ("[namespace | fact id]")))), ("Implies --z3refresh; prunes the context to include facts from the given namespace of fact id (multiple uses of this option will prune the context to include those facts that match any of the provided namespaces / fact ids")))::(((FStar_Getopt.noshort), ("verify_all"), (FStar_Getopt.ZeroArgs ((fun uu____1696 -> Bool (true)))), ("With automatic dependencies, verify all the dependencies, not just the files passed on the command-line.")))::(((FStar_Getopt.noshort), ("verify_module"), (FStar_Getopt.OneArg (((cons_verify_module), ("[module name]")))), ("Name of the module to verify")))::(((FStar_Getopt.noshort), ("__temp_no_proj"), (FStar_Getopt.OneArg ((((fun x -> (

let uu____1714 = (

let uu____1716 = (

let uu____1718 = (get___temp_no_proj ())
in (x)::uu____1718)
in (FStar_All.pipe_right uu____1716 (FStar_List.map (fun _0_46 -> String (_0_46)))))
in List (uu____1714)))), ("[module name]")))), ("Don\'t generate projectors for this module")))::((('v'), ("version"), (FStar_Getopt.ZeroArgs ((fun uu____1728 -> ((display_version ());
(FStar_All.exit (Prims.parse_int "0"));
)))), ("Display version number")))::(((FStar_Getopt.noshort), ("warn_default_effects"), (FStar_Getopt.ZeroArgs ((fun uu____1736 -> Bool (true)))), ("Warn when (a -> b) is desugared to (a -> Tot b)")))::(((FStar_Getopt.noshort), ("z3cliopt"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1746 = (

let uu____1748 = (

let uu____1750 = (get_z3cliopt ())
in (FStar_List.append uu____1750 ((s)::[])))
in (FStar_All.pipe_right uu____1748 (FStar_List.map (fun _0_47 -> String (_0_47)))))
in List (uu____1746)))), ("[option]")))), ("Z3 command line options")))::(((FStar_Getopt.noshort), ("z3refresh"), (FStar_Getopt.ZeroArgs ((fun uu____1760 -> Bool (true)))), ("Restart Z3 after each query; useful for ensuring proof robustness")))::(((FStar_Getopt.noshort), ("z3rlimit"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1770 = (FStar_Util.int_of_string s)
in Int (uu____1770)))), ("[positive integer]")))), ("Set the Z3 per-query resource limit (default 5 units, taking roughtly 5s)")))::(((FStar_Getopt.noshort), ("z3rlimit_factor"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1780 = (FStar_Util.int_of_string s)
in Int (uu____1780)))), ("[positive integer]")))), ("Set the Z3 per-query resource limit multiplier. This is useful when, say, regenerating hints and you want to be more lax. (default 1)")))::(((FStar_Getopt.noshort), ("z3seed"), (FStar_Getopt.OneArg ((((fun s -> (

let uu____1790 = (FStar_Util.int_of_string s)
in Int (uu____1790)))), ("[positive integer]")))), ("Set the Z3 random seed (default 0)")))::(((FStar_Getopt.noshort), ("z3timeout"), (FStar_Getopt.OneArg ((((fun s -> ((FStar_Util.print_string "Warning: z3timeout ignored; use z3rlimit instead\n");
(

let uu____1801 = (FStar_Util.int_of_string s)
in Int (uu____1801));
))), ("[positive integer]")))), ("Set the Z3 per-query (soft) timeout to [t] seconds (default 5)")))::(((FStar_Getopt.noshort), ("__no_positivity"), (FStar_Getopt.ZeroArgs ((fun uu____1808 -> Bool (true)))), ("Don\'t check positivity of inductive types")))::[]
in (

let uu____1814 = (FStar_List.map mk_spec specs1)
in ((('h'), ("help"), (FStar_Getopt.ZeroArgs ((fun x -> ((display_usage_aux specs1);
(FStar_All.exit (Prims.parse_int "0"));
)))), ("Display this information")))::uu____1814)))
and parse_codegen : Prims.string  ->  Prims.string = (fun s -> (match (s) with
| "Kremlin" -> begin
s
end
| "OCaml" -> begin
s
end
| "FSharp" -> begin
s
end
| uu____1835 -> begin
((FStar_Util.print_string "Wrong argument to codegen flag\n");
(

let uu____1838 = (specs ())
in (display_usage_aux uu____1838));
(FStar_All.exit (Prims.parse_int "1"));
)
end))
and parse_solver : Prims.string  ->  Prims.string = (fun s -> (match (s) with
| "Z3" -> begin
s
end
| "CVC4" -> begin
s
end
| "z3" -> begin
s
end
| "cvc4" -> begin
s
end
| uu____1846 -> begin
((FStar_Util.print_string "Wrong argument to \'smt_solver\' flag\n");
(

let uu____1849 = (specs ())
in (display_usage_aux uu____1849));
(FStar_All.exit (Prims.parse_int "1"));
)
end))
and string_as_bool : Prims.string  ->  Prims.string  ->  option_val = (fun option_name uu___55_1857 -> (match (uu___55_1857) with
| "true" -> begin
Bool (true)
end
| "false" -> begin
Bool (false)
end
| uu____1858 -> begin
((FStar_Util.print1 "Wrong argument to %s\n" option_name);
(

let uu____1861 = (specs ())
in (display_usage_aux uu____1861));
(FStar_All.exit (Prims.parse_int "1"));
)
end))
and validate_dir : Prims.string  ->  Prims.string = (fun p -> ((FStar_Util.mkdir false p);
p;
))


let docs : Prims.unit  ->  (Prims.string * Prims.string) Prims.list = (fun uu____1875 -> (

let uu____1876 = (specs ())
in (FStar_List.map (fun uu____1890 -> (match (uu____1890) with
| (uu____1898, name, uu____1900, doc) -> begin
((name), (doc))
end)) uu____1876)))


let settable : Prims.string  ->  Prims.bool = (fun uu___56_1906 -> (match (uu___56_1906) with
| "admit_smt_queries" -> begin
true
end
| "debug" -> begin
true
end
| "debug_level" -> begin
true
end
| "detail_errors" -> begin
true
end
| "eager_inference" -> begin
true
end
| "hide_genident_nums" -> begin
true
end
| "hide_uvar_nums" -> begin
true
end
| "hint_info" -> begin
true
end
| "hint_file" -> begin
true
end
| "initial_fuel" -> begin
true
end
| "initial_ifuel" -> begin
true
end
| "inline_arith" -> begin
true
end
| "lax" -> begin
true
end
| "lax_except" -> begin
true
end
| "log_types" -> begin
true
end
| "log_queries" -> begin
true
end
| "max_fuel" -> begin
true
end
| "max_ifuel" -> begin
true
end
| "min_fuel" -> begin
true
end
| "ugly" -> begin
true
end
| "print_bound_var_types" -> begin
true
end
| "print_effect_args" -> begin
true
end
| "print_fuels" -> begin
true
end
| "print_full_names" -> begin
true
end
| "print_implicits" -> begin
true
end
| "print_universes" -> begin
true
end
| "print_z3_statistics" -> begin
true
end
| "prn" -> begin
true
end
| "show_signatures" -> begin
true
end
| "silent" -> begin
true
end
| "smtencoding.elim_box" -> begin
true
end
| "smtencoding.nl_arith_repr" -> begin
true
end
| "smtencoding.l_arith_repr" -> begin
true
end
| "split_cases" -> begin
true
end
| "timing" -> begin
true
end
| "trace_error" -> begin
true
end
| "unthrottle_inductives" -> begin
true
end
| "use_eq_at_higher_order" -> begin
true
end
| "no_tactics" -> begin
true
end
| "using_facts_from" -> begin
true
end
| "__temp_no_proj" -> begin
true
end
| "reuse_hint_for" -> begin
true
end
| "z3rlimit_factor" -> begin
true
end
| "z3rlimit" -> begin
true
end
| "z3refresh" -> begin
true
end
| uu____1907 -> begin
false
end))


let resettable : Prims.string  ->  Prims.bool = (fun s -> ((((settable s) || (s = "z3timeout")) || (s = "z3seed")) || (s = "z3cliopt")))


let all_specs : FStar_Getopt.opt Prims.list = (specs ())


let settable_specs : (FStar_BaseTypes.char * Prims.string * Prims.unit FStar_Getopt.opt_variant * Prims.string) Prims.list = (FStar_All.pipe_right all_specs (FStar_List.filter (fun uu____1930 -> (match (uu____1930) with
| (uu____1936, x, uu____1938, uu____1939) -> begin
(settable x)
end))))


let resettable_specs : (FStar_BaseTypes.char * Prims.string * Prims.unit FStar_Getopt.opt_variant * Prims.string) Prims.list = (FStar_All.pipe_right all_specs (FStar_List.filter (fun uu____1960 -> (match (uu____1960) with
| (uu____1966, x, uu____1968, uu____1969) -> begin
(resettable x)
end))))


let display_usage : Prims.unit  ->  Prims.unit = (fun uu____1974 -> (

let uu____1975 = (specs ())
in (display_usage_aux uu____1975)))


let fstar_home : Prims.unit  ->  Prims.string = (fun uu____1984 -> (

let uu____1985 = (get_fstar_home ())
in (match (uu____1985) with
| FStar_Pervasives_Native.None -> begin
(

let x = (FStar_Util.get_exec_dir ())
in (

let x1 = (Prims.strcat x "/..")
in ((set_option' (("fstar_home"), (String (x1))));
x1;
)))
end
| FStar_Pervasives_Native.Some (x) -> begin
x
end)))

exception File_argument of (Prims.string)


let uu___is_File_argument : Prims.exn  ->  Prims.bool = (fun projectee -> (match (projectee) with
| File_argument (uu____1997) -> begin
true
end
| uu____1998 -> begin
false
end))


let __proj__File_argument__item__uu___ : Prims.exn  ->  Prims.string = (fun projectee -> (match (projectee) with
| File_argument (uu____2005) -> begin
uu____2005
end))


let set_options : options  ->  Prims.string  ->  FStar_Getopt.parse_cmdline_res = (fun o s -> (

let specs1 = (match (o) with
| Set -> begin
settable_specs
end
| Reset -> begin
resettable_specs
end
| Restore -> begin
all_specs
end)
in try
(match (()) with
| () -> begin
(match ((s = "")) with
| true -> begin
FStar_Getopt.Success
end
| uu____2026 -> begin
(FStar_Getopt.parse_string specs1 (fun s1 -> (FStar_Pervasives.raise (File_argument (s1)))) s)
end)
end)
with
| File_argument (s1) -> begin
(

let uu____2031 = (FStar_Util.format1 "File %s is not a valid option" s1)
in FStar_Getopt.Error (uu____2031))
end))


let file_list_ : Prims.string Prims.list FStar_ST.ref = (FStar_Util.mk_ref [])


let parse_cmd_line : Prims.unit  ->  (FStar_Getopt.parse_cmdline_res * Prims.string Prims.list) = (fun uu____2042 -> (

let res = (

let uu____2044 = (specs ())
in (FStar_Getopt.parse_cmdline uu____2044 (fun i -> (

let uu____2047 = (

let uu____2049 = (FStar_ST.read file_list_)
in (FStar_List.append uu____2049 ((i)::[])))
in (FStar_ST.write file_list_ uu____2047)))))
in (

let uu____2057 = (

let uu____2059 = (FStar_ST.read file_list_)
in (FStar_List.map FStar_Common.try_convert_file_name_to_mixed uu____2059))
in ((res), (uu____2057)))))


let file_list : Prims.unit  ->  Prims.string Prims.list = (fun uu____2068 -> (FStar_ST.read file_list_))


let restore_cmd_line_options : Prims.bool  ->  FStar_Getopt.parse_cmdline_res = (fun should_clear -> (

let old_verify_module = (get_verify_module ())
in ((match (should_clear) with
| true -> begin
(clear ())
end
| uu____2078 -> begin
(init ())
end);
(

let r = (

let uu____2080 = (specs ())
in (FStar_Getopt.parse_cmdline uu____2080 (fun x -> ())))
in ((

let uu____2084 = (

let uu____2087 = (

let uu____2088 = (FStar_List.map (fun _0_48 -> String (_0_48)) old_verify_module)
in List (uu____2088))
in (("verify_module"), (uu____2087)))
in (set_option' uu____2084));
r;
));
)))


let should_verify : Prims.string  ->  Prims.bool = (fun m -> (

let uu____2093 = (get_lax ())
in (match (uu____2093) with
| true -> begin
false
end
| uu____2094 -> begin
(

let uu____2095 = (get_verify_all ())
in (match (uu____2095) with
| true -> begin
true
end
| uu____2096 -> begin
(

let uu____2097 = (get_verify_module ())
in (match (uu____2097) with
| [] -> begin
(

let uu____2099 = (file_list ())
in (FStar_List.existsML (fun f -> (

let f1 = (FStar_Util.basename f)
in (

let f2 = (

let uu____2104 = (

let uu____2105 = (

let uu____2106 = (

let uu____2107 = (FStar_Util.get_file_extension f1)
in (FStar_String.length uu____2107))
in ((FStar_String.length f1) - uu____2106))
in (uu____2105 - (Prims.parse_int "1")))
in (FStar_String.substring f1 (Prims.parse_int "0") uu____2104))
in ((FStar_String.lowercase f2) = m)))) uu____2099))
end
| l -> begin
(FStar_List.contains (FStar_String.lowercase m) l)
end))
end))
end)))


let dont_gen_projectors : Prims.string  ->  Prims.bool = (fun m -> (

let uu____2117 = (get___temp_no_proj ())
in (FStar_List.contains m uu____2117)))


let should_print_message : Prims.string  ->  Prims.bool = (fun m -> (

let uu____2122 = (should_verify m)
in (match (uu____2122) with
| true -> begin
(m <> "Prims")
end
| uu____2123 -> begin
false
end)))


let include_path : Prims.unit  ->  Prims.string Prims.list = (fun uu____2127 -> (

let uu____2128 = (get_no_default_includes ())
in (match (uu____2128) with
| true -> begin
(get_include ())
end
| uu____2130 -> begin
(

let h = (fstar_home ())
in (

let defs = universe_include_path_base_dirs
in (

let uu____2134 = (

let uu____2136 = (FStar_All.pipe_right defs (FStar_List.map (fun x -> (Prims.strcat h x))))
in (FStar_All.pipe_right uu____2136 (FStar_List.filter FStar_Util.file_exists)))
in (

let uu____2143 = (

let uu____2145 = (get_include ())
in (FStar_List.append uu____2145 ((".")::[])))
in (FStar_List.append uu____2134 uu____2143)))))
end)))


let find_file : Prims.string  ->  Prims.string FStar_Pervasives_Native.option = (fun filename -> (

let uu____2151 = (FStar_Util.is_path_absolute filename)
in (match (uu____2151) with
| true -> begin
(match ((FStar_Util.file_exists filename)) with
| true -> begin
FStar_Pervasives_Native.Some (filename)
end
| uu____2154 -> begin
FStar_Pervasives_Native.None
end)
end
| uu____2155 -> begin
(

let uu____2156 = (

let uu____2158 = (include_path ())
in (FStar_List.rev uu____2158))
in (FStar_Util.find_map uu____2156 (fun p -> (

let path = (FStar_Util.join_paths p filename)
in (match ((FStar_Util.file_exists path)) with
| true -> begin
FStar_Pervasives_Native.Some (path)
end
| uu____2163 -> begin
FStar_Pervasives_Native.None
end)))))
end)))


let prims : Prims.unit  ->  Prims.string = (fun uu____2166 -> (

let uu____2167 = (get_prims ())
in (match (uu____2167) with
| FStar_Pervasives_Native.None -> begin
(

let filename = "prims.fst"
in (

let uu____2170 = (find_file filename)
in (match (uu____2170) with
| FStar_Pervasives_Native.Some (result) -> begin
result
end
| FStar_Pervasives_Native.None -> begin
(

let uu____2173 = (

let uu____2174 = (FStar_Util.format1 "unable to find required file \"%s\" in the module search path.\n" filename)
in FStar_Util.Failure (uu____2174))
in (FStar_Pervasives.raise uu____2173))
end)))
end
| FStar_Pervasives_Native.Some (x) -> begin
x
end)))


let prims_basename : Prims.unit  ->  Prims.string = (fun uu____2178 -> (

let uu____2179 = (prims ())
in (FStar_Util.basename uu____2179)))


let pervasives : Prims.unit  ->  Prims.string = (fun uu____2182 -> (

let filename = "FStar.Pervasives.fst"
in (

let uu____2184 = (find_file filename)
in (match (uu____2184) with
| FStar_Pervasives_Native.Some (result) -> begin
result
end
| FStar_Pervasives_Native.None -> begin
(

let uu____2187 = (

let uu____2188 = (FStar_Util.format1 "unable to find required file \"%s\" in the module search path.\n" filename)
in FStar_Util.Failure (uu____2188))
in (FStar_Pervasives.raise uu____2187))
end))))


let pervasives_basename : Prims.unit  ->  Prims.string = (fun uu____2191 -> (

let uu____2192 = (pervasives ())
in (FStar_Util.basename uu____2192)))


let pervasives_native_basename : Prims.unit  ->  Prims.string = (fun uu____2195 -> (

let filename = "FStar.Pervasives.Native.fst"
in (

let uu____2197 = (find_file filename)
in (match (uu____2197) with
| FStar_Pervasives_Native.Some (result) -> begin
(FStar_Util.basename result)
end
| FStar_Pervasives_Native.None -> begin
(

let uu____2200 = (

let uu____2201 = (FStar_Util.format1 "unable to find required file \"%s\" in the module search path.\n" filename)
in FStar_Util.Failure (uu____2201))
in (FStar_Pervasives.raise uu____2200))
end))))


let prepend_output_dir : Prims.string  ->  Prims.string = (fun fname -> (

let uu____2205 = (get_odir ())
in (match (uu____2205) with
| FStar_Pervasives_Native.None -> begin
fname
end
| FStar_Pervasives_Native.Some (x) -> begin
(Prims.strcat x (Prims.strcat "/" fname))
end)))


let __temp_no_proj : Prims.string  ->  Prims.bool = (fun s -> (

let uu____2211 = (get___temp_no_proj ())
in (FStar_All.pipe_right uu____2211 (FStar_List.contains s))))


let admit_smt_queries : Prims.unit  ->  Prims.bool = (fun uu____2216 -> (get_admit_smt_queries ()))


let check_hints : Prims.unit  ->  Prims.bool = (fun uu____2219 -> (get_check_hints ()))


let codegen : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____2223 -> (get_codegen ()))


let codegen_libs : Prims.unit  ->  Prims.string Prims.list Prims.list = (fun uu____2228 -> (

let uu____2229 = (get_codegen_lib ())
in (FStar_All.pipe_right uu____2229 (FStar_List.map (fun x -> (FStar_Util.split x "."))))))


let debug_any : Prims.unit  ->  Prims.bool = (fun uu____2238 -> (

let uu____2239 = (get_debug ())
in (uu____2239 <> [])))


let debug_at_level : Prims.string  ->  debug_level_t  ->  Prims.bool = (fun modul level -> (((modul = "") || (

let uu____2248 = (get_debug ())
in (FStar_All.pipe_right uu____2248 (FStar_List.contains modul)))) && (debug_level_geq level)))


let dep : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____2254 -> (get_dep ()))


let detail_errors : Prims.unit  ->  Prims.bool = (fun uu____2257 -> (get_detail_errors ()))


let doc : Prims.unit  ->  Prims.bool = (fun uu____2260 -> (get_doc ()))


let dump_module : Prims.string  ->  Prims.bool = (fun s -> (

let uu____2264 = (get_dump_module ())
in (FStar_All.pipe_right uu____2264 (FStar_List.contains s))))


let eager_inference : Prims.unit  ->  Prims.bool = (fun uu____2269 -> (get_eager_inference ()))


let explicit_deps : Prims.unit  ->  Prims.bool = (fun uu____2272 -> (get_explicit_deps ()))


let extract_all : Prims.unit  ->  Prims.bool = (fun uu____2275 -> (get_extract_all ()))


let fs_typ_app : Prims.string  ->  Prims.bool = (fun filename -> (

let uu____2279 = (FStar_ST.read light_off_files)
in (FStar_List.contains filename uu____2279)))


let full_context_dependency : Prims.unit  ->  Prims.bool = (fun uu____2286 -> true)


let hide_genident_nums : Prims.unit  ->  Prims.bool = (fun uu____2289 -> (get_hide_genident_nums ()))


let hide_uvar_nums : Prims.unit  ->  Prims.bool = (fun uu____2292 -> (get_hide_uvar_nums ()))


let hint_info : Prims.unit  ->  Prims.bool = (fun uu____2295 -> (get_hint_info ()))


let hint_file : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____2299 -> (get_hint_file ()))


let ide : Prims.unit  ->  Prims.bool = (fun uu____2302 -> (get_ide ()))


let indent : Prims.unit  ->  Prims.bool = (fun uu____2305 -> (get_indent ()))


let initial_fuel : Prims.unit  ->  Prims.int = (fun uu____2308 -> (

let uu____2309 = (get_initial_fuel ())
in (

let uu____2310 = (get_max_fuel ())
in (Prims.min uu____2309 uu____2310))))


let initial_ifuel : Prims.unit  ->  Prims.int = (fun uu____2313 -> (

let uu____2314 = (get_initial_ifuel ())
in (

let uu____2315 = (get_max_ifuel ())
in (Prims.min uu____2314 uu____2315))))


let interactive : Prims.unit  ->  Prims.bool = (fun uu____2318 -> ((get_in ()) || (get_ide ())))


let lax : Prims.unit  ->  Prims.bool = (fun uu____2321 -> (get_lax ()))


let lax_except : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____2325 -> (get_lax_except ()))


let legacy_interactive : Prims.unit  ->  Prims.bool = (fun uu____2328 -> (get_in ()))


let log_queries : Prims.unit  ->  Prims.bool = (fun uu____2331 -> (get_log_queries ()))


let log_types : Prims.unit  ->  Prims.bool = (fun uu____2334 -> (get_log_types ()))


let max_fuel : Prims.unit  ->  Prims.int = (fun uu____2337 -> (get_max_fuel ()))


let max_ifuel : Prims.unit  ->  Prims.int = (fun uu____2340 -> (get_max_ifuel ()))


let min_fuel : Prims.unit  ->  Prims.int = (fun uu____2343 -> (get_min_fuel ()))


let ml_ish : Prims.unit  ->  Prims.bool = (fun uu____2346 -> (get_MLish ()))


let set_ml_ish : Prims.unit  ->  Prims.unit = (fun uu____2349 -> (set_option "MLish" (Bool (true))))


let n_cores : Prims.unit  ->  Prims.int = (fun uu____2352 -> (get_n_cores ()))


let no_default_includes : Prims.unit  ->  Prims.bool = (fun uu____2355 -> (get_no_default_includes ()))


let no_extract : Prims.string  ->  Prims.bool = (fun s -> (

let uu____2359 = (get_no_extract ())
in (FStar_All.pipe_right uu____2359 (FStar_List.contains s))))


let no_location_info : Prims.unit  ->  Prims.bool = (fun uu____2364 -> (get_no_location_info ()))


let output_dir : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____2368 -> (get_odir ()))


let ugly : Prims.unit  ->  Prims.bool = (fun uu____2371 -> (get_ugly ()))


let print_bound_var_types : Prims.unit  ->  Prims.bool = (fun uu____2374 -> (get_print_bound_var_types ()))


let print_effect_args : Prims.unit  ->  Prims.bool = (fun uu____2377 -> (get_print_effect_args ()))


let print_fuels : Prims.unit  ->  Prims.bool = (fun uu____2380 -> (get_print_fuels ()))


let print_implicits : Prims.unit  ->  Prims.bool = (fun uu____2383 -> (get_print_implicits ()))


let print_real_names : Prims.unit  ->  Prims.bool = (fun uu____2386 -> ((get_prn ()) || (get_print_full_names ())))


let print_universes : Prims.unit  ->  Prims.bool = (fun uu____2389 -> (get_print_universes ()))


let print_z3_statistics : Prims.unit  ->  Prims.bool = (fun uu____2392 -> (get_print_z3_statistics ()))


let record_hints : Prims.unit  ->  Prims.bool = (fun uu____2395 -> (get_record_hints ()))


let reuse_hint_for : Prims.unit  ->  Prims.string FStar_Pervasives_Native.option = (fun uu____2399 -> (get_reuse_hint_for ()))


let silent : Prims.unit  ->  Prims.bool = (fun uu____2402 -> (get_silent ()))


let smtencoding_elim_box : Prims.unit  ->  Prims.bool = (fun uu____2405 -> (get_smtencoding_elim_box ()))


let smtencoding_nl_arith_native : Prims.unit  ->  Prims.bool = (fun uu____2408 -> (

let uu____2409 = (get_smtencoding_nl_arith_repr ())
in (uu____2409 = "native")))


let smtencoding_nl_arith_wrapped : Prims.unit  ->  Prims.bool = (fun uu____2412 -> (

let uu____2413 = (get_smtencoding_nl_arith_repr ())
in (uu____2413 = "wrapped")))


let smtencoding_nl_arith_default : Prims.unit  ->  Prims.bool = (fun uu____2416 -> (

let uu____2417 = (get_smtencoding_nl_arith_repr ())
in (uu____2417 = "boxwrap")))


let smtencoding_l_arith_native : Prims.unit  ->  Prims.bool = (fun uu____2420 -> (

let uu____2421 = (get_smtencoding_l_arith_repr ())
in (uu____2421 = "native")))


let smtencoding_l_arith_default : Prims.unit  ->  Prims.bool = (fun uu____2424 -> (

let uu____2425 = (get_smtencoding_l_arith_repr ())
in (uu____2425 = "boxwrap")))


let smt_solver : Prims.unit  ->  solver = (fun uu____2428 -> (

let uu____2429 = (get_smtsolver ())
in (match (uu____2429) with
| FStar_Pervasives_Native.None -> begin
Z3
end
| FStar_Pervasives_Native.Some ("z3") -> begin
Z3
end
| FStar_Pervasives_Native.Some ("Z3") -> begin
Z3
end
| FStar_Pervasives_Native.Some ("cvc4") -> begin
CVC4
end
| FStar_Pervasives_Native.Some ("CVC4") -> begin
CVC4
end
| uu____2431 -> begin
(failwith "Invalid SMT solver")
end)))


let split_cases : Prims.unit  ->  Prims.int = (fun uu____2435 -> (get_split_cases ()))


let timing : Prims.unit  ->  Prims.bool = (fun uu____2438 -> (get_timing ()))


let trace_error : Prims.unit  ->  Prims.bool = (fun uu____2441 -> (get_trace_error ()))


let unthrottle_inductives : Prims.unit  ->  Prims.bool = (fun uu____2444 -> (get_unthrottle_inductives ()))


let use_eq_at_higher_order : Prims.unit  ->  Prims.bool = (fun uu____2447 -> (get_use_eq_at_higher_order ()))


let use_hints : Prims.unit  ->  Prims.bool = (fun uu____2450 -> (get_use_hints ()))


let use_tactics : Prims.unit  ->  Prims.bool = (fun uu____2453 -> (get_use_tactics ()))


let using_facts_from : Prims.unit  ->  Prims.string Prims.list FStar_Pervasives_Native.option = (fun uu____2458 -> (get_using_facts_from ()))


let verify_all : Prims.unit  ->  Prims.bool = (fun uu____2461 -> (get_verify_all ()))


let verify_module : Prims.unit  ->  Prims.string Prims.list = (fun uu____2465 -> (get_verify_module ()))


let warn_default_effects : Prims.unit  ->  Prims.bool = (fun uu____2468 -> (get_warn_default_effects ()))


let solver_exe : Prims.unit  ->  Prims.string = (fun uu____2471 -> (

let uu____2472 = (get_smt ())
in (match (uu____2472) with
| FStar_Pervasives_Native.None -> begin
(

let uu____2474 = (

let uu____2475 = (smt_solver ())
in (match (uu____2475) with
| Z3 -> begin
"z3"
end
| CVC4 -> begin
"cvc4"
end))
in (FStar_All.pipe_right uu____2474 FStar_Platform.exe))
end
| FStar_Pervasives_Native.Some (s) -> begin
s
end)))


let z3_cliopt : Prims.unit  ->  Prims.string Prims.list = (fun uu____2480 -> (get_z3cliopt ()))


let z3_refresh : Prims.unit  ->  Prims.bool = (fun uu____2483 -> (get_z3refresh ()))


let z3_rlimit : Prims.unit  ->  Prims.int = (fun uu____2486 -> (get_z3rlimit ()))


let z3_rlimit_factor : Prims.unit  ->  Prims.int = (fun uu____2489 -> (get_z3rlimit_factor ()))


let z3_seed : Prims.unit  ->  Prims.int = (fun uu____2492 -> (get_z3seed ()))


let z3_timeout : Prims.unit  ->  Prims.int = (fun uu____2495 -> (get_z3timeout ()))


let no_positivity : Prims.unit  ->  Prims.bool = (fun uu____2498 -> (get_no_positivity ()))


let should_extract : Prims.string  ->  Prims.bool = (fun m -> ((

let uu____2502 = (no_extract m)
in (not (uu____2502))) && ((extract_all ()) || (

let uu____2503 = (get_extract_module ())
in (match (uu____2503) with
| [] -> begin
(

let uu____2505 = (get_extract_namespace ())
in (match (uu____2505) with
| [] -> begin
true
end
| ns -> begin
(FStar_Util.for_some (FStar_Util.starts_with (FStar_String.lowercase m)) ns)
end))
end
| l -> begin
(FStar_List.contains (FStar_String.lowercase m) l)
end)))))




