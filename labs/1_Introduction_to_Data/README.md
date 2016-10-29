# Lab 1: Introduction to Data

My corresponding reading notes for this lab are at http://joshterrell.com/blog/posts/1471406524

## Exercise 1
How many cases are there in this data set? How many variables? For each variable, identify its data
type (e.g. categorical, discrete).
```R
source('cdc.R')

dim(cdc) # 20,000 cases and 9 variables
```
- `genhlth` - ordinal - excellent, very good, good, fair or poor
- `exerany` - ordinal - 1 = exercised in the past month, 0 = otherwise
- `hlthpln` - ordinal - 1 = some form of health coverage, 0 = otherwise
- `smoke100` - ordinal - 1 = smoked at least 100 cigarettes in lifetime, 0 = otherwise
- `height` - discrete - body height in inches
- `weight` - discrete - body weight in pounds
- `wtdesire` - discrete - desired body weight in pounds
- `age` - discrete - age in years
- `gender` - nominal - gender ('m' or 'f')

Note: the lab instructions suggested using `head` and `tail` to look at a few cases. I used `sample`
as well.

## Exercise 2
Create a numerical summary for height and age, and compute the interquartile range for each. Compute
the relative frequency distribution for gender and exerany. How many males are in the sample? What
proportion of the sample reports being in excellent health?
```R
# numerical summary tables
summary(cdc$height)
summary(cdc$age)
# interquartile ranges
IQR(cdc$height)
IQR(cdc$age)
# relative frequency distributions
table(cdc$gender)/nrow(cdc)
table(cdc$exerany)/nrow(cdc)
# number of males
sum(cdc$gender = 'm')
# proportion of sample reporting excellent health
sum(cdc$genhlth == 'excellent')/nrow(cdc)
```

## Exercise 3
What does the mosaic plot reveal about smoking habits and gender?
```R
mosaicplot(table(cdc$gender, cdc$smoke100))
```
A larger proportion of males have smoked more than 100 cigarettes than females have.

## Exercise 4
Create a new object called under23\_and\_smoke that contains all observations of respondents under the
age of 23 that have smoked 100 cigarettes in their lifetime. Write the command you used to create
the new object as the answer to this exercise.
```R
under23_and_smoke <- subset(cdc, cdc$age < 23 & cdc$smoke100 == 1)
```

## Exercise 5
What does this box plot show? Pick another categorical variable from the data set and see how it
relates to BMI. List the variable you chose, why you might think it would have a relationship to
BMI, and indicate what the figure seems to suggest.

```R
# graph shows box plot of bmi for each level of genhlth
# as genhlth approaches poor, median of bmi gets slightly larger.
cdc$bmi <- cdc$weight / cdc$height^2 * 703
boxplot(cdc$bmi ~ cdc$genhlth)

# strikingly similar box plots
boxplot(cdc$bmi ~ cdc$smoke100)

# bmi slightly smaller if exerany is true
boxplot(cdc$bmi ~ cdc$exerany)

# bmi slightly smaller if female, and quartile range is larger if female
boxplot(cdc$bmi ~ cdc$gender)
```

## On Your Own
1\. Make a scatterplot of weight versus desired weight. Describe the relationship between these two
variables.

There is a positive linear relationship between weight and desired weight; as weight increases, so
does desired weight. The slope of the relationship is less than one: as weight increases x pounds,
desired weight increases some amount of pounds less than x.

2\. Let’s consider a new variable: the difference between desired weight (wtdesire) and current weight
(weight). Create this new variable by subtracting the two columns in the data frame and assigning
them to a new object called wdiff.

```R
cdc$wdiff = cdc$wtdesire - cdc$weight
```

3\. What type of data is wdiff? If an observation wdiff is 0, what does this mean about the person’s
weight and desired weight. What if wdiff is positive or negative?

`wdiff` is a discrete numeric variable. If `wdiff` is positive, it means the person desires to weigh
more than their current weight. If `wdiff` is negative, the person desires to weigh less than their
current weight.

4\. Describe the distribution of wdiff in terms of its center, shape, and spread, including any plots
you use. What does this tell us about how people feel about their current weight?
```R
# simple summary (min, Q1, median, mean, Q3, max)
summary(cdc$wdiff)

# boxplot without outliers
boxplot(cdc$wdiff, outline=F)

# hist without outliers <= 0.01 percentile or >= 0.99 percentile
plot(table(
  cdc$wdiff[which(cdc$wdiff > quantile(cdc$wdiff, 0.01) & cdc$wdiff < quantile(cdc$wdiff, 0.99))]
))  
```
- [boxplot without outliers](https://cloud.githubusercontent.com/assets/4649127/14802540/8294c80e-0b06-11e6-9fad-db38116176e1.png)
- [hist](https://cloud.githubusercontent.com/assets/4649127/14802663/6744e97a-0b07-11e6-9a37-689ae77c25a2.png)
- center: median of -10, mean of -14.59
- shape: unimodal, left skew (indicated by mean < median and graphs), smaller noticable modes at
increments of 5lbs (people rounded their weight+desired to even 5?).
- spread: Q1 = -21, Q3 = 0

About 3/4 of respondents wanted to weigh less than they currently do, and about 1/4 of the
respondents indicated wanting to weigh their current weight or more.

5\. Using numerical summaries and a side-by-side box plot, determine if men tend to view their weight
differently than women.

```R
# simple summary (min, Q1, median, mean, Q3, max)
summary(cdc$wdiff[cdc$gender == 'f'])
summary(cdc$wdiff[cdc$gender == 'm'])

# side-by-side boxplot of males and females, again without outliers
boxplot(cdc$wdiff ~ cdc$gender, outline=F)

# overlapping histogram of males (pink) and females (blue) between percentiles(0.01-0.99)
hist(cdc$wdiff[which(cdc$wdiff > quantile(cdc$wdiff, 0.01) & cdc$wdiff < quantile(cdc$wdiff, 0.99) & cdc$gender == 'm')], col=rgb(1, 0, 0, 0.5), breaks=50)
hist(cdc$wdiff[which(cdc$wdiff > quantile(cdc$wdiff, 0.01) & cdc$wdiff < quantile(cdc$wdiff, 0.99) & cdc$gender == 'f')], col=rgb(0, 0, 1, 0.5), add=T, breaks=50)
```
- [side-by-side boxplots](https://cloud.githubusercontent.com/assets/4649127/14803049/251ab1de-0b0b-11e6-8822-e6a260a43331.png)
- [overlapping histograms](https://cloud.githubusercontent.com/assets/4649127/14803032/ebf79d68-0b0a-11e6-9dd3-61bef6d1e583.png)

- females typically want their difference between weight desired and weight to be more negative than
males. Also females have a larger spread of desired differences than males do.

6\. Now it’s time to get creative. Find the mean and standard deviation of weight and determine what
proportion of the weights are within one standard deviation of the mean.

```R
mean(cdc$weight) # 170
sd(cdc$weight)   # 40
sum(abs(cdc$weight - mean(cdc$weight)) <= sd(cdc$weight)) / nrow(cdc) # 71%
```
