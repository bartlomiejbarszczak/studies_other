load("expected")

result_film_in_category = expected$film_in_category 

result_film_in_category_case_insensitive = expected$film_in_category_case_insensitive 

result_film_cast = expected$film_cast 

result_film_title_case_insensitive = expected$film_title_case_insensitive 



# Define a test
test_that("Test for film_in_category",{
  for (i in result_film_in_category){
    result <- film_in_category(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)

test_that("Test for film_in_category_case_insensitive",{
  for (i in result_film_in_category_case_insensitive){
    result <- film_in_category_case_insensitive(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)

test_that("Test for film_cast",{
  for (i in result_film_cast){
    result <- film_cast(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)

test_that("Test for film_title_case_insensitive",{
  for (i in result_film_title_case_insensitive){
    result <- film_title_case_insensitive(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)