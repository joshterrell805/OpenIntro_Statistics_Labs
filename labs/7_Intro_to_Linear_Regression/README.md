# Lab 7: Introduction to Linear Regression

My corresponding reading notes for this chapter are at http://joshterrell.com/blog/posts/1477838366

```R
download.file("http://www.openintro.org/stat/data/mlb11.RData", destfile = "mlb11.RData")
load("mlb11.RData")
```

## Exercise 1
> What type of plot would you use to display the relationship between `runs` and one of the other numerical variables? Plot this relationship using the variable `at_bats` as the predictor. Does the relationship look linear? If you knew a team’s `at_bats`, would you be comfortable using a linear model to predict the number of runs?

A scatter plot is useful for observing the relationship between two numeric variables: [image](https://cloud.githubusercontent.com/assets/4649127/20086670/eaec4d68-a526-11e6-9a5c-2ccfc7538322.png). The relationship appears to have a positive linear trend. Having a team's `at_bats` would allow me to make a better prediction than using nothing at all.

```R
plot(mlb11$runs ~ mlb11$at_bats)
```

> If the relationship looks linear, we can quantify the strength of the relationship with the correlation coefficient.

```R
cor(mlb11$runs, mlb11$at_bats) # 0.610627
```

## Exercise 2
> Looking at your plot from the previous exercise, describe the relationship between these two variables. Make sure to discuss the form, direction, and strength of the relationship as well as any unusual observations.

The two variables appear to be positively correlated (R=0.61) with a slope of approximately 1. The variation appears constant. There are a few outliers, though they appear to follow the general linear trend.

## Exercise 3
> Using `plot_ss`, choose a line that does a good job of minimizing the sum of squares. Run the function several times. What was the smallest sum of squares that you got? How does it compare to your neighbors?

```R
plot_ss(x = mlb11$at_bats, y= mlb11$runs, showSquares = TRUE)
```

The smallest sum of squares I got was 156594.8

## Exercise 4
> Fit a new model that uses `homeruns` to predict runs. Using the estimates from the R output, write the equation of the regression line. What does the slope tell us in the context of the relationship between success of a team and its home runs?

For every homerun a team gets, they make about 1.8 runs.

```R
m1 <- lm(runs ~ homeruns, data = mlb11)
summary(m1)
# Call:
# lm(formula = runs ~ homeruns, data = mlb11)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max
# -91.615 -33.410   3.231  24.292 104.631
# 
# Coefficients:
# '            Estimate Std. Error t value Pr(>|t|)
# (Intercept) 415.2389    41.6779   9.963 1.04e-10 ***
# homeruns      1.8345     0.2677   6.854 1.90e-07 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 51.29 on 28 degrees of freedom
# Multiple R-squared:  0.6266,    Adjusted R-squared:  0.6132
# F-statistic: 46.98 on 1 and 28 DF,  p-value: 1.9e-07
```

## Exercise 5
> If a team manager saw the least squares regression line and not the actual data, how many runs would he or she predict for a team with 5,578 at-bats? Is this an overestimate or an underestimate, and by how much? In other words, what is the residual for this prediction?

Based on the [graph](https://cloud.githubusercontent.com/assets/4649127/20101025/e9e48f22-a574-11e6-9003-256cbeacb0de.png), the line predicts that a team with 5,575 at-bats would make 800 runs. The actual observation at this point (furthest to the right) has a value of around 875. The residual is `875-800=75`.

```R
plot(mlb11$runs ~ mlb11$at_bats)
m1 <- lm(runs ~ at_bats, data = mlb11)
abline(m1)
```

## Exercise 6
To assess whether the linear model is reliable, we need to check for (1) linearity, (2) nearly normal residuals, and (3) constant variability.

> Is there any apparent pattern in the residuals plot? What does this indicate about the linearity of the relationship between runs and at-bats?

There appears to be no pattern in the [residuals plot](https://cloud.githubusercontent.com/assets/4649127/20103463/f64f9d6a-a57e-11e6-8f39-964ece5fa7b5.png).

```R
plot(m1$residuals ~ mlb11$at_bats)
abline(h = 0, lty = 3)  # adds a horizontal dashed line at y = 0
```

## Exercise 7
> Based on the histogram and the normal probability plot, does the nearly normal residuals condition appear to be met?


The [histogram](https://cloud.githubusercontent.com/assets/4649127/20103562/608115c4-a57f-11e6-8581-bd72ea2ef277.png) does not appear to be normal, but has the general shape of normality. The [qq plot](https://cloud.githubusercontent.com/assets/4649127/20103624/a3b60a34-a57f-11e6-9a67-9a1c48297e52.png) shows some evident deviations from normal too.

```R
hist(m1$residuals)
qqnorm(m1$residuals)
qqline(m1$residuals)  # adds diagonal line to the normal prob plot
```

## Exercise 8
> Based on the plot in (1), does the constant variability condition appear to be met?

Yes, the [plot from the first exercise](https://cloud.githubusercontent.com/assets/4649127/20086670/eaec4d68-a526-11e6-9a5c-2ccfc7538322.png) appears to show constant variability.

## On Your Own
### 1
> Choose another traditional variable from `mlb11` that you think might be a good predictor of `runs`. Produce a scatterplot of the two variables and fit a linear model. At a glance, does there seem to be a linear relationship?

`hits` appears to have a linear relationship with `runs`. The variables are related with a correlation of R=0.80

[scatterplot with least squares line](https://cloud.githubusercontent.com/assets/4649127/20103921/aed434da-a580-11e6-93bb-c115c7d4d3b0.png)
```R
plot(runs ~ hits, data=mlb11)
m2 <- lm(runs ~ hits, data = mlb11)
abline(m2)
cor(mlb11$runs, mlb11$hits) # 0.8012108
```

### 2
> How does this relationship compare to the relationship between `runs` and `at_bats`? Use the R<sup>2</sup> values from the two model summaries to compare. Does your variable seem to predict `runs` better than `at_bats`? How can you tell?

Since `hits` R<sup>2</sup> (= 0.64) with `runs` (R=0.80) is greater than `at_bats` R<sup>2</sup> (= 0.37) with `runs` (R=0.61), `hits` is a better predictor for `runs` than `at_bats`.

### 3
> Now that you can summarize the linear relationship between two variables, investigate the relationships between `runs` and each of the other five traditional variables. Which variable best predicts `runs`? Support your conclusion using the graphical and numerical methods we’ve discussed (for the sake of conciseness, only include output for the best variable, not all five).

`runs` vs `bat_avg` has the highest R<sup>2</sup> (= 0.66) and also appears to meet the criteria for linear regression (normal residuals, constant variance, linear). [scatterplot with least squares line](https://cloud.githubusercontent.com/assets/4649127/20104276/3c9fca08-a582-11e6-957c-2e90dcc8fc41.png).

```R
preds = c('at_bats', 'hits', 'homeruns', 'bat_avg', 'strikeouts', 'stolen_bases', 'wins')
for (p in preds) {
  R = cor(mlb11[, p], mlb11$runs)
  print(paste(p, ': ', R ^ 2, sep=''))
}
# "at_bats: 0.372865390186806"
# "hits: 0.641938767239419"
# "homeruns: 0.626563569566283"
# "bat_avg: 0.656077134646863"
# "strikeouts: 0.169357932236312"
# "stolen_bases: 0.00291399266657398"
# "wins: 0.360971179446681"

plot(runs ~ bat_avg, data=mlb11)
m3 <- lm(runs ~ bat_avg, data=mlb11)
abline(m3)
```

### 4
> Now examine the three newer variables. These are the statistics used by the author of Moneyball to predict a teams success. In general, are they more or less effective at predicting `runs` that the old variables? Explain using appropriate graphical and numerical evidence. Of all ten variables we’ve analyzed, which seems to be the best predictor of `runs`? Using the limited (or not so limited) information you know about these baseball statistics, does your result make sense?

The new variables are much more effective at predicting `runs` than the old variables. The predictor with the best R<sup>2</sup> (= 0.93), `new_obs`, [has a linear relationship with `runs`](https://cloud.githubusercontent.com/assets/4649127/20104527/269dd7a8-a583-11e6-8e3e-72a60c3ea464.png) and meets the two residual criteria.

```R
preds = c('new_onbase', 'new_slug', 'new_obs')
for (p in preds) {
  R = cor(mlb11[, p], mlb11$runs)
  print(paste(p, ': ', R ^ 2, sep=''))
}
# "new_onbase: 0.849105251446139"
# "new_slug: 0.896870368409638"
# "new_obs: 0.934927126351814"

plot(runs ~ new_obs, data=mlb11)
m4 <- lm(runs ~ new_obs, data=mlb11)
abline(m4)

```

### 5
> Check the model diagnostics for the regression model with the variable you decided was the best predictor for runs.

As mentioned in the last question, the scatterplot appears to meet the three criteria of linear regression. The [histogram of residuals](https://cloud.githubusercontent.com/assets/4649127/20104692/c897206e-a583-11e6-8736-6d441941ea91.png) and [qq-plot](https://cloud.githubusercontent.com/assets/4649127/20104722/e6284ce8-a583-11e6-9844-79ec42c97b11.png) appear to show more normality than `at_bats`.

```R
hist(m4$residuals)
qqnorm(m4$residuals)
qqline(m4$residuals)
```
