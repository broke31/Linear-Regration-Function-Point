# Linear-Regression-Function-Point

## Dataset

Dataset number contains 499 observations regarding the measurement of function points. 
Inside the dataset there are null values, so before carrying out the statistical study it was considered appropriate to replace the null values with the whole part of the average of the variable represented by the column.
As dependent variable the Effort was taken into consideration, while as independent variables Input, Output, Enquiry, File, Interface were taken into consideration.

## Shapiro Test
The first step was to perform the Shapiro Test to verify the normality of the sample. 
|         | Input           | Output  | Enquiry | File    | Interface | Effort  |
|---------|-----------------|---------|---------|---------|-----------|---------|
| W       | 0.25009         | 0.49987 | 0.58299 | 0.38801 | 0.22723   | 0.54687 |
| P-VALUE |  2.2e-16        | 2.2e-16 | 2.2e-16 | 2.2e-16 | 2.2e-16   | 2.2e-16 |

The P-Value below 0.05 shall be taken into account as the waste threshold value.
Since for each variable the P-Value is lower than the threshold value then the null hypothesis was rejected, so the data do not have a normal distribution. 
Since it is not possible to apply linear regression to this data, the values of the dataset were normalized by applying the logarithmic function. This technique makes it possible to transform the large values into smaller values and consequently try to approximate the data better in order to get closer to a normal distribution.
After transforming the data into logarithm, the Shapiro function shows the following outputs:

|         | Input           | Output    | Enquiry  | File      | Interface | Effort  |
|---------|-----------------|-----------|----------|-----------|-----------|---------|
| W       | 0.9946          | 0.98543   | 0.97308  | 0.97509   | 0.854     | 0.99662 |
| P-VALUE | 0.07615         | 6.769e-05 | 6.05e-08 | 1.652e-07 | 2.2e-16   | 0.38    |

The application of the logarithmic function has allowed the null hypothesis to be accepted for the Input and Effort variables, while for the Output, Enquiry,File and Interface variables the null hypothesis cannot be accepted. Representing the data with histograms, you can see the non-normal trend of variables whose p-value is <0.05.

## Descriptive statistics normalized data
|           | Observations | Min    | Max     | AVG   | Median  |  Standard Dev. | First Quartile | Third Quartile |
|-----------|--------------|--------|---------|-------|---------|---------------|----------------|----------------|
| Input     | 499          | 1.099  | 9.149   | 4.331 | 4.304   | 1.2244889     | 3.418          | 5.118          |
| Output    | 499          | 1.386  | 7.806   | 4.049 | 4.190   | 1.2790467     | 3.135          | 4.727          |
| Enquiry   | 499          | 1.099  | 6.859   | 3.612 | 3.871   | 1.2078997     | 2.803          | 4.227          |
| File      | 499          | 1.946  | 7.991   | 3.995 | 4.094   | 1.0888870     | 3.219          | 4.511          |
| Interface | 499          | 1.609  | 7.360   | 3.138 | 3.178   | 0.8127342     | 2.996          | 3.178          |
| Effort    | 499          | 3.258  | 10.908  | 7.485 | 7.512   | 1.2570150     | 6.556          | 8.250          |

## Linearity check
The Pearson correlation coefficient has been performed to see the linearity between the various variables.
The Pearson correlation coefficient (r) is a value that oscillates in the range [-1;1]. If r tends to -1 then the two variables are negatively correlated; if r tends to 1 then the two variables are positively correlated; if r tends to 0 it means that there is no linear correlation between the variables.

|                    | Correlation  (r)   |
|--------------------|--------------------|
| Effort - Input     | 0.490852039392373  |
| Effort - Output    | 0.420487600587818) |
| Effort - Enquiry   | 0.393465685143137  |
| Effort - File      | 0.453505381512598  |
| Effort - Interface | 0.236721426477299  |

From the table you can see that the indices are always above 0 and therefore there is a positive correlation between the variables.

## Homoschedasticity
The second hypothesis that must be verified is that of homoschedasticity, i.e. there must be constant variance between all the errors observed. To verify the homoschedasticity, the BP Test has been applied, choosing as null hypothesis the absence of homoschedasticity.

|                    | BP      | P - Value |
|--------------------|---------|-----------|
| Effort - Input     | 0.22057 | 0.6386    |
| Effort - Output    | 0.24991 | 0.6171    |
| Effort - Enquiry   | 2.2435  | 0.1342    |
| Effort - File      | 2.9049  | 0.08831   |
| Effort - Interface | 2.9418  | 0.08631   |


In all cases the P - Value exceeds 0.05, so the null hypothesis cannot be rejected.
The GVLMA function is then applied with the following output:
Call:
 gvlma(x = fm)

|                         |Value  |  p-value| Decision                      |
|-------------------------|-------|---------|-------------------------------|
|Global Stat              |13.2730| 0.010016|Assumptions NOT satisfied!     |
|Skewness                 |5.4206 | 0.019901|Assumptions NOT satisfied!     |
|Kurtosis                 |0.3467 | 0.555977|Assumptions acceptable.        |
|Link Function            |6.8521 | 0.008854|Assumptions NOT satisfied!     |
|Heteroscedasticity       |0.6536 | 0.418830|Assumptions acceptable.        |

From the GVLMA test we obtain that homoschedasticity cannot be accepted.
## Prediction model
Multiple linear regression is used to show a possible relationship between a dependent variable and one or more independent variables.
We use the multiple regression model to provide a form prediction model:
```y = b1 x1 + b2 x2 +...+bn xn +eps```
This procedure therefore allows us to identify which are the independent variables that best explain the dependent variable (not always all are necessary). 

## Multivariate linear regression
The stepwise method was used to construct the multivariate linear regression model. This method outputs all the independent variables that best explain the model. In some cases the stepwise method could also add independent variables, but they only slightly improve the model, so it is always preferable to do a manual check to see if the changes are actually significant.
 
Below is shown in tabular form the output of the stepwise and the "summary" function present by default in R.

|               | Intercept  | Input   | Output  | Enquiry  | File    | Interface |
|---------------|------------|---------|---------|----------|---------|-----------|
| R2            |  0.3287             |
| T - Value     | 16.201     |  4.199  | 4.170   | 3.112    | 3.230   | 3.044     |
| Estimate      | 3.99592    | 0.22208 | 0.17759 |  0.14549 | 0.18019 | 0.17932   |
| F - Statistic | 49.76              |
| P - Value     | < 2.2e-16         |


Several indicators need to be analysed in order to assess the model.
The first indicator that needs to be seen is that of R2 (which corresponds to the square of the correlation coefficient r); this index should be very close to 1 to obtain a good prediction model. In this case R2 is 0.32, which means that the model is not able to explain the data well.

The other indicators that we can use to evaluate the goodness of the model are: F - Statistic where we can go to verify the confidence level of the forecasts and T - Value where we go to see the significance of the independent variables, in particular the F-Statistic value must be as high as possible and the T Value greater than 1.5 to consider that particular independent variable significant in the construction of the model. In the case in question we have a very high F - Statistic (49.76), moreover the T - Value is greater than 1.5 for all the independent variables, this means that all the independent variables are necessary for the construction of the model.
The P - Value less than 0.05 indicates that we can reject the null hypothesis, the variable is a good predictor with an accuracy of 95%.
The equation of the regression model is therefore given by:
effort = 0.22208 * Input + 0.17759 * Output + 0.14549 * Enquiry + 0.18019 * File + 0.17932* Interface + 3.99592
