# 1 Problem 1 : The Number of Seniors and Juniors to Join the Company (https://leetcode.com/problems/the-number-of-seniors-and-juniors-to-join-the-company/)

# Solution
with cte as
(
    select employee_id, experience, sum(salary) over(partition by experience order by salary, employee_id) as running_salary
    from Candidates
)
select 'Senior' as experience, count(employee_id) as accepted_candidates 
from cte
where experience = 'Senior' and running_salary <= 70000
union 
select 'Junior' as experience, count(employee_id) as accepted_candidates 
from cte
where experience = 'Junior' and running_salary <= (
    select 70000 - ifnull(max(running_salary), 0) 
    from cte 
    where experience = 'Senior' and running_salary <= 70000)

# 2 Problem 2 : League Statistics (https://leetcode.com/problems/league-statistics/ )

# Solution
with cte as
(
    select home_team_id as r1 , home_team_goals as g1, away_team_goals as g2
    from Matches 
    union all
    select away_team_id as r1, away_team_goals as g1, home_team_goals as g2
    from Matches 
)
select
t.team_name, 
count(c.r1) as matches_played, 
sum(case 
        when c.g1 > c.g2 then 3
        when c.g1 = c.g2 then 1
        else 0
    end) as points,
sum(c.g1) as goal_for, 
sum(c.g2) as goal_against, 
sum(c.g1) - sum(c.g2) as goal_diff 
from Teams t
join cte c
on t.team_id = c.r1
group by c.r1
order by points desc, goal_diff desc, t.team_name

# 3 Problem 3 : Sales Person (https://leetcode.com/problems/sales-person/ )

# Solution
select name
from SalesPerson
where sales_id not in
(
    select s.sales_id
    from SalesPerson s
    left join Orders o
    on s.sales_id = o.sales_id
    left join Company c
    on c.com_id = o.com_id
    where c.name = 'Red'
)

# 4 Problem 4 : Friend Requests II (https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/ )

# Solution
with cte as
(
    select requester_id as id, count(requester_id) as cnt
    from RequestAccepted
    group by requester_id  
    union all
    select accepter_id as id, count(accepter_id) as cnt
    from RequestAccepted
    group by accepter_id  
)
select id, sum(cnt) as num
from cte
group by id
order by num desc
limit 1