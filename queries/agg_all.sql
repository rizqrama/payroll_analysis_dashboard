select
    sum(e_salary_received) AS total_salary_paid,
	count(distinct employee_id) AS total_headcount,
    count(distinct branch_id) AS total_branch,
    sum(e_work_hours) AS total_work_hours
from payroll2.agg_employee_personal