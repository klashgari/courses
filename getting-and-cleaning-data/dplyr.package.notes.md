# dplyr pacakge notes

## loading dplyr

```sh
library(dplyr)
packageVersion("dplyr")
```

## tbl_df(..)

 load the data into what the package authors call a 'data frame tbl' or
| 'tbl_df'. Use the following code to create a new tbl_df called cran:

dplyr supplies five 'verbs' that cover all fundamental data
manipulation tasks: select(), filter(), arrange(), mutate(), and summarize().

Use ?manip to pull up the documentation for these core functions.
```sh
mydf <- read.csv( path2csv , stringsAsFactors = FALSE)
dim(mydf)
head(mydf)
```

### Loading data into tbl_df

```sh
?tbl_df

cran <- tbl_df(mydf).
```
From ?tbl_df, The main advantage to using a tbl_df over a regular data frame is the printing. 
Let's see what is meant by this. Type cran to print our tbl_df to the console.

```sh
cran
Source: local data frame [225,468 x 11]

    X       date     time    size r_version r_arch      r_os      package version country ip_id
1   1 2014-07-08 00:54:41   80589     3.1.0 x86_64   mingw32    htmltools   0.2.4      US     1
2   2 2014-07-08 00:59:53  321767     3.1.0 x86_64   mingw32      tseries 0.10-32      US     2
3   3 2014-07-08 00:47:13  748063     3.1.0 x86_64 linux-gnu        party  1.0-15      US     3
4   4 2014-07-08 00:48:05  606104     3.1.0 x86_64 linux-gnu        Hmisc  3.14-4      US     3
5   5 2014-07-08 00:46:50   79825     3.0.2 x86_64 linux-gnu       digest   0.6.4      CA     4
6   6 2014-07-08 00:48:04   77681     3.1.0 x86_64 linux-gnu randomForest   4.6-7      US     3
7   7 2014-07-08 00:48:35  393754     3.1.0 x86_64 linux-gnu         plyr   1.8.1      US     3
8   8 2014-07-08 00:47:30   28216     3.0.2 x86_64 linux-gnu      whisker   0.3-2      US     5
9   9 2014-07-08 00:54:58    5928        NA     NA        NA         Rcpp  0.10.4      CN     6
10 10 2014-07-08 00:15:35 2206029     3.0.2 x86_64 linux-gnu     hflights     0.1      US     7
.. ..        ...      ...     ...       ...    ...       ...          ...     ...     ...   ...
```
### using select
First, we are shown the class and dimensions of the dataset. Just below that, we get a preview of the data. Instead of
attempting to print the entire dataset, dplyr just shows us the first 10 rows of data and only as many columns as fit
neatly in our console. At the bottom, we see the names and classes for any variables that didn't fit on our screen.

As may often be the case, particularly with larger datasets, we are only interested in some of the variables. Use
select(cran, ip_id, package, country) to select only the ip_id, package, and country variables from the cran dataset.

```sh
select(cran, ip_id, package, country)
Source: local data frame [225,468 x 3]

   ip_id      package country
1      1    htmltools      US
2      2      tseries      US
3      3        party      US
4      3        Hmisc      US
5      4       digest      CA
6      3 randomForest      US
7      3         plyr      US
8      5      whisker      US
9      6         Rcpp      CN
10     7     hflights      US
..   ...          ...     ...
```

 Normally, this notation is reserved for numbers, but select() allows you to specify a sequence of columns this way, which can save a bunch of typing. Use select(cran, r_arch:country) to select all columns starting from r_arch and ending with country.
```sh
select( cran, r_arch:country)
Source: local data frame [225,468 x 5]

   r_arch      r_os      package version country
1  x86_64   mingw32    htmltools   0.2.4      US
2  x86_64   mingw32      tseries 0.10-32      US
3  x86_64 linux-gnu        party  1.0-15      US
4  x86_64 linux-gnu        Hmisc  3.14-4      US
5  x86_64 linux-gnu       digest   0.6.4      CA
6  x86_64 linux-gnu randomForest   4.6-7      US
7  x86_64 linux-gnu         plyr   1.8.1      US
8  x86_64 linux-gnu      whisker   0.3-2      US
9      NA        NA         Rcpp  0.10.4      CN
10 x86_64 linux-gnu     hflights     0.1      US
..    ...       ...          ...     ...     ...
```
Instead of specifying the columns we want to keep, we can also specify the columns we want to
throw away. To see how this works, do select(cran, -time) to omit the time column.

```sh
select(cran, -time)
Source: local data frame [225,468 x 10]

    X       date    size r_version r_arch      r_os      package version country ip_id
1   1 2014-07-08   80589     3.1.0 x86_64   mingw32    htmltools   0.2.4      US     1
2   2 2014-07-08  321767     3.1.0 x86_64   mingw32      tseries 0.10-32      US     2
3   3 2014-07-08  748063     3.1.0 x86_64 linux-gnu        party  1.0-15      US     3
```

We can remove the columns
```sh
select( cran , -(X:size))
Source: local data frame [225,468 x 7]

   r_version r_arch      r_os      package version country ip_id
1      3.1.0 x86_64   mingw32    htmltools   0.2.4      US     1
2      3.1.0 x86_64   mingw32      tseries 0.10-32      US     2
3      3.1.0 x86_64 linux-gnu        party  1.0-15      US     3
```

### filter()  using dplyr lib
How do I select a subset of rows?" That's where the filter() function comes in


Use filter(cran, package == "swirl") to select all rows for which the package variable is equal to
"swirl". Be sure to use two equals signs side-by-side!

```sh
 filter( cran, package == "swirl")
Source: local data frame [820 x 11]

      X       date     time   size r_version r_arch         r_os package version country ip_id
1    27 2014-07-08 00:17:16 105350     3.0.2 x86_64      mingw32   swirl   2.2.9      US    20
2   156 2014-07-08 00:22:53  41261     3.1.0 x86_64    linux-gnu   swirl   2.2.9      US    66
3   358 2014-07-08 00:13:42 105335    2.15.2 x86_64      mingw32   swirl   2.2.9      CA   115
4   593 2014-07-08 00:59:45 105465     3.1.0 x86_64 darwin13.1.0   swirl   2.2.9      MX   162
5   831 2014-07-08 00:55:27 105335     3.0.3 x86_64      mingw32   swirl   2.2.9      US    57
6   997 2014-07-08 00:33:06  41261     3.1.0 x86_64      mingw32   swirl   2.2.9      US    70
7  1023 2014-07-08 00:35:36 106393     3.1.0 x86_64      mingw32   swirl   2.2.9      BR   248
8  1144 2014-07-08 00:00:39 106534     3.0.2 x86_64    linux-gnu   swirl   2.2.9      US   261
9  1402 2014-07-08 00:41:41  41261     3.1.0   i386      mingw32   swirl   2.2.9      US   234
10 1424 2014-07-08 00:44:49 106393     3.1.0 x86_64    linux-gnu   swirl   2.2.9      US   301
..  ...        ...      ...    ...       ...    ...          ...     ...     ...     ...   ...
```
Again, note that filter() recognizes 'package' as a column of cran, without you having to
explicitly specify cran$package.

 You can specify as many conditions as you want, separated by commas. 
 For example filter(cran, r_version == "3.1.1", country == "US") 
 will return all rows of cran corresponding to downloads from users in the US running R version 3.1.1.
 
 ```sh
filter(cran, r_version == "3.1.1", country == "US")
Source: local data frame [1,588 x 11]

       X       date     time    size r_version r_arch         r_os      package version country ip_id
1   2216 2014-07-08 00:48:58  385112     3.1.1 x86_64 darwin13.1.0   colorspace   1.2-4      US   191
2  17332 2014-07-08 03:39:57  197459     3.1.1 x86_64 darwin13.1.0         httr     0.3      US  1704
3  17465 2014-07-08 03:25:38   23259     3.1.1 x86_64 darwin13.1.0         snow  0.3-13      US    62
4  18844 2014-07-08 03:59:17  190594     3.1.1 x86_64 darwin13.1.0       maxLik   1.2-0      US  1533
5  30182 2014-07-08 04:13:15   77683     3.1.1   i386      mingw32 randomForest   4.6-7      US   646
6  30193 2014-07-08 04:06:26 2351969     3.1.1   i386      mingw32      ggplot2   1.0.0      US     8
7  30195 2014-07-08 04:07:09  299080     3.1.1   i386      mingw32    fExtremes 3010.81      US  2010
8  30217 2014-07-08 04:32:04  568036     3.1.1   i386      mingw32        rJava   0.9-6      US    98
9  30245 2014-07-08 04:10:41  526858     3.1.1   i386      mingw32         LPCM  0.44-8      US     8
10 30354 2014-07-08 04:32:51 1763717     3.1.1   i386      mingw32         mgcv   1.8-1      US  2122
..   ...        ...      ...     ...       ...    ...          ...          ...     ...     ...   ...
```

The conditions passed to filter() can make use of any of the standard comparison operators. Pull up the relevant documentation with ?Comparison 
 
Here is an example using numerics and strings

```sh

> filter(cran, size > 100500 , r_os == "linux-gnu")
Source: local data frame [33,683 x 11]

    X       date     time    size r_version r_arch      r_os  package version country ip_id
1   3 2014-07-08 00:47:13  748063     3.1.0 x86_64 linux-gnu    party  1.0-15      US     3
2   4 2014-07-08 00:48:05  606104     3.1.0 x86_64 linux-gnu    Hmisc  3.14-4      US     3
3   7 2014-07-08 00:48:35  393754     3.1.0 x86_64 linux-gnu     plyr   1.8.1      US     3
4  10 2014-07-08 00:15:35 2206029     3.0.2 x86_64 linux-gnu hflights     0.1      US     7
5  11 2014-07-08 00:15:25  526858     3.0.2 x86_64 linux-gnu     LPCM  0.44-8      US     8
6  12 2014-07-08 00:14:45 2351969    2.14.1 x86_64 linux-gnu  ggplot2   1.0.0      US     8
7  14 2014-07-08 00:15:35 3097729     3.0.2 x86_64 linux-gnu     Rcpp   0.9.7      VE    10
8  15 2014-07-08 00:14:37  568036     3.1.0 x86_64 linux-gnu    rJava   0.9-6      US    11
9  16 2014-07-08 00:15:50 1600441     3.1.0 x86_64 linux-gnu  RSQLite  0.11.4      US     7
10 18 2014-07-08 00:26:59  186685     3.1.0 x86_64 linux-gnu    ipred   0.9-3      DE    13
.. ..        ...      ...     ...       ...    ...       ...      ...     ...     ...   ...
```

 Here is how to list all rows with r_version is not NA
 
 ```sh
 filter(cran,  !is.na( r_version))
 Source: local data frame [207,205 x 11]

    X       date     time    size r_version r_arch      r_os      package version country ip_id
1   1 2014-07-08 00:54:41   80589     3.1.0 x86_64   mingw32    htmltools   0.2.4      US     1
2   2 2014-07-08 00:59:53  321767     3.1.0 x86_64   mingw32      tseries 0.10-32      US     2
3   3 2014-07-08 00:47:13  748063     3.1.0 x86_64 linux-gnu        party  1.0-15      US     3
4   4 2014-07-08 00:48:05  606104     3.1.0 x86_64 linux-gnu        Hmisc  3.14-4      US     3
5   5 2014-07-08 00:46:50   79825     3.0.2 x86_64 linux-gnu       digest   0.6.4      CA     4
6   6 2014-07-08 00:48:04   77681     3.1.0 x86_64 linux-gnu randomForest   4.6-7      US     3
7   7 2014-07-08 00:48:35  393754     3.1.0 x86_64 linux-gnu         plyr   1.8.1      US     3
8   8 2014-07-08 00:47:30   28216     3.0.2 x86_64 linux-gnu      whisker   0.3-2      US     5
9  10 2014-07-08 00:15:35 2206029     3.0.2 x86_64 linux-gnu     hflights     0.1      US     7
10 11 2014-07-08 00:15:25  526858     3.0.2 x86_64 linux-gnu         LPCM  0.44-8      US     8
.. ..        ...      ...     ...       ...    ...       ...          ...     ...     ...   ...
 ```
 
### arrange()

Sometimes we want to order the rows of a dataset according to the values of a particular variable. This is the job of arrange().

to order the ROWS of cran2 so that ip_id is in ascending order (from small to large), 
type arrange(cran2, ip_id).

```sh
cran2 <- select(cran, size:ip_id)

arrange( cran2, ip_id)

Source: local data frame [225,468 x 8]

     size r_version r_arch         r_os     package version country ip_id
1   80589     3.1.0 x86_64      mingw32   htmltools   0.2.4      US     1
2  180562     3.0.2 x86_64      mingw32        yaml  2.1.13      US     1
3  190120     3.1.0   i386      mingw32       babel   0.2-6      US     1
4  321767     3.1.0 x86_64      mingw32     tseries 0.10-32      US     2
5   52281     3.0.3 x86_64 darwin10.8.0    quadprog   1.5-5      US     2
6  876702     3.1.0 x86_64    linux-gnu         zoo  1.7-11      US     2
7  321764     3.0.2 x86_64    linux-gnu     tseries 0.10-32      US     2
8  876702     3.1.0 x86_64    linux-gnu         zoo  1.7-11      US     2
9  321768     3.1.0 x86_64      mingw32     tseries 0.10-32      US     2
10 784093     3.1.0 x86_64    linux-gnu strucchange   1.5-0      US     2
..    ...       ...    ...          ...         ...     ...     ...   ...

```

To do the same, but in descending order, change the second argument to desc(ip_id), where desc() stands for
'descending'.

```sh
arrange( cran2, desc(ip_id))

Source: local data frame [225,468 x 8]

      size r_version r_arch         r_os      package version country ip_id
1     5933        NA     NA           NA          CPE   1.4.2      CN 13859
2   569241     3.1.0 x86_64      mingw32 multcompView   0.1-5      US 13858
3   228444     3.1.0 x86_64      mingw32        tourr   0.5.3      NZ 13857
4   308962     3.1.0 x86_64 darwin13.1.0          ctv   0.7-9      CN 13856
5   950964     3.0.3   i386      mingw32        knitr     1.6      CA 13855
6    80185     3.0.3   i386      mingw32    htmltools   0.2.4      CA 13855
7  1431750     3.0.3   i386      mingw32        shiny  0.10.0      CA 13855
8  2189695     3.1.0 x86_64      mingw32       RMySQL   0.9-3      US 13854
9  4818024     3.1.0   i386      mingw32       igraph   0.7.1      US 13853
10  197495     3.1.0 x86_64      mingw32         coda  0.16-1      US 13852
..     ...       ...    ...          ...          ...     ...     ...   ...
```
We can also arrange the data according to the values of multiple variables. For example, arrange(cran2, package, ip_id) will first arrange by package names (ascending alphabetically), then by ip_id. This means that if there are multiple rows with the same value for package, they will be sorted by ip_id (ascending numerically).

```sh
arrange(cran2, package, ip_id)

Source: local data frame [225,468 x 8]

    size r_version r_arch         r_os package version country ip_id
1  71677     3.0.3 x86_64 darwin10.8.0      A3   0.9.2      CN  1003
2  71672     3.1.0 x86_64    linux-gnu      A3   0.9.2      US  1015
3  71677     3.1.0 x86_64      mingw32      A3   0.9.2      IN  1054
```

### mutate() 

It's common to create a new variable based on the value of one or more variables already in a dataset. 
The mutate() function does exactly this.

We want to add a column called size_mb that contains the download size in megabytes. Here''s the code to do it:

```sh
cran3 <- select( cran, ip_id, package, size)

mutate(cran3, size_mb = size / 2^20)

Source: local data frame [225,468 x 4]

   ip_id      package    size     size_mb
1      1    htmltools   80589 0.076855659
2      2      tseries  321767 0.306860924
3      3        party  748063 0.713408470
4      3        Hmisc  606104 0.578025818
5      4       digest   79825 0.076127052
6      3 randomForest   77681 0.074082375
7      3         plyr  393754 0.375513077
8      5      whisker   28216 0.026908875
9      6         Rcpp    5928 0.005653381
10     7     hflights 2206029 2.103833199
..   ...          ...     ...         ...

```

One very nice feature of mutate() is that you can use the value computed for your second column (size_mb) to
create a third column, all in the same line of code. To see this in action, repeat the exact same command as
| above, except add a third argument creating a column that is named size_gb and equal to size_mb / 2^10

```sh
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)

Source: local data frame [225,468 x 5]

   ip_id      package    size     size_mb      size_gb
1      1    htmltools   80589 0.076855659 7.505435e-05
2      2      tseries  321767 0.306860924 2.996689e-04
3      3        party  748063 0.713408470 6.966880e-04
4      3        Hmisc  606104 0.578025818 5.644783e-04
5      4       digest   79825 0.076127052 7.434282e-05
6      3 randomForest   77681 0.074082375 7.234607e-05
7      3         plyr  393754 0.375513077 3.667120e-04
8      5      whisker   28216 0.026908875 2.627820e-05
9      6         Rcpp    5928 0.005653381 5.520880e-06
10     7     hflights 2206029 2.103833199 2.054525e-03
..   ...          ...     ...         ...          ...

```

### summarize()

summarize(), collapses the dataset to a single row. Let's say we're interested in knowing the average download size. summarize(cran, avg_bytes = mean(size)) will yield the mean value of the size variable. Here we've chosen to label the result 'avg_bytes', but we could have named it

```sh
summarize(cran, avg_bytes = mean(size))
Source: local data frame [1 x 1]

  avg_bytes
1  844086.5
```
summarize() can give you the requested value FOR EACH group in your dataset.


## Grouping data

The main idea behind grouping data is that you want to break up your dataset into groups of rows based on the
values of one or more variables. The group_by() function is reponsible for doing this.

Group cran by the package variable and store the result in a new variable called by_package.
```sh
cran <- tbl_df(mydf)

by_package <- group_by(cran, package)

 by_package
Source: local data frame [225,468 x 11]
Groups: package

    X       date     time    size r_version r_arch      r_os      package version country ip_id
1   1 2014-07-08 00:54:41   80589     3.1.0 x86_64   mingw32    htmltools   0.2.4      US     1
2   2 2014-07-08 00:59:53  321767     3.1.0 x86_64   mingw32      tseries 0.10-32      US     2
3   3 2014-07-08 00:47:13  748063     3.1.0 x86_64 linux-gnu        party  1.0-15      US     3
4   4 2014-07-08 00:48:05  606104     3.1.0 x86_64 linux-gnu        Hmisc  3.14-4      US     3
5   5 2014-07-08 00:46:50   79825     3.0.2 x86_64 linux-gnu       digest   0.6.4      CA     4
6   6 2014-07-08 00:48:04   77681     3.1.0 x86_64 linux-gnu randomForest   4.6-7      US     3
7   7 2014-07-08 00:48:35  393754     3.1.0 x86_64 linux-gnu         plyr   1.8.1      US     3
8   8 2014-07-08 00:47:30   28216     3.0.2 x86_64 linux-gnu      whisker   0.3-2      US     5
9   9 2014-07-08 00:54:58    5928        NA     NA        NA         Rcpp  0.10.4      CN     6
10 10 2014-07-08 00:15:35 2206029     3.0.2 x86_64 linux-gnu     hflights     0.1      US     7
.. ..        ...      ...     ...       ...    ...       ...          ...     ...     ...   ...

```

At the top of the output above, you'll see 'Groups: package', which tells us that this tbl has been grouped by the package variable. Everything else looks the same, but now any operation we apply to the grouped data will take place on a per package basis.

```sh
summarize( by_package, mean(size))
Source: local data frame [6,023 x 2]

       package mean(size)
1           A3   62194.96
2  ABCExtremes   22904.33
3     ABCoptim   17807.25
4        ABCp2   30473.33
5       ACCLMA   33375.53
6          ACD   99055.29
7         ACNE   96099.75
8        ACTCD  134746.27
9    ADGofTest   12262.91
10        ADM3 1077203.47
..         ...        ...
```
Instead of returning a single value, summarize() now returns the mean size for EACH package in our dataset.

```sh


pack_sum <- summarize(by_package,
                      count = n(),
                      unique =  n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes =  mean(size))
 pack_sum
Source: local data frame [6,023 x 5]

       package count unique countries  avg_bytes
1           A3    25     24        10   62194.96
2  ABCExtremes    18     17         9   22904.33
3     ABCoptim    16     15         9   17807.25
4        ABCp2    18     17        10   30473.33
5       ACCLMA    15     14         9   33375.53
6          ACD    17     16        10   99055.29
7         ACNE    16     15        10   96099.75
8        ACTCD    15     14         9  134746.27
9    ADGofTest    47     44        20   12262.91
10        ADM3    17     16        10 1077203.47
..         ...   ...    ...       ...        ...                     
                      
```
The 'count' column, created with n(), contains the total number of rows (i.e. downloads) for each package. The 'unique' column, created with n_distinct(ip_id), gives the total number of unique downloads for each package, as measure by the number of distinct ip_id's. The 'countries' column, created with n_distinct(country), provides the number of countries in which the each package was downloaded. And finally, the 'avg_bytes' column, created with mean(size), contains the mean download size (in bytes) for each package.

we'd like to know which packages were most popular on the day these data were collected (July 8, 2014). Let's start by isolating the top 1% of packages, based on the total number of downloads as measured by the 'count' column.

## quantile
We need to know the value of 'count' that splits the data into the top 1% and bottom 99% of packages based on total downloads. In statistics, this is called the 0.99, or 99%, sample quantile. Use quantile(pack_sum$count, probs = 0.99) to determine this number.

```sh
quantile(pack_sum$count, probs = 0.99)
   99% 
679.56 
```

Now we can isolate only those packages which had more than 679 total downloads. Use filter() to select all rows from pack_sum for which 'count' is strictly greater (>) than 679. Store the result in a new variable called top_counts.
```sh
top_counts <- filter( pack_sum , count > 679)

top_counts
Source: local data frame [61 x 5]

        package count unique countries   avg_bytes
1           DBI  2599    492        48  206933.250
2       Formula   852    777        65  155742.002
3         Hmisc   954    812        69 1367675.911
4          LPCM  2335     17        10  526814.226
5          MASS   834    698        66  981152.179
6        Matrix   932    801        66 3220134.165
7  RColorBrewer  1890   1584        79   22763.995
8         RCurl  1504   1207        73 1903505.324
9         RJDBC   809    107        28   18715.441
10      RJSONIO   751    585        60 1208103.992
11       RMySQL   862     98        21  212832.918
12         Rcpp  3195   2044        84 2512100.355
13      SparseM  1167    454        60  674890.722
14          VIF   697     37        12 2344226.571
15          XML  1022    770        62 2927022.407
16       bitops  1549   1408        76   28715.046
17      caTools   812    699        64  176589.018
18          car  1008    837        64 1229122.307
19   colorspace  1683   1433        80  357411.197
20   data.table   680    564        59 1252721.215
21     devtools   769    560        55  212932.640
22    dichromat  1486   1257        74  134731.938
23       digest  2210   1894        83  120549.294
24       doSNOW   740     75        24    8363.755
25     evaluate  1095    998        73   35139.161
26      foreach  1984    485        53  358069.782
27      formatR   815    709        65   43311.099
28      ggplot2  4602   1680        81 2427716.054
29       gplots   708    645        65  519971.459
30       gtable  1466   1255        75   55137.990
31       gtools   875    793        62  109778.034
32        highr   807    709        64   27969.524
33    htmltools   762    656        55   65717.295
34         httr  1195   1015        68  293879.626
35    iterators  1887    462        53  294757.526
36        knitr  1037    885        70  946708.266
37     labeling  1502   1270        75   34739.487
38 latticeExtra   887    791        69 1909937.068
39         lme4   938    756        68 3921084.377
40     markdown   939    809        66  138671.633
41         mgcv  1122   1006        72 1674032.285
42         mime   886    780        65   15268.103
43      munsell  1514   1276        75  119432.542
44      mvtnorm   841    729        64  203047.132
45       nloptr   756    682        63  754357.567
46         plyr  2908   1754        81  799122.790
47        proto  1500   1281        76  469796.779
48     quantreg  1098    388        54 1733616.958
49        rJava  2773    963        70  633522.348
50     reshape2  2032   1652        76  330128.263
51          rgl   786    655        70 2543589.210
52       scales  1726   1408        77  126819.331
53        shiny   713    455        50 1212965.833
54         snow   809    134        30   28989.546
55      stringr  2267   1948        82   65277.166
56        swirl   820    698        66   95868.696
57     testthat   818    755        64  188230.345
58         xlsx   798    578        59  380129.548
59       xtable   751    611        54  376072.182
60         yaml  1062    982        72  161006.309
61          zoo  1245   1073        63  857691.878
```

arrange() the rows of top_counts based on the 'count' column. We want the packages with the highest number of downloads at the top, which means we want 'count' to be in descending order.

```sh
arrange( top_counts, desc(count)

```

Find the 0.99, or 99%, quantile for the 'unique' variable with quantile(pack_sum$unique, probs = 0.99).

```sh
quantile(pack_sum$unique, probs = 0.99)
99% 
465 

```
Apply filter() to pack_sum to select all rows corresponding to values of 'unique' that are strictly greater than 465. Assign the result to a variable called top_unique.
```sh
top_unique <- filter( pack_sum,  unique > 465)
 top_unique
Source: local data frame [60 x 5]

        package count unique countries  avg_bytes
1           DBI  2599    492        48  206933.25
2       Formula   852    777        65  155742.00
3         Hmisc   954    812        69 1367675.91
4          MASS   834    698        66  981152.18
5        Matrix   932    801        66 3220134.17
6  RColorBrewer  1890   1584        79   22763.99
7         RCurl  1504   1207        73 1903505.32
8       RJSONIO   751    585        60 1208103.99
9          Rcpp  3195   2044        84 2512100.35
10    RcppEigen   546    474        52 2032426.11
11          XML  1022    770        62 2927022.41
12       bitops  1549   1408        76   28715.05
13      caTools   812    699        64  176589.02
14          car  1008    837        64 1229122.31
15   colorspace  1683   1433        80  357411.20
16   data.table   680    564        59 1252721.21
17     devtools   769    560        55  212932.64
18    dichromat  1486   1257        74  134731.94
19       digest  2210   1894        83  120549.29
20        e1071   562    482        61  743153.75
21     evaluate  1095    998        73   35139.16
22      foreach  1984    485        53  358069.78
23      formatR   815    709        65   43311.10
24        gdata   673    619        57  800502.47
25      ggplot2  4602   1680        81 2427716.05
26       gplots   708    645        65  519971.46
27       gtable  1466   1255        75   55137.99
28       gtools   875    793        62  109778.03
29        highr   807    709        64   27969.52
30    htmltools   762    656        55   65717.30
31         httr  1195   1015        68  293879.63
32        knitr  1037    885        70  946708.27
33     labeling  1502   1270        75   34739.49
34      lattice   627    523        56  642181.03
35 latticeExtra   887    791        69 1909937.07
36         lme4   938    756        68 3921084.38
37     markdown   939    809        66  138671.63
38      memoise   678    600        59   14023.51
39         mgcv  1122   1006        72 1674032.29
40         mime   886    780        65   15268.10
41      munsell  1514   1276        75  119432.54
42      mvtnorm   841    729        64  203047.13
43       nloptr   756    682        63  754357.57
44         plyr  2908   1754        81  799122.79
45        proto  1500   1281        76  469796.78
46        rJava  2773    963        70  633522.35
47      reshape   611    522        52  111337.99
48     reshape2  2032   1652        76  330128.26
49          rgl   786    655        70 2543589.21
50     sandwich   597    507        56  491268.38
51       scales  1726   1408        77  126819.33
52           sp   559    470        54 1410246.55
53      stringr  2267   1948        82   65277.17
54        swirl   820    698        66   95868.70
55     testthat   818    755        64  188230.34
56         xlsx   798    578        59  380129.55
57     xlsxjars   665    527        58 9214537.15
58       xtable   751    611        54  376072.18
59         yaml  1062    982        72  161006.31
60          zoo  1245   1073        63  857691.88

arrange( top_unique, desc(unique)

```



