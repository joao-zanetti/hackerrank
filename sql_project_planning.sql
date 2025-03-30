with lead_lag_dates_projects as (
    SELECT *,
    LEAD(start_date) OVER(ORDER BY start_date) as lead_start_date,
    LAG(end_date) OVER(ORDER BY end_date) as lag_end_date
    FROM Projects
),

dif_between_tasks as (
    SELECT
        CASE 
            WHEN lag_end_date is null or lag_end_date <>  start_date THEN 1
            ELSE 0
        END AS type_task,
    * 
    from lead_lag_dates_projects
),

grouped_tasks as (
    select 
        SUM(type_task) OVER(ORDER BY end_DATE) as sum_group,
        *
        from dif_between_tasks)
        
select MIN(START_DATE) as Start_date, MAX(end_DATE) as end_DATE
from grouped_tasks
group by sum_group
ORDER BY DATEDIFF(DAY, MIN(start_date), MAX(end_date)) ASC, MIN(start_date);
