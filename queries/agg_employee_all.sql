select
    avg(tenure) as avg_tenure,
    (sum(e_work_days) / sum(i_work_days)) as avg_workdays_ratio,
    (sum(e_work_hours) / (sum(i_work_days)*8)) as avg_workhours_ratio,
    (sum(e_salary_received) / sum(e_work_hours)) as avg_salary_per_hour
from
    payroll.agg_employee_personal;
