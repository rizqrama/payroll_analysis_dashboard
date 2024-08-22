with source_table as (
select
    branch_id,
    sum(e_salary_received) as total_salary_paid,
    sum(e_work_hours) as e_total_work_hours,
    (sum(i_work_days)*8) as i_total_work_hours
from
    payroll2.agg_employee_personal
GROUP BY
    branch_id
ORDER BY
    branch_id
)

select
    'Branch ' || branch_id::int as branch_name,
    'Existing Salary per Hour' as salary_type,
    (total_salary_paid / e_total_work_hours) as hourly_salary
from source_table

UNION ALL

select
    'Branch ' || branch_id::int as branch_name,
    'Ideal Salary per Hour' as salary_type,
    (total_salary_paid / i_total_work_hours) as hourly_salary
from source_table
order by branch_name;