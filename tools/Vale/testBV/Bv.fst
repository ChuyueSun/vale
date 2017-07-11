module Bv

open FStar.Mul
open FStar.Seq

(* Define bitwise operators with new type BitVector. *)
abstract 
type bv_t (n:nat) = vec:seq bool{length vec = n} // abstract or private?

(* Constants *)
abstract
val zero_vec: #n:pos -> Tot (bv_t n)
let zero_vec #n = create n false
abstract
val elem_vec: #n:pos -> i:nat{i < n} -> Tot (bv_t n)
let elem_vec #n i = upd (create n false) i true
abstract
val ones_vec: #n:pos -> Tot (bv_t n)
let ones_vec #n = create n true

(* Conversions to and from nat *)
abstract
val nat_to_bv: #n:nat -> a:nat{a < pow2 n} -> Tot (bv_t n)
let rec nat_to_bv #n a =
  if n = 0 then Seq.createEmpty #bool
  else Seq.append (nat_to_bv #(n - 1) (a / 2)) (Seq.create 1 (a % 2 = 1))

(* Bitwise operators *)
abstract
val logand_vec: #n:pos -> a:bv_t n -> b:bv_t n -> Tot (bv_t n)
let rec logand_vec #n a b = 
  if n = 1 then create 1 (index a 0 && index b 0)
  else append (create 1 (index a 0 && index b 0)) (logand_vec #(n - 1) (slice a 1 n) (slice b 1 n))

abstract
val logxor_vec: #n:pos -> a:bv_t n -> b:bv_t n -> Tot (bv_t n)
let rec logxor_vec #n a b = 
  if n = 1 then create 1 (index a 0 <> index b 0)
  else append (create 1 (index a 0 <> index b 0)) (logxor_vec #(n - 1) (slice a 1 n) (slice b 1 n))

abstract
val logor_vec: #n:pos -> a:bv_t n -> b:bv_t n -> Tot (bv_t n)
let rec logor_vec #n a b = 
  if n = 1 then create 1 (index a 0 || index b 0)
  else append (create 1 (index a 0 || index b 0)) (logor_vec #(n - 1) (slice a 1 n) (slice b 1 n))

abstract
val lognot_vec: #n:pos -> a:bv_t n -> Tot (bv_t n)
let rec lognot_vec #n a = 
  if n = 1 then create 1 (not (index a 0))
  else append (create 1 (not (index a 0))) (lognot_vec #(n - 1) (slice a 1 n))

(* Bitwise operators definitions *)
val logand_vec_definition: #n:pos -> a:bv_t n -> b:bv_t n -> i:nat{i < n} ->
  Lemma (requires True)
        (ensures index (logand_vec #n a b) i = (index a i && index b i))
	[SMTPat (index (logand_vec #n a b) i)]
let rec logand_vec_definition #n a b i =
  if i = 0 then ()
  else logand_vec_definition #(n - 1) (slice a 1 n) (slice b 1 n) (i - 1)

val logxor_vec_definition: #n:pos -> a:bv_t n -> b:bv_t n -> i:nat{i < n} ->
  Lemma (requires True)
        (ensures index (logxor_vec #n a b) i = (index a i <> index b i))
	[SMTPat (index (logxor_vec #n a b) i)]
let rec logxor_vec_definition #n a b i =
  if i = 0 then ()
  else logxor_vec_definition #(n - 1) (slice a 1 n) (slice b 1 n) (i - 1)

val logor_vec_definition: #n:pos -> a:bv_t n -> b:bv_t n -> i:nat{i < n} ->
  Lemma (requires True)
        (ensures index (logor_vec #n a b) i = (index a i || index b i))
	[SMTPat (index (logor_vec #n a b) i)]
let rec logor_vec_definition #n a b i =
  if i = 0 then ()
  else logor_vec_definition #(n - 1) (slice a 1 n) (slice b 1 n) (i - 1)

val lognot_vec_definition: #n:pos -> a:bv_t n -> i:nat{i < n} ->
  Lemma (requires True)
        (ensures index (lognot_vec #n a) i = not (index a i))
	[SMTPat (index (lognot_vec #n a) i)]
let rec lognot_vec_definition #n a i =
  if i = 0 then ()
  else lognot_vec_definition #(n - 1) (slice a 1 n) (i - 1)

val lemma_xor_bounded: m:pos -> n:nat -> x:bv_t m -> y:bv_t m ->
  Lemma (requires (forall (i:nat). (i < m /\ i >= n) ==> (Seq.index x (m-1-i) = false /\ Seq.index y (m-1-i) = false)))
        (ensures  (forall (i:nat). (i < m /\ i >= n) ==> (Seq.index (logxor_vec x y) (m-1-i) = false)))
let lemma_xor_bounded m n x y = ()

(* Shift operators *)
val shift_left_vec: #n:pos -> a:bv_t n -> s:nat -> Tot (bv_t n)
let shift_left_vec #n a s =
  if s >= n then zero_vec #n
  else if s = 0 then a
  else append (slice a s n) (zero_vec #s)

val shift_right_vec: #n:pos -> a:bv_t n -> s:nat -> Tot (bv_t n)
let shift_right_vec #n a s =
  if s >= n then zero_vec #n
  else if s = 0 then a
  else append (zero_vec #s) (slice a 0 (n - s))

(* Shift operators lemmas *)
val shift_left_vec_lemma_1: #n:pos -> a:bv_t n -> s:nat -> i:nat{i < n && i >= n - s} ->
  Lemma (requires True)
        (ensures index (shift_left_vec #n a s) i = false)
	[SMTPat (index (shift_left_vec #n a s) i)]
let shift_left_vec_lemma_1 #n a s i = ()

val shift_left_vec_lemma_2: #n:pos -> a:bv_t n -> s:nat -> i:nat{i < n && i < n - s} ->
  Lemma (requires True)
        (ensures index (shift_left_vec #n a s) i = index a (i + s))
	[SMTPat (index (shift_left_vec #n a s) i)]
let shift_left_vec_lemma_2 #n a s i = ()

val shift_right_vec_lemma_1: #n:pos -> a:bv_t n -> s:nat -> i:nat{i < n && i < s} ->
  Lemma (requires True)
        (ensures index (shift_right_vec #n a s) i = false)
	[SMTPat (index (shift_right_vec #n a s) i)]
let shift_right_vec_lemma_1 #n a s i = ()

val shift_right_vec_lemma_2: #n:pos -> a:bv_t n -> s:nat -> i:nat{i < n && i >= s} ->
  Lemma (requires True)
        (ensures index (shift_right_vec #n a s) i = index a (i - s))
	[SMTPat (index (shift_right_vec #n a s) i)]
let shift_right_vec_lemma_2 #n a s i = ()
