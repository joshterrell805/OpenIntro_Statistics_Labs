# Lab 3: Distributions

## Goals
Study the normal distribution, as the normal distribution "opens the door to many powerful statistical methods."

## Exercise 1
> Make a histogram of men’s heights and a histogram of women’s heights. How would you compare the various aspects of the two distributions?

```R
load('bdims.RData')
males <- bdims[bdims$sex == 1,]
females <- bdims[bdims$sex == 0,]
hist(females$hgt)
dev.new()
hist(males$hgt)
summary(females$hgt)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#     147.2   160.0   164.5   164.9   169.5   182.9
sd(females$hgt)
# 6.544602
summary(males$hgt)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#     157.2   172.9   177.8   177.7   182.6   198.1
sd(males$hgt)
# 7.183629
```


The females' and males' heights are unimodal and approximately normally distributed. The females'heights are centered at around 165cm and have a standard deviation of about 6.5cm. The males' heights are centered at around 178cm and have a standard deviation of about 7.2cm.

![image](https://cloud.githubusercontent.com/assets/4649127/15982795/dde146c4-2f46-11e6-9063-838387f9714f.png)

## Exercise 2
> Based on the this plot [of the density hist and normal distribution], does it appear that the data follow a nearly normal distribution?

```R
hist(females$hgt, probability=T)
x <- seq(min(females$hgt), max(females$hgt), 1)
lines(x=x, y=dnorm(x=x, mean=mean(females$hgt), sd=sd(females$hgt)), col='blue')

dev.new()
hist(males$hgt, probability=T)
x <- seq(min(males$hgt), max(males$hgt), 1)
lines(x=x, y=dnorm(x=x, mean=mean(males$hgt), sd=sd(males$hgt)), col='blue')
```

Yes, it appears both the males' and females' heights are normally distributed.
![image](https://cloud.githubusercontent.com/assets/4649127/15982875/b3e0f376-2f49-11e6-8c0d-426556781d24.png)

## Exercise 3
> Make a normal probability plot of sim\_norm. Do all of the points fall on the line? How does this plot compare to the probability plot for the real data?

```R
qqnorm(females$hgt, main='QQ - Female heights')
qqline(females$hgt)
dev.new()
sim_data <- rnorm(n=nrow(females), mean=mean(females$hgt), sd=sd(females$hgt))
qqnorm(sim_data, main='QQ - Female simulated heights')
qqline(sim_data)

dev.new()
qqnorm(males$hgt, main='QQ - Male heights')
qqline(males$hgt)
dev.new()
sim_data <- rnorm(n=nrow(males), mean=mean(males$hgt), sd=sd(males$hgt))
qqnorm(sim_data, main='QQ - Male simulated heights')
qqline(sim_data)
```

![image](https://cloud.githubusercontent.com/assets/4649127/15982937/e0ba0296-2f4b-11e6-9f96-64562e88fc29.png)

Not all of the points fall exactly on the line; the `bdims` data appears to have (what I assume are) some rounding artifacts (sharp, small triangle-looking cutouts away from the line). The males' and females' height distributions look reasonably normal when compared to simulated normal data.

## Exercise 4
> Does the normal probability plot for fdims$hgt look similar to the plots created for the simulated data? That is, do plots provide evidence that the female heights are nearly normal?

```R
qqnormsim(females$hgt)
```

Yes.
![image](https://cloud.githubusercontent.com/assets/4649127/15985648/b6e7fae6-2fa9-11e6-9e84-19d2ecd1bc31.png)

## Exercise 5
> Using the same technique, determine whether or not female weights appear to come from a normal distribution.

```R
qqnormsim(females$wgt)
```

The top 2% of the data (at and above 2 theoretical sd (x-axis)) appear to have a strong deviation away from normality. The shape of the distribution appears also a little bit parabola shaped. The graph looks almost normal, but the deviation and shape are a little bit concerning.

![image](https://cloud.githubusercontent.com/assets/4649127/15985738/09e15fba-2fac-11e6-89a3-aa3ba565ffd6.png)

## Exercise 6
Write out two probability questions that you would like to answer; one regarding female heights and one regarding female weights. Calculate the those probabilities using both the theoretical normal distribution as well as the empirical distribution (four probabilities in all). Which variable, height or weight, had a closer agreement between the two methods?

1. What is the probability that a female is between 5ft and 6ft tall?
1. What is the probability that a female weighs less than 100lbs?

```R
# 1. What is the probability that a female is between 5ft and 6ft tall?
feet_to_meter <- function(feet) 0.3048 * feet
feet_to_cm <- function(feet) feet_to_meter(feet) * 100
low <- feet_to_cm(5)
high <- feet_to_cm(6)
empirical <- sum(females$hgt >= low & females$hgt <= high) / nrow(females)
# 0.9692308
theoretical <- pnorm(q=high, mean=mean(females$hgt), sd=sd(females$hgt)) -
    pnorm(q=low, mean=mean(females$hgt), sd=sd(females$hgt))
# 0.9686922
abs(empirical-theoretical)
# 0.0005386134

# 2. What is the probability that a female weighs less than 100lbs?
lbs_to_kg <- function(lbs) 0.453592 * lbs
low <- lbs_to_kg(100)
empirical <- sum(females$wgt < low) / nrow(females)
# 0.01538462
theoretical <- pnorm(q=low, mean=mean(females$wgt), sd=sd(females$wgt))
# 0.0564796
abs(empirical-theoretical)
# 0.04109498
```

The probabilities for the question about height had better agreement, but I don't think any normality conclusions should be based on the answers to these questions. The questions are taken on a completely different portion of their respective samples, and even if they were taken on the same portion of the samples, qqplots are much more effective as they analyze the entire sample rather than just one portion.

## On your own

### 1
Match the histograms to the normal probability plots.

![image](https://cloud.githubusercontent.com/assets/4649127/15986615/e625af12-2fc0-11e6-8e9d-377f9d16a8a3.png)

1. female bii.di = B. The data looks very close to normal except for a few outliers with very small values.
1. female elb.di = C. The hist looks fairly normal with 0.5 sd being a bit too frequent and 1 sd being a bit too infrequent. These observations are manifested in the C qqplot with small jumps up and down.
1. general age = D. The data is right skewed which means its got a long right tail, or too many big values, so it must be A or D. Based on the zscores at the bottom of the hist, the lowest datapoint is 1 sd below the mean, so the qqplot must be D.
1. female che.de = A. The data is right skewed, so A or D. The hist has data up to 5 sds above the mean and 2 sds below, so the A qqplot fits best.

### 2
Why do you think C and D have slight stepwise pattern?

The *slight* stepwise pattern is probably from rounding. Larger deviations are from the data not being perfectly normal.

### 3
Based on the qqplot of female knee diamater(kne.di), is the variable left skewed, symmetric, or right skewed? Verify with a hist.

```R
qqnorm(females$kne.di, main='QQ - Female Knee Diamater')
qqline(females$kne.di)
```

The qqplot looks decently right skewed because it's got several values on the high end that are very big. The qqplot also looks like the data has a slightly too large of left tail to be perfectly normal, but the deviation is not too much.
![image](https://cloud.githubusercontent.com/assets/4649127/15986708/b7ac50fc-2fc3-11e6-9a3e-1231ac388527.png)

```R
hist(females$kne.di)
```
![image](https://cloud.githubusercontent.com/assets/4649127/15986741/c57a20a0-2fc4-11e6-8377-cb0c6773d0c3.png)
