# Cash-transfers-and-employability_Brazil
## Standard OLS and dprobit model

### Findings
- Clients of Bolsa Familia, a cash transfer program to the poorest households in Brazil, found jobs in 2011 faster than other poor groups. However, once they start working, only half remain employed after a year compared to two-thirds of other poor groups. 
- Jobs created in Brazil are concentrated in i) low skills, ii) micro and small firms and iii) regions where many beneciaries reside. 
- Thus beneficiaries are not losing their jobs because these disappear, because they are undereducated, due to opportunity costs or lack of job-seeking networks. 
- It is the difference in accumulated experience that is making beneciaries lose their jobs faster. Beneficiaries start accumulating experience later than (poor) non-beneficiaries and are more likely to lose their jobs in a given period.

### Suggestions
- Complementing classroom training with apprenticeships would enable BF recipients to put recently acquired skills into practice and keep their jobs. 
- We recommend to the Ministries of Social Development to provide apprenticeships in micro and small firms to help beneciaries develop skills that firms demand. 

### Methodology
- Stage 1: Investigate the effect of demand, supply and job matching variables on i) `job duration` (which we use as proxy for rate of job loss) and ii) `probability of unemployment`. We used i) a standard OLS regression to identify the variables that explain expected job duration and ii) a probit regression to explain probability of unemployment. Both regression specications will use location (rural or urban), region, and occupation fixed effects.
- Stage 2: Test the following hypotheses in the three major factors affecting higher job loss and unemployment:

**01. Supply**

    (a) BF beneciaries are still severely undereducated and thus less likely to be productive once hired;
    (b) Once employed, female beneciaries (majority of BF beneciaries) tend to lose or quit jobs because of opportunity costs at home (childcare and housekeeping);

**02. Demand**

    (a) Jobs are being created by small, non-productive firms that tend to shut down in a few years;
    (b) Jobs are being destroyed in places with high concentration of BF beneciaries.

**03. Job Matching**

    (a) BF beneciaries are newcomers to job markets, and a good match is unlikely in their first or second job (under this hypothesis, high turnover is not necessarily negative);
    (b) Beneciaries find jobs mostly through informal social networks, and may not seek all vacancies available.
    (c) Firms are having a hard time to fill positions that require some qualication.

### Data
- `job duration`: the number of months through which an individual has been employed in 2011
- `unemployed`: dummy for the unemployment status of an individual in 2011, defined as "not working" and "unoccupied and looking for work" in the past month.

### Visualization

![50/50](https://github.com/quinrod/Cash-transfers-and-employability_Brazil/blob/master/figures/50%20vs%2050.png)

![80/20](https://github.com/quinrod/Cash-transfers-and-employability_Brazil/blob/master/figures/20%20vs%2080.png)

![Experience](https://github.com/quinrod/Cash-transfers-and-employability_Brazil/blob/master/figures/experience.png)


