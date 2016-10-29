# Lab 6: Inference for Categorical Data

My corresponding reading notes for this chapter are at http://joshterrell.com/blog/posts/1476630555

Paper: [link][paper]

## Exercise 1
> In the first paragraph, several key findings are reported. Do these percentages appear to be sample statistics (derived from the data sample) or population parameters?

These are sample statistics, and the first paragraph depicts them as such.

## Exercise 2
> The title of the report is “Global Index of Religiosity and Atheism”. To generalize the report’s findings to the global human population, what must we assume about the sampling method? Does that seem like a reasonable assumption?

Must assume the sampling method is random and less than 10% of population. Sounds reasonable, though should be investigated.

## Exercise 3
> What does each row of Table 6 correspond to? What does each row of atheism correspond to?

Each row of Table 6 corresponds to all the responses for a country. Each row of `atheism` corresponds to a single response.

```R
download.file("http://www.openintro.org/stat/data/atheism.RData", destfile = "atheism.RData")
load("atheism.RData")
head(atheism)
```

## Exercise 4
> Using the command below, create a new dataframe called `us12` that contains only the rows in atheism associated with respondents to the 2012 survey from the United States. Next, calculate the proportion of atheist responses. Does it agree with the percentage in Table 6? If not, why?

Yes 0.0499002 ~= 0.5. They rounded a tad.

```R
us12 <- subset(atheism, nationality == "United States" & year == "2012")
sum(us12$response == "atheist") / nrow(us12) # 0.0499002
```

## Exercise 5
> Write out the conditions for inference to construct a 95% confidence interval for the proportion of atheists in the United States in 2012. Are you confident all conditions are met?

- observations in the sample are independent
- meets success-failure condition (&gt;=10 successes/fails)

The only condition I am not confident in is the independence condition. It's a survey, so I'll give the researchers the benefit of the doubt, but it'd be good to ask them their methods relating to independence.

```R
sum(us12$response == "atheist") # 50
sum(us12$response != "atheist") # 952
```

## Exercise 6
> Based on the R output, what is the margin of error for the estimate of the proportion of atheists in US in 2012?

ME = 0.0069 * 1.96 ~= 1.3%

```R
inference(us12$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist", conf = 0.95)
# Single proportion -- success: atheist
# Summary statistics: p_hat = 0.0499 ;  n = 1002
# Check conditions: number of successes = 50 ; number of failures = 952
# Standard error = 0.0069
# 95 % Confidence interval = ( 0.0364 , 0.0634 )
```

## Exercise 7
> Using the `inference` function, calculate confidence intervals for the proportion of atheists in 2012 in two other countries of your choice, and report the associated margins of error. Be sure to note whether the conditions for inference are met. It may be helpful to create new data sets for each of the two countries first, and then use these data sets in the `inference` function to construct the confidence intervals.

```R
turkey12 <- subset(atheism, nationality == "Turkey" & year == "2012")
canada12 <- subset(atheism, nationality == "Canada" & year == "2012")
inference(turkey12$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist", conf = 0.95)
# Single proportion -- success: atheist
# Summary statistics: p_hat = 0.0203 ;  n = 1032
# Check conditions: number of successes = 21 ; number of failures = 1011
# Standard error = 0.0044
# 95 % Confidence interval = ( 0.0117 , 0.029 )
inference(canada12$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist", conf = 0.95)
# Single proportion -- success: atheist
# Summary statistics: p_hat = 0.0898 ;  n = 1002
# Check conditions: number of successes = 90 ; number of failures = 912
# Standard error = 0.009
# 95 % Confidence interval = ( 0.0721 , 0.1075 )
```

ME for Turkey is 0.0044 * 1.96 ~= 1%

ME for Canada is 0.009 * 1.96 ~= 2%

## Exercise 8
> Describe the relationship between `p` and `me`.

There is a parabolic relationship between `p` and `me`. When `p` is at 0.5, `me` is largest.

```R
n <- 1000
p <- seq(0, 1, 0.01)
me <- 2 * sqrt(p * (1 - p)/n)
plot(me ~ p, ylab = "Margin of Error", xlab = "Population Proportion")
```

![image](https://cloud.githubusercontent.com/assets/4649127/19753014/7348dc28-9bb6-11e6-92cb-477b8a27a0bc.png)

## Exercise 9
> Describe the sampling distribution of sample proportions at `n=1040` and  `p=0.1`. Be sure to note the center, spread, and shape.
>
> Hint: Remember that R has functions such as `mean` to calculate summary statistics.

The distribution is centered around 0.1, has a standard deviation of about 0.01, and is approximately normal with no noticeable skew.

```R
p <- 0.1
n <- 1040
p_hats <- rep(0, 5000)

for(i in 1:5000){
  samp <- sample(c("atheist", "non_atheist"), n, replace = TRUE, prob = c(p, 1-p))
  p_hats[i] <- sum(samp == "atheist")/n
}

hist(p_hats, main = "p = 0.1, n = 1040", xlim = c(0, 0.18))
summary(p_hats)
#     Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#  0.07019 0.09327 0.09904 0.09969 0.10580 0.12980
sd(p_hats) # 0.009287382
```

![image](https://cloud.githubusercontent.com/assets/4649127/19753616/055b655a-9bbb-11e6-85b5-cff74829c4ec.png)

## Exercise 10
> Repeat the above simulation three more times but with modified sample sizes and proportions: for `n=400` and `p=0.1`, `n=1040` and `p=0.02`, and `n=400` and `p=0.02`. Plot all four histograms together by running the `par(mfrow = c(2, 2))` command before creating the histograms. You may need to expand the plot window to accommodate the larger two-by-two plot. Describe the three new sampling distributions. Based on these limited plots, how does `n` appear to affect the distribution of `p^`? How does `p` affect the sampling distribution?

- A larger `n` makes the sampling distribution smoother (more possible proportions with larger n).
- A larger `p` makes the sampling distributions center shift.
- when n and p were at their smallest, the (bottom right) graph appeared slightly right skewed

```R
plot <- function(p, n) {
  p_hats <- rep(0, 5000)

  for(i in 1:5000){
    samp <- sample(c("atheist", "non_atheist"), n, replace = TRUE, prob = c(p, 1-p))
    p_hats[i] <- sum(samp == "atheist")/n
  }

  hist(p_hats, main = paste("p = ", p, ", n = ", n, sep=""), xlim = c(0, 0.18))
}
par(mfrow = c(2, 2))
plot(p=0.1, n=1040)
plot(p=0.1, n=400)
plot(p=0.02, n=1040)
plot(p=0.02, n=400)

par(mfrow = c(1, 1))
```

![image](https://cloud.githubusercontent.com/assets/4649127/19753738/1d44c44e-9bbc-11e6-9fe7-3b0d42c125bf.png)

## Exercise 11
> If you refer to Table 6, you’ll find that Australia has a sample proportion of 0.1 on a sample size of 1040, and that Ecuador has a sample proportion of 0.02 on 400 subjects. Let’s suppose for this exercise that these point estimates are actually the truth. Then given the shape of their respective sampling distributions, do you think it is sensible to proceed with inference and report margin of errors, as the reports does?

We shouldn't report margin of errors for Ecuador because it doesn't meet the success-failure condition (thus the distribution is too far from normal to make inferences on using theoretical methods).

## Own your own
### 1. Answer the following two questions using the inference function. As always, write out the hypotheses for any tests you conduct and outline the status of the conditions for inference.
#### a. Is there convincing evidence that Spain has seen a change in its atheism index between 2005 and 2012?
*Hint: Create a new data set for respondents from Spain. Form confidence intervals for the true proportion of athiests in both years, and determine whether they overlap.*

- H<sub>0</sub>: In Spain, there is no difference between the proportion of atheists in 2005 and 2012.
- H<sub>A</sub>: In Spain, there is a difference between the proportion of atheists in 2005 and 2012.
- Conditions
  - Observations are independent (in each sample and across samples). Assumed yes.
  - success/failure condition met for both samples: at least 10 of each success and fail
    - the `inference` function checks this for us, its output is below, and yes, the conditions are met (all groups > 10 observations)

Since the confidence intervals overlap (see output below), there is not convincing evidence to reject the null hypothesis. Spain's proportion of atheists did not significantly change (at the 95% confidence level) between the years 2005 and 2012.

```R
spain05 <- subset(atheism, nationality == "Spain" & year == "2005")
spain12 <- subset(atheism, nationality == "Spain" & year == "2012")
inference(spain05$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist", conf = 0.95)
# Single proportion -- success: atheist
# Summary statistics: p_hat = 0.1003 ;  n = 1146
# Check conditions: number of successes = 115 ; number of failures = 1031
# Standard error = 0.0089
# 95 % Confidence interval = ( 0.083 , 0.1177 )
inference(spain12$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist", conf = 0.95)
# Single proportion -- success: atheist
# Summary statistics: p_hat = 0.09 ;  n = 1145
# Check conditions: number of successes = 103 ; number of failures = 1042
# Standard error = 0.0085
# 95 % Confidence interval = ( 0.0734 , 0.1065 )
```


#### b. Is there convincing evidence that the United States has seen a change in its atheism index between 2005 and 2012?

Same hypotheses and conditions as part (a) but substitute "Spain" for "United States".

Since the confidence intervals do not overlap (see output below), there is convincing evidence to reject the null hypothesis. The United State's proportion of atheists significantly changed (at the 95% confidence level) between the years 2005 and 2012.

```R
load("atheism.RData")
us05 <- subset(atheism, nationality == "United States" & year == "2005")
us12 <- subset(atheism, nationality == "United States" & year == "2012")
inference(us05$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist", conf = 0.95)
# Single proportion -- success: atheist
# Summary statistics: p_hat = 0.01 ;  n = 1002
# Check conditions: number of successes = 10 ; number of failures = 992
# Standard error = 0.0031
# 95 % Confidence interval = ( 0.0038 , 0.0161 )
inference(us12$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist", conf = 0.95)
# Single proportion -- success: atheist
# Summary statistics: p_hat = 0.0499 ;  n = 1002
# Check conditions: number of successes = 50 ; number of failures = 952
# Standard error = 0.0069
# 95 % Confidence interval = ( 0.0364 , 0.0634 )
```

### 2. If in fact there has been no change in the atheism index in the countries listed in Table 4, in how many of those countries would you expect to detect a change (at a significance level of 0.05) simply by chance?
*Hint: Look in the textbook index under Type 1 error.*

A Type 1 Error happens when we incorrectly reject the null hypothesis in favor of the alternative.

Using a significance level of 5% (confidence level of 95%), we make type 1 errors 5% of the time, on average. If all countries listed in table 4 have no actual change, then, using our sample data, we'd likely find around 5% of them that indicate a difference at the 5% significance level. Since this question supposes that all countries have no actual difference, and our data indicated that 5% have a difference, these 5% would constitute a type 1 error (the data lead us to believe there was a difference when there was no actual difference).

### 3. Suppose you’re hired by the local government to estimate the proportion of residents that attend a religious service on a weekly basis. According to the guidelines, the estimate must have a margin of error no greater than 1% with 95% confidence. You have no idea what to expect for `p`. How many people would you have to sample to ensure that you are within the guidelines?
*Hint: Refer to your plot of the relationship between `p` and margin of error. Do not use the data set to answer this question.*

Our goal is to calculate `n`, the number of observations required to ensure the `ME` (margin of error) is &le; 0.01. The margin of error is equal to:

```
ME = z* SE
```

`SE` is the standard error of the sampling mean proportion, and is given by:

```
SE = sqrt( p(p-1)/n )
```

So the formula for ME can be written as:

```
ME = z* sqrt( p(p-1)/n )
```

We can rearrange it to solve for n:

```
ME / z* = sqrt( p(p-1)/n )

(ME / z*)^2 = p(p-1)/n

(ME / z*)^2 / (p(p-1)) = 1/n

      p(p-1)
n = -----------
    (ME / z*)^2
```

This equation for `n` says that `n` is determined by `p`, `ME`, and `z*`. We know `z*` is 1.96 given the 95% confidence level, and `ME` is 1% or 0.01, but we don't know `p`, the population proportion.

If we have a reasonably confident estimate for `p`, we'd typically use that estimate. We were given instruction to make sure the margin of error does not exceed 1%. Since we have no estimate, we want to assume a value for `p` that leads to the greatest margin of error (worst case) so we could never possibly exceed 1%, no matter what the actual `p` turns out to be.

From the statistics book and from exercise 8 above, we know that when `p` is 0.5, the margin of error is the greatest, so we use this `p` to calculate `n`.

Substituting our constants, we get:

```
      p(p-1)
n = -----------
    (ME / z*)^2

      0.5(0.5-1)
n = -----------
    (0.01 / 1.96)^2

n = 9603.99
```

Thus we'd need 9604 observations to guarantee our margin of error is less than or equal to 1% at the 95% confidence level.


[paper]: http://www.wingia.com/web/files/richeditor/filemanager/Global_INDEX_of_Religiosity_and_Atheism_PR__6.pdf
