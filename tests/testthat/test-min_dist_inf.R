test_that("min_dist_inf works", {
    data("sampleped")
    colnames(sampleped) <- c("ped", "id", "dadid", "momid",
        "sex", "affected", "avail"
    )
    sampleped[c("id", "dadid", "momid")] <- as.data.frame(lapply(
        sampleped[c("id", "dadid", "momid")], as.character
    ), stringsAsFactors = FALSE)

    id_inf <- with(sampleped, is_informative(
        id, avail, affected, informative = "AvAf"
    ))

    res <- with(sampleped,
        min_dist_inf(id, dadid, momid, sex, id_inf
        )
    )

    expect_equal(sum(res[!is.infinite(res)], na.rm = TRUE), 97)

    id_inf <- with(sampleped, is_informative(
        id, avail, affected, informative = "Av"
    ))
    mxkin <- with(sampleped,
        min_dist_inf(id, dadid, momid, sex, id_inf)
    )
    expect_equal(sum(mxkin, na.rm = TRUE), 90)

    id_inf <- with(sampleped, is_informative(
        id, avail, affected, informative = "AvOrAf"
    ))
    mxkin <- with(sampleped,
        min_dist_inf(id, dadid, momid, sex, id_inf)
    )
    expect_equal(sum(mxkin, na.rm = TRUE), 77)
})

test_that("min_dist_inf works with Pedigree", {
    data("sampleped")
    pedi <- Pedigree(sampleped)
    pedi <- generate_colors(pedi, col_aff = "affection",
        threshold = 0.5, sup_thres_aff = TRUE
    )
    expect_equal(sum(affected(ped(pedi)), na.rm = TRUE), 22)
    pedi <- is_informative(pedi, col_aff = "affection", informative = "Av")
    mxkin <- min_dist_inf(pedi, col_aff = "affection")
    expect_s4_class(mxkin, "Pedigree")
    expect_equal(sum(kin(ped(mxkin)), na.rm = TRUE), 90)
})
