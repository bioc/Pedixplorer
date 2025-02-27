test_that("unavailable detection works", {
    data("sampleped")
    pedi <- Pedigree(sampleped)
    expect_equal(find_unavailable(pedi),
        c(paste("1", c(
            101, 102, 107, 108, 111, 113, 121, 122, 123, 131, 132, 134, 139
        ), sep = "_"), paste("2", c(205, 210, 213), sep = "_"))
    )
    affected(ped(pedi))[25] <- NA
    set.seed(10)
    expect_equal(
        find_avail_affected(pedi)$id_trimmed,
        c("1_126")
    )
    set.seed(10)
    expect_equal(find_avail_noninform(pedi),
        c(paste("1", c(
            101, 102, 107, 108, 111, 113, 121, 122, 123, 131, 132, 134, 139
        ), sep = "_"), paste("2", c(205, 210, 213), sep = "_"))
    )
})

test_that("Unrelated detection works", {
    data("sampleped")
    pedi <- Pedigree(sampleped)
    adopted(ped(pedi)) <- FALSE

    ped1 <- pedi[famid(ped(pedi)) == 1]
    ped2 <- pedi[famid(ped(pedi)) == 2]

    set.seed(10)
    expect_equal(unrelated(ped1),
        c("1_109", "1_113", "1_133", "1_141")
    )
    set.seed(10)
    expect_equal(unrelated(ped2), c("2_203", "2_206"))
})
