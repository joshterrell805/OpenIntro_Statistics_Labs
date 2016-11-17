# Lab 8: Multiple Regression

My corresponding reading notes for this chapter are at http://joshterrell.com/blog/posts/1478990607

```R
download.file("http://www.openintro.org/stat/data/evals.RData", destfile = "evals.RData")
load("evals.RData")
```

## Exercise 1
> Is this an observational study or an experiment? The original research question posed in the paper is whether beauty leads directly to the differences in course evaluations. Given the study design, is it possible to answer this question as it is phrased? If not, rephrase the question.

The study is an observational study since there is no randomization, controlled variables, etc. It is not possible to answer this question. Rephrased: Is there a correlation between professors' appearances and students' ratings?

## Exercise 2
> Describe the distribution of `score`. Is the distribution skewed? What does that tell you about how students rate courses? Is this what you expected to see? Why, or why not?

The [distribution](https://cloud.githubusercontent.com/assets/4649127/20247625/83471df6-a985-11e6-9792-ad02bc242527.png) is left-skewed, most people voted around 4.5/5.

```R
hist(evals$score)
```

## Exercise 3
> Excluding `score`, select two other variables and describe their relationship using an appropriate visualization (scatterplot, side-by-side boxplots, or mosaic plot).

- female professors' classes are rated by more students. [plot](https://cloud.githubusercontent.com/assets/4649127/20247652/3b003ef0-a986-11e6-821d-4935c1ff2d5b.png)
- male professors' classes are rated higher by students. [plot](https://cloud.githubusercontent.com/assets/4649127/20247653/48328eac-a986-11e6-9abf-d77baaf186f5.png)

## Exercise 3.5
> The fundamental phenomenon suggested by the study is that better looking teachers are evaluated more favorably. Let’s create a scatterplot to see if this appears to be the case:

```R
plot(evals$score ~ evals$bty_avg)
nrow(evals) #463
```
> Before we draw conclusions about the trend, compare the number of observations in the data frame with the approximate number of points on the scatterplot. Is anything awry?

The [plot](https://cloud.githubusercontent.com/assets/4649127/20247666/bcd0fb72-a986-11e6-8897-eef67005e1ca.png) shows approximatley one to two hundred distinct points. There are 463 evals. It looks like many observations overlap (darker circles).

## Exercise 4
> Replot the scatterplot, but this time use the function jitter() on the y- or the x-coordinate. (Use ?jitter to learn more.) What was misleading about the initial scatterplot?

```R
plot(jitter(evals$score) ~ jitter(evals$bty_avg))
```

The [plot](https://cloud.githubusercontent.com/assets/4649127/20247695/d863dda4-a987-11e6-9e15-ca2f275ad5dc.png) shows that many points overlapped.

## Exercise 5
> Let’s see if the apparent trend in the plot is something more than natural variation. Fit a linear model called `m_bty` to predict average professor score by average beauty rating and add the line to your plot using `abline(m_bty)`. Write out the equation for the linear model and interpret the slope. Is average beauty score a statistically significant predictor? Does it appear to be a practically significant predictor?

```R
m_bty <- lm(evals$score ~ evals$bty_avg)
summary(m_bty)
# Call:
# lm(formula = evals$score ~ evals$bty_avg)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max
# -1.9246 -0.3690  0.1420  0.3977  0.9309
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)
# (Intercept)    3.88034    0.07614   50.96  < 2e-16 ***
# evals$bty_avg  0.06664    0.01629    4.09 5.08e-05 ***

plot(jitter(evals$score) ~ jitter(evals$bty_avg))
abline(m_bty)
```

The [plot](https://cloud.githubusercontent.com/assets/4649127/20247718/87af7642-a988-11e6-96bd-48492bf29325.png).

```
score = 3.88044 + 0.06664 * bty_avg
```

Beauty is a statistically significant predictor, however it hardly looks practically significant. There is a lot of variance around the line and the slope is very small.

Just curious: R<sup>2</sup> is 0.035%&mdash;beauty explains 3.5% of the variance.

```R
cor(evals$score, evals$bty_avg) ** 2
```

## Exercise 6
> Use residual plots to evaluate whether the conditions of least squares regression are reasonable. Provide plots and comments for each one (see the Simple Regression Lab for a reminder of how to make these).

```R
bty_res = residuals(m_bty)

qqnorm(bty_res)
qqline(bty_res)

plot(jitter(bty_res) ~ jitter(evals$bty_avg))
```

Conditions for linear regression:

1. Linearity
  - the [regression plot](https://cloud.githubusercontent.com/assets/4649127/20247718/87af7642-a988-11e6-96bd-48492bf29325.png) looks more like a blob than a line, but it has no obvious non-linear trends (se
2. Normal residuals
  - The [qq plot](https://cloud.githubusercontent.com/assets/4649127/20247770/32d691b2-a98a-11e6-87ab-0c83559c28ca.png) shows that there's some evident non-normality.
3. Constant variability
  - just by looking at the [regression plot](https://cloud.githubusercontent.com/assets/4649127/20247718/87af7642-a988-11e6-96bd-48492bf29325.png), the variance appears to decrease as beauty reaches about 7.
  - [residuals by beauty](https://cloud.githubusercontent.com/assets/4649127/20247834/dcc86104-a98b-11e6-8b8a-aa47df02d3a1.png) confirms this observation, but the deviation looks too minor to invalidate this condition.
4. Independence of Observations

## Exercise 7
> P-values and parameter estimates should only be trusted if the conditions for the regression are reasonable. Verify that the conditions for this model are reasonable using diagnostic plots.

Conditions for multiple regression:

1. Normal residuals
  - [residual histogram](https://cloud.githubusercontent.com/assets/4649127/20248017/41e04332-a990-11e6-89b7-d30d1d2f80de.png)
    - `hist(residuals(m_bty_gen))`
  - [qq plot](https://cloud.githubusercontent.com/assets/4649127/20248024/7a77ffd2-a990-11e6-8c65-e2086c8a159f.png)
    - `qqnorm(residuals(m_bty_gen)); qqline(residuals(m_bty_gen))`
  - this condition appears to be violated
2. Constant variability of residuals
  - [residuals by m\_bty](https://cloud.githubusercontent.com/assets/4649127/20248229/1dc148ee-a994-11e6-9740-6270497f6a29.png)
    - `plot(residuals(m_bty_gen)  ~ jitter(bty_avg), data = evals)`
  - [residuals by gender](https://cloud.githubusercontent.com/assets/4649127/20248248/c67e77c2-a994-11e6-8e38-b149a4a8e37a.png)
    - `plot(residuals(m_bty_gen)  ~ jitter(as.numeric(gender)), data = evals)`
  - the residuals have an approximately constant variablity across the variables
3. Residuals are independent
  - [residuals by observation#](https://cloud.githubusercontent.com/assets/4649127/20248256/f724d70e-a994-11e6-9869-ce08fbb86b9d.png)
    - `plot(residuals(m_bty_gen))`
  - there appears to be no relationship between observation time and residual
4. each variable is linearly related to outcome
  - see plots from "(2) constant variability of residuals"
  - they appear at least to not show any highly non-linear trends

## Exercise 8
> Is `bty_avg` still a significant predictor of score? Has the addition of `gender` to the model changed the parameter estimate for `bty_avg`?

Yes, `bty_avg` is still a significant predictor for score (p<0.05). Adding `gender` only barely changed the parameter estimate for `bty_avg`. This means that `bty_avg` and `gender` probably have a near 0 correlation.

```R
summary(m_bty_gen)
# Residuals:
#     Min      1Q  Median      3Q     Max
# -1.8305 -0.3625  0.1055  0.4213  0.9314
# 
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept)  3.74734    0.08466  44.266  < 2e-16 ***
# bty_avg      0.07416    0.01625   4.563 6.48e-06 ***
# gendermale   0.17239    0.05022   3.433 0.000652 ***

cor(as.numeric(evals$gender), evals$bty_avg) # -0.135
```

## Exercise 9
> We can plot this line and the line corresponding to males with the following custom function.

[image](https://cloud.githubusercontent.com/assets/4649127/20392140/5d7c7888-ac8b-11e6-8ca0-4050316456e6.png)

```R
multiLines(m_bty_gen)
```

> What is the equation of the line corresponding to males? (Hint: For males, the parameter estimate is multiplied by 1.) For two professors who received the same beauty rating, which gender tends to have the higher course evaluation score?

The equation for males is `score = 3.75 + 0.074*bty_avg + 0.17`. the equation for females is `score = 3.75 + 0.074*bty_avg`.

If a male and female professor have the same beauty score, the male is expected to have a 0.17 higher corse evaluation score.

## Exercise 10
> Create a new model called `m_bty_rank` with `gender` removed and `rank` added in. How does R appear to handle categorical variables that have more than two levels? Note that the `rank` variable has three levels: `teaching`, `tenure track`, `tenured`.

R appears to handle categorical variables with k levels by creating k-1 indicator (or "dummy") variables. For ordinal variables, it may be better to convert the variable and each of its levels into real values then trying different transformations (such as squaring the values) to see what offeres the best R<sup>2</sup> score.

```R
m_bty_rank <- lm(score ~ bty_avg + rank, data=evals)

summary(m_bty_rank)
# Coefficients:
#                  Estimate Std. Error t value Pr(>|t|)
# (Intercept)       3.98155    0.09078  43.860  < 2e-16 ***
# bty_avg           0.06783    0.01655   4.098 4.92e-05 ***
# ranktenure track -0.16070    0.07395  -2.173   0.0303 *
# ranktenured      -0.12623    0.06266  -2.014   0.0445 *
```

## Exercise 11
> We will start with a full model...Which variable would you expect to have the highest p-value in this model? Why? Hint: Think about which variable would you expect to not have any association with the professor score.

I'd actually expect rank to have the *lowest* p-value, but from the last example that seems to be false. As for highest p-value, I think `cls_students` and `cls_profs` should be pretty unrelated.

```R
m_full <- lm(score ~ rank + ethnicity + gender + language + age + cls_perc_eval 
             + cls_students + cls_level + cls_profs + cls_credits + bty_avg 
             + pic_outfit + pic_color, data = evals)
summary(m_full)
# Coefficients:
#                         Estimate Std. Error t value Pr(>|t|)
# (Intercept)            4.0952141  0.2905277  14.096  < 2e-16 ***
# ranktenure track      -0.1475932  0.0820671  -1.798  0.07278 .
# ranktenured           -0.0973378  0.0663296  -1.467  0.14295
# ethnicitynot minority  0.1234929  0.0786273   1.571  0.11698
# gendermale             0.2109481  0.0518230   4.071 5.54e-05 ***
# languagenon-english   -0.2298112  0.1113754  -2.063  0.03965 *
# age                   -0.0090072  0.0031359  -2.872  0.00427 **
# cls_perc_eval          0.0053272  0.0015393   3.461  0.00059 ***
# cls_students           0.0004546  0.0003774   1.205  0.22896
# cls_levelupper         0.0605140  0.0575617   1.051  0.29369
# cls_profssingle       -0.0146619  0.0519885  -0.282  0.77806
# cls_creditsone credit  0.5020432  0.1159388   4.330 1.84e-05 ***
# bty_avg                0.0400333  0.0175064   2.287  0.02267 *
# pic_outfitnot formal  -0.1126817  0.0738800  -1.525  0.12792
# pic_colorcolor        -0.2172630  0.0715021  -3.039  0.00252 **
#
# R_2_adj = 0.1617
```

## Exercise 12
> Check your suspicions from the previous exercise. Include the model output in your response.

In addition to `cls_students` and `cls_profs`, `cls_level` seems to be poorly associated with score.

## Exercise 13
> Interpret the coefficient associated with the ethnicity variable.

If a professor is not of a minority ethnicity, the average score increases by about 0.12 when holding all other variables constant. On a side note, I think this "when holding all other variables consant" phrase is pretty important. The reason why models that model correlated variables do worse than models that don't is because the models operate by holding all variables constant except one. If two variables are correlated, they need to be adjusted simultaneously.

## Exercise 14
> Drop the variable with the highest p-value and re-fit the model. Did the coefficients and significance of the other explanatory variables change? (One of the things that makes multiple regression interesting is that coefficient estimates depend on the other variables that are included in the model.) If not, what does this say about whether or not the dropped variable was collinear with the other explanatory variables?

R<sup>2</sup>-adj increased. Some estimates changed slightly.

```R
m_full_1 <- lm(score ~ rank + ethnicity + gender + language + age + cls_perc_eval
             + cls_students + cls_level + cls_credits + bty_avg
             + pic_outfit + pic_color, data = evals)
summary(m_full_1)
# Coefficients:
#                         Estimate Std. Error t value Pr(>|t|)
# (Intercept)            4.0872523  0.2888562  14.150  < 2e-16 ***
# ranktenure track      -0.1476746  0.0819824  -1.801 0.072327 .
# ranktenured           -0.0973829  0.0662614  -1.470 0.142349
# ethnicitynot minority  0.1274458  0.0772887   1.649 0.099856 .
# gendermale             0.2101231  0.0516873   4.065 5.66e-05 ***
# languagenon-english   -0.2282894  0.1111305  -2.054 0.040530 *
# age                   -0.0089992  0.0031326  -2.873 0.004262 **
# cls_perc_eval          0.0052888  0.0015317   3.453 0.000607 ***
# cls_students           0.0004687  0.0003737   1.254 0.210384
# cls_levelupper         0.0606374  0.0575010   1.055 0.292200
# cls_creditsone credit  0.5061196  0.1149163   4.404 1.33e-05 ***
# bty_avg                0.0398629  0.0174780   2.281 0.023032 *
# pic_outfitnot formal  -0.1083227  0.0721711  -1.501 0.134080
# pic_colorcolor        -0.2190527  0.0711469  -3.079 0.002205 **
#
# R_2_adj = 0.1634
```

## Exercise 15
> Using backward-selection and p-value as the selection criterion, determine the best model. You do not need to show all steps in your answer, just the output for the final model. Also, write out the linear model for predicting score based on the final model you settle on.

In the p-value model selection method, we keep removing the variable with the highest p-value until all variables have a p-value of < alpha=0.05. When doing this, I removed some rank, a multi-level categorical variable, which was significant for one level but had a high p-value for another. There are most definitely better strategies for this.

```
score = 3.77 + 0.168 * ethnicity_not_minority + 0.207 * gender_male + .... - 0.191 * pic_colorcolor
```

```R
m_best_p <- lm(score ~ ethnicity + gender + language + age + cls_perc_eval + cls_credits + bty_avg + pic_color, data = evals)
summary(m_best_p)
# Coefficients:
#                        Estimate Std. Error t value Pr(>|t|)
# (Intercept)            3.771922   0.232053  16.255  < 2e-16 ***
# ethnicitynot minority  0.167872   0.075275   2.230  0.02623 *
# gendermale             0.207112   0.050135   4.131 4.30e-05 ***
# languagenon-english   -0.206178   0.103639  -1.989  0.04726 *
# age                   -0.006046   0.002612  -2.315  0.02108 *
# cls_perc_eval          0.004656   0.001435   3.244  0.00127 **
# cls_creditsone credit  0.505306   0.104119   4.853 1.67e-06 ***
# bty_avg                0.051069   0.016934   3.016  0.00271 **
# pic_colorcolor        -0.190579   0.067351  -2.830  0.00487 **
# 
# R_2_adj = 0.1576
```

## Exercise 16
> Verify that the conditions for this model are reasonable using diagnostic plots.

Multiple-regression conditions:
1. The residuals of the model are nearly normal
  - `hist(residuals(m_best_p))`
  - [image](https://cloud.githubusercontent.com/assets/4649127/20393742/d6aca57e-ac91-11e6-8348-5b0b9860eefd.png) - there's more skew than is desireable, but this isn't a huge concern.
2. The variability of the residuals is nearly constant
  - these plots are also used to validate #4
  - [ethnicity](https://cloud.githubusercontent.com/assets/4649127/20393941/a8808c1e-ac92-11e6-9a5d-5b838ad38d56.png) - `plot(residuals(m_best_p) ~ evals$ethnicity)` - not quite constant variability, close enough. B.c. it's an indicator, its got no choice but to be linear.
  - [gender](https://cloud.githubusercontent.com/assets/4649127/20394066/14be2ecc-ac93-11e6-8b11-50571edb76ff.png) - `plot(residuals(m_best_p) ~ evals$gender)` - constant=good, linear=good (indicator).
  - [language](https://cloud.githubusercontent.com/assets/4649127/20394116/478acb76-ac93-11e6-890f-1fcac77d70f4.png) - `plot(residuals(m_best_p) ~ evals$language)` - constant=poor, linear=good (indicator).
  - [age](https://cloud.githubusercontent.com/assets/4649127/20394184/81940eb8-ac93-11e6-87fa-31ec38709279.png) - `plot(residuals(m_best_p) ~ jitter(evals$age))` - constant=good, linear=good.
  - [class\_perc\_eval](https://cloud.githubusercontent.com/assets/4649127/20394255/c3ad95bc-ac93-11e6-9a54-f8aa57eda596.png) - constant = acceptable, linear = good.
  - ...got tired of uploading these, but the rest look fine.
3. The residuals are independent" (eg: not time series)
  - `plot(residuals(m_best_p))`
  - [image](https://cloud.githubusercontent.com/assets/4649127/20393810/18ebc7da-ac92-11e6-99c2-2b70d228ccdc.png) - looks good
4. each variable is linearly related to the outcome
  - answers to #2 also incorporate whether the variable is linear

## Exercise 17
> The original paper describes how these data were gathered by taking a sample of professors from the University of Texas at Austin and including all courses that they have taught. Considering that each row represents a course, could this new information have an impact on any of the conditions of linear regression?

It's curious they did it this way rather than just taking a random sample of course evaluations (might have been too expensive to compute beauty, etc for random professors). Having all the evaluations from each professor means that the independence assumption should be examined more thorougly. On first thought, I think these are not independent because a professor's score in one class will likely be related to their score in other classes. We may also observe trends in corse scores over time for a professor (as they accept feedback and hopefully do better). The relationship should be examined. Another concern: professors' appearance change over time. If we are curious about beauty, how do we know that a professor who has taught for 20 years and who we have 20 years worth of courses for has the same beauty ranking now as they did 20 years go?

## Exercise 18
> Based on your final model, describe the characteristics of a professor and course at University of Texas at Austin that would be associated with a high evaluation score.

Not minority + male + received ed at english-speaking university + young + gets high percent of students to complete eval + teaches a single-credit class + beautiful + black & white picture.

## Exercise 19
> Would you be comfortable generalizing your conclusions to apply to professors generally (at any university)? Why or why not?

No. I think the conditions from 17 need to be looked into further. We need to make sure our selected courses are independent and that beauty is gauged at the same time as the course eval.
