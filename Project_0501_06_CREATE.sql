USE BUDT702_Project_0501_06;

-- SQL create tables:
CREATE TABLE [InsightHarbor.School] (
	schoolID CHAR(4) NOT NULL, 
	schoolName VARCHAR(50), 
	schoolLocation VARCHAR(20), 
	schoolDeanName  VARCHAR(20),
	schoolEstablishedYear INT, 

	CONSTRAINT pk_School_schoolID PRIMARY KEY (schoolID)
);

CREATE TABLE [InsightHarbor.Program] (
	programID CHAR(8) NOT NULL,
	programName VARCHAR(100) NOT NULL,
	programType VARCHAR(20),
	programYear VARCHAR(20) NOT NULL, -- eg: Fall 2023
	programDirector VARCHAR(20),
	programDuration INT, -- eg: 16 months for MSIS program
	programInStateTuition DECIMAL(6,2),
	programOutStateTuition DECIMAL(6,2),
	programMinimumTOEFL INT,
	schoolID CHAR(4) NOT NULL,

	CONSTRAINT pk_Program_programID PRIMARY KEY (programID),

	CONSTRAINT fk_Program_schoolID FOREIGN KEY (schoolID)
		REFERENCES [InsightHarbor.School] (schoolID)
		ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE [InsightHarbor.Faculty] (

	facultyID CHAR(9) NOT NULL, 
	facultyFirstName VARCHAR(20), 
	facultyLastName VARCHAR(20),  
	facultyWorkExperience INT, 
	facultyEducation VARCHAR(200), 
	facultyPhoneNumber CHAR(10),
	facultyEmailAddress VARCHAR(30),

	CONSTRAINT pk_Faculty_facultyID PRIMARY KEY (facultyID)
);


CREATE TABLE [InsightHarbor.Course] (
	courseID CHAR(4) NOT NULL,
	courseCode VARCHAR(8), 
	courseName VARCHAR(100),
	courseSemester VARCHAR(6),
	courseYear INT,
	courseCredits INT, 
	programID CHAR(8) NOT NULL,
	facultyID CHAR(9),

	CONSTRAINT pk_Course_courseID_programID PRIMARY KEY (courseID, programID),

	CONSTRAINT fk_Course_programID FOREIGN KEY (programID) 
		REFERENCES [InsightHarbor.Program] (programID)
		ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT fk_Course_facultyID FOREIGN KEY (facultyID)
		REFERENCES [InsightHarbor.Faculty] (facultyID)
		ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE [InsightHarbor.Alumni] (
	alumniID INT NOT NULL,
	alumniFirstName VARCHAR(20) NOT NULL,
	alumniLastName VARCHAR(20) NOT NULL,
	alumniJobRole VARCHAR(50),
	alumniEmployer VARCHAR(50),
	alumniGraduationYear INT,
	programID CHAR(8),

	CONSTRAINT pk_Alumni_alumniID PRIMARY KEY (alumniID),

	CONSTRAINT fk_Alumni_programID FOREIGN KEY (programID)
		REFERENCES [InsightHarbor.Program] (programID)
		ON DELETE NO ACTION ON UPDATE CASCADE
);


CREATE TABLE [InsightHarbor.RankSource] (
	sourceID CHAR(3) NOT NULL, 
	sourceName VARCHAR(30), 
	
	CONSTRAINT pk_RankSource_sourceID PRIMARY KEY (sourceID)
);

CREATE TABLE [InsightHarbor.Rank] (

	sourceID CHAR(3) NOT NULL, 
	programID CHAR(8) NOT NULL, 
	programRank INT NOT NULL,

	CONSTRAINT pk_Rank_sourceID_programID PRIMARY KEY (sourceID, programID),

	CONSTRAINT fk_Rank_sourceID FOREIGN KEY (sourceID)
		REFERENCES [InsightHarbor.RankSource] (sourceID)
		ON DELETE NO ACTION ON UPDATE CASCADE,

	CONSTRAINT fk_Rank_programID FOREIGN KEY (programID)
		REFERENCES [InsightHarbor.Program] (programID)
		ON DELETE NO ACTION ON UPDATE CASCADE
);





