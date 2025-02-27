rel_df <- c(
    213, 214, 1, 3,
    210, 211, 2, 3,
    140, 141, 3, 1,
    133, 134, 4, 1
)

rel_df <- matrix(rel_df, ncol = 4, byrow = TRUE)
dimnames(rel_df) <- list(NULL, c("id1", "id2", "code", "famid"))
rel_df <- data.frame(rel_df)

test_that("upd_famid works", {
    id <- c("A_1", "B_", "_3", "4", "E_5_A", "NA", NA_character_)
    famid <- c(1, 2, 3, 4, 5, 6, 7)
    expect_equal(
        upd_famid(id, famid),
        c("1_1", "2_", "3_3", "4_4", "5_5_A", "6_NA", NA_character_)
    )

    data("sampleped")

    pedi <- Pedigree(sampleped[-1], rel_df[c(1:3)])
    pedi <- make_famid(pedi)
    ids_all <- paste(famid(ped(pedi)), c(101:141, 201:214), sep = "_")
    ids_all[ids_all == "NA_113"] <- "113"
    expect_equal(
        id(upd_famid(ped(pedi), famid(ped(pedi)))),
        ids_all
    )
    expect_equal(
        id(upd_famid(ped(pedi))),
        ids_all
    )
    expect_equal(
        id(ped(upd_famid(pedi, famid(ped(pedi))))),
        ids_all
    )
    expect_equal(
        id1(rel(upd_famid(pedi))),
        c("2_213", "2_210", "1_140", "1_133")
    )
})

test_that("make_famid works", {
    id <- as.character(1:20)
    mom <- as.character(c(
        0, 0, 0, 2, 2, 2, 0, 2, 0, 0, 2, 2, 0, 2, 0, 2, 7, 7, 11, 14
    ))
    dad <- as.character(c(
        0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 3, 3, 0, 3, 0, 3, 8, 8, 10, 13
    ))
    famid <- as.character(
        c(1, 1, 1, 1, 1, 1, 1, 1, NA, 1, 1, 1, 1, 1, NA, 1, 1, 1, 1, 1)
    )
    temp <- make_famid(id, mom, dad)
    expect_equal(temp, famid)
})

test_that("make_famid works with Pedigree", {
    ## Simple case with no family id
    data("sampleped")
    pedi <- Pedigree(sampleped[-1], rel_df[c(1:3)])
    pedi <- make_famid(pedi)

    ## Expected values
    fam <- sampleped$famid
    fam[sampleped$id == "113"] <- NA # singleton
    id <- paste(fam, c(101:141, 201:214), sep = "_")
    id[id == "NA_113"] <- "113"
    expect_equal(id(ped(pedi)), id)
    expect_equal(id1(rel(pedi)), c("2_213", "2_210", "1_140", "1_133"))

    ## Updating already present family id
    data("sampleped")
    sampleped$famid[sampleped$famid == "2"] <- 3
    rel_df[c(1:3)]
    pedi <- Pedigree(sampleped, rel_df)

    pedi <- make_famid(pedi)
    expect_equal(id(ped(pedi)), id)
    expect_equal(id1(rel(pedi)), c("2_213", "2_210", "1_140", "1_133"))
})

test_that("Family check works", {
    data("sampleped")
    pedi <- Pedigree(sampleped)

    ## check them giving separate ped ids
    fcheck_df_sep <- with(sampleped,
        family_check(id, dadid, momid, famid)
    )
    fcheck_ped_sep <- family_check(pedi)
    expect_equal(as.numeric(as.vector(fcheck_df_sep[1, ])), c(1, 41, 1, 1, 0))
    expect_equal(as.numeric(as.vector(fcheck_ped_sep[1, ])), c(1, 41, 1, 1, 0))

    ## check assigning them same ped id
    fcheck_df_combined <- with(sampleped, family_check(
        as.character(id), dadid, momid, rep(1, nrow(sampleped))
    ))
    sampleped$famid[sampleped$famid == "2"] <- 1
    pedi <- Pedigree(sampleped)
    fcheck_ped_combined <- family_check(pedi)
    expect_equal(as.numeric(as.vector(fcheck_df_combined[1, ])),
        c(1, 55, 1, 2, 0)
    )
    expect_equal(as.numeric(as.vector(fcheck_ped_combined[1, ])),
        c(1, 55, 1, 2, 0)
    )

    ## Correct the family id with make_famid
    pedi <- make_famid(pedi)
    fcheck_ped_corrected <- family_check(pedi)
    expect_equal(as.numeric(as.vector(fcheck_ped_corrected[1, ])),
        c(1, 40, 0, 1, 0)
    )
    expect_equal(as.numeric(as.vector(fcheck_ped_corrected[2, ])),
        c(2, 14, 0, 1, 0)
    )
    expect_equal(as.numeric(as.vector(fcheck_ped_corrected[3, ])),
        c(NA, 1, 1, 0, 0)
    )
})
