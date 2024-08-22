select
    *,
    (b_total_salary_paid / b_total_work_hours) as b_avg_salary_hour,
    (b_total_work_hours / b_total_work_days) as b_avg_daily_workhour
from
    payroll.agg_branch_all