# Lab 4.2: Foundations for Inference (Confidence Intervals)

My corresponding reading notes for this lab are at http://joshterrell.com/blog/posts/1476570675

## Exercise 1
> Describe the distribution of your sample. What would you say is the “typical” size within your sample? Also state precisely what you interpreted “typical” to mean.

```R
load("ames.RData")
area <- ames$Gr.Liv.Area
samp <- sample(area, 60)
summary(samp)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#    572    1221    1576    1565    1814    2872
sd(samp) # 512.4915
hist(samp)
```

The sample is unimodal with its mode around 1750 ft<sup>2</sup>. It has a standard deviation of 512.4915 ft<sup>2</sup> and looks approximately bell shaped. Outliers are few if at all in this sample.

![image](https://cloud.githubusercontent.com/assets/4649127/18516123/a4383526-7a4c-11e6-9d63-015cbecaf3d9.png)

## Exercise 2
> Would you expect another student’s distribution to be identical to yours? Would you expect it to be similar? Why or why not?

No. I drew a random sample of 60. If another reader drew a random sample of 60, their sample would almost certainly have different data points, which means our distributions would be different. I would expect our distributions to be similar since the distribution appears bell shaped, so there's a higher probability that the other reader's sample will be mostly drawn from near the top of the bell (as was mine) than the tails.

## Exercise 3
> For the confidence interval to be valid, the sample mean must be normally distributed and have standard error `s/sqrt(n)`. What conditions must be met for this to be true?

```R
se <- sd(samp) / sqrt(length(samp))
lower <- mean(samp) - 1.96 * se
upper <- mean(samp) + 1.96 * se
c(lower, upper) # (1435.088, 1694.445)
```

1. each point in the sample must be taken independently
2. the shape of the population should be approximately normal and not be skewed too much in either direction (estimated by sample)
3. the sample should have at least 30 data points

## Exercise 4
> What does “95% confidence” mean? If you’re not sure, see Section 4.2.2.

First, we must assume the assumptions above are true. If so, "95% confidence" means that if we were to draw billions of random samples, 95% of them would contain the population mean within their lower and upper bounds. Therefore we are 95% confident that this one sample contains the population mean within its lower and upper bounds.

## Exercise 5
> Does your confidence interval capture the true average size of houses in Ames? If you are working on this lab in a classroom, does your neighbor’s interval capture this value?

```R
mean(area)      # 1499.69
c(lower, upper) # (1435.088, 1694.445)
lower <=  mean(area) && mean(area) <= upper # TRUE
```

Yes, the confidence interval captures the true average. Most likely my neighbor's interval captures the true average too. We'd expect 19/20 people's confidence interval to capture the true average.

## Exercise 6
> Each student in your class should have gotten a slightly different confidence interval. What proportion of those intervals would you expect to capture the true population mean? Why? If you are working in this lab in a classroom, collect data on the intervals created by other students in the class and calculate the proportion of intervals that capture the true population mean.

I'd expect 19/20 students' confidence intervals to capture the true average since we used a 95% confidence interval.

## On your own
```R
n_samps = 50
samp_size = 60
samp_mean <- rep(NA, n_samps)
samp_sd <- rep(NA, n_samps)

for (i in 1:n_samps) {
  samp <- sample(area, samp_size)
  samp_mean[i] <- mean(samp)
  samp_sd[i] <- sd(samp)
}

samp_lower <- samp_mean - 1.96 * samp_sd / sqrt(samp_size)
samp_upper <- samp_mean + 1.96 * samp_sd / sqrt(samp_size)

plot_ci(samp_lower, samp_upper, mean(area))
```

![image](https://cloud.githubusercontent.com/assets/4649127/18518173/c6c0f356-7a53-11e6-859f-923b6b82c3b7.png)

### 1. Using the following function (which was downloaded with the data set), plot all intervals. What proportion of your confidence intervals include the true population mean? Is this proportion exactly equal to the confidence level? If not, explain why.
48/50 (96%) include the true population mean. The proportion is not exactly equal to 95% due to variation due to randomness in the samples.

### 2. Pick a confidence level of your choosing, provided it is not 95%. What is the appropriate critical value?
90% = 1.645

### 3. Calculate 50 confidence intervals at the confidence level you chose in the previous question. You do not need to obtain new samples, simply calculate new intervals based on the sample means and standard deviations you have already collected. Using the plot_ci function, plot all intervals and calculate the proportion of intervals that include the true population mean. How does this percentage compare to the confidence level selected for the intervals?


```R
samp_lower <- samp_mean - 1.645 * samp_sd / sqrt(samp_size)
samp_upper <- samp_mean + 1.645 * samp_sd / sqrt(samp_size)

plot_ci(samp_lower, samp_upper, mean(area))
```

![image](https://cloud.githubusercontent.com/assets/4649127/18518332/69044f5a-7a54-11e6-93ca-8b3ba69a45ca.png)

46/50 (92%) confidence intervals contain the population mean. 46/50 is pretty similar to the expected 45/50.
