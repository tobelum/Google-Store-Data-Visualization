/***********************************************
**                MSc ANALYTICS 
** DATABASE DESIGN & IMPLEMENTATION (MSCA 31005)
** File:   Gstore
** Desc:   Creation of dimensional model
** Auth:   Tobel Ezeokoli, Chen Pan
** Date:   12/03/2018
************************************************/

-- -----------------------------------------------------
-- Copy Data from GStore 
-- -----------------------------------------------------
# dimBroswer table 
# insert data into the dimBrowser table from gstore browser table 
INSERT INTO gstoredw.dimBrowser
(SELECT 
    *
FROM
    gstore.browser);
    
# dimChanneGroup table 
# insert data into the dimChannelGroup table from gstore channelgroup table 
INSERT INTO gstoredw.dimChannelGroup
(SELECT 
    *
FROM
    gstore.channelgroup);
    
# dimCity table 
# insert data into the dimCity table from gstore city table 
INSERT INTO gstoredw.dimCity
(SELECT 
    *
FROM
    gstore.city);

# dimCountry table 
# insert data into the dimCountry table from gstore country table 
INSERT INTO gstoredw.dimCountry
(SELECT 
    *
FROM
    gstore.country);

# dimDate table 
# insert data into the dimDate table from gstore visitdate table 
INSERT INTO gstoredw.dimDate
(SELECT 
    *
FROM
    gstore.visitDate);
    

# FactSession table
INSERT INTO gstoredw.factSession
(fullVisitorId, visitId, visitNumber, isMobile, deviceCategory, hits, pageviews, newVisits,bounces,transactionRevenue,cityID,countryID, channelGroupID,dateID, browserID)
SELECT 
    fullVisitorId, 
    visitId, 
    visitNumber, 
    isMobile, 
    deviceCategory, 
    hits, 
    pageviews, 
    newVisits,
    bounces,
    transactionRevenue,
    city.cityID,
    country.countryID, 
    channelgroup.channelID,
    visitdate.dateID, 
    browser.browserID

FROM
    gstore.session,
    gstore.city,
    gstore.country,
    gstore.channelgroup,
    gstore.visitdate,
    gstore.browser
WHERE
    session.cityID = city.cityID
        AND session.countryID = country.countryID
        AND session.channelGroupID = channelgroup.channelID
        AND session.dateID = visitdate.dateID
        AND session.browserID = browser.browserID;

-- END--

