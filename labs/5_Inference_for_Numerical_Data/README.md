# Lab 5: Inference for Numerical Data

## Exercise 1
> What are the cases in this data set? How many cases are there in our sample?

```R
load("nc.RData")
summary(nc)
nrow(nc) # 1000
```

Each case contains information about a birth in North Carolina. For each birth, we know the age of the father (`fage`), the age of the mother (`mage`), whether the baby was prematurely delivered (`premie`), etc. There are 1000 cases in the data set.

## Exercise 2
> Make a side-by-side boxplot of `habit` and `weight`. What does the plot highlight about the relationship between these two variables?

People who smoke appear to have lighter babies.

```R
library(ggplot2)
ggplot(aes(y = weight, x = habit, fill = habit), data = nc) + geom_boxplot()
by(nc$weight, nc$habit, mean)
```

![image](https://cloud.githubusercontent.com/assets/4649127/18573717/fe3c6752-7b7a-11e6-849a-af595406a812.png)

## Exercise 3
> Check if the conditions necessary for inference are satisfied. Note that you will need to obtain sample sizes to check the conditions. You can compute the group size using the same `by` command above but replacing `mean` with `length`.

1. Samples must be drawn independently from one another (the description doesn't say exactly, but we'll assume so).
2. Samples must be nearly normal. See image below. The data are a bit skewed to the left but otherwise the qq-plots are pretty linear.
3. There must be at least 30 observations. `nonsmoker=873`, `smoker=126`

```R
qplot(sample=weight, data=nc[nc$habit %in% c('smoker', 'nonsmoker'),], color=habit)
by(nc$weight, nc$habit, length) # nonsmoker=873, smoker=126
```

![image](https://cloud.githubusercontent.com/assets/4649127/18573963/3ed8fecc-7b7d-11e6-8b4a-450270402c3a.png)

## Exercise 4
> Write the hypotheses for testing if the average weights of babies born to smoking and non-smoking mothers are different.

H<sub>0</sub>: babies born to smoking and non-smoking mothers have the same weights, on average.
H<sub>A</sub>: babies born to smoking mothers have different weights than babies born to non-smoking mothers.

## Exercise 5
> Change the type argument to "ci" to construct and record a confidence interval for the difference between the weights of babies born to smoking and non-smoking mothers.

```R
inference(y = nc$weight, x = nc$habit, est = "mean", type = "ci", null = 0, 
          alternative = "twosided", method = "theoretical", order=c("smoker", "nonsmoker"))

# n_smoker = 126, mean_smoker = 6.8287, sd_smoker = 1.3862
# n_nonsmoker = 873, mean_nonsmoker = 7.1443, sd_nonsmoker = 1.5187
# Observed difference between means (smoker-nonsmoker) = -0.3155
#
# Standard error = 0.1338
# 95 % Confidence interval = ( -0.5777 , -0.0534 )
```

The results of the inference function show that the observed difference in means (smoker-nonsmoker) is -0.3155, meaning on average, smokers tend to have babies that are 0.3155 lbs(?) lighter than nonsmokers. We are 95% confident that the true difference in means lies between -0.5777 and 0.0534 lbs.


## On Your Own

### 1. Calculate a 95% confidence interval for the average length of pregnancies (`weeks`) and interpret it in context. Note that since you’re doing inference on a single population parameter, there is no explanatory variable, so you can omit the `x` variable from the function.

```R
inference(y = nc$weeks, est = "mean", type = "ci", alternative = "twosided", method = "theoretical")
```

We are 95% confident that the mean number of weeks is between 38.15 and 38.52.

### 2. Calculate a new confidence interval for the same parameter at the 90% confidence level. You can change the confidence level by adding a new argument to the function: `conflevel = 0.90`.

```R
inference(y = nc$weeks, est = "mean", type = "ci", alternative = "twosided", method = "theoretical", conflevel=0.90)
```

We are 90% confident that the true mean number of weeks for a pregnancy is between 38.18 and 38.49.

### 3. Conduct a hypothesis test evaluating whether the average weight gained by younger mothers is different than the average weight gained by mature mothers.
```R
levels(nc$mature) # "mature mom" "younger mom"
qplot(data=nc, sample=gained, color=mature)
by(nc$gained, nc$mature, length) # 133 mature, 867 younger
inference(y=nc$gained, x=nc$mature, est="mean", type="ht", null=0, alternative="twosided",
          method="theoretical", conflevel=0.95, order=c("younger mom", "mature mom"))
```
First, are conditions met?

1. Independence? Yes (assumed).
2. Nearly normal? Just about (see image below).
3. More than 30 samples? 133 mature and 867 younger.

H<sub>0</sub>: difference in mean gained weight between the younger mother group and mature mother group is 0.
H<sub>A</sub>: difference in mean gained weight between the younger mother group and mature mother group is not 0.

For our two sided test we get a p-value of 0.1686, which is not less than 0.05, so we conclude that we do not have sufficient evidence to reject the null hypothesis. There is insufficient evidence to support the hypothesis that mature mothers and younger mothers gain different amounts of weight during their pregnancies.

![image](https://cloud.githubusercontent.com/assets/4649127/18574233/f8c8353a-7b7f-11e6-98d7-e7128d621a14.png)

### 4. Now, a non-inference task: Determine the age cutoff for younger and mature mothers. Use a method of your choice, and explain how your method works.

```R
by(nc$mage, nc$mature, summary)
# nc$mature: mature mom
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#   35.00   35.00   37.00   37.18   38.00   50.00
# ------------------------------------------------------------
# nc$mature: younger mom
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#   13.00   21.00   25.00   25.44   30.00   34.00
```

It appears that 35 is the age cutoff for younger and mature mothers since the oldest younger mother is 34 and the youngest mature mother is 35.

### 5. Pick a pair of numerical and categorical variables and come up with a research question evaluating the relationship between these variables. Formulate the question in a way that it can be answered using a hypothesis test and/or a confidence interval. Answer your question using the `inference` function, report the statistical results, and also provide an explanation in plain language.

Is the mother-father age difference different for white moms vs not white moms? What about for mature moms vs younger moms?
```R
d <- na.omit(data.frame(mofa_diff=nc$mage - nc$fage, whitemom=nc$whitemom, mature=nc$mature))
qplot(data=d, sample=mofa_diff, color=whitemom)
qplot(data=d, sample=mofa_diff, color=mature)
```

Conditions:
1. random
2. normal enough (see below)
3. at least 30 per sample (190 not white, 637 white), (121 mature, 706 not mature)

H<sub>0</sub>: difference in mean mother-father age diff between white/young moms and non-white/mature moms is 0.
H<sub>A</sub>: difference in mean mother-father age diff between white/young moms and non-white/mature moms is not 0.

```R
inference(y=d$mofa_diff, x=d$whitemom, est="mean", type="ht", null=0, alternative="twosided",
          method="theoretical", conflevel=0.95, order=c("white", "not white")) # diff = -0.0618, p = 0.869
inference(y=d$mofa_diff, x=d$mature, est="mean", type="ht", null=0, alternative="twosided",
          method="theoretical", conflevel=0.95, order=c("younger mom", "mature mom")) # diff = -1.6352,  p = 0.0002
```
There is not sufficient evidence to reject the null hypothesis: that the difference in age between mothers and fathers is different among white moms than non-white moms.

There is sufficient evidence to reject the null hypothesis: that the difference in age between mothers and fathers is different among young moms than mature moms. Given the sample, it is 0.02% likely that this sample of birth records was drawn from a population where the mean difference between the age of mothers and fathers is different between young and mature moms.

Note: we had to omit a lot of NAs to perform this analysis (lots of fathers ages, `fage`, were missing). The NAs may be non-random, so our analysis does not hold (maybe proportionally more young moms decided not to tell about the child's father's age, for example).

![image](https://cloud.githubusercontent.com/assets/4649127/18574522/b87f0258-7b82-11e6-9189-c8be086b5dba.png)

![image](https://cloud.githubusercontent.com/assets/4649127/18574579/3cf58e12-7b83-11e6-8bf6-fadf77bc7485.png)
