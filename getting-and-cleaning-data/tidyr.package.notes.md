# tidyr pacakge notes

## how to tidy your data with the tidyr package

http://vita.had.co.nz/papers/tidy-data.pdf

```sh

library(tidyr)

```

Tidy data is formatted in a standard way that facilitates exploration and analysis and works seemlessly with
|other tidy data tools. Specifically, tidy data satisfies three conditions:
 
 1) Each variable forms a column
 2) Each observation forms a row
 3) Each type of observational unit forms a table
 
Any dataset that doesn't satisfy these conditions is considered 'messy' data. Therefore, all of the following are characteristics of messy data

1: Column headers are values, not variable names
2: Variables are stored in both rows and columns
3: A single observational unit is stored in multiple tables
4: Multiple types of observational units are stored in the same table
5: Multiple variables are stored in one column



## Problem:  Column headers are values, not variable names
 The first problem is when you have column headers that are values, not variable names. I've created a simple
dataset called 'students' that demonstrates this scenario. Type students to take a look.
```sh
students
  grade male female
1     A    1      5
2     B    5      0
3     C    5      2
4     D    5      5
5     E    7      4
```
###  gather()

To tidy the students data, we need to have one column for each of these three variables. We'll use the gather() function from tidyr to accomplish this. Pull up the documentation for this function with ?gather.


 Using the help file as a guide, call gather() with the following 
 arguments (in order): students, sex, count, -grade. 
 Note the minus sign before grade, which says we want to gather all columns EXCEPT grade.

```sh
gather( students, sex, count, -grade)

  grade    sex count
1      A   male     1
2      B   male     5
3      C   male     5
4      D   male     5
5      E   male     7
6      A female     5
7      B female     0
8      C female     2
9      D female     5
10     E female     4


```



The second messy data case we'll look at is when multiple variables are stored in one column. Type students2 to see an example of this.

```sh

students2
  grade male_1 female_1 male_2 female_2
1     A      3        4      3        4
2     B      6        4      3        5
3     C      7        4      3        8
4     D      4        0      8        1
5     E      1        1      2        7
```
 Let's start by using gather() to stack the columns of students2, like we just did with students. This time, name the 'key' column sex_class and the 'value' column count. Save the result to a new variable called res. Consult ?gather again if you need help.

```sh

res <- gather( students2, sex_class, count, -grade)
 res
    grade sex_class count
1      A    male_1     3
2      B    male_1     6
3      C    male_1     7
4      D    male_1     4
5      E    male_1     1
6      A  female_1     4
7      B  female_1     4
8      C  female_1     4
9      D  female_1     0
10     E  female_1     1
11     A    male_2     3
etc...


```

### separate()
That got us half way to tidy data, but we still have two different variables, sex and class, stored together in the sex_class column. tidyr offers a convenient separate() function for the purpose of separating one column into multiple columns. Pull up the help file for separate() now.

```sh
separate( res, col = sex_class, into = c("sex", "class"))
   grade    sex class count
1      A   male     1     3
2      B   male     1     6
3      C   male     1     7
4      D   male     1     4
5      E   male     1     1
6      A female     1     4
7      B female     1     4
8      C female     1     4
9      D female     1     0
10     E female     1     1
11     A   male     2     3
12     B   male     2     3
13     C   male     2     3
14     D   male     2     8
15     E   male     2     2
16     A female     2     4
17     B female     2     5
18     C female     2     8
19     D female     2     1
20     E female     2     7

```

Conveniently, separate() was able to figure out on its own how to separate the sex_class column. Unless you request otherwise with the 'sep' argument, it splits on non-alphanumeric values. In other words, it assumes that the values are separated by something other than a letter or number (in this case, an underscore.)

```sh
students2 %>%
  gather( sex_class, count, -grade ) %>%
  separate( col = sex_class, into = c("sex", "class") , sep="_") 
```

 A third symptom of messy data is when variables are stored in both rows and columns. students3 provides an example of this. Print students3 to the console.
 
 The first variable, name, is already a column and should remain as it is. The headers of the last five columns, class1 through class5, are all different values of what should be a class variable. The values in the test column, midterm and final, should each be its own variable containing the respective grades for each student.
 ```sh
  students3
    name    test class1 class2 class3 class4 class5
1  Sally midterm      A   <NA>      B   <NA>   <NA>
2  Sally   final      C   <NA>      C   <NA>   <NA>
3   Jeff midterm   <NA>      D   <NA>      A   <NA>
4   Jeff   final   <NA>      E   <NA>      C   <NA>
5  Roger midterm   <NA>      C   <NA>   <NA>      B
6  Roger   final   <NA>      A   <NA>   <NA>      A
7  Karen midterm   <NA>   <NA>      C      A   <NA>
8  Karen   final   <NA>   <NA>      C      A   <NA>
9  Brian midterm      B   <NA>   <NA>   <NA>      A
10 Brian   final      B   <NA>   <NA>   <NA>      C
```


The fourth messy data problem we'll look at occurs when multiple observational units are stored in the same table. students4 presents an example of this. Take a look at the data now.
```sh
> students4
    id  name sex class midterm final
1  168 Brian   F     1       B     B
2  168 Brian   F     5       A     C
3  588 Sally   M     1       A     C
4  588 Sally   M     3       B     C
5  710  Jeff   M     2       D     E
6  710  Jeff   M     4       A     C
7  731 Roger   F     2       C     A
8  731 Roger   F     5       B     A
9  908 Karen   M     3       C     C
10 908 Karen   M     4       A     A
```


create a new column wth value "failed"
```sh 
 failed <- mutate( failed, status = "failed")
```

Now, pass as arguments the passed and failed tables (in order) to the dplyr function rbind_list() (for 'row bind'), which will join them together into a single unit. Check ?rbind_list if you need help.

```sh
> rbind_list(passed, failed)
    name class final status
1  Brian     1     B passed
2  Roger     2     A passed
3  Roger     5     A passed
4  Karen     4     A passed
5  Brian     5     C failed
6  Sally     1     C failed
7  Sally     3     C failed
8   Jeff     2     E failed
9   Jeff     4     C failed
10 Karen     3     C failed
```
 



 The SAT is a popular college-readiness exam in the United States that consists of three sections:
 critical reading, mathematics, and writing. Students can earn up to 800 points on each section. This dataset presents the total number of students, for each combination of exam section and sex, within each of six score ranges. It comes from the 'Total Group Report 2013', which can be found here: 
  http://research.collegeboard.org/programs/sat/data/cb-seniors-2013


###Here is the data:
```sh
> sat
Source: local data frame [6 x 10]

  score_range read_male read_fem read_total math_male math_fem math_total write_male write_fem
1     700–800     40151    3889879049     74461    46040     120501      31574     39101
2     600-690    121950   126084     248034    162564   133954     296518     100963    125368
3     500-590    227141   259553     486694    233141   257678     490819     202326    247239
4     400-490    242554   296793     539347    204670   288696     493366     262623    302933
5     300-390    113568   133473     247041     82468   131025     213493     146106    144381
6     200-290     30728    29154      59882     18788    26562      45350      32500     24933
Variables not shown: write_total (int)
```

