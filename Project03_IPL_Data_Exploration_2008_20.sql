--Pending Questions..
-- 1..Highest Strike Rate.
--2...Does Toss Winning Affect the Match Winner 
--Toss/Win Ratio.
select a.toss_winner , a.Numbers_of_times_Wins_Toss , b.Numbers_of_times_MAtches_Wins ,
(a.Numbers_of_times_Wins_Toss / b.Numbers_of_times_MAtches_Wins) * 100 Percantage
from (select toss_winner , count(toss_winner) as Numbers_of_times_Wins_Toss
from Dataset_01 
group by toss_winner) a join (select winner , count(winner) as Numbers_of_times_MAtches_Wins
from Dataset_01 
group by winner) b 
on a.toss_winner = b.winner ; 
--Most Title Wins.

--USe the Database...
use Project03_IPL_Data_Exploration_2008_20 ; 

--See the DataBAse .....
select * from dataset_01 ;
select * from dataset_02 ;

-- Count the Numbers of Rows
select count(*)  as Numbers_of_ROws from Dataset_01 ; 
select count(*) as Numbers_of_ROws from Dataset_02 ;

--If there is Large Amount of Dataset Then we can break that dataset and make new tables and then decide the column
-- and in the insert value we can  join all that table we are dividing so it will make our dataset same...


--Question Practise of Different types Of Questions...
 --Numbers of Matches Per Season...
select Years , count(distinct id) as Matches_Per_Season
from ( select * , year(date) as Years
from  Dataset_01 ) A  
group by Years 
order by Matches_Per_Season desc;

--Most Player of Match...
select player_of_match , count(player_of_match) as Most_Player_of_Match
from Dataset_01 
group by player_of_match 
order by Most_Player_of_Match desc ;

--Top 10 Most Player of Match...
select * 
from (select * , DENSE_RANK() over(order by Most_Player_of_Match desc) as Rnks
from (select player_of_match , count(player_of_match) as Most_Player_of_Match
from Dataset_01 
group by player_of_match ) ABC )CDE 
where Rnks <  11 ;  


--Top Most Player of Match Per Season or Year
select Yearss , player_of_match , count(player_of_match) as Counts , 
DENSE_RANK() over(partition by Yearss order by count(player_of_match) desc) Rnks
from  (select * , year(date) as Yearss
from Dataset_01 ) A 
group by  Yearss , player_of_match ;

--Top PLayer Per YEars..
select *
from (select Yearss , player_of_match , count(player_of_match) as Counts , 
DENSE_RANK() over(partition by Yearss order by count(player_of_match) desc) Rnks
from  (select * , year(date) as Yearss
from Dataset_01 ) A 
group by  Yearss , player_of_match ) ABC 
where Rnks = 1 ; 


--Most Win By Any Team..
select * , DENSE_RANK() over(order by Numbers_of_Times_Wins desc) as Rnks
from (select winner , count(winner) as Numbers_of_Times_Wins 
from Dataset_01
group by winner ) ABC ;

--Top Venue Where MAtch Played
select venue , count(venue) as Numbers_of_match_PLayed , DENSE_RANK() over(order by count(venue) desc) as Rnkss
from Dataset_01
group by venue ; 

--Top  10 Venue Where MAtch Played
select *
from (select venue , count(venue) as Numbers_of_match_PLayed , DENSE_RANK() over(order by count(venue) desc) as Rnkss
from Dataset_01
group by venue) A 
where Rnkss < 11 ; 

--Most  Runs By Any Batsman..
select batsman , sum(batsman_runs)  as Total_Runs_By_Batsman ,DENSE_RANK() over(order by sum(batsman_runs) desc) as Rnks
from Dataset_02
group by batsman ; 

--Total Runs Score In IPL
select sum(total_runs) as Total_Runs from Dataset_02 ;

--% of Total Runs Scored By Each Batsman ..
select * , round((Runs_Scored_By_Batsman/Total_Runs) * 100 , 2) Percant_Run_Done
from (select batsman ,(select sum(total_runs) as Total_Runs from Dataset_02) as Total_Runs,
sum(total_runs) as Runs_Scored_By_Batsman 
from Dataset_02 
group by batsman) A
where Runs_Scored_By_Batsman > 0
order by Percant_Run_Done desc;


--Most  Sixed By Any Batsman..
select batsman  , COUNT(batsman) as Numbers_of_Sixes , dense_rank() over(order by COUNT(batsman) desc) as Rnks
from Dataset_02 
where batsman_runs = 6
group by batsman ; 

--Top 10 Most  Sixed By Any Batsman..
select *
from (select batsman  , COUNT(batsman) as Numbers_of_Sixes , dense_rank() over(order by COUNT(batsman) desc) as Rnks
from Dataset_02 
where batsman_runs = 6
group by batsman) A 
where Rnks < 11 ; 


--Most Fours..
select *
from (select  batsman  , COUNT(batsman) as Numbers_of_Sixes ,
dense_rank() over(order by COUNT(batsman) desc) as Rnks
from Dataset_02 
where batsman_runs = 4
group by batsman) A 
where Rnks < 11 ;


--3000Runs Club 
select *
from (select batsman , sum(batsman_runs) as Runs_Scored 
from Dataset_02
group by batsman) A
where Runs_Scored >= 3000 ; 
 

--Total Numbers of  Matches Till 2020
select count(*) as Numbers_of_matches
from (select * , year(date) as Dtes from Dataset_01) A
where Dtes <= 2020 ;


--Total Numbers  of Matches Win by Each Teams.
select winner , count(winner) as Numbers_of_Wins
from Dataset_01 
group by winner
order by Numbers_of_Wins desc ;

--Total Numbers of Matches PLayed By Team... 
With ABC as (
select team1 as Teams , count(team1) as Numbers_of_Matches_PLayed
from Dataset_01 
group by team1  
union all
select team2 , count(team2) as Numbers_of_Matches_PLayed_02
from Dataset_01
group by team2 ) 
select Teams , sum(Numbers_of_Matches_PLayed)  as Total_matches_PLyaed
from ABC 
group by Teams ;


--Total Numbers of Matches PLayed Per Year..By using CTE
With CC as (select Years , team1 as Teams, count(team1) as Numbers_of_matches_played
from (select * , year(date) as  Years
from Dataset_01 ) ABC
group by Years , team1 
union all
select Years , team2 , count(team1) as Numbers_of_matches_played
from (select * , year(date) as  Years
from Dataset_01 ) CDE
group by Years , team2 )
select Years , Teams , sum(Numbers_of_matches_played) as Total_Matches_Played_Per_Year
from CC
group by Years , Teams
order by Years ; 

--Total Numbers of Matches PLayed Per Year..By using SubQueries
select Years , Teams , sum(Numbers_of_matches_played) as Total_Matches_Played_Per_Year
from (select Years , team1 as Teams, count(team1) as Numbers_of_matches_played
from (select * , year(date) as  Years
from Dataset_01 ) ABC
group by Years , team1 
union all
select Years , team2 , count(team1) as Numbers_of_matches_played
from (select * , year(date) as  Years
from Dataset_01 ) CDE
group by Years , team2) DEF
group by Years , Teams
order by Years ; 

--Total Runs Per Season..
select years ,  batting_team ,  sum(total_runs) as Total_Runs_Per_Season
from (select   b.* , year(a.date) as years from Dataset_01 a  inner join Dataset_02 b 
on a.id = b.id ) ABCD 
group by years ,  batting_team 
order by years ;

--Average Score of Each Team Per Season.
select HIK.years , HIK.batting_team , HIK.Total_Runs_Per_Season,
GFG.Total_Matches_Played_Per_Year , 
round((HIK.Total_Runs_Per_Season / GFG.Total_Matches_Played_Per_Year ), 0)as Average_Runs
from (select Years , Teams , sum(Numbers_of_matches_played) as Total_Matches_Played_Per_Year
from (select Years , team1 as Teams, count(team1) as Numbers_of_matches_played
from (select * , year(date) as  Years
from Dataset_01 ) ABC
group by Years , team1 
union all
select Years , team2 , count(team1) as Numbers_of_matches_played
from (select * , year(date) as  Years
from Dataset_01 ) CDE
group by Years , team2) DEF
group by Years , Teams) GFG 
inner join --Join From Here
(select years ,  batting_team ,  sum(total_runs) as Total_Runs_Per_Season
from (select   b.* , year(a.date) as years from Dataset_01 a  inner join Dataset_02 b 
on a.id = b.id ) ABCD 
group by years ,  batting_team) HIK 
on HIK.batting_team = GFG.Teams and HIK.years = GFG.Years; 



--How many time each team scored > 200 .
select batting_team , count(batting_team) as Numbers_of_times
from (select  id , batting_team , sum(total_runs) as Total_Runs
from Dataset_02  
group by id , batting_team ) ABC 
where Total_Runs >= 200 
group by batting_team 
order by Numbers_of_times desc;

--Total Numbers  of Wins By Any Teams
select winner , count(winner) as Total_Wins , DENSE_RANK() over(order by count(winner) desc) as Rnks
from Dataset_01 
group by winner ; 


--TOp 10 Player With Most Runs
select *
from (select batsman , sum(batsman_runs)  as Total_Runs_By_Batsman ,DENSE_RANK() over(order by sum(batsman_runs) desc) as Rnks
from Dataset_02
group by batsman ) ABC
where Rnks <= 10 ; 


--Top 10 Bowlers Till 2020.
select *
from (select bowler as Bowler_name, sum(is_wicket) as Numbers_of_Wicket , 
DENSE_RANK() over(order by sum(is_wicket) desc) as Rnks
from Dataset_02
group by bowler) A
where Rnks <11 ; 


--Top 10 bowling Performance Till 2020..
select bowler , sum(is_wicket) as Total_Wicket_Taken , sum(total_runs) as Total_Runs 
from Dataset_02
group by bowler
order by Total_Wicket_Taken desc , Total_Runs asc ; 

--Count of Matches PLayed in Each Season..
--Runs Scored In Each Season
--Runs Scroed in Per Match in Differeent Season
--Who Has Umpired the Most
--Which Team has won the most Tosses.
--What the team decide after winning the toss.
--How Toss Decision Varies Acroos Season
--Does Winning The Toss Implies winning the games.
--How many times chasing team win the match..
--Which All Team Had Won These Tournaments
--Which Team had played most numbers of Matches
--Which Team Has Won the Most Numbers of Times.
--Which Team Has The Highest Winnign PErcantage 
--Is there any lucky venue for particular team.
-- Comparision Between Two Teams
