#' @importFrom S4Vectors parallel_slot_names
NULL

#### Class integer / character ####

setClassUnion("character_OR_integer", c("character", "integer"))
setClassUnion("numeric_OR_logical", c("numeric", "logical"))
setClassUnion("missing_OR_NULL", c("missing", "NULL"))

#### Ped Class ####

#' Ped object
#'
#' S4 class to represent the identity informations of the individuals
#' in a pedigree.
#'
#' The minimal needed informations are `id`, `dadid`,
#' `momid` and `sex`.
#' The other slots are used to store recognized informations.
#' Additional columns can be added to the Ped object and will be
#' stored in the `elementMetadata` slot of the Ped object.
#'
#' @slot id A character vector with the id of the individuals.
#' @slot dadid A character vector with the id of the father of
#' the individuals.
#' @slot momid A character vector with the id of the mother of
#' the individuals.
#' @slot famid A character vector with the family identifiers of the
#' individuals (optional).
#' @slot sex An ordered factor vector for the sex of the individuals
#' (i.e. `male` < `female` < `unknown`).
#' @slot fertility A factor vector with the fertility status of the
#' individuals (optional).
#' (i.e. `infertile_choice_na` = no children by choice or unknown reason,
#' `infertile` = individual is inferile,
#' `fertile` = individual is fertile).
#' @slot miscarriage A factor vector with the miscarriage status of the
#' individuals (optional).
#' (i.e. `TOP` = Termination of Pregnancy,
#' `SAB` = Spontaneous Abortion,
#' `ECT` = Ectopic Pregnancy,
#' `FALSE` = no miscarriage).
#' @slot deceased A logical vector with the death status of the
#' individuals (optional).
#' (i.e. `FALSE` = alive,
#' `TRUE` = dead,
#' `NA` = unknown).
#' @slot avail A logical vector with the availability status of the
#' individuals (optional).
#' (i.e. `FALSE` = not available,
#' `TRUE` = available,
#' `NA` = unknown).
#' @slot evaluated A logical vector with the evaluation status of the
#' individuals (optional).
#' (i.e. `FALSE` = documented evaluation not available,
#' `TRUE` = documented evaluation available).
#' @slot consultand A logical vector with the consultand status of the
#' individuals (optional). A consultand being an individual seeking
#' genetic counseling/testing
#' (i.e. `FALSE` = not a consultand,
#' `TRUE` = consultand).
#' @slot proband A logical vector with the proband status of the
#' individuals (optional). A proband being an affected family
#' member coming to medical attention independent of other
#' family members.
#' (i.e. `FALSE` = not a proband,
#' `TRUE` = proband).
#' @slot affected A logical vector with the affection status of the
#' individuals (optional).
#' (i.e. `FALSE` = not affected,
#' `TRUE` = affected,
#' `NA` = unknown).
#' @slot carrier A logical vector with the carrier status of the
#' individuals (optional). A carrier being an individual who has
#' the genetic trait but who is not likely to manifest the
#' disease regardless of inheritance pattern
#' (i.e. `FALSE` = not carrier,
#' `TRUE` = carrier,
#' `NA` = unknown).
#' @slot asymptomatic A logical vector with the asymptomatic status of
#' the individuals (optional). An asymptomatic individual being an individual
#' clinically unaffected at this time but could later exhibit symptoms.
#' (i.e. `FALSE` = not asymptomatic,
#' `TRUE` = asymptomatic,
#' `NA` = unknown).
#' @slot adopted A logical vector with the adopted status of the
#' individuals (optional).
#' (i.e. `FALSE` = not adopted,
#' `TRUE` = adopted,
#' `NA` = unknown).
#' @slot dateofbirth A date vector with the birth date of the
#' individuals (optional).
#' @slot dateofdeath A date vector with the death date of the
#' individuals (optional).
#' @slot useful A logical vector with the usefulness status of the
#' individuals (computed).
#' (i.e. `FALSE` = not useful,
#' `TRUE` = useful).
#' @slot isinf A logical vector indicating if the individual is informative
#' or not (computed).
#' (i.e. `FALSE` = not informative,
#' `TRUE` = informative).
#' @slot kin A numeric vector with minimal kinship value between the
#' individuals and the useful individuals (computed).
#' @slot num_child_tot A numeric vector with the total number of children
#' of the individuals (computed).
#' @slot num_child_dir A numeric vector with the number of children
#' of the individuals (computed).
#' @slot num_child_ind A numeric vector with the number of children
#' of the individuals (computed).
#' @slot elementMetadata A DataFrame with the additional metadata columns
#' of the Ped object.
#' @slot metadata Meta informations about the pedigree.
#'
#' @seealso [Pedigree()]
#' @name Ped-class
#' @export
setClass("Ped",
    contains = "Vector",
    slots = c(
        id = "character",
        dadid = "character",
        momid = "character",
        famid = "character",
        sex = "factor",
        fertility = "factor",
        miscarriage = "factor",
        deceased = "logical",
        avail = "logical",
        evaluated = "logical",
        consultand = "logical",
        proband = "logical",
        affected = "logical",
        carrier = "logical",
        asymptomatic = "logical",
        adopted = "logical",
        dateofbirth = "character",
        dateofdeath = "character",
        useful = "logical",
        kin = "numeric",
        isinf = "logical",
        num_child_tot = "numeric",
        num_child_dir = "numeric",
        num_child_ind = "numeric"
    )
)

#' @importFrom S4Vectors parallel_slot_names
setMethod("parallel_slot_names", "Ped",
    function(x) {
        c(
            "id", "dadid", "momid", "famid", "sex",
            "fertility", "miscarriage", "deceased",
            "avail", "evaluated", "consultand", "proband",
            "affected", "carrier", "asymptomatic",
            "adopted", "dateofbirth", "dateofdeath",
            "useful", "kin", "isinf",
            "num_child_tot", "num_child_dir", "num_child_ind",
            callNextMethod()
        )
    }
)

setValidity("Ped", is_valid_ped)

#### Rel Class ####

#' Rel object
#'
#' S4 class to represent the special relationships in a Pedigree.
#'
#' A Rel object is a list of special relationships
#' between individuals in the pedigree.
#' It is used to create a Pedigree object.
#' The minimal needed informations are `id1`, `id2`
#' and `code`.
#'
#' If a `famid` is provided, the individuals `id` will be aggregated
#' to the `famid` character to ensure the uniqueness of the `id`.
#'
#' @slot id1 A character vector with the id of the first individual.
#' @slot id2 A character vector with the id of the second individual.
#' @slot code An ordered factor vector with the code of the special
#' relationship.
#'
#' (i.e. `MZ twin` < `DZ twin` < `UZ twin` < `Spouse`).
#' @slot famid A character vector with the famid of the individuals.
#'
#' @seealso [Pedigree()]
#' @name Rel-class
#' @export
setClass("Rel",
    contains = "Vector",
    slots = c(
        id1 = "character",
        id2 = "character",
        code = "factor",
        famid = "character"
    )
)

setMethod("parallel_slot_names", "Rel",
    function(x) {
        c(
            "id1", "id2", "code", "famid",
            callNextMethod()
        )
    }
)

setValidity("Rel", is_valid_rel)

#### Hints Class ####

#' Hints object
#'
#' The hints are used to specify the order of the individuals in the pedigree
#' and to specify the order of the spouses.
#'
#' @slot horder A numeric named vector with one element per subject in the
#' Pedigree.  It determines the relative horizontal order of subjects within
#' a sibship, as well as the relative order of processing for the founder
#' couples. (For this latter, the female founders are ordered as though they
#' were sisters).
#' @slot spouse A data.frame with one row per hinted marriage, usually
#' only a few marriages in a Pedigree will need an added hint, for
#' instance reverse the plot order of a husband/wife pair.
#' Each row contains the identifiers of the left spouse, the right hand spouse,
#' and the anchor (i.e : `1` = left, `2` = right, `0` = either).
#'
#' @seealso [Pedigree()]
#' @rdname Hints-class
#' @export
setClass("Hints",
    representation(
        horder = "numeric",
        spouse = "data.frame"
    )
)

setValidity("Hints", is_valid_hints)

#### Scale Class ####

#' Scales object
#'
#' A Scales object is a list of two data.frame.
#' The first one is used to represent the affection status of the individuals
#' and therefore the filling of the individuals in the pedigree plot.
#' The second one is used to represent the availability status of the
#' individuals and therefore the border color of the individuals in the
#' pedigree plot.
#'
#' @slot fill A data.frame with the informations for the affection status.
#' The columns needed are:
#' - 'order': the order of the affection to be used
#' - 'column_values': name of the column containing the raw values in the
#' Ped object
#' - 'column_mods': name of the column containing the mods of the transformed
#' values in the Ped object
#' - 'mods': all the different mods
#' - 'labels': the corresponding labels of each mods
#' - 'affected': a logical value indicating if the mod
#' correspond to an affected individuals
#' - 'fill': the color to use for this mods
#' - 'density': the density of the shading
#' - 'angle': the angle of the shading
#' @slot border A data.frame with the informations for the availability
#' status.
#' The columns needed are:
#' - 'column_values': name of the column containing the raw values in the
#' Ped object
#' - 'column_mods': name of the column containing the mods of the transformed
#' values in the Ped object
#' - 'mods': all the different mods
#' - 'labels': the corresponding labels of each mods
#' - 'border': the color to use for this mods
#'
#' @seealso [Pedigree()]
#' @docType class
#' @rdname Scales-class
#' @export
setClass("Scales",
    representation(
        fill = "data.frame",
        border = "data.frame"
    )
)

setValidity("Scales", is_valid_scales)

#### Pedigree Class ####
#' Pedigree object
#'
#' A pedigree is a ensemble of individuals linked to each other into
#' a family tree.
#' A Pedigree object store the informations of the individuals and the
#' special relationships between them. It also permit to store the
#' informations needed to plot the pedigree (i.e. scales and hints).
#'
#' @slot ped A Ped object for the identity informations.
#' See [Ped()] for more informations.
#' @slot rel A Rel object for the special relationships.
#' See [Rel()] for more informations.
#' @slot scales A Scales object for the filling and bordering
#' colors used in the plot.
#' See [Scales()] for more informations.
#' @slot hints A Hints object for the ordering of the
#' individuals in the plot.
#' See [Hints()] for more informations.
#'
#' @seealso
#' [Pedigree()]
#' [Ped()]
#' [Rel()]
#' [Scales()]
#' [Hints()]
#' @rdname Pedigree-class
#' @include AllValidity.R
#' @export
setClass("Pedigree",
    representation(
        ped = "Ped",         # identity data
        rel = "Rel",         # special relationships
        scales = "Scales",   # scales for the plot
        hints = "Hints"      # hints for the plot
    )
)

setValidity("Pedigree", is_valid_pedigree)
