select *, goal_for - goal_against as goal_diff
from (
select T.team_name, sum(home_team_games) as matches_played, sum(home_team_points) as points, sum(home_team_goals) as goal_for, sum(away_team_goals) as goal_against
from (
select 
home_team_id, 
count(home_team_id) as home_team_games,
sum(if ( home_team_goals > away_team_goals, 3, if(home_team_goals = away_team_goals, 1, 0) ) )as home_team_points,
sum(home_team_goals) as home_team_goals,
sum(away_team_goals) as away_team_goals
from Matches M1 
group by 1

union

select 
away_team_id, 
count(away_team_id) as away_team_games,
sum(if ( away_team_goals > home_team_goals, 3, if(home_team_goals = away_team_goals, 1, 0) ) )as away_team_points, 
sum(away_team_goals) as away_team_goals,
sum(home_team_goals) 
from Matches M1 
group by 1
) A
join Teams T 
on A.home_team_id = T.team_id
group by 1) B
order by points desc, goal_diff desc, matches_played asc;
