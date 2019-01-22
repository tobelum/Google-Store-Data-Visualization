use `gstore`;

select count(`visitid`) as NumberOfVisits, sum(transactionRevenue) as TotalRevenue, avg(transactionRevenue) as AverageRevenue, continent from session, country where session.countryID=country.countryID
group by continent order by TotalRevenue desc;

-- list 10 countries with highest transaction revenue as well as the number of visits and average transaction amount
select count(`visitid`) as NumberOfVisits, sum(transactionRevenue) as TotalRevenue, avg(transactionRevenue) as AverageRevenue, country.country from session, country 
where session.countryID=country.countryID
group by country order by TotalRevenue desc limit 10;

-- list 10 cities with highest transaction revenue as well as the number of visits and average transaction amount
select count(`visitid`) as NumberOfVisits, sum(transactionRevenue) as TotalRevenue, avg(transactionRevenue) as AverageRevenue, city.city from session, city 
where session.cityID=city.cityID
group by city order by TotalRevenue desc limit 20;

-- list devices with highest transaction revenue as well as the number of visits and average transaction amount
select count(`visitid`) as NumberOfVisits, sum(transactionRevenue) as TotalRevenue, avg(transactionRevenue) as AverageRevenue, deviceCategory from session
group by deviceCategory order by TotalRevenue desc;

-- list channels with highest transaction revenue as well as the number of visits and average transaction amount
select count(`visitid`) as NumberOfVisits, sum(transactionRevenue) as TotalRevenue, avg(transactionRevenue) as AverageRevenue, channel from session, channelgroup
where session.channelGroupID = channelGroup.channelID
group by channel order by TotalRevenue desc;