test_that("kinship works", {
    twindat <- c(
        1, 3, 4, 2,
        2, 0, 0, 1,
        3, 8, 7, 1,
        4, 6, 5, 2,
        5, 0, 0, 2,
        6, 0, 0, 1,
        7, 0, 0, 2,
        8, 0, 0, 1,
        100, 3, 4, 1,
        101, 3, 4, 2,
        102, 3, 4, 2,
        103, 3, 4, 2,
        104, 3, 4, 2,
        105, 3, 4, 2,
        106, 3, 4, 2,
        107, 0, 0, 1,
        108, 0, 0, 1,
        201, 2, 1, 1,
        202, 2, 1, 1,
        203, 2, 1, 1,
        204, 2, 1, 1,
        205, 107, 102, 1,
        206, 108, 103, 2
    )
    twindat <- matrix(twindat, ncol = 4, byrow = TRUE)
    dimnames(twindat) <- list(NULL, c("id", "dadid", "momid", "sex"))
    twindat <- data.frame(twindat)
    twindat[c("id", "dadid", "momid")] <- as.data.frame(lapply(
        twindat[c("id", "dadid", "momid")], as.character
    ))

    relate <- data.frame(
        id1 = c(101, 102, 101, 104, 203),
        id2 = c(102, 103, 103, 105, 204),
        code = c(1, 1, 1, 2, 1)
    )

    ## Test with no special relationship
    kmat_char <- with(twindat, kinship(id, dadid, momid))
    tped <- Pedigree(twindat, missid = "0")
    kmat_ped <- kinship(tped)
    ord <- order(as.numeric(row.names(kmat_ped)))
    expect_equal(kmat_char, kmat_ped[ord, ord])

    ## Test with no special relationship with chr_type to X
    kmat_char <- with(twindat, kinship(id, dadid, momid, sex, chrtype = "X"))
    tped <- Pedigree(twindat, missid = "0")
    kmat_ped <- kinship(tped, chrtype = "X")
    ord <- order(as.numeric(row.names(kmat_ped)))
    expect_equal(kmat_char, kmat_ped[ord, ord])

    ## Test with monozygotic relationship
    tped <- Pedigree(twindat, relate, missid = "0")
    kmat <- kinship(tped)

    ## should show kinship coeff of 0.5 for where MZ twins are
    ## ids: 102-103 and 203-204
    expect_true(all(kmat[
        c("102", "101", "103"),
        c("102", "101", "103")
    ] == 0.5))
    expect_true(all(kmat[c("203", "204"), c("203", "204")] == 0.5))

    truth <- matrix(
        c(
            "5", "6", 0, # Spouse no link
            "5", "4", .25, # parent child
            "101", "103", .5, # MZ twins
            "205", "103", .25, # aunt, mz with mother
            "205", "100", .125, # aunt, dz
            "104", "105", .25, # dz twins
            "203", "204", .5, # MZ twins
            "108", "205", .0, # marry in uncle
            "205", "104", .125, # aunt who is a twin
            "205", "3", .125 # grandmother
        ),
        byrow = TRUE, ncol = 3
    )
    row <- match(truth[, 1], row.names(kmat))
    col <- match(truth[, 2], row.names(kmat))
    expect_equal(kmat[as.matrix(data.frame(row, col))], as.numeric(truth[, 3]))
})

test_that("Kinship Claus Ekstrom 09/2012", {
    ## simple test case for kinship of MZ twins from Claus Ekstrom, 9/2012
    mydata <- data.frame(
        id = 1:4,
        dadid = c(0, 0, 1, 1),
        momid = c(0, 0, 2, 2),
        sex = c("male", "female", "male", "male"),
        famid = c(1, 1, 1, 1)
    )
    relation <- data.frame(id1 = c(3), id2 = c(4), famid = c(1), code = c(1))

    pedi <- Pedigree(mydata, relation, missid = "0")

    kmat <- kinship(pedi)
    expect_true(all(kmat[3:4, 3:4] == 0.5))
})

test_that("kinship works with X chromosoms", {
    ## test Pedigree from bioinformatics manuscript
    ## try x-chrom kinship
    ## also has inbreeding and twins, for quick check
    ped2mat <- matrix(c(
        1, 1, 0, 0, 1,
        1, 2, 0, 0, 2,
        1, 3, 1, 2, 1,
        1, 4, 1, 2, 2,
        1, 5, 0, 0, 2,
        1, 6, 0, 0, 1,
        1, 7, 3, 5, 2,
        1, 8, 6, 4, 1,
        1, 9, 6, 4, 1,
        1, 10, 8, 7, 2
    ), ncol = 5, byrow = TRUE)

    ped2df <- as.data.frame(ped2mat)
    names(ped2df) <- c("fam", "id", "dadid", "momid", "sex")
    rel_df <- as.data.frame(matrix(c(8, 9, 1), ncol = 3))
    names(rel_df) <- c("id1", "id2", "code")
    ped2 <- Pedigree(ped2df, rel_df, missid = "0")

    ## regular kinship matrix
    expect_snapshot(kinship(ped2))
    expect_snapshot(kinship(ped2, chr = "X"))

    ped3 <- ped2
    sex(ped(ped3))[10] <- "unknown"

    ## regular again, should be same as above
    expect_equal(kinship(ped2), kinship(ped3))

    ## now with unknown sex, gets NAs
    k3 <- kinship(ped3, chrtype = "X")
    expect_true(all(is.na(k3[2, ])))
})

test_that("Kinship with 2 different family", {
    ped2mat <- matrix(c(
        1, 1, 0, 0, 1,
        1, 2, 0, 0, 2,
        1, 3, 1, 2, 1,
        1, 4, 1, 2, 2,
        1, 5, 0, 0, 2,
        1, 6, 0, 0, 1,
        1, 7, 3, 5, 2,
        1, 8, 6, 4, 1,
        1, 9, 6, 4, 1,
        1, 10, 8, 7, 2
    ), ncol = 5, byrow = TRUE)

    ped2df <- as.data.frame(ped2mat)
    names(ped2df) <- c("famid", "id", "dadid", "momid", "sex")

    ## testing when only one subject in a family
    peddf <- rbind(ped2df, c(2, 1, 0, 0, 1))

    peds <- Pedigree(peddf, missid = "0")
    kinfam <- kinship(peds)
    expect_true(all(kinfam["2_1", 1:10] == 0))

    ## now add two more for ped2, and check again
    peddf <- rbind(peddf,
        c(2, 2, 0, 0, 2),
        c(2, 3, 1, 2, 1)
    )
    peds <- Pedigree(peddf, missid = "0")
    kin2fam <- kinship(peds)
    expect_true(all(kin2fam[11:13, 1:10] == 0))
})

test_that("Kinship with adopted individuals", {
    data("sampleped")
    pedi <- Pedigree(sampleped[sampleped$famid %in% 2, ])
    adopted(ped(pedi))[3] <- TRUE
    expect_error(kinship(pedi))
})
