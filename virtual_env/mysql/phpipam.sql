-- MySQL dump 10.13  Distrib 5.6.46, for Linux (x86_64)
--
-- Host: localhost    Database: phpipam
-- ------------------------------------------------------
-- Server version	5.6.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `api`
--

DROP TABLE IF EXISTS `api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` varchar(32) NOT NULL DEFAULT '',
  `app_code` varchar(32) DEFAULT '',
  `app_permissions` int(1) DEFAULT '1',
  `app_comment` text,
  `app_security` set('ssl_code','ssl_token','crypt','user','none') NOT NULL DEFAULT 'ssl_token',
  `app_lock` int(1) NOT NULL DEFAULT '0',
  `app_lock_wait` int(4) NOT NULL DEFAULT '30',
  `app_nest_custom_fields` tinyint(1) DEFAULT '0',
  `app_show_links` tinyint(1) DEFAULT '0',
  `app_last_access` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id` (`app_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api`
--

LOCK TABLES `api` WRITE;
/*!40000 ALTER TABLE `api` DISABLE KEYS */;
INSERT INTO `api` VALUES (1,'userssl','Fhfe_68qIWsvYqmB-t3zx0D9AVfuFufL',3,NULL,'ssl_token',0,0,0,0,'2019-11-02 13:06:16'),(2,'appcode','i-C5fsW8w47FX9hVLEcRd-u3jBlAp5WO',3,NULL,'ssl_code',0,0,0,0,'2019-11-02 13:06:18'),(3,'usernossl','M_unnBjZ9lF51OzRZhYKk7uWrGhhW5vO',3,NULL,'none',0,0,0,0,'2019-11-02 13:06:19');
/*!40000 ALTER TABLE `api` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changelog`
--

DROP TABLE IF EXISTS `changelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changelog` (
  `cid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype` set('ip_addr','subnet','section') NOT NULL DEFAULT '',
  `coid` int(11) unsigned NOT NULL,
  `cuser` int(11) unsigned NOT NULL,
  `caction` set('add','edit','delete','truncate','resize','perm_change') NOT NULL DEFAULT 'edit',
  `cresult` set('error','success') NOT NULL DEFAULT '',
  `cdate` datetime NOT NULL,
  `cdiff` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `coid` (`coid`),
  KEY `ctype` (`ctype`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `circuitProviders`
--

DROP TABLE IF EXISTS `circuitProviders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circuitProviders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `description` text,
  `contact` varchar(128) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circuitProviders`
--

LOCK TABLES `circuitProviders` WRITE;
/*!40000 ALTER TABLE `circuitProviders` DISABLE KEYS */;
/*!40000 ALTER TABLE `circuitProviders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circuitTypes`
--

DROP TABLE IF EXISTS `circuitTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circuitTypes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctname` varchar(64) NOT NULL,
  `ctcolor` varchar(7) DEFAULT '#000000',
  `ctpattern` enum('Solid','Dotted') DEFAULT 'Solid',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circuitTypes`
--

LOCK TABLES `circuitTypes` WRITE;
/*!40000 ALTER TABLE `circuitTypes` DISABLE KEYS */;
INSERT INTO `circuitTypes` VALUES (1,'Default','#000000','Solid');
/*!40000 ALTER TABLE `circuitTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circuits`
--

DROP TABLE IF EXISTS `circuits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circuits` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(128) DEFAULT NULL,
  `provider` int(11) unsigned NOT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `capacity` varchar(128) DEFAULT NULL,
  `status` enum('Active','Inactive','Reserved') NOT NULL DEFAULT 'Active',
  `device1` int(11) unsigned DEFAULT NULL,
  `location1` int(11) unsigned DEFAULT NULL,
  `device2` int(11) unsigned DEFAULT NULL,
  `location2` int(11) unsigned DEFAULT NULL,
  `comment` text,
  `parent` int(10) unsigned NOT NULL DEFAULT '0',
  `customer_id` int(11) unsigned DEFAULT NULL,
  `differentiator` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `circuits_diff_UN` (`cid`,`differentiator`),
  KEY `location1` (`location1`),
  KEY `location2` (`location2`),
  KEY `customer_circuits` (`customer_id`),
  CONSTRAINT `customer_circuits` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circuits`
--

LOCK TABLES `circuits` WRITE;
/*!40000 ALTER TABLE `circuits` DISABLE KEYS */;
/*!40000 ALTER TABLE `circuits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circuitsLogical`
--

DROP TABLE IF EXISTS `circuitsLogical`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circuitsLogical` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logical_cid` varchar(128) NOT NULL,
  `purpose` varchar(64) DEFAULT NULL,
  `comments` text,
  `member_count` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `circuitsLogical_UN` (`logical_cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circuitsLogical`
--

LOCK TABLES `circuitsLogical` WRITE;
/*!40000 ALTER TABLE `circuitsLogical` DISABLE KEYS */;
/*!40000 ALTER TABLE `circuitsLogical` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circuitsLogicalMapping`
--

DROP TABLE IF EXISTS `circuitsLogicalMapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circuitsLogicalMapping` (
  `logicalCircuit_id` int(11) unsigned NOT NULL,
  `circuit_id` int(11) unsigned NOT NULL,
  `order` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circuitsLogicalMapping`
--

LOCK TABLES `circuitsLogicalMapping` WRITE;
/*!40000 ALTER TABLE `circuitsLogicalMapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `circuitsLogicalMapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL DEFAULT '',
  `address` varchar(255) DEFAULT NULL,
  `postcode` int(8) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `lat` varchar(12) DEFAULT NULL,
  `long` varchar(12) DEFAULT NULL,
  `contact_person` text,
  `contact_phone` varchar(32) DEFAULT NULL,
  `contact_mail` varchar(255) DEFAULT NULL,
  `note` text,
  `status` set('Active','Reserved','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deviceTypes`
--

DROP TABLE IF EXISTS `deviceTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deviceTypes` (
  `tid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tname` varchar(128) DEFAULT NULL,
  `tdescription` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deviceTypes`
--

LOCK TABLES `deviceTypes` WRITE;
/*!40000 ALTER TABLE `deviceTypes` DISABLE KEYS */;
INSERT INTO `deviceTypes` VALUES (1,'Switch','Switch'),(2,'Router','Router'),(3,'Firewall','Firewall'),(4,'Hub','Hub'),(5,'Wireless','Wireless'),(6,'Database','Database'),(7,'Workstation','Workstation'),(8,'Laptop','Laptop'),(9,'Other','Other');
/*!40000 ALTER TABLE `deviceTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) DEFAULT NULL,
  `ip_addr` varchar(100) DEFAULT NULL,
  `type` int(2) DEFAULT '0',
  `description` varchar(256) DEFAULT NULL,
  `sections` varchar(1024) DEFAULT NULL,
  `snmp_community` varchar(100) DEFAULT NULL,
  `snmp_version` set('0','1','2','3') DEFAULT '0',
  `snmp_port` mediumint(5) unsigned DEFAULT '161',
  `snmp_timeout` mediumint(5) unsigned DEFAULT '1000',
  `snmp_queries` varchar(128) DEFAULT NULL,
  `snmp_v3_sec_level` set('none','noAuthNoPriv','authNoPriv','authPriv') DEFAULT 'none',
  `snmp_v3_auth_protocol` set('none','MD5','SHA') DEFAULT 'none',
  `snmp_v3_auth_pass` varchar(64) DEFAULT NULL,
  `snmp_v3_priv_protocol` set('none','DES','AES') DEFAULT 'none',
  `snmp_v3_priv_pass` varchar(64) DEFAULT NULL,
  `snmp_v3_ctx_name` varchar(64) DEFAULT NULL,
  `snmp_v3_ctx_engine_id` varchar(64) DEFAULT NULL,
  `rack` int(11) unsigned DEFAULT NULL,
  `rack_start` int(11) unsigned DEFAULT NULL,
  `rack_size` int(11) unsigned DEFAULT NULL,
  `location` int(11) unsigned DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `hostname` (`hostname`),
  KEY `location` (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firewallZoneMapping`
--

DROP TABLE IF EXISTS `firewallZoneMapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firewallZoneMapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zoneId` int(11) unsigned NOT NULL,
  `alias` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deviceId` int(11) unsigned DEFAULT NULL,
  `interface` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `devId_idx` (`deviceId`),
  CONSTRAINT `devId` FOREIGN KEY (`deviceId`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firewallZoneMapping`
--

LOCK TABLES `firewallZoneMapping` WRITE;
/*!40000 ALTER TABLE `firewallZoneMapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewallZoneMapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firewallZoneSubnet`
--

DROP TABLE IF EXISTS `firewallZoneSubnet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firewallZoneSubnet` (
  `zoneId` int(11) NOT NULL,
  `subnetId` int(11) NOT NULL,
  KEY `fk_zoneId_idx` (`zoneId`),
  KEY `fk_subnetId_idx` (`subnetId`),
  CONSTRAINT `fk_subnetId` FOREIGN KEY (`subnetId`) REFERENCES `subnets` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_zoneId` FOREIGN KEY (`zoneId`) REFERENCES `firewallZones` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firewallZoneSubnet`
--

LOCK TABLES `firewallZoneSubnet` WRITE;
/*!40000 ALTER TABLE `firewallZoneSubnet` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewallZoneSubnet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firewallZones`
--

DROP TABLE IF EXISTS `firewallZones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firewallZones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `generator` tinyint(1) NOT NULL,
  `length` int(2) DEFAULT NULL,
  `padding` tinyint(1) DEFAULT NULL,
  `zone` varchar(31) COLLATE utf8_unicode_ci NOT NULL,
  `indicator` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `permissions` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firewallZones`
--

LOCK TABLES `firewallZones` WRITE;
/*!40000 ALTER TABLE `firewallZones` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewallZones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instructions`
--

DROP TABLE IF EXISTS `instructions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instructions` (
  `id` int(11) NOT NULL,
  `instructions` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructions`
--

LOCK TABLES `instructions` WRITE;
/*!40000 ALTER TABLE `instructions` DISABLE KEYS */;
INSERT INTO `instructions` VALUES (1,'You can write instructions under admin menu!');
/*!40000 ALTER TABLE `instructions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipTags`
--

DROP TABLE IF EXISTS `ipTags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipTags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `showtag` tinyint(4) DEFAULT '1',
  `bgcolor` varchar(7) DEFAULT '#000',
  `fgcolor` varchar(7) DEFAULT '#fff',
  `compress` set('No','Yes') NOT NULL DEFAULT 'No',
  `locked` set('No','Yes') NOT NULL DEFAULT 'No',
  `updateTag` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipTags`
--

LOCK TABLES `ipTags` WRITE;
/*!40000 ALTER TABLE `ipTags` DISABLE KEYS */;
INSERT INTO `ipTags` VALUES (1,'Offline',1,'#f59c99','#ffffff','No','Yes',1),(2,'Used',0,'#a9c9a4','#ffffff','No','Yes',1),(3,'Reserved',1,'#9ac0cd','#ffffff','No','Yes',1),(4,'DHCP',1,'#c9c9c9','#ffffff','Yes','Yes',1);
/*!40000 ALTER TABLE `ipTags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipaddresses`
--

DROP TABLE IF EXISTS `ipaddresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipaddresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subnetId` int(11) unsigned DEFAULT NULL,
  `ip_addr` varchar(100) NOT NULL,
  `is_gateway` tinyint(1) DEFAULT '0',
  `description` varchar(64) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `mac` varchar(20) DEFAULT NULL,
  `owner` varchar(128) DEFAULT NULL,
  `state` int(3) DEFAULT '2',
  `switch` int(11) unsigned DEFAULT NULL,
  `location` int(11) unsigned DEFAULT NULL,
  `port` varchar(32) DEFAULT NULL,
  `note` text,
  `lastSeen` datetime DEFAULT '1970-01-01 00:00:01',
  `excludePing` binary(1) DEFAULT '0',
  `PTRignore` binary(1) DEFAULT '0',
  `PTR` int(11) unsigned DEFAULT '0',
  `firewallAddressObject` varchar(100) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sid_ip_unique` (`ip_addr`,`subnetId`),
  KEY `subnetid` (`subnetId`),
  KEY `location` (`location`),
  KEY `customer_ip` (`customer_id`),
  CONSTRAINT `customer_ip` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipaddresses`
--

LOCK TABLES `ipaddresses` WRITE;
/*!40000 ALTER TABLE `ipaddresses` DISABLE KEYS */;
INSERT INTO `ipaddresses` VALUES (67,28,'3232263938',NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL),(68,28,'3232263939',NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ipaddresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lang`
--

DROP TABLE IF EXISTS `lang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lang` (
  `l_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `l_code` varchar(12) NOT NULL DEFAULT '',
  `l_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`l_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lang`
--

LOCK TABLES `lang` WRITE;
/*!40000 ALTER TABLE `lang` DISABLE KEYS */;
INSERT INTO `lang` VALUES (1,'en_GB.UTF-8','English'),(2,'sl_SI.UTF-8','Slovenščina'),(3,'fr_FR.UTF-8','Français'),(4,'nl_NL.UTF-8','Nederlands'),(5,'de_DE.UTF-8','Deutsch'),(6,'pt_BR.UTF-8','Brazil'),(7,'es_ES.UTF-8','Español'),(8,'cs_CZ.UTF-8','Czech'),(9,'en_US.UTF-8','English (US)'),(10,'ru_RU.UTF-8','Russian'),(11,'zh_CN.UTF-8','Chinese'),(12,'ja_JP.UTF-8','Japanese');
/*!40000 ALTER TABLE `lang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `description` text,
  `address` varchar(128) DEFAULT NULL,
  `lat` varchar(12) DEFAULT NULL,
  `long` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loginAttempts`
--

DROP TABLE IF EXISTS `loginAttempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loginAttempts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ip` varchar(128) NOT NULL DEFAULT '',
  `count` int(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loginAttempts`
--

LOCK TABLES `loginAttempts` WRITE;
/*!40000 ALTER TABLE `loginAttempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `loginAttempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `severity` int(11) DEFAULT NULL,
  `date` varchar(32) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `ipaddr` varchar(64) DEFAULT NULL,
  `command` varchar(128) DEFAULT '0',
  `details` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `nameservers`
--

DROP TABLE IF EXISTS `nameservers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nameservers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `namesrv1` varchar(255) DEFAULT NULL,
  `description` text,
  `permissions` varchar(128) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nameservers`
--

LOCK TABLES `nameservers` WRITE;
/*!40000 ALTER TABLE `nameservers` DISABLE KEYS */;
INSERT INTO `nameservers` VALUES (1,'Google NS','8.8.8.8;8.8.4.4','Google public nameservers','1;2',NULL);
/*!40000 ALTER TABLE `nameservers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nat`
--

DROP TABLE IF EXISTS `nat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nat` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `type` set('source','static','destination') DEFAULT 'source',
  `src` text,
  `dst` text,
  `src_port` int(5) DEFAULT NULL,
  `dst_port` int(5) DEFAULT NULL,
  `device` int(11) unsigned DEFAULT NULL,
  `description` text,
  `policy` set('Yes','No') NOT NULL DEFAULT 'No',
  `policy_dst` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nat`
--

LOCK TABLES `nat` WRITE;
/*!40000 ALTER TABLE `nat` DISABLE KEYS */;
/*!40000 ALTER TABLE `nat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `php_sessions`
--

DROP TABLE IF EXISTS `php_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `php_sessions` (
  `id` varchar(128) NOT NULL DEFAULT '',
  `access` int(10) unsigned DEFAULT NULL,
  `data` text NOT NULL,
  `remote_ip` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `php_sessions`
--

LOCK TABLES `php_sessions` WRITE;
/*!40000 ALTER TABLE `php_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `php_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pstnNumbers`
--

DROP TABLE IF EXISTS `pstnNumbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pstnNumbers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prefix` int(11) unsigned DEFAULT NULL,
  `number` varchar(32) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `owner` varchar(128) DEFAULT NULL,
  `state` int(11) unsigned DEFAULT NULL,
  `deviceId` int(11) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pstnNumbers`
--

LOCK TABLES `pstnNumbers` WRITE;
/*!40000 ALTER TABLE `pstnNumbers` DISABLE KEYS */;
/*!40000 ALTER TABLE `pstnNumbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pstnPrefixes`
--

DROP TABLE IF EXISTS `pstnPrefixes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pstnPrefixes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `prefix` varchar(32) DEFAULT NULL,
  `start` varchar(32) DEFAULT NULL,
  `stop` varchar(32) DEFAULT NULL,
  `master` int(11) DEFAULT '0',
  `deviceId` int(11) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pstnPrefixes`
--

LOCK TABLES `pstnPrefixes` WRITE;
/*!40000 ALTER TABLE `pstnPrefixes` DISABLE KEYS */;
/*!40000 ALTER TABLE `pstnPrefixes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rackContents`
--

DROP TABLE IF EXISTS `rackContents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rackContents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `rack` int(11) unsigned DEFAULT NULL,
  `rack_start` int(11) unsigned DEFAULT NULL,
  `rack_size` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rack` (`rack`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rackContents`
--

LOCK TABLES `rackContents` WRITE;
/*!40000 ALTER TABLE `rackContents` DISABLE KEYS */;
/*!40000 ALTER TABLE `rackContents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `racks`
--

DROP TABLE IF EXISTS `racks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `racks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `size` int(2) DEFAULT NULL,
  `location` int(11) unsigned DEFAULT NULL,
  `row` int(11) NOT NULL DEFAULT '1',
  `hasBack` tinyint(1) NOT NULL DEFAULT '0',
  `topDown` tinyint(1) NOT NULL DEFAULT '0',
  `description` text,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `location` (`location`),
  KEY `customer_racks` (`customer_id`),
  CONSTRAINT `customer_racks` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `racks`
--

LOCK TABLES `racks` WRITE;
/*!40000 ALTER TABLE `racks` DISABLE KEYS */;
/*!40000 ALTER TABLE `racks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subnetId` int(11) unsigned DEFAULT NULL,
  `ip_addr` varchar(100) DEFAULT NULL,
  `description` varchar(64) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `state` int(11) DEFAULT '2',
  `owner` varchar(128) DEFAULT NULL,
  `requester` varchar(128) DEFAULT NULL,
  `comment` text,
  `processed` binary(1) DEFAULT NULL,
  `accepted` binary(1) DEFAULT NULL,
  `adminComment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routing_bgp`
--

DROP TABLE IF EXISTS `routing_bgp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `routing_bgp` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `local_as` int(12) unsigned NOT NULL,
  `local_address` varchar(100) NOT NULL DEFAULT '',
  `peer_name` varchar(255) NOT NULL DEFAULT '',
  `peer_as` int(12) unsigned NOT NULL,
  `peer_address` varchar(100) NOT NULL DEFAULT '',
  `bgp_type` enum('internal','external') NOT NULL DEFAULT 'external',
  `vrf_id` int(11) unsigned DEFAULT NULL,
  `circuit_id` int(11) unsigned DEFAULT NULL,
  `customer_id` int(11) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `vrf_id` (`vrf_id`),
  KEY `circuit_id` (`circuit_id`),
  KEY `cust_id` (`customer_id`),
  CONSTRAINT `circuit_id` FOREIGN KEY (`circuit_id`) REFERENCES `circuits` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `cust_id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `vrf_id` FOREIGN KEY (`vrf_id`) REFERENCES `vrf` (`vrfId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routing_bgp`
--

LOCK TABLES `routing_bgp` WRITE;
/*!40000 ALTER TABLE `routing_bgp` DISABLE KEYS */;
/*!40000 ALTER TABLE `routing_bgp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routing_subnets`
--

DROP TABLE IF EXISTS `routing_subnets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `routing_subnets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('bgp','ospf') NOT NULL DEFAULT 'bgp',
  `direction` enum('advertised','received') NOT NULL DEFAULT 'advertised',
  `object_id` int(11) unsigned NOT NULL,
  `subnet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`object_id`,`subnet_id`),
  KEY `bgp_id` (`object_id`),
  KEY `subnet_id` (`subnet_id`),
  CONSTRAINT `bgp_id` FOREIGN KEY (`object_id`) REFERENCES `routing_bgp` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `subnet_id` FOREIGN KEY (`subnet_id`) REFERENCES `subnets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routing_subnets`
--

LOCK TABLES `routing_subnets` WRITE;
/*!40000 ALTER TABLE `routing_subnets` DISABLE KEYS */;
/*!40000 ALTER TABLE `routing_subnets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scanAgents`
--

DROP TABLE IF EXISTS `scanAgents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scanAgents` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `description` text,
  `type` set('direct','api','mysql') NOT NULL DEFAULT '',
  `code` varchar(32) DEFAULT NULL,
  `last_access` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scanAgents`
--

LOCK TABLES `scanAgents` WRITE;
/*!40000 ALTER TABLE `scanAgents` DISABLE KEYS */;
INSERT INTO `scanAgents` VALUES (1,'localhost','Scanning from local machine','direct',NULL,NULL);
/*!40000 ALTER TABLE `scanAgents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `description` text,
  `masterSection` int(11) DEFAULT '0',
  `permissions` varchar(1024) DEFAULT NULL,
  `strictMode` binary(1) NOT NULL DEFAULT '1',
  `subnetOrdering` varchar(16) DEFAULT NULL,
  `order` int(3) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `showVLAN` tinyint(1) NOT NULL DEFAULT '0',
  `showVRF` tinyint(1) NOT NULL DEFAULT '0',
  `showSupernetOnly` tinyint(1) NOT NULL DEFAULT '0',
  `DNS` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `id_2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
INSERT INTO `sections` VALUES (1,'Customers','Section for customers',0,'{\"3\":\"1\",\"2\":\"2\"}','1',NULL,NULL,NULL,0,0,0,NULL),(2,'IPv6','Section for IPv6 addresses',0,'{\"3\":\"1\",\"2\":\"2\"}','1',NULL,NULL,NULL,0,0,0,NULL);
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `siteTitle` varchar(64) DEFAULT NULL,
  `siteAdminName` varchar(64) DEFAULT NULL,
  `siteAdminMail` varchar(64) DEFAULT NULL,
  `siteDomain` varchar(32) DEFAULT NULL,
  `siteURL` varchar(64) DEFAULT NULL,
  `siteLoginText` varchar(128) DEFAULT NULL,
  `domainAuth` tinyint(1) DEFAULT NULL,
  `enableIPrequests` tinyint(1) DEFAULT NULL,
  `enableVRF` tinyint(1) DEFAULT '1',
  `enableDNSresolving` tinyint(1) DEFAULT NULL,
  `enableFirewallZones` tinyint(1) NOT NULL DEFAULT '0',
  `firewallZoneSettings` varchar(1024) NOT NULL DEFAULT '{"zoneLength":3,"ipType":{"0":"v4","1":"v6"},"separator":"_","indicator":{"0":"own","1":"customer"},"zoneGenerator":"2","zoneGeneratorType":{"0":"decimal","1":"hex","2":"text"},"deviceType":"3","padding":"on","strictMode":"on","pattern":{"0":"patternFQDN"}}',
  `enablePowerDNS` tinyint(1) DEFAULT '0',
  `powerDNS` text,
  `enableDHCP` tinyint(1) DEFAULT '0',
  `DHCP` varchar(256) DEFAULT '{"type":"kea","settings":{"file":"/etc/kea/kea.conf"}}',
  `enableMulticast` tinyint(1) DEFAULT '0',
  `enableNAT` tinyint(1) DEFAULT '1',
  `enableSNMP` tinyint(1) DEFAULT '0',
  `enableThreshold` tinyint(1) DEFAULT '1',
  `enableRACK` tinyint(1) DEFAULT '1',
  `enableLocations` tinyint(1) DEFAULT '1',
  `enablePSTN` tinyint(1) DEFAULT '0',
  `enableChangelog` tinyint(1) NOT NULL DEFAULT '1',
  `enableCustomers` tinyint(1) NOT NULL DEFAULT '1',
  `link_field` varchar(32) DEFAULT '0',
  `version` varchar(5) DEFAULT NULL,
  `dbversion` int(8) NOT NULL DEFAULT '0',
  `dbverified` binary(1) NOT NULL DEFAULT '0',
  `donate` tinyint(1) DEFAULT '0',
  `IPfilter` varchar(128) DEFAULT NULL,
  `IPrequired` varchar(128) DEFAULT NULL,
  `vlanDuplicate` int(1) DEFAULT '0',
  `vlanMax` int(8) DEFAULT '4096',
  `subnetOrdering` varchar(16) DEFAULT 'subnet,asc',
  `visualLimit` int(2) NOT NULL DEFAULT '0',
  `theme` varchar(32) NOT NULL DEFAULT 'dark',
  `autoSuggestNetwork` tinyint(1) NOT NULL DEFAULT '0',
  `pingStatus` varchar(32) NOT NULL DEFAULT '1800;3600',
  `defaultLang` int(3) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `vcheckDate` datetime DEFAULT NULL,
  `api` binary(1) NOT NULL DEFAULT '0',
  `scanPingPath` varchar(64) DEFAULT '/bin/ping',
  `scanFPingPath` varchar(64) DEFAULT '/bin/fping',
  `scanPingType` set('ping','pear','fping') NOT NULL DEFAULT 'ping',
  `scanMaxThreads` int(4) DEFAULT '128',
  `prettyLinks` set('Yes','No') NOT NULL DEFAULT 'No',
  `hiddenCustomFields` text,
  `inactivityTimeout` int(5) NOT NULL DEFAULT '3600',
  `updateTags` tinyint(1) DEFAULT '0',
  `enforceUnique` tinyint(1) DEFAULT '1',
  `authmigrated` tinyint(4) NOT NULL DEFAULT '0',
  `maintaneanceMode` tinyint(1) DEFAULT '0',
  `decodeMAC` tinyint(1) DEFAULT '1',
  `tempShare` tinyint(1) DEFAULT '0',
  `tempAccess` text,
  `log` set('Database','syslog','both') NOT NULL DEFAULT 'Database',
  `subnetView` tinyint(4) NOT NULL DEFAULT '0',
  `enableCircuits` tinyint(1) DEFAULT '1',
  `enableRouting` tinyint(1) DEFAULT '0',
  `permissionPropagate` tinyint(1) DEFAULT '1',
  `passwordPolicy` varchar(1024) DEFAULT '{"minLength":8,"maxLength":0,"minNumbers":0,"minLetters":0,"minLowerCase":0,"minUpperCase":0,"minSymbols":0,"maxSymbols":0,"allowedSymbols":"#,_,-,!,[,],=,~"}',
  `2fa_provider` set('none','Google_Authenticator') DEFAULT 'none',
  `2fa_name` varchar(32) DEFAULT 'phpipam',
  `2fa_length` int(2) DEFAULT '16',
  `2fa_userchange` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'phpipam IP address management','Sysadmin','admin@domain.local','domain.local','http://yourpublicurl.com',NULL,0,0,0,0,0,'{\"zoneLength\":3,\"ipType\":{\"0\":\"v4\",\"1\":\"v6\"},\"separator\":\"_\",\"indicator\":{\"0\":\"own\",\"1\":\"customer\"},\"zoneGenerator\":\"2\",\"zoneGeneratorType\":{\"0\":\"decimal\",\"1\":\"hex\",\"2\":\"text\"},\"deviceType\":\"3\",\"padding\":\"on\",\"strictMode\":\"on\",\"pattern\":{\"0\":\"patternFQDN\"}}',0,NULL,0,'{\"type\":\"kea\",\"settings\":{\"file\":\"/etc/kea/kea.conf\"}}',0,1,0,1,1,1,0,1,1,NULL,'1.4',25,'1',0,'mac;owner;state;switch;note;firewallAddressObject',NULL,1,4096,'subnet,asc',24,'dark',0,'1800;3600',11,'2019-11-02 05:50:10','2019-11-02 04:34:16','1','/bin/ping','/bin/fping','ping',128,'No',NULL,3600,0,1,0,0,1,0,NULL,'Database',0,1,0,1,'{\"minLength\":8,\"maxLength\":0,\"minNumbers\":0,\"minLetters\":0,\"minLowerCase\":0,\"minUpperCase\":0,\"minSymbols\":0,\"maxSymbols\":0,\"allowedSymbols\":\"#,_,-,!,[,],=,~\"}','none','phpipam',16,1);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settingsMail`
--

DROP TABLE IF EXISTS `settingsMail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settingsMail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mtype` set('localhost','smtp') NOT NULL DEFAULT 'localhost',
  `msecure` set('none','ssl','tls') NOT NULL DEFAULT 'none',
  `mauth` set('yes','no') NOT NULL DEFAULT 'no',
  `mserver` varchar(128) DEFAULT NULL,
  `mport` int(5) DEFAULT '25',
  `muser` varchar(64) DEFAULT NULL,
  `mpass` varchar(64) DEFAULT NULL,
  `mAdminName` varchar(64) DEFAULT NULL,
  `mAdminMail` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settingsMail`
--

LOCK TABLES `settingsMail` WRITE;
/*!40000 ALTER TABLE `settingsMail` DISABLE KEYS */;
INSERT INTO `settingsMail` VALUES (1,'localhost','none','no',NULL,25,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `settingsMail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subnets`
--

DROP TABLE IF EXISTS `subnets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subnets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subnet` varchar(255) DEFAULT NULL,
  `mask` varchar(3) DEFAULT NULL,
  `sectionId` int(11) unsigned DEFAULT NULL,
  `description` text,
  `linked_subnet` int(11) unsigned DEFAULT NULL,
  `firewallAddressObject` varchar(100) DEFAULT NULL,
  `vrfId` int(11) unsigned DEFAULT NULL,
  `masterSubnetId` int(11) unsigned NOT NULL DEFAULT '0',
  `allowRequests` tinyint(1) DEFAULT '0',
  `vlanId` int(11) unsigned DEFAULT NULL,
  `showName` tinyint(1) DEFAULT '0',
  `device` int(10) unsigned DEFAULT '0',
  `permissions` varchar(1024) DEFAULT NULL,
  `pingSubnet` tinyint(1) DEFAULT '0',
  `discoverSubnet` binary(1) DEFAULT '0',
  `resolveDNS` tinyint(1) DEFAULT '0',
  `DNSrecursive` tinyint(1) DEFAULT '0',
  `DNSrecords` tinyint(1) DEFAULT '0',
  `nameserverId` int(11) DEFAULT '0',
  `scanAgent` int(11) DEFAULT NULL,
  `customer_id` int(11) unsigned DEFAULT NULL,
  `isFolder` tinyint(1) DEFAULT '0',
  `isFull` tinyint(1) DEFAULT '0',
  `state` int(3) DEFAULT '2',
  `threshold` int(3) DEFAULT '0',
  `location` int(11) unsigned DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `lastScan` timestamp NULL DEFAULT NULL,
  `lastDiscovery` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `masterSubnetId` (`masterSubnetId`),
  KEY `location` (`location`),
  KEY `sectionId` (`sectionId`),
  KEY `vrfId` (`vrfId`),
  KEY `customer_subnets` (`customer_id`),
  CONSTRAINT `customer_subnets` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subnets`
--

LOCK TABLES `subnets` WRITE;
/*!40000 ALTER TABLE `subnets` DISABLE KEYS */;
INSERT INTO `subnets` VALUES (1,'336395549904799703390415618052362076160','64',2,'Private subnet 1',NULL,NULL,0,0,1,1,1,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,0,0,2,0,NULL,NULL,NULL,NULL),(2,'168427520','16',1,'Business customers',NULL,NULL,0,0,1,0,1,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,0,0,2,0,NULL,NULL,NULL,NULL),(3,'168427776','24',1,'Customer 1',NULL,NULL,0,2,1,0,1,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,0,0,2,0,NULL,NULL,NULL,NULL),(4,'168428032','24',1,'Customer 2',NULL,NULL,0,2,1,0,1,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,0,0,2,0,NULL,NULL,NULL,NULL),(5,'0','',1,'My folder',NULL,NULL,0,0,0,0,0,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,1,0,2,0,NULL,NULL,NULL,NULL),(6,'172037632','24',1,'DHCP range',NULL,NULL,0,5,0,0,1,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,0,0,2,0,NULL,NULL,NULL,NULL),(28,'3232263936','24',2,NULL,NULL,NULL,NULL,0,0,NULL,0,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,0,0,2,0,NULL,NULL,NULL,NULL),(39,'3232238080','24',2,NULL,NULL,NULL,NULL,0,0,NULL,0,0,'{\"3\":\"1\",\"2\":\"2\"}',0,'0',0,0,0,0,NULL,NULL,0,0,2,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `subnets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userGroups`
--

DROP TABLE IF EXISTS `userGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userGroups` (
  `g_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `g_name` varchar(32) DEFAULT NULL,
  `g_desc` varchar(1024) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`g_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userGroups`
--

LOCK TABLES `userGroups` WRITE;
/*!40000 ALTER TABLE `userGroups` DISABLE KEYS */;
INSERT INTO `userGroups` VALUES (2,'Operators','default Operator group',NULL),(3,'Guests','default Guest group (viewers)',NULL);
/*!40000 ALTER TABLE `userGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `authMethod` int(2) DEFAULT '1',
  `password` char(128) COLLATE utf8_bin DEFAULT NULL,
  `groups` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `role` text CHARACTER SET utf8,
  `real_name` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `domainUser` binary(1) DEFAULT '0',
  `widgets` varchar(1024) COLLATE utf8_bin DEFAULT 'statistics;favourite_subnets;changelog;top10_hosts_v4',
  `lang` int(11) unsigned DEFAULT '9',
  `favourite_subnets` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `disabled` set('Yes','No') COLLATE utf8_bin NOT NULL DEFAULT 'No',
  `mailNotify` set('Yes','No') COLLATE utf8_bin DEFAULT 'No',
  `mailChangelog` set('Yes','No') COLLATE utf8_bin DEFAULT 'No',
  `passChange` set('Yes','No') COLLATE utf8_bin NOT NULL DEFAULT 'No',
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `lastLogin` timestamp NULL DEFAULT NULL,
  `lastActivity` timestamp NULL DEFAULT NULL,
  `compressOverride` set('default','Uncompress') COLLATE utf8_bin NOT NULL DEFAULT 'default',
  `hideFreeRange` tinyint(1) DEFAULT '0',
  `menuType` set('Static','Dynamic') COLLATE utf8_bin DEFAULT 'Dynamic',
  `menuCompact` tinyint(4) DEFAULT '1',
  `2fa` tinyint(1) NOT NULL DEFAULT '0',
  `2fa_secret` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `theme` varchar(32) COLLATE utf8_bin DEFAULT '',
  `token` varchar(24) COLLATE utf8_bin DEFAULT NULL,
  `token_valid_until` datetime DEFAULT NULL,
  `module_permissions` varchar(255) COLLATE utf8_bin DEFAULT '{"vlan":"1","vrf":"1","pdns":"1","circuits":"1","racks":"1","nat":"1","pstn":"1","customers":"1","locations":"1","devices":"1"}',
  `compress_actions` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`username`),
  UNIQUE KEY `id_2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin',1,'$6$rounds=3000$meIUunywS6HibtPI$3PXN4ebZ8Kgh20a.jPIsLivZ6nSE89J6mg.MzHrUJQDqJEUu1sAm.Ra5r424oPp.FUe9ourh28PT2N2N7pdIC0','','Administrator','phpIPAM Admin','admin@domain.local','0','statistics;favourite_subnets;changelog;access_logs;error_logs;top10_hosts_v4',9,NULL,'No','No','No','No','2019-11-02 13:06:18','2019-11-02 13:06:18','2019-11-02 11:52:54','default',0,'Dynamic',1,0,NULL,'','wN4yS9huCozQNfdyN0hRjhHu','2019-11-02 19:06:18','{\"vlan\":\"1\",\"vrf\":\"1\",\"pdns\":\"1\",\"circuits\":\"1\",\"racks\":\"1\",\"nat\":\"1\",\"pstn\":\"1\",\"customers\":\"1\",\"locations\":\"1\",\"devices\":\"1\"}',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usersAuthMethod`
--

DROP TABLE IF EXISTS `usersAuthMethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usersAuthMethod` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` set('local','http','AD','LDAP','NetIQ','Radius','SAML2') NOT NULL DEFAULT 'local',
  `params` varchar(2048) DEFAULT NULL,
  `protected` set('Yes','No') NOT NULL DEFAULT 'Yes',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usersAuthMethod`
--

LOCK TABLES `usersAuthMethod` WRITE;
/*!40000 ALTER TABLE `usersAuthMethod` DISABLE KEYS */;
INSERT INTO `usersAuthMethod` VALUES (1,'local',NULL,'Yes','Local database'),(2,'http',NULL,'Yes','Apache authentication');
/*!40000 ALTER TABLE `usersAuthMethod` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vlanDomains`
--

DROP TABLE IF EXISTS `vlanDomains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vlanDomains` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `description` text,
  `permissions` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vlanDomains`
--

LOCK TABLES `vlanDomains` WRITE;
/*!40000 ALTER TABLE `vlanDomains` DISABLE KEYS */;
INSERT INTO `vlanDomains` VALUES (1,'default','default L2 domain',NULL);
/*!40000 ALTER TABLE `vlanDomains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vlans`
--

DROP TABLE IF EXISTS `vlans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vlans` (
  `vlanId` int(11) NOT NULL AUTO_INCREMENT,
  `domainId` int(11) NOT NULL DEFAULT '1',
  `name` varchar(255) NOT NULL,
  `number` int(4) DEFAULT NULL,
  `description` text,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`vlanId`),
  KEY `customer_vlans` (`customer_id`),
  CONSTRAINT `customer_vlans` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vlans`
--

LOCK TABLES `vlans` WRITE;
/*!40000 ALTER TABLE `vlans` DISABLE KEYS */;
INSERT INTO `vlans` VALUES (1,1,'IPv6 private 1',2001,'IPv6 private 1 subnets',NULL,NULL),(2,1,'Servers DMZ',4001,'DMZ public',NULL,NULL);
/*!40000 ALTER TABLE `vlans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vrf`
--

DROP TABLE IF EXISTS `vrf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vrf` (
  `vrfId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `rd` varchar(32) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `sections` varchar(128) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`vrfId`),
  KEY `customer_vrf` (`customer_id`),
  CONSTRAINT `customer_vrf` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vrf`
--

LOCK TABLES `vrf` WRITE;
/*!40000 ALTER TABLE `vrf` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `widgets`
--

DROP TABLE IF EXISTS `widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widgets` (
  `wid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `wtitle` varchar(64) NOT NULL DEFAULT '',
  `wdescription` varchar(1024) DEFAULT NULL,
  `wfile` varchar(64) NOT NULL DEFAULT '',
  `wparams` varchar(1024) DEFAULT NULL,
  `whref` enum('yes','no') NOT NULL DEFAULT 'no',
  `wsize` enum('4','6','8','12') NOT NULL DEFAULT '6',
  `wadminonly` enum('yes','no') NOT NULL DEFAULT 'no',
  `wactive` enum('yes','no') NOT NULL DEFAULT 'no',
  PRIMARY KEY (`wid`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widgets`
--

LOCK TABLES `widgets` WRITE;
/*!40000 ALTER TABLE `widgets` DISABLE KEYS */;
INSERT INTO `widgets` VALUES (1,'Statistics','Shows some statistics on number of hosts, subnets','statistics',NULL,'no','4','no','yes'),(2,'Favourite subnets','Shows 5 favourite subnets','favourite_subnets',NULL,'yes','8','no','yes'),(3,'Top 10 IPv4 subnets by number of hosts','Shows graph of top 10 IPv4 subnets by number of hosts','top10_hosts_v4',NULL,'yes','6','no','yes'),(4,'Top 10 IPv6 subnets by number of hosts','Shows graph of top 10 IPv6 subnets by number of hosts','top10_hosts_v6',NULL,'yes','6','no','yes'),(5,'Top 10 IPv4 subnets by usage percentage','Shows graph of top 10 IPv4 subnets by usage percentage','top10_percentage',NULL,'yes','6','no','yes'),(6,'Last 5 change log entries','Shows last 5 change log entries','changelog',NULL,'yes','12','no','yes'),(7,'Active IP addresses requests','Shows list of active IP address request','requests',NULL,'yes','6','yes','yes'),(8,'Last 5 informational logs','Shows list of last 5 informational logs','access_logs',NULL,'yes','6','yes','yes'),(9,'Last 5 warning / error logs','Shows list of last 5 warning and error logs','error_logs',NULL,'yes','6','yes','yes'),(10,'Tools menu','Shows quick access to tools menu','tools',NULL,'yes','6','no','yes'),(11,'IP Calculator','Shows IP calculator as widget','ipcalc',NULL,'yes','6','no','yes'),(12,'IP Request','IP Request widget','iprequest',NULL,'no','6','no','yes'),(13,'Threshold','Shows threshold usage for top 5 subnets','threshold',NULL,'yes','6','no','yes'),(14,'Inactive hosts','Shows list of inactive hosts for defined period','inactive-hosts','86400','yes','6','yes','yes'),(15,'Locations','Shows map of locations','locations',NULL,'yes','6','no','yes'),(16,'Bandwidth calculator','Calculate bandwidth','bw_calculator',NULL,'no','6','no','yes'),(17,'Customers','Shows customer list','customers',NULL,'yes','6','no','yes'),(18,'User Instructions','Shows user instructions','instructions',NULL,'yes','6','no','yes');
/*!40000 ALTER TABLE `widgets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-02 15:11:53
