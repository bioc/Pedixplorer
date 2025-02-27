% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bit_size.R
\name{bit_size}
\alias{bit_size}
\alias{bit_size,character_OR_integer-method}
\alias{bit_size,Pedigree-method}
\alias{bit_size,Ped-method}
\title{Bit size of a Pedigree}
\usage{
\S4method{bit_size}{character_OR_integer}(obj, momid, missid = NA_character_)

\S4method{bit_size}{Pedigree}(obj)

\S4method{bit_size}{Ped}(obj)
}
\arguments{
\item{obj}{A Ped or Pedigree object or a vector of fathers identifiers}

\item{momid}{A vector containing for each subject, the identifiers of the
biologicals mothers.}

\item{missid}{A character vector with the missing values identifiers.
All the id, dadid and momid corresponding to those values will be set
to \code{NA_character_}.}
}
\value{
A list with the following components:
\itemize{
\item bit_size The bit size of the Pedigree
\item nFounder The number of founders in the Pedigree
\item nNonFounder The number of non founders in the Pedigree
}
}
\description{
Utility function used in the \code{shrink()} function
to calculate the bit size of a Pedigree.
}
\details{
The bit size of a Pedigree is defined as :

\deqn{
    2 \times NbNonFounders - NbFounders
}

Where \code{NbNonFounders} is the number of non founders in the Pedigree
(i.e. individuals with identified parents) and
\code{NbFounders} is the number of founders in the Pedigree
(i.e. individuals without identified parents).
}
\examples{
data(sampleped)
pedi <- Pedigree(sampleped)
bit_size(pedi)
}
\seealso{
\code{\link[=shrink]{shrink()}}
}
\keyword{shrink}
