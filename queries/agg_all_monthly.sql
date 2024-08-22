SELECT
	year_month,
	sum(total_work_hours) as m_total_work_hours,
	sum(total_work_days) as m_total_work_days,
	sum(salary) as m_salary,
	sum(total_work_hours) / sum(total_work_days) as avg_daily_work_hours,
	sum(salary) / sum(total_work_hours) as avg_salary_per_hour 
FROM payroll2.agg_employee_monthly
GROUP by year_month
order by year_month;