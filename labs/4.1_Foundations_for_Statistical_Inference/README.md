# Lab 4.1: Foundations for Inference (Sampling Distributions)

My corresponding reading notes for this lab are at http://joshterrell.com/blog/posts/1476570675

## Exercise 1
> Describe this population distribution.

```R
load("ames.RData")
area <- ames$Gr.Liv.Area
price <- ames$SalePrice
summary(area)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#    334    1126    1442    1500    1743    5642
sd(area) # 505.5089
hist(area)
```

The distribution is unimodal with a peak (median) at 1442 ft<sup>2</sup> and a standard deviation of 506 ft<sup>2</sup>. It is decently close to a normal distribution, but it has a very long (but narrow) right tail and a truncated left tail.

![image](https://cloud.githubusercontent.com/assets/4649127/16546648/3ef597aa-4106-11e6-9f96-001d3acfd215.png)

## Exercise 2
> Describe the distribution of this sample. How does it compare to the distribution of the population?

```R
samp1 <- sample(area, 50)
summary(samp1)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#    788    1104    1456    1492    1704    3112
sd(samp1) # 507.493
hist(samp1)
```

The sample distribution looks like it is a decent approximation of the population distribution. Although the sample is missing much of the outlier information, the information in the IQR seems to be preserved fairly well. The standard deviation is similar.

![image](https://cloud.githubusercontent.com/assets/4649127/16546671/d61a0bac-4106-11e6-8a65-fb9fd2c7c58e.png)

## Exercise 3
> Take a second sample, also of size 50, and call it samp2. How does the mean of samp2 compare with the mean of samp1? Suppose we took two more samples, one of size 100 and one of size 1000. Which would you think would provide a more accurate estimate of the population mean?

```R
mean(area) # 1499.69
samp2 <- sample(area, 50)
mean(samp1) # 1492.4
mean(samp2) # 1530.28
```

Both sample means are reasonably close to the population mean, though the differences are noticable. I'd expect the mean of a sample of 100 to more closely approximate the population mean, and the mean of a sample of 1000 to be extremely close to the population mean.

## Exercise 4
> How many elements are there in `sample_means50`? Describe the sampling distribution, and be sure to specifically note its center. Would you expect the distribution to change if we instead collected 50,000 sample means?

```R
sample_means50 <- rep(NA, 5000)

for(i in 1:5000){
  samp <- sample(area, 50)
  sample_means50[i] <- mean(samp)
}

hist(sample_means50)

length(sample_means50) # 5000
sd(sample_means50) # 72.74714
```

There are 5000 elements in `sample_means50`. The sample distribution is very close to normal with a mean of 1500 ft<sup>2</sup> and a standard deviation of 72.7 ft<sup>2</sup>. I would not expect the distribution to change substantially if we sampled 50,000 sample means, however the shape would almost certainly change slightly.

![image](https://cloud.githubusercontent.com/assets/4649127/16546800/40bd4786-410b-11e6-9f89-3578afeb0378.png)

## Exercise 5
> To make sure you understand what you’ve done in this loop, try running a smaller version. Initialize a vector of 100 zeros called `sample_means_small`. Run a loop that takes a sample of size 50 from area and stores the sample mean in `sample_means_small`, but only iterate from 1 to 100. Print the output to your screen (type `sample_means_small` into the console and press enter). How many elements are there in this object called `sample_means_small`? What does each element represent?

```R
sample_means_small <- rep(NA, 100)

for(i in 1:100){
  samp <- sample(area, 50)
  sample_means_small[i] <- mean(samp)
}
```

Each element in `sample_means_small` represents the mean area of a sample of 50 random areas from the population.

## Exercise 6
> When the sample size is larger, what happens to the center? What about the spread?

```R
sample_means10 <- rep(NA, 5000)
sample_means100 <- rep(NA, 5000)

for(i in 1:5000){
  samp <- sample(area, 10)
  sample_means10[i] <- mean(samp)
  samp <- sample(area, 100)
  sample_means100[i] <- mean(samp)
}

par(mfrow = c(3, 1))

xlimits <- range(sample_means10)

hist(sample_means10, breaks = 20, xlim = xlimits)
hist(sample_means50, breaks = 20, xlim = xlimits)
hist(sample_means100, breaks = 20, xlim = xlimits)
par(mfrow = c(1, 1)) # reset the parameters so the next plot gets plotted on its own.
```

As the sample size increases, the sampling distribution changes. The mean shifts right from 1400ish to 1500ish and the standard deviation decreases.

![image](https://cloud.githubusercontent.com/assets/4649127/16546849/e724bd24-410c-11e6-8259-4cdb34afb85d.png)

## Own Your Own
### 1. Take a random sample of size 50 from price. Using this sample, what is your best point estimate of the population mean?
```R
samp <- sample(price, 50)
mean(samp) # 190760.8
```
### 2. Since you have access to the population, simulate the sampling distribution for mean(x<sub>price</sub>) by taking 5000 samples from the population of size 50 and computing 5000 sample means. Store these means in a vector called `sample_means50`. Plot the data, then describe the shape of this sampling distribution. Based on this sampling distribution, what would you guess the mean home price of the population to be? Finally, calculate and report the population mean.

```R
sample_means_50 <- rep(NA, 5000)
for (i in 1:5000) {
  sample_means_50[i] <- mean(sample(price, 50))
}
hist(sample_means_50)
mean(sample_means_50) # 180977.5
sd(sample_means_50) # 11147.26
mean(price) # 180796.1
```

The distribution is approximately normal with a mean of about $180,000 and a standard deviation of about $11,100. The population mean is $180,796.

![image](https://cloud.githubusercontent.com/assets/4649127/16546899/5ed31130-410e-11e6-811b-1d9a380cb29b.png)

### 3. Change your sample size from 50 to 150, then compute the sampling distribution using the same method as above, and store these means in a new vector called `sample_means150`. Describe the shape of this sampling distribution, and compare it to the sampling distribution for a sample size of 50. Based on this sampling distribution, what would you guess to be the mean sale price of homes in Ames?
```R
sample_means_150 <- rep(NA, 5000)
for (i in 1:5000) {
  sample_means_150[i] <- mean(sample(price, 150))
}
hist(sample_means_150, breaks=25)
mean(sample_means_150) # 180701.7
sd(sample_means_150) # 6279.891
```

The sampling distribution of the mean of 150 samples from the population of prices is approximately normal with a mean of about $180,000 and a standard deviation of about $6,300.

![image](https://cloud.githubusercontent.com/assets/4649127/16546938/c3d11784-410f-11e6-97da-b22d8dd160d0.png)

### 4. Of the sampling distributions from 2 and 3, which has a smaller spread? If we’re concerned with making estimates that are more often close to the true value, would we prefer a distribution with a large or small spread?

The sampling distribution of means of 150 samples has a smaller spread. If we wanted to approximate the population parameter as accurately as possible, we'd want a smaller spread and thus larger sample size.
