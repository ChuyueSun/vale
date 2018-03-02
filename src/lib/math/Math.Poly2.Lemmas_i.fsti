module Math.Poly2.Lemmas_i
open Math.Poly2_s
open Math.Poly2_i
open FStar.Seq
module List = FStar.List.Tot

// Derived lemmas (see Math.Poly2_i for fundamental lemmas)

val lemma_index (a:poly) : Lemma (forall (i:int).{:pattern a.[i]} a.[i] ==> 0 <= i /\ i <= degree a)

val lemma_zero_define (_:unit) : Lemma (forall (i:int).{:pattern zero.[i]} not zero.[i])
val lemma_one_define (_:unit) : Lemma (forall (i:int).{:pattern one.[i]} one.[i] == (i = 0))
val lemma_monomial_define (n:nat) : Lemma
  (forall (i:int).{:pattern (monomial n).[i]} (monomial n).[i] == (i = n))
val lemma_shift_define (p:poly) (n:nat) : Lemma
  (forall (i:int).{:pattern (shift p n).[i]} (shift p n).[i] == p.[i - n])
val lemma_reverse_define (a:poly) (n:nat) : Lemma
  (forall (i:int).{:pattern (reverse a n).[i]} (reverse a n).[i] == (a.[n - i] && i >= 0))

val lemma_zero_degree (_:unit) : Lemma (degree zero == -1)
val lemma_reverse_degree (a:poly) (n:nat) : Lemma (degree (reverse a n) <= n)
val lemma_degree_negative (a:poly) : Lemma (requires degree a < 0) (ensures a == zero)
val lemma_degree_is (a:poly) (n:nat) : Lemma
  (requires a.[n] /\ (forall (i:int).{:pattern a.[i]} i > n ==> not a.[i]))
  (ensures degree a == n)

val lemma_of_list_degree (l:list bool) : Lemma
  (requires (
    let len = List.length l in
    len == 0 \/ normalize (b2t (List.index l (len - 1)))
  ))
  (ensures (
    let len = normalize_term (List.length l) in
    let a = of_seq (of_list l) in
    degree a == len - 1 /\
    (forall (i:int).{:pattern a.[i]} a.[i] ==> (0 <= i && i < len))
  ))

val lemma_add_define (a b:poly) : Lemma
  (forall (i:int).{:pattern (a +. b).[i] \/ a.[i] \/ b.[i]} (a +. b).[i] == (a.[i] <> b.[i]))

val lemma_add_define_all (_:unit) : Lemma
  (forall (a b:poly).{:pattern (a +. b)}
    (forall (i:int).{:pattern (a +. b).[i] \/ a.[i] \/ b.[i]} (a +. b).[i] == (a.[i] <> b.[i])))

val lemma_mul_distribute_left (a b c:poly) : Lemma ((a +. b) *. c == (a *. c) +. (b *. c))
val lemma_mul_distribute_right (a b c:poly) : Lemma (a *. (b +. c) == (a *. b) +. (a *. c))

val lemma_mul_smaller_is_zero (a b:poly) : Lemma
  (requires degree b > degree (a *. b))
  (ensures a == zero /\ a *. b == zero)

val lemma_mul_reverse_shift_1 (a b:poly) (n:nat) : Lemma
  (requires degree a <= n /\ degree b <= n)
  (ensures reverse (a *. b) (n + n + 1) == shift (reverse a n *. reverse b n) 1)

val lemma_mod_distribute (a b c:poly) : Lemma
  (requires degree c >= 0)
  (ensures (a +. b) %. c == (a %. c) +. (b %. c))

val lemma_div_mod_unique (a b x y:poly) : Lemma
  (requires
    degree b >= 0 /\
    degree y < degree b /\
    a == x *. b +. y
  )
  (ensures
    x == a /. b /\
    y == a %. b
  )

val lemma_div_mod_exact (a b:poly) : Lemma
  (requires degree b >= 0)
  (ensures (a *. b) /. b == a /\ (a *. b) %. b == zero)

val lemma_mod_small (a b:poly) : Lemma
  (requires degree b >= 0 /\ degree a < degree b)
  (ensures a %. b == a)

val lemma_mod_mod (a b:poly) : Lemma
  (requires degree b >= 0)
  (ensures (a %. b) %. b == a %. b)

val lemma_mod_cancel (a:poly) : Lemma
  (requires degree a >= 0)
  (ensures a %. a == zero)

val lemma_mod_mul_mod (a b c:poly) : Lemma
  (requires degree b >= 0)
  (ensures ((a %. b) *. c) %. b == (a *. c) %. b)
