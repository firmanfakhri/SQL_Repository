declare @firstdate date='1990-01-01'
declare @enddate date=getdate()

--select DATEDIFF(day,@firstdate,@enddate)+1
IF OBJECT_ID('tempdb.dbo.#datedim','U') IS NOT NULL
  DROP TABLE #datedim; 

CREATE TABLE #datedim (
	[date] date
)

while (@firstdate <= @enddate)
BEGIN
  INSERT INTO #datedim
  select @firstdate
  set @firstdate=DATEADD(d,1,@firstdate)
END

select 
ROW_NUMBER() OVER(ORDER BY date) AS RowDateID,
date,
year(date) as [year],
DATEPART(quarter,date) quarter,
cast(year(date) as varchar)+
case when DATEPART(quarter,date)=1 then 'Q1'
     when DATEPART(quarter,date)=2 then 'Q2'
	 when DATEPART(quarter,date)=3 then 'Q3'
	 when DATEPART(quarter,date)=4 then 'Q4'
end as [QuarterID],
MONTH(date) as month,
cast(year(date) as varchar)+
case when len(MONTH(date))=1 then '0'+cast(month(date) as varchar)
     else cast(month(date) as varchar) end as MonthID ,
DATENAME(month,date) as MonthName,
DAY(date) as day,
DATENAME(weekday,date) as DayName
from #datedim






