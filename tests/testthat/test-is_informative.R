test_that("is_informative works", {
    data("sampleped")

    # Test for character
    id <- as.character(sampleped$id)
    avail <- sampleped$avail
    affected <- sampleped$affection

    expect_equal(is_informative(id, avail, affected),
        c(
            "110", "116", "118", "119", "124", "127",
            "128", "201", "203", "206", "207", "214"
        )
    )
    expect_equal(
        length(is_informative(id, avail, affected, informative = "AvOrAf")),
        34
    )
    expect_equal(
        length(is_informative(id, avail, affected, informative = "Av")),
        24
    )
    expect_equal(
        length(is_informative(id, avail, affected, informative = "Af")),
        22
    )
    expect_equal(
        is_informative(
            id, avail, affected,
            informative = c("1", "110", "150", "214")
        ),
        c("110", "214")
    )
    expect_equal(
        is_informative(
            id, avail, affected,
            informative = c(TRUE, FALSE, TRUE, rep(FALSE, 52))
        ),
        c("101", "103")
    )
    expect_equal(
        length(is_informative(id, avail, affected, informative = "All")),
        55
    )
})

test_that("is_informative works with Pedigree", {
    data("sampleped")

    pedi <- Pedigree(sampleped[1:7])
    pedi <- generate_colors(pedi, col_aff = "affection",
        threshold = 0.5, sup_thres_aff = TRUE,
        add_to_scale = FALSE
    )


    ped_upd <- is_informative(pedi, col_aff = "affection",
        informative = "AvAf"
    )

    expect_equal(
        id(ped(ped_upd))[isinf(ped(ped_upd)) == TRUE],
        c(
            "1_110", "1_116", "1_118", "1_119", "1_124", "1_127",
            "1_128", "2_201", "2_203", "2_206", "2_207", "2_214"
        )
    )
    pedi <- Pedigree(sampleped[c(2:5, 7)])
    expect_snapshot_error(is_informative(
        pedi, col_aff = "test", informative = "AvAf"
    ))

    pedi <- generate_colors(pedi,
        col_aff = "sex", mods_aff = "male", add_to_scale = FALSE
    )
    expect_equal(
        sum(isinf(ped(is_informative(
            pedi, col_aff = "sex", informative = "Af"
        )))),
        length(ped(pedi, "id")[ped(pedi, "sex") == "male"])
    )

    data(minnbreast)
    # Need to remove proband due to change in affected
    pedi <- Pedigree(minnbreast[-2], cols_ren_ped = list(
        "dadid" = "fatherid", "momid" = "motherid"
    ), missid = "0")

    pedi <- generate_colors(pedi, col_aff = "education",
        threshold = 3, sup_thres_aff = TRUE, keep_full_scale = TRUE,
        add_to_scale = FALSE
    )
    expect_equal(
        sum(isinf(ped(is_informative(
            pedi, col_aff = "education", informative = "Af"
        )))),
        sum(minnbreast$education > 3, na.rm = TRUE)
    )
})
