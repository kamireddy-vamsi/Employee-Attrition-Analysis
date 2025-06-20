create database project2;
use project2;

Create Table HR_1_Data (
                         Age int,
                         Attrition varchar(50),
                         BusinessTravel varchar(50),
                         DailyRate int,
                         Department varchar(50),
                         DistanceFromHome int,
                         Education int,
                         EducationField varchar(50),
                         EmployeeCount int,
                         EmployeeNumber int,
                         EnvironmentSatisfaction int,
                         Gender varchar(10),
                         HourlyRate int,
                         JobInvolvement int,
                         JobLevel int,
                         JobRole varchar(100),
                         JobSatisfaction int,
                         MaritalStatus varchar(20)
                         );
                         
                         Select * from hr_1_data;

Create Table hr_2_Data( 
                       EmployeeID INT,
					   MonthlyIncome INT,
                       MonthlyRate INT,
					   NumCompaniesWorked INT,
					   Over18 CHAR(1),
                       OverTime VARCHAR(5),
                       PercentSalaryHike INT,
                       PerformanceRating INT,
                       RelationshipSatisfaction INT,
                       StandardHours INT,
                       StockOptionLevel INT,
                       TotalWorkingYears INT,
                       TrainingTimesLastYear INT,
                        WorkLifeBalance INT,
                        YearsAtCompany INT,
                        YearsInCurrentRole INT,
                        YearsSinceLastPromotion INT,
						YearsWithCurrManager INT
                        );
                        
        Select * from hr_2_data;

CREATE TABLE merged_hr_data AS
        Select * from hr_1_data as Hr1
        Join
        hr_2_data as Hr2
        ON
        Hr1.EmployeeNumber=Hr2.EmployeeID;
        
	  Select * From merged_hr_data;
      Desc merged_hr_data;
      
####1.Average Attrition rate for all Departments
     
Select department,
round(avg(attrition="Yes") * 100,2) 
as Avg_Attrition_rate
from merged_hr_data
group by department;

####2.Average Hourly rate of Male Research Scientist

Select round(avg(HourlyRate)) as Avg_Hourly_Rate_of_R_Scientist
from merged_hr_data 
where 
Gender="Male" and
JobRole="Research scientist";

###3.Attrition rate Vs Monthly income stats

Select IncomeRange,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRatePercent,
    COUNT(*) AS TotalEmployees
FROM (
    SELECT
        Attrition,
        CASE
            WHEN MonthlyIncome < 5000 THEN '<5000'
            WHEN MonthlyIncome < 10000 THEN '5000-9999'
            WHEN MonthlyIncome < 15000 THEN '10000-14999'
            WHEN MonthlyIncome < 20000 THEN '15000-19999'
            ELSE '>=20000'
        END AS IncomeRange
    FROM
        merged_hr_data
) AS income_data
GROUP BY
    IncomeRange
ORDER BY
    CASE 
        WHEN IncomeRange = '<5000' THEN 1
        WHEN IncomeRange = '5000-9999' THEN 2
        WHEN IncomeRange = '10000-14999' THEN 3
        WHEN IncomeRange = '15000-19999' THEN 4
        WHEN IncomeRange = '>=20000' THEN 5
        ELSE 6
    END;


###4.Average working years for each Department

Select department,
round(avg(TotalWorkingyears),2) as Avg_wrkng_yrs
from 
merged_hr_data
group by
 department 
order by 
2;

####5.Job Role Vs Work life balance

Select JobRole,
    Case WorkLifeBalance
        When 1 THEN 'Poor'
        When 2 THEN 'Average'
        When 3 THEN 'Good'
        When 4 THEN 'Excellent'
        Else 'Unknown'
    END AS WorkLife_Balance,
    count(*) AS Count
From
    merged_hr_data
Group by 
    JobRole,
    WorkLife_Balance
ORDER BY 
    JobRole, WorkLife_Balance;
  
###6.Attrition rate Vs Year since last promotion relation

Select Case
        When YearsSinceLastPromotion <= 10 THEN '1–10 years'
        When YearsSinceLastPromotion <= 20 THEN '11–20 years'
        When YearsSinceLastPromotion <= 30 THEN '21–30 years'
        Else '>30 years'
    End as  Yr_since_last_Promotion_rltn,
    count(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS AttritionRatePercent
FROM
    merged_hr_data
Group by
    Yr_since_last_Promotion_rltn
Order by
    MIN(YearsSinceLastPromotion);
    
    ###7.Attrition
    
    Select count(*) AS attrition_count
FROM merged_hr_data
WHERE attrition = 'Yes';

    ###8.Attrition Rate 
    
    Select(SUM(attrition = 'Yes') / COUNT(*)) * 100 
    AS Attrition_rate
from merged_hr_data;
    
   ###9.Total Employees
   
    Select COUNT(*) AS total_employees
From Merged_hr_data;

###10.Active Employees

Select
SUM(1) - SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
 AS ActiveEmployees
From
    merged_hr_data;
        