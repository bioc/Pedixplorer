% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ibd_matrix.R
\name{ibd_matrix}
\alias{ibd_matrix}
\title{IBD matrix}
\usage{
ibd_matrix(id1, id2, ibd, idmap, diagonal)
}
\arguments{
\item{id1}{A character vector with the id of the first individuals of each
pairs or a matrix or data frame with 3 columns: id1, id2, and ibd}

\item{id2}{A character vector with the id of the second individuals of each
pairs}

\item{ibd}{the IBD value for that pair}

\item{idmap}{an optional 2 column matrix or data frame whose first element
is the internal value (as found in \code{id1} and \code{id2}, and whose
second element will be used for the dimnames of the result}

\item{diagonal}{optional value for the diagonal element. If present, any
missing diagonal elements in the input data will be set to this value.}
}
\value{
a sparse matrix of class \code{dsCMatrix}.  This is the same form
used for kinship matrices.
}
\description{
Transform identity by descent (IBD) matrix data from the form produced by
external programs such as SOLAR into the compact form used by the coxme and
lmekin routines.
}
\details{
The IBD matrix for a set of n subjects will be an n by n symmetric matrix
whose i,j element is the contains, for some given genetic location, a 0/1
indicator of whether 0, 1/2 or 2/2 of the alleles for i and j are identical
by descent.  Fractional values occur if the IBD fraction must be imputed.
The diagonal will be 1.  Since a large fraction of the values will be zero,
programs such as Solar return a data set containing only the non-zero
elements.  As well, Solar will have renumbered the subjects as seq_len(n)
in such a way that families are grouped together in the matrix; a separate
index file contains the mapping between this new id and the original one.
The final matrix should be labeled with the original identifiers.
}
\examples{
df <- data.frame(
    id1 = c("1", "2", "1"),
    id2 = c("2", "3", "4"),
    ibd = c(0.5, 0.16, 0.27)
)
ibd_matrix(df$id1, df$id2, df$ibd, diagonal = 2)
}
\seealso{
\code{\link[=kinship]{kinship()}}
}
