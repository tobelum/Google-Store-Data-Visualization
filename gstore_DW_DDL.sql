/***********************************************
**                MSc ANALYTICS 
** DATABASE DESIGN & IMPLEMENTATION (MSCA 31005)
** File:   Gstore
** Desc:   Creation of dimensional model
** Auth:   Tobel Ezeokoli, Chen Pan
** Date:   12/03/2018
************************************************/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ALLOW_INVALID_DATES';
SET SQL_SAFE_UPDATES=0; 

-- -----------------------------------------------------
-- Schema classicmodelsdw
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `gstoredw` DEFAULT CHARACTER SET utf8 ;
USE `gstoredw` ;

-- -----------------------------------------------------
-- Table `gstoredw`.`dimChannelGroup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gstoredw`.`dimChannelGroup` (
  `channelID` int(11) NOT NULL,
  `channel` varchar(50) NOT NULL,
  PRIMARY KEY (`channelID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `gstoredw`.`dimDate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gstoredw`.`dimDate` (
  `dateID` int(11) NOT NULL,
  `dateVisited` date NOT NULL,
  `day` int(11) NOT NULL,
  `month` varchar(20) NOT NULL,
  `year` year NOT NULL,
  PRIMARY KEY (`dateID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `gstoredw`.`dimCountry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gstoredw`.`dimCountry` (
  `countryID` int(11) NOT NULL,
  `country` varchar(50) NOT NULL,
  `subcontinent` varchar(50) NOT NULL,
  `continent` varchar(50) NOT NULL,
  PRIMARY KEY (`countryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `gstoredw`.`dimBrowser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gstoredw`.`dimBrowser` (
  `browserID` int(11) NOT NULL,
  `browserName` varchar(50) NOT NULL,
  PRIMARY KEY (`browserID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `gstoredw`.`dimCity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gstoredw`.`dimCity` (
  `cityID` int(11) NOT NULL,
  `city` varchar(50) NULL,
  `region` varchar(50) NULL,
  PRIMARY KEY (`cityID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `gstoredw`.`factSession`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `gstoredw`.`factSession` (
  `fullVisitorId` bigint NOT NULL,
  `visitId` bigint NOT NULL,
  `visitNumber` int(11) NOT NULL,
  `isMobile` enum('TRUE','FALSE') NOT NULL,
  `deviceCategory` enum('mobile','desktop','tablet') NOT NULL,
  `hits` int(11) NOT NULL,
  `pageviews` int(11) NOT NULL,
  `newVisits` int(2) NOT NULL,
  `bounces` int(2) NOT NULL,
  `transactionRevenue` float(6,2) NOT NULL,
  `cityID` int(11) NULL,
  `countryID` int(11) NOT NULL,
  `channelGroupID` int(11) NOT NULL,
  `dateID` int(11) NOT NULL,
  `browserID` int(11) NOT NULL,
  PRIMARY KEY (`fullVisitorId`,`visitId`),
  INDEX `fk_factSession_dimCity_idx` (`cityID` ASC),
  INDEX `fk_factSession_dimCountry_idx` (`countryID` ASC),
  INDEX `fk_factSession_dimChannelGroup_idx` (`channelGroupID` ASC),
  INDEX `fk_factSession_dimDate_idx` (`dateID` ASC),
  INDEX `fk_factSession_dimBrowser_idx` (`browserID` ASC),
  CONSTRAINT `fk_factSession_dimCity`
    FOREIGN KEY (`cityID`)
    REFERENCES `gstoredw`.`dimCity` (`cityID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factSession_dimCountry`
    FOREIGN KEY (`countryID`)
    REFERENCES `gstoredw`.`dimCountry` (`countryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factSession_dimChannelGroup`
    FOREIGN KEY (`channelGroupID`)
    REFERENCES `gstoredw`.`dimChannelGroup` (`channelID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factSession_dimDate`
    FOREIGN KEY (`dateID`)
    REFERENCES `gstoredw`.`dimDate` (`dateID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factSession_dimBrowser`
    FOREIGN KEY (`browserID`)
    REFERENCES `gstoredw`.`dimBrowser` (`browserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- END--