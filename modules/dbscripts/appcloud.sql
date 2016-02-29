-- MySQL Script generated by MySQL Workbench
-- Mon Feb  1 17:54:10 2016
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema AppCloudDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema AppCloudDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `AppCloudDB` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `AppCloudDB` ;

-- -----------------------------------------------------
-- Table `AppCloudDB`.`ApplicationType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationType` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `app_type_name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(1000) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`ApplicationType`
-- -----------------------------------------------------
INSERT INTO `ApplicationType` (`id`, `app_type_name`, `description`) VALUES
(1, 'war', 'Allows you to create dynamic websites using Servlets and JSPs, instead of the static HTML webpages and JAX-RS/JAX-WS services.'),
(2, 'mss', 'WSO2 Microservices Framework for Java (WSO2 MSF4J) offers the best option to create microservices in Java using annotation-based programming model.'),
(3, 'php', 'Allows you to create dynamic web page content using PHP web applications.');


-- -----------------------------------------------------
-- Table `AppCloudDB`.`ApplicationRuntime`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationRuntime` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `runtime_name` VARCHAR(100) NOT NULL,
  `repo_url` VARCHAR(100) NULL,
  `image_name` VARCHAR(100) NULL,
  `tag` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`ApplicationRuntime`
-- -----------------------------------------------------

INSERT INTO `ApplicationRuntime` (`id`, `runtime_name`, `repo_url`, `image_name`, `tag`) VALUES
(1, 'Apache Tomcat 8.0.30', 'registry.docker.appfactory.private.wso2.com:5000', 'tomcat', '8.0'),
(2, 'WSO2 Microservices Server 1.0.0', 'registry.docker.appfactory.private.wso2.com:5000', 'msf4j', '1.0'),
(3, 'Apache 2.4.10', 'registry.docker.appfactory.private.wso2.com:5000','php','5.6'),
(4, 'Apache 2.4.18', 'registry.docker.appfactory.private.wso2.com:5000','php','5.7');

-- -----------------------------------------------------
-- Table `AppCloudDB`.`ApplicationDeployment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationDeployment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `deployment_name` VARCHAR(100) NULL,
  `replicas` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`Application`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`Application` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `application_name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NOT NULL,
  `revision` VARCHAR(45) NOT NULL,
  `application_runtime_id` INT NULL,
  `application_type_id` INT NULL,
  `endpoint_url` VARCHAR(1000) NULL,
  `status` VARCHAR(45) NULL,
  `number_of_replica` INT NULL,
  `ApplicationDeployment_id` INT,
  PRIMARY KEY (`id`),
  CONSTRAINT uk_Application_NAME_TID_REV UNIQUE(`application_name`, `tenant_id`, `revision`),
  CONSTRAINT `fk_Application_ApplicationRuntime`
    FOREIGN KEY (`application_runtime_id`)
    REFERENCES `AppCloudDB`.`ApplicationRuntime` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Application_ApplicationType1`
    FOREIGN KEY (`application_type_id`)
    REFERENCES `AppCloudDB`.`ApplicationType` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationIcon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_name` varchar(45) NOT NULL,
  `icon` MEDIUMBLOB DEFAULT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT uk_AppIcon UNIQUE( `application_name` ,  `tenant_id`),
  CONSTRAINT  `fk_ApplicationIcon_Application`
  FOREIGN KEY (`application_name`,`tenant_id`)
  REFERENCES `AppCloudDB`.`Application` (`application_name`,`tenant_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION)
ENGINE=InnoDB;



-- -----------------------------------------------------
-- Table `AppCloudDB`.`Label`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`Label` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label_name` VARCHAR(100) NOT NULL,
  `label_value` VARCHAR(100) NULL,
  `application_id` INT NOT NULL,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Label_Application1`
    FOREIGN KEY (`application_id`)
    REFERENCES `AppCloudDB`.`Application` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`RuntimeProperties`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`RuntimeProperties` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `property_name` VARCHAR(100) NOT NULL,
  `property_value` VARCHAR(100) NULL,
  `application_id` INT NOT NULL,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_RuntimeProperties_Application1`
    FOREIGN KEY (`application_id`)
    REFERENCES `AppCloudDB`.`Application` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`EndpointURL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`EndpointURL` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `url_value` VARCHAR(1000) NULL,
  `Application_id` INT NOT NULL,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_EndpointURL_Application1`
    FOREIGN KEY (`Application_id`)
    REFERENCES `AppCloudDB`.`Application` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`TenantAppType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`TenantAppType` (
  `tenant_id` INT NOT NULL,
  `application_type_id` INT NOT NULL,
  CONSTRAINT `fk_TenantAppType_ApplicationType1`
    FOREIGN KEY (`application_type_id`)
    REFERENCES `AppCloudDB`.`ApplicationType` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`ApplicationTypeRuntime`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationTypeRuntime` (
  `application_type_id` INT NOT NULL,
  `application_runtime_id` INT NOT NULL,
  CONSTRAINT `fk_ApplicationType_has_ApplicationRuntime_ApplicationType1`
    FOREIGN KEY (`application_type_id`)
    REFERENCES `AppCloudDB`.`ApplicationType` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ApplicationType_has_ApplicationRuntime_ApplicationRuntime1`
    FOREIGN KEY (`application_runtime_id`)
    REFERENCES `AppCloudDB`.`ApplicationRuntime` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`ApplicationTypeRuntime`
-- -----------------------------------------------------
INSERT INTO `ApplicationTypeRuntime` (`application_type_id`, `application_runtime_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(3, 4);


-- -----------------------------------------------------
-- Table `AppCloudDB`.`TenanntRuntime`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`TenanntRuntime` (
  `tenant_id` INT NOT NULL,
  `application_runtime_id` INT NOT NULL,
  CONSTRAINT `fk_TenanntRuntime_ApplicationRuntime1`
    FOREIGN KEY (`application_runtime_id`)
    REFERENCES `AppCloudDB`.`ApplicationRuntime` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`ApplicationEvents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationEvents` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `application_id` INT NOT NULL,
  `event_name` VARCHAR(100) NOT NULL,
  `event_status` VARCHAR(45) NULL,
  `timestamp` TIMESTAMP NOT NULL,
  `event_desc` VARCHAR(1000) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ApplicationEvents_Application1`
    FOREIGN KEY (`application_id`)
    REFERENCES `AppCloudDB`.`Application` (`id`)
    ON DELETE CASCADE 
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`ApplicationContainer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationContainer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `image_name` VARCHAR(100) NULL,
  `image_version` VARCHAR(45) NULL,
  `ApplicationDeployment_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ApplicationContainer_ApplicationDeployment1`
    FOREIGN KEY (`ApplicationDeployment_id`)
    REFERENCES `AppCloudDB`.`ApplicationDeployment` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`ApplicationServiceProxy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`ApplicationServiceProxy` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `service_name` VARCHAR(100) NULL,
  `service_protocol` VARCHAR(100) NULL,
  `service_port` INT NULL,
  `service_backend_port` VARCHAR(45) NULL,
  `ApplicationContainer_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ApplicationServiceProxy_ApplicationContainer1`
    FOREIGN KEY (`ApplicationContainer_id`)
    REFERENCES `AppCloudDB`.`ApplicationContainer` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
