module X64.Vale.Decls
open FStar.Mul
open X64.Machine_s
open X64.Vale
open X64.Vale.State
open X64.Vale.StateLemmas
open FStar.UInt
module S = X64.Semantics_s
module P = X64.Print_s

let cf = Lemmas.cf
let overflow = Lemmas.overflow
let update_cf = Lemmas.update_cf
let update_of = Lemmas.update_of
let ins = S.ins
type ocmp = S.ocmp
type va_fuel = nat

type va_pbool = Vale.Def.PossiblyMonad.pbool
let va_ttrue () = Vale.Def.PossiblyMonad.ttrue
let va_ffalse = Vale.Def.PossiblyMonad.ffalse
let va_pbool_and x y = Vale.Def.PossiblyMonad.((&&.)) x y

let mul_nat_helper x y =
  FStar.Math.Lemmas.nat_times_nat_is_nat x y

let va_fuel_default () = 0

let va_lemma_upd_update sM =
  ()

let va_cmp_eq o1 o2 = S.OEq o1 o2
let va_cmp_ne o1 o2 = S.ONe o1 o2
let va_cmp_le o1 o2 = S.OLe o1 o2
let va_cmp_ge o1 o2 = S.OGe o1 o2
let va_cmp_lt o1 o2 = S.OLt o1 o2
let va_cmp_gt o1 o2 = S.OGt o1 o2

let eval_code = Lemmas.eval_code
let eval_while_inv = Lemmas.eval_while_inv

let mem_inv m = True
let va_ins_lemma c0 s0 = ()

let eval_ocmp = Lemmas.eval_ocmp
let valid_ocmp = Lemmas.valid_ocmp
let havoc = S.havoc

unfold let va_eval_ins = Lemmas.eval_ins

let lemma_cmp_eq s o1 o2 = ()
let lemma_cmp_ne s o1 o2 = ()
let lemma_cmp_le s o1 o2 = ()
let lemma_cmp_ge s o1 o2 = ()
let lemma_cmp_lt s o1 o2 = ()
let lemma_cmp_gt s o1 o2 = ()

let lemma_valid_cmp_eq s o1 o2 = ()
let lemma_valid_cmp_ne s o1 o2 = ()
let lemma_valid_cmp_le s o1 o2 = ()
let lemma_valid_cmp_ge s o1 o2 = ()
let lemma_valid_cmp_lt s o1 o2 = ()
let lemma_valid_cmp_gt s o1 o2 = ()

let va_compute_merge_total = Lemmas.compute_merge_total
let va_lemma_merge_total b0 s0 f0 sM fM sN = Lemmas.lemma_merge_total b0 s0 f0 sM fM sN; Lemmas.compute_merge_total f0 fM
let va_lemma_empty_total = Lemmas.lemma_empty_total
let va_lemma_ifElse_total = Lemmas.lemma_ifElse_total
let va_lemma_ifElseTrue_total = Lemmas.lemma_ifElseTrue_total
let va_lemma_ifElseFalse_total = Lemmas.lemma_ifElseFalse_total
let va_lemma_while_total = Lemmas.lemma_while_total
let va_lemma_whileTrue_total = Lemmas.lemma_whileTrue_total
let va_lemma_whileFalse_total = Lemmas.lemma_whileFalse_total
let va_lemma_whileMerge_total = Lemmas.lemma_whileMerge_total

let printer = P.printer
let print_string = FStar.IO.print_string
let print_header = P.print_header
let print_proc = P.print_proc
let print_footer = P.print_footer
let masm = P.masm
let gcc = P.gcc
