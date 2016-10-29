# Lab 2: Probability

My corresponding reading notes for this lab are at http://joshterrell.com/blog/posts/1472532759

## Goals
> (1) think about the effects of independent and dependent events, (2) learn how to simulate shooting
streaks in R, and (3) to compare a simulation to actual data in order to determine if the hot hand
phenomenon appears to be real.

## Exercise 1
> What does a streak length of 1 mean, i.e. how many hits and misses are in a streak of 1? What about
a streak length of 0?

Streak length = N means there are N consecutive hits (baskets).

## Excercise 2
> Describe the distribution of Kobe’s streak lengths from the 2009 NBA finals. What was his typical
streak length? How long was his longest streak of baskets?

```R
summary(calc_streak(kobe$basket))
```

Typical (median) is 0, with mean of 0.7. longest (max) is 4.

## Exercise 3
> In your simulation of flipping the unfair coin 100 times, how many flips came up heads?

```R
table(sample(c("H", "T"), size=100, replace=T, prob=c(0.2, 0.8)))
```

21 came up heads.

## Exercise 4
> What change needs to be made to the sample function so that it reflects a shooting percentage of
45%? Make this adjustment, then run a simulation to sample 133 shots. Assign the output of this
simulation to a new object called sim\_basket.

The probability of H needs to be 45%.

```R
sim_basket <- sample(c("H", "M"), size=133, replace=T, prob=c(0.45, 0.55))
```

## On your own
> Comparing Kobe Bryant to the Independent Shooter
> Using calc\_streak, compute the streak lengths of sim\_basket.

> 1\. Describe the distribution of streak lengths. What is the typical streak length for this simulated independent shooter with a 45% shooting percentage? How long is the player’s longest streak of baskets in 133 shots?

```R
summary(calc_streak(sim_basket))
```

median = 0, mean = 0.9, max = 7

> 2\. If you were to run the simulation of the independent shooter a second time, how would you expect its streak distribution to compare to the distribution from the question above? Exactly the same? Somewhat similar? Totally different? Explain your reasoning.

I would expect it to be somewhat similar. There are 133 observations, so due to the law of large numbers I'd expect the median and mean to be about the same, the max (outliers) would likely be different.

> 3\. How does Kobe Bryant’s distribution of streak lengths compare to the distribution of streak lengths for the simulated shooter? Using this comparison, do you have evidence that the hot hand model fits Kobe’s shooting patterns? Explain.

The simulated shots using the independence assumption have many higher streaks than Kobe's shots.  The distributions appear similar in shape except for the independent distribution having more right skew. If the hot hand model were correct for Kobe, we'd expect Kobe's distribution to be more right skewed than the random independent model. This does not appear to be the case. Both distributions appear to be a geometric distribution where a "miss" is a success.
