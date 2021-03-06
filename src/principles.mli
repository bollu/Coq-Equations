(** Generation of equations and inductive graph *)
open EConstr

type statement = constr * types option
type statements = statement list
type recursive = bool

type node_kind =
  | Regular
  | Refine
  | Where
  | Nested of recursive

val pi1 : 'a * 'b * 'c -> 'a
val pi2 : 'a * 'b * 'c -> 'b
val match_arguments : Evd.evar_map -> constr array -> constr array -> int list
val filter_arguments : int list -> 'a list -> 'a list
val is_applied_to_structarg : Names.Id.t -> Syntax.rec_type option -> int -> bool option

val abstract_rec_calls : Evd.evar_map -> Names.Id.Set.t ->
  ?do_subst:bool ->
  Syntax.rec_type option ->
  int ->
  ((constr * int list) * (constr * int list) option * int *
   EConstr.rel_context * Constr.t)
  list -> constr -> rel_context * int * constr
val subst_app :Evd.evar_map ->
  constr ->
  (int -> constr -> constr array -> constr) ->
  constr -> constr
val subst_comp_proj : Evd.evar_map ->
  constr -> constr -> constr -> constr
val subst_comp_proj_split : Evd.evar_map ->
  constr -> constr -> Covering.splitting -> Covering.splitting
val clear_ind_assums : Evd.evar_map ->
  Names.MutInd.t ->
  Equations_common.rel_context -> Equations_common.rel_context
val type_of_rel : Constr.t -> rel_context -> constr
val compute_elim_type :
  Environ.env ->
  Equations_common.esigma -> Names.Id.Set.t ->
  Syntax.rec_type option ->
  ((constr * int list) * (constr * int list) option * int *
   EConstr.rel_context * Constr.t)
  list ->
  Names.MutInd.t ->
  int ->
         (int *
          ((EConstr.constr * int list) *
           ((EConstr.constr * int list) * Names.Id.t * Covering.splitting)
           option * Covering.path * EConstr.rel_context * EConstr.types *
           EConstr.constr list * (EConstr.constr * int) list * (node_kind * bool)) *
          (int *
           (bool * unit Proofview.tactic * EConstr.t * EConstr.constr option))
          list)
         list ->
  (node_kind * 'e * 'f * 'g option) list ->
  rel_context -> constr -> types -> int * types
val replace_vars_context :
  Names.Id.t list ->
  Equations_common.rel_declaration list ->
  int * Equations_common.rel_declaration list
val pr_where :
  Environ.env -> Evd.evar_map -> Constr.rel_context -> Covering.where_clause -> Pp.t
val where_instance : Covering.where_clause list -> constr list
val arguments : Evd.evar_map -> constr -> constr array
val unfold_constr : Evd.evar_map -> constr -> Proofview.V82.tac

(** Unfolding lemma tactic *)

val subst_rec_split :            Environ.env ->
           Evd.evar_map ->
           constr ->
           bool ->
           int option ->
           Covering.path ->
           Covering.context_map ->
           (Names.Id.t * constr) list ->
           Covering.splitting -> Covering.splitting

  
val update_split : Environ.env ->
  Evd.evar_map ref ->
  Names.Id.t ->
  Syntax.rec_type option ->
  constr ->
  Covering.context_map ->
  (Names.Id.t * constr) list -> Covering.splitting -> Covering.splitting * Principles_proofs.where_map

val build_equations :
  bool ->
  Environ.env ->
  Evd.evar_map ->
  ?alias:constr * Names.Id.t * Covering.splitting ->
  (Splitting.program_info * Splitting.compiled_program_info * Principles_proofs.equations_info) list ->
  unit

val computations :            Environ.env ->
           Evd.evar_map ->
           (EConstr.t * 'a * 'b) option ->
           node_kind * bool ->
           Principles_proofs.equations_info ->
           ((Equations_common.rel_context * EConstr.t *
             (EConstr.t * 'a * 'b) option * EConstr.constr list * EConstr.t *
             EConstr.t * (node_kind * bool) * Covering.splitting_rhs *
             ((EConstr.t * int list) *
              ((EConstr.constr * int list) * Names.Id.t * Covering.splitting)
              option * Covering.path * Equations_common.rel_context *
              EConstr.t * EConstr.constr list * (EConstr.constr * int) list *
              'c)
             list option)
            list as 'c)
