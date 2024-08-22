---
title: Payroll Analysis Dashboard
hide_title: true
queries:
  - agg_all: agg_all.sql
  - agg_all_monthly: agg_all_monthly.sql
  - agg_branch_all: agg_branch_all.sql
  - agg_employee_all: agg_employee_all.sql
  - agg_employee_personal: agg_employee_personal.sql
sources:
  - agg_branch_monthly: payroll/agg_branch_monthly.sql
  - agg_employee_all: payroll/agg_employee_personal.sql
  - agg_employee_monthly: payroll/agg_employee_monthly.sql
---

# Company Overview
This report shows the overview of payroll scheme for our company.

<center>
<Grid cols=3>
<BigValue
  data={agg_all}
  value=total_branch
  title="Total Branch"
/>
<BigValue
  data={agg_all}
  value=total_headcount
  title="Total Employees"
/>
<BigValue
  data={agg_all}
  value=total_salary_paid
  title="Total Paid salary"
  fmt='"Rp" #,##0.00,,," Bn"'
/>
</Grid>
</center>


<Details title='Show Charts'>

 
  <LineChart
    data={agg_all_monthly}
    x=year_month
    y=avg_daily_work_hours
    title="Average Daily Work Hours"
  />

  <LineChart
    data={agg_all_monthly}
    x=year_month
    y=avg_salary_per_hour
    yFmt='#,##0.00," k"'
    title="Average Salary per Hour"
  />
  
From the charts above we can have some insights such as:

  1. Both charts show a period of stability during 2020. While work hours remained stable around 8 hours per day, the average salary per hour remained very low, indicating that the cost per hour of work was kept consistently low.
  2. At the end of 2020, there’s a slight increase in average daily work hours, and a more pronounced spike in average salary per hour. This could indicate a late-year adjustment, possibly due to end-of-year bonuses, overtime, or adjustments in payroll practices.
  3. The significant drop in the average salary per hour right after the initial period will be worth investigating. One hypotheses is that there are several peoples who worked far from the minimum required working hours that still got paid


</Details>

---

## Output KPI's

<Details title="Why these analysis?">

Dividing the payroll scheme analysis into branch-wise and personal/employee-wise categories can provide a comprehensive and multi-faceted understanding of how resources are utilized and how compensation impacts both individual employees and the organization as a whole:

  1. **Branch Analysis**: Analyzing payroll at the branch level allows us to see how resources are allocated across different branches
  2. **Employee Analysis**: Analyzing payroll on a personal level allows you to assess whether employees are being compensated fairly in relation to their contributions

</Details>

### Branch Analysis

<Dropdown
  title="Select a KPI"
  name=dropdown_branch_all
  defaultValue = "b_total_headcount"
>
  <DropdownOption valueLabel="Number of Employees" value="b_total_headcount"/>
  <DropdownOption valueLabel="Average Daily Working Hours" value="b_avg_daily_workhour"/>
  <DropdownOption valueLabel="Average Hourly Salary" value="b_avg_salary_hour"/>
</Dropdown>

```sql top5branch
select
  'Branch ' || branch_id::int as branch_name,
  ${inputs.dropdown_branch_all.value}
from ${agg_branch_all}
order by ${inputs.dropdown_branch_all.value} desc
limit 5
```
```sql bot5branch
select
  'Branch ' || branch_id::int as branch_name,
  ${inputs.dropdown_branch_all.value}
from ${agg_branch_all}
order by ${inputs.dropdown_branch_all.value} asc
limit 5
```

<center>
<Grid cols=2>
<BarChart
  data={top5branch}
  x=branch_name
  y={inputs.dropdown_branch_all.value}
  swapXY=true
  title='Top 5 Branch with Highest {inputs.dropdown_branch_all.label}'
/>
<BarChart
  data={bot5branch}
  x=branch_name
  y={inputs.dropdown_branch_all.value}
  swapXY=true
  sort = false
  title='Top 5 Branch with Lowest {inputs.dropdown_branch_all.label}'
/>
</Grid>
</center>

### Employee Analysis

<center>
<Grid cols=3>
<BigValue
  data={agg_employee_all}
  value=avg_tenure
  title="Average Tenure"
/>
<BigValue
  data={agg_employee_all}
  value=avg_workhours_ratio
  title="Average Working Hours Ratio"
/>
<BigValue
  data={agg_employee_all}
  value=avg_salary_per_hour
  title="Average Hourly Salary"
  fmt='"Rp" #,##0.00," k"'
/>
</Grid>
</center>

<center>
<ScatterPlot
  data={agg_employee_personal}
  x=e_workhours_ratio
  y=e_hourly_salary
  series=is_resigned
  xAxisTitle='Working Hours Ratio'
  yAxisTitle='Average Salary per Hour'
/>
</center>

<Details title="What is Working Hours Ratio?">

Working hours ratio can be defined as how much the actual working hours done by employees compared to *ideal* working hours. The *ideal working hours* itself derived from the standard of average working days during the employees' working period. This metric is taken to measure employees compliance and actual productivity. From the *scatter plot* above we can see that:

  1. Majority compliance: Majority of employees are located around 1.00, means that their working hours are as expected
  2. Extreme Outlierss: There is an employee that is almost not working at all, stated by working hours ratio is around 0.06 eventhough having the highest average hourly salary. This finding should be investigated further to find the possible causation of this anomaly.

</Details>

