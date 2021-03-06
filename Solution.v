Require Import Preloaded Coq.Lists.List VST.floyd.proofauto.

Lemma bt_invert_involution : forall (A : Type) (tree : bt A),
  bt_invert (bt_invert tree) = tree.
Proof. intros A tree; induction tree; simpl; congruence. Qed.

Lemma bt_invert_inorder : forall (A : Type) (tree : bt A),
  bt_inorder (bt_invert tree) = rev (bt_inorder tree).
Proof.
  intros A tree; induction tree; simpl; auto.
  rewrite IHtree1, IHtree2, rev_app_distr; simpl.
  now rewrite <- app_assoc.
Qed.

Lemma btrep_local_facts: forall sigma p,
   btrep sigma p |--
   !! (is_pointer_or_null p /\ (p=nullval <-> sigma=bt_leaf)).
Proof.
  induction sigma; intros.
  - unfold btrep.
    entailer!.
    split; auto.
  - unfold btrep; fold btrep.
    Intros y z.
    entailer!.
    split; intros H3.
    + subst p.
      eapply field_compatible_nullval; eauto.
    + discriminate.
Qed.

#[export] Hint Resolve btrep_local_facts : saturate_local.

Lemma btrep_valid_pointer: forall sigma p,
   btrep sigma p |-- valid_pointer p.
Proof.
  destruct sigma; intros; unfold btrep; fold btrep.
  - entailer!.
  - Intros y z.
    entailer!.
Qed.

#[export] Hint Resolve btrep_valid_pointer : valid_pointer.

Lemma body_invert: semax_body Vprog Gprog f_invert invert_spec.
Proof.
  start_function.
  forward_if (PROP (isptr p)  LOCAL (temp _p p)  SEP (btrep sigma p)).
  - forward.
    rewrite (proj1 H0) by auto.
    Exists nullval.
    entailer!.
  - forward.
    entailer!.
    destruct p; simpl in PNp; try now exfalso; try subst i.
    now simpl.
  - destruct sigma; unfold btrep; fold btrep.
    + Intros; subst p; inversion Pp.
    + Intros y z.
      forward.
      forward_call (sigma1, y).
      Intros vret.
      do 2 forward.
      forward_call (sigma2, z).
      Intros vret0.
      do 3 forward.
      simpl; unfold btrep; fold btrep.
      Exists p vret0 vret.
      entailer!.
Qed.