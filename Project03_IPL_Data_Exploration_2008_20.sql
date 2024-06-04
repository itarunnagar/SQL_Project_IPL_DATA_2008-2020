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


--5000 Runs Club 
select *
from (select batsman , sum(batsman_runs) as Runs_Scored 
from Dataset_02
group by batsman) A
where Runs_Scored >= 5000
order by Runs_Scored desc ; 
 

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
group by Teams 
order by Total_matches_PLyaed desc;


--Total Numbers of Matches PLayed Per Year by Each Team ..By using CTE
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

--Total Numbers of Matches PLayed Per Year by per team..By using SubQueries
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
select Years , sum(Number_of_Matches) as Numbers_of_MAtches
from(select Years , winner as Teams , count(winner) as Number_of_Matches
from (select * , year(date) as Years 
from Dataset_01) A
group by Years , winner ) A 
group by Years ; 

--Runs Scored In Each Season
select Years , sum(total_runs) as Total_Runs
from (select  b.* , year(date) as Years from Dataset_01 a inner join  dataset_02 b
on a.id = b.id) ABC
group by Years  ;

--Runs Scroed in Per Match in Differeent Season
select Years , id , inning , sum(total_runs) as Runs_Per_Match
from (select b.* , year(date) as Years from Dataset_01 a inner join dataset_02 b on a.id = b.id) A
group by Years , inning , id
order by id ;

--Who Has Umpired the Most
WitH ABC as (
select umpire1  as Umpire_NAme, COUNT(umpire1) as Numbers_of_Time_Present
from Dataset_01
group by umpire1 
union all
select umpire2 , COUNT(umpire2) as Numbers_of_Time_Present
from Dataset_01
group by umpire2 )
select Umpire_NAme , sum(Numbers_of_Time_Present) as Numbers_of_Time_Present , 
DENSE_RANK() over(order by sum(Numbers_of_Time_Present) desc) as Rnks 
from ABC 
group by Umpire_NAme ;


--Which Team has won the most Tosses.
select toss_winner , count(toss_winner) as Numbers_of_Times_Wins , 
DENSE_RANK() over(order by count(toss_winner) desc)as Rnks
from Dataset_01
group by toss_winner; 


--What the team decide after winning the toss.
select toss_winner , toss_decision , 
count(toss_decision) as Numbers_of_Decision
from Dataset_01
group by toss_winner , toss_decision 
order by toss_winner ; 

--How many times chasing team win the match..
select Numbers_of_Wins , sum(Numbers_of_Wins) as Total_Wins_By_Chasing_teams
from (select a.id , bowling_team , winner , 
case when bowling_team = winner then 1
else 0
end as Numbers_of_Wins
from Dataset_01 a join Dataset_02 b 
on a.id = b.id 
where b.inning = 1 
group by a.id , bowling_team , winner) ABCD
group by Numbers_of_Wins ;

--Which Team Has The Highest Winnign PErcantage 
select winner , count(winner) as Numbers_of_times_Wins , DENSE_RANK() over(order by count(winner) desc) rnks
from Dataset_01 group by winner;  

--Is there any lucky venue for particular team.
--All The Lucky Where Team Matches Wins High Numbers..
select *
from (select Venue ,  Winner , count(winner) as Numbers_of_times_Wins , 
DENSE_RANK() over(partition by winner order by count(winner) desc) Rnks
from Dataset_01 
group by venue ,  winner ) ABC
where rnks = 1 ;


--Which Team HAs Scored The MOst Numbers of 200+ Scores..
select batting_team , count(batting_team) as NUmmbers_of_time_Above_200
from (select  id , inning ,batting_team ,  sum(total_runs) as Runs_Per_Match
from (select b.* , year(date) as Years from Dataset_01 a inner join dataset_02 b on a.id = b.id) A
group by  inning , id , batting_team) ABC
where Runs_Per_Match >= 200 
group by batting_team
order by NUmmbers_of_time_Above_200 desc ;


--Which Team HAs Conceeded 200+ Scores The Most.
select *
from (select * , DENSE_RANK() over(order by NUmmbers_of_time_Above_200 desc) Rnks
from (select batting_team , count(batting_team) as NUmmbers_of_time_Above_200
from (select  id , inning ,batting_team ,  sum(total_runs) as Runs_Per_Match
from (select b.* , year(date) as Years from Dataset_01 a inner join dataset_02 b on a.id = b.id) A
group by  inning , id , batting_team) ABC
where Runs_Per_Match >= 200 
group by batting_team) ABCDE ) DEF
where Rnks <= 5 ;


-- Highest Runs Scored By Any Team In Any Single Match 
select *
from (select id , inning , batting_team , sum(total_runs) as Total_Runs , DENSE_RANK() over(order by sum(total_runs) desc) as Rnks
from Dataset_02 
group by id , inning , batting_team) ABC
where Rnks = 1 ;


-- Highest Top 10 Runs Scored By Any Team In Any Single Match 
select *
from (select id , inning , batting_team , sum(total_runs) as Total_Runs , DENSE_RANK() over(order by sum(total_runs) desc) as Rnks
from Dataset_02 
group by id , inning , batting_team) ABC
where Rnks <= 10 ;

--Bigggest Win In Term of Runs MArgin
select *
from (select *, DENSE_RANK() over(order by result_margin desc) as Rnks
from Dataset_01 ) ABC
where rnks = 1 ;


-- Which Batsman Have played the most numbers of balls
select batsman ,count(bowler) as Numbers_of_Bowls , 
dense_rank() over(order by count(bowler) desc) as Rnks
from Dataset_02
group by batsman ; 


--Who are the leading runs scorer of all time 
select batsman , sum(batsman_runs) as Total_Runs_By_BAtsman , 
DENSE_RANK() over(order by sum(batsman_runs) desc) as Rnks
from Dataset_02
group by batsman ; 


--Leading Wicket Taker
select bowler , sum(is_wicket) as Numbers_of_Wicket_Taken , DENSE_RANK() over(order by sum(is_wicket) desc)
from Dataset_02
group by bowler ; 

--Which Stadium Has HOsted the Most Numbers of MAtches
select venue , count(distinct id) as Numbers_of_Matches , 
DENSE_RANK() over(order by count(distinct id)desc) as Rnks
from Dataset_01 
group by venue ;  


--Who Has won the  Most MOM Awards
select player_of_match , count(player_of_match) as Numbers_of_MOM , DENSE_RANK() over(order by count(player_of_match) desc) as Rnks
from Dataset_01
group by player_of_match ; 


--Count Hit of 4s In Each Season
select  years , count(years) as Numbers_of_4S 
from (select a.id , year(a.date) as Years 
from Dataset_01 a inner join Dataset_02 b
on a.id = b.id
where b.batsman_runs = 4 ) GHI 
group by years
order by years ;  

--COunt Hit of 6s In Each Season
select  years , count(years) as Numbers_of_Sixes 
from (select a.id , year(a.date) as Years 
from Dataset_01 a inner join Dataset_02 b
on a.id = b.id
where b.batsman_runs = 6 ) GHI 
group by years
order by years ; 

--Count 0f Runs Scored From Boundaries in each season average and Total Runs.
select Years , sum(total_runs) as Total_Runs_By_4s_6s
from (select a.id , a.batsman , a.batsman_runs , a.total_runs , year(date) as Years
from Dataset_02 a inner join Dataset_01 b
on a.id = b.id
where total_runs = 6 or total_runs = 4   ) ABC
group by Years ;


--Runs in PowerPLay of  Each Team    
select batting_team , sum(total_runs) as Total_Runs_Made_In_POwerPLay
from Dataset_02  a inner join Dataset_01 b
on a.id = b.id 
where overs >= 1 and overs <= 6
group by a.batting_team 
order by Total_Runs_Made_In_POwerPLay desc ;

--Total Numbers of Matches..
select count(distinct id) from Dataset_01 ;


--PowerPlay AVerage Runs
select round((Total_Runs_In_PowerPLay/Total_Matches_Played),0) as Average_Runs
from (select sum(total_runs) as Total_Runs_In_PowerPLay , 
(select count(distinct id) from Dataset_01) as Total_Matches_Played
from Dataset_02 
where overs >= 1 and overs <= 6 ) ABC ;


--Total Wicket in PowerPLay..
select Bowler , sum(is_wicket) as Total_Numbers_of_Wickets
from Dataset_02 
where overs >= 1 and overs <= 6
group by bowler 
order by Total_Numbers_of_Wickets desc ;
 

--Numbers of Fileder Who Cuaght Catch Times or Any Things That Lead to Wicket..
select fielder ,count(fielder) as Times 
from Dataset_02 
where fielder  not in ('NA')
group by fielder
order by Times desc ; 


--Top 10 batsman in runs category
select *
from (select batsman , sum(total_runs) as Runs_Make_By_Batsman , 
DENSE_RANK() over(order by sum(total_runs) desc) as Rnks
from Dataset_02
group by batsman ) ABC
where Rnks <= 10 ; 


--Top 10 Batsman Overall 
select *
from (select a.Batsman , B.fielder , Helps_To_Wickets , Total_Runs , 
DENSE_RANK() over(order by Total_Runs desc, Helps_To_Wickets desc ) as Rnks
from (select batsman , sum(total_runs) as Total_Runs
from Dataset_02 
group by batsman ) A full outer join (select fielder ,count(fielder) as Helps_To_Wickets from Dataset_02 where fielder  not in ('NA')
group by fielder ) B 
on b.fielder = a.batsman ) ABC
where rnks <= 10 ;


--Orange Cap Holder -- Means The Highest Runs Scorer in Every Season  
select * 
from(select Years , batsman , sum(batsman_runs) as Total_Runs_By_Batsman, 
DENSE_RANK() over(partition by Years order by sum(batsman_runs) desc) as Rnks
from (select b.id ,b.batsman , b.batsman_runs ,year(date) as Years 
from Dataset_01 a inner join Dataset_02 b 
on a.id = b.id ) ABC 
group by Years , batsman) CDE
where rnks = 1 ;

--Purple Cap Holders
select years , bowler , Total_NUmbers_Of_Wicket
from (select years ,  bowler ,sum(is_wicket) as Total_NUmbers_Of_Wicket , 
DENSE_RANK() over(partition by years  order by sum(is_wicket)desc) as Rnks
from (select bowler , is_wicket  , year(date) as Years 
from Dataset_02  a join Dataset_01 b 
on a.id = b.id) ABC
group by Years , bowler) GHI
where Rnks = 1  ; 


--Best Bowler In Each Category
select bowler , sum(is_wicket) as Numbers_of_Wickets , sum(total_runs) as Runs
from Dataset_02 
group by bowler
order by Numbers_of_Wickets desc , Runs asc; 


--Top  Bowlers
select *
from (select bowler , sum(is_wicket) as Numbers_of_Wickets , sum(total_runs) as Runs , 
DENSE_RANK() over(order by sum(is_wicket) desc , sum(total_runs) asc) as Rnks
from Dataset_02 
group by bowler ) Gi
where Rnks <= 10 ;


--Which Team has scored the most runs inlast 4 overs ?
select batting_team , sum(total_runs) as Total_Runs ,
DENSE_RANK() over(order by sum(total_runs) desc) as Rnks
from Dataset_02 
where overs >= 16 and overs <= 20
group by batting_team ; 


--Which Team win Title Year Wise
select Years , winner
from (select * , DENSE_RANK() over(partition by Years order by date desc) as Rnks
from ( select b.id , Inning,  a.date, a.venue , team1 , team2 , winner , batsman , batsman_runs , total_runs , batting_team ,bowling_team
,is_wicket, year(date) as Years 
from Dataset_01 a inner join Dataset_02 b
on a.id =  b.id ) ABC )GHi
where Rnks = 1 
group by Years , winner
order by Years ; 


--Which Team win Highest Numbers of Season 
select winner , count(winner) as Number_of_Times_Wins
from (select Years , winner
from (select * , DENSE_RANK() over(partition by Years order by date desc) as Rnks
from ( select b.id , Inning,  a.date, a.venue , team1 , team2 , winner , batsman , batsman_runs , total_runs , batting_team ,bowling_team
,is_wicket, year(date) as Years 
from Dataset_01 a inner join Dataset_02 b
on a.id =  b.id ) ABC )GHi
where Rnks = 1 
group by Years , winner) GHIR
group  by winner 
order by Number_of_Times_Wins desc;

--Most Title Wins.
select *
from (select winner , count(winner) as Number_of_Times_Wins , DENSE_RANK() over(order by count(winner) desc) Rnks
from (select Years , winner
from (select * , DENSE_RANK() over(partition by Years order by date desc) as Rnks
from ( select b.id , Inning,  a.date, a.venue , team1 , team2 , winner , batsman , batsman_runs , total_runs , batting_team ,bowling_team
,is_wicket, year(date) as Years 
from Dataset_01 a inner join Dataset_02 b
on a.id =  b.id ) ABC )GHi
where Rnks = 1 
group by Years , winner) GHIR
group  by winner ) GHID
where rnks <= 3 ; 

