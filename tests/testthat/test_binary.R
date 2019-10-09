context("binary classification measures")

test_that("trigger all", {
  N = 20L
  truth = factor(sample(letters[1:2], N, replace = TRUE), levels = letters[1:2])
  response = factor(sample(letters[1:2], N, replace = TRUE), levels = letters[1:2])
  prob = runif(N)

  Filter(Negate(is.null), eapply(measures, function(m) {
    if (m$type == "binary") {
      f = match.fun(m$id)
      perf = f(truth, response = response, prob = prob, positive = "a")
      expect_number(perf, na.ok = FALSE, lower = m$min, upper = m$max, label = m$id)
    }
  }))
})


test_that("tests from Metrics", {
  as_fac = function(...) factor(ifelse(c(...) == 0, "b", "a"), levels = c("a", "b"))

  expect_equal(auc(as_fac(1,0,1,1), c(.32,.52,.26,.86), "a"), 1/3)
  expect_equal(auc(as_fac(1,0,1,0,1),c(.9,.1,.8,.1,.7), "a"), 1)
  expect_equal(auc(as_fac(0,1,1,0),c(.2,.1,.3,.4), "a"), 1/4)
  expect_equal(auc(as_fac(1,1,1,1,0,0,0,0,0,0),0*(1:10), "a"), 0.5)

  # expect_equal(ll(1,1), 0)
  # expect_equal(ll(1,0), Inf)
  # expect_equal(ll(0,1), Inf)
  # expect_equal(ll(1,0.5), -log(0.5))
  #
  # expect_equal(logLoss(c(1,1,0,0),c(1,1,0,0)), 0)
  # expect_equal(logLoss(c(1,1,0,0),c(1,1,1,0)), Inf)
  # expect_equal(logLoss(c(1,1,1,0,0,0),c(.5,.1,.01,.9,.75,.001)), 1.881797068998267)

  expect_equal(ppv(as_fac(1,1,0,0),as_fac(1,1,0,0), "a"), 1)
  expect_equal(ppv(as_fac(0,0,1,1),as_fac(1,1,0,0), "a"), 0)
  expect_equal(ppv(as_fac(1,1,0,0),as_fac(1,1,1,1), "a"), 1/2)

  expect_equal(tpr(as_fac(1,1,0,0),as_fac(1,1,0,0), "a"), 1)
  expect_equal(tpr(as_fac(0,0,1,1),as_fac(1,1,0,0), "a"), 0)
  expect_equal(tpr(as_fac(1,1,1,1),as_fac(1,0,0,1), "a"), 1/2)

  expect_equal(fbeta(as_fac(1,1,0,0), as_fac(1,1,0,0), "a"), 1)
  expect_equal(fbeta(as_fac(0,0,1,1), as_fac(1,1,1,0), "a"), 2/5)
  expect_equal(fbeta(as_fac(1,1,1,1), as_fac(1,0,0,1), "a"), 2/3)
  expect_equal(fbeta(as_fac(1,1,0,0), as_fac(1,1,1,1), "a", beta=0), 1/2)
})