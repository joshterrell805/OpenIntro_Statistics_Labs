source('arbuthnot.R')
source('present.R')

print('1a. What years are included in this data set?')
print(present$year)
print('1b. What are the dimensions of the data frame?')
print(dim(present))
print('1c. What are the variable or column names?')
print(names(present))

print('2. How do these counts compare to Arbuthnot\'s? Are they on a similar scale?')
print(sapply(present[,c('boys', 'girls')], median))
print(sapply(arbuthnot[,c('boys', 'girls')], median))
print('The present dataset is on the scale of millions whereas arbuthnot is on the scale of thousands.')

print('3. Make a plot that displays the boy-to-girl ratio for every year in the data set. What do you see? Does Arbuthnot’s observation about boys being born in greater proportion than girls hold up in the U.S.? Include the plot in your response.')
plot(x=present$year, y=present$boys/present$girls)
# # validation
# print(present$boys > present$girls)
print('Yes, this dataset shows that boys are born in greater proportion.')

print('4. In what year did we see the most total number of births in the U.S.?')
print(present$year[which.max(present$girls + present$boys)])
# # validation
# present$births = present$boys+present$girls
# print(present)
