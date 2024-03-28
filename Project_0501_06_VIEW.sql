USE [BUDT702_Project_0501_06]


-- 1. What is the total number of faculties possessing a PhD degree?
GO
DROP VIEW IF EXISTS FacultyWithPhD
GO
CREATE VIEW FacultyWithPhD AS 
	SELECT COUNT(*) AS 'Number Of Professors with PhD'
	FROM [InsightHarbor.Faculty]
	WHERE facultyEducation LIKE '%PhD%';
GO
SELECT *
FROM FacultyWithPhD


-- 2. What are the name, education, work experience, and contact details of the faculty members who are alumni of the University of Maryland?
GO
DROP VIEW IF EXISTS UMDAlumniFaculty
GO
CREATE VIEW UMDAlumniFaculty AS 
	SELECT f.facultyFirstName AS 'Faculty First Name', f.facultyLastName AS 'Faculty Last Name', 
		f.facultyWorkExperience AS 'Years of Experience', f.facultyEducation AS 'Education',
		f.facultyPhoneNumber AS 'Phone Number', f.facultyEmailAddress AS 'Email Address'
	FROM [InsightHarbor.Faculty] f
	WHERE LOWER(facultyEducation) LIKE '%university of maryland%';
GO
SELECT *
FROM UMDAlumniFaculty


-- 3. What is the total number of alumni for each program?
GO
DROP VIEW IF EXISTS NumberOfAlumni
GO
CREATE VIEW NumberOfAlumni AS 
	SELECT p.programName AS 'Program Name', COUNT(a.alumniID) AS 'Number of Alumni'
	FROM [InsightHarbor.Program] p 
		JOIN [InsightHarbor.Alumni] a ON p.programID = a.programID
	GROUP BY p.programName
GO
SELECT *
FROM NumberOfAlumni


-- 4. What are the rank sources, ranks, program names, program types, and program years for the Business Analytics program?
GO
DROP VIEW IF EXISTS DetailsOfMSBA
GO
CREATE VIEW DetailsOfMSBA AS 
SELECT p.programName AS 'Program Name', p.programYear AS 'Year of Program', 
	p.programType AS 'Type of Program', rs.sourceName AS 'Source of Rank', 
	r.programRank AS 'Rank of Program'
FROM [InsightHarbor.RankSource] rs
	JOIN [InsightHarbor.Rank] r ON rs.sourceID = r.sourceID
	JOIN [InsightHarbor.Program] p ON r.programID = p.programID
WHERE p.programName = 'MS in Business Analytics';
GO
SELECT *
FROM DetailsOfMSBA


-- 5. What is the average number of years of work experience for faculties in each program?
GO
DROP VIEW IF EXISTS AvgWorkExp
GO
CREATE VIEW AvgWorkExp AS 
	SELECT p.programName AS 'Program Name', AVG(f.facultyWorkExperience) AS 'Average Work Experience of Faculties'
	FROM [InsightHarbor.Faculty] f  
		INNER JOIN [InsightHarbor.Course] c ON f.facultyID = c.facultyID
		INNER JOIN [InsightHarbor.Program] p ON c.programID=p.programID
	GROUP BY p.programName
GO 
SELECT *
FROM AvgWorkExp
ORDER BY 'Average Work Experience of Faculties'



-- 6. What is the name and education of the faculties in the MS in Quantitative Finance and MS in Finance programs having a PhD in Finance?
GO
DROP VIEW IF EXISTS FacultyWithPhDinFinanceinMSQF
GO
CREATE VIEW FacultyWithPhDinFinanceinMSQF AS 
	SELECT p.programName AS 'Program Name', f.facultyFirstName+' '+ f.facultyLastName AS 'Name of Faculty', 
		f.facultyEducation AS 'Education'
	FROM [InsightHarbor.Program] p 
		INNER JOIN [InsightHarbor.Course] c ON p.programID = c.programID
		INNER JOIN [InsightHarbor.Faculty] f ON f.facultyID = f.facultyID
	WHERE p.programName = 'MS in Finance and MS in Quantitative Finance' 
	 AND f.facultyEducation LIKE '%PhD in Finance%'
	GROUP BY p.programName, f.facultyFirstName, f.facultyLastName, f.facultyEducation;
GO 
SELECT *
FROM FacultyWithPhDinFinanceinMSQF


-- 7. What are the details of the faculties in the MSMA program having a PhD in Marketing?
GO
DROP VIEW IF EXISTS PhDFacultyInMSMA
GO
CREATE VIEW PhDFacultyInMSMA AS 
	SELECT p.programName 'Program Name', f.facultyFirstName+' '+ f.facultyLastName AS 'Name of Faculty', 
		f.facultyEducation AS 'Education'
	FROM [InsightHarbor.Faculty] f  
	INNER JOIN [InsightHarbor.Course] c ON f.facultyID = c.facultyID
	INNER JOIN [InsightHarbor.Program] p ON c.programID = p.programID
	WHERE p.programName = 'MS in Marketing Analytics' 
	   AND f.facultyEducation LIKE '%PhD in Marketing%'
	GROUP BY p.programName, f.facultyFirstName, f.facultyLastName, f.facultyEducation;
GO 
SELECT *
FROM PhDFacultyInMSMA


-- 8. What are the new courses in the MSIS program offered for the Fall 2023 Batch that were not part of the curriculum for the Fall 2022 Batch?
GO
DROP VIEW IF EXISTS NewCoursesIn2023
GO
CREATE VIEW NewCoursesIn2023 AS 
	SELECT c.courseName AS 'Course Name',  
	c.courseSemester AS 'Course Semester', 
	c.courseYear AS 'Course Year'
	FROM [InsightHarbor.Course] c
	WHERE c.courseID IN (
			SELECT c1.courseID
			FROM [InsightHarbor.Course] c1
			WHERE c1.programID = 'BSMSIS02'
			EXCEPT
			SELECT c2.courseID
			FROM [InsightHarbor.Course] c2
			WHERE c2.programID = 'BSMSIS01');
GO 
SELECT *
FROM NewCoursesIn2023


-- 9. Which professor teaches how many courses in 2022 and 2023?
GO
DROP VIEW IF EXISTS CoursesTaughtByProf
GO
CREATE VIEW CoursesTaughtByProf AS 
	SELECT f.facultyFirstName+' '+ f.facultyLastName AS 'Name of Faculty', 
		   COUNT(c.courseID) AS 'Number of Courses'
	FROM [InsightHarbor.Faculty] f
	JOIN [InsightHarbor.Course] c 
	ON f.facultyID = c.facultyID
	WHERE (c.courseYear = 2022 OR c.courseYear = 2023)
	GROUP BY f.facultyFirstName, f.facultyLastName
GO 
SELECT *
FROM CoursesTaughtByProf
ORDER BY 'Number of Courses' DESC;


-- 10. What is the total number of alumni for each program as per the year and batch?
GO
DROP VIEW IF EXISTS AlumniPerBatchYear
GO
CREATE VIEW AlumniPerBatchYear AS 
	SELECT TOP 100 PERCENT
		COALESCE(p.programID, 'Data Unavailable') AS programID,
		COALESCE(p.programName, 'Data Unavailable') AS 'Program Name',
		COALESCE(p.programYear, 'Data Unavailable') AS 'Year of Program',
		COUNT(a.alumniID) AS 'Number of Alumni'
	FROM [InsightHarbor.Alumni] a
	LEFT JOIN [InsightHarbor.Program] p ON p.programID = a.programID
	GROUP BY 
		COALESCE(p.programID, 'Data Unavailable'),
		COALESCE(p.programName, 'Data Unavailable'),
		COALESCE(p.programYear, 'Data Unavailable')
GO 
SELECT *
FROM AlumniPerBatchYear
ORDER BY 'Number of Alumni' DESC;


-- 11. Which Smith school programs were ranked under the top 10 over the years?
GO
DROP VIEW IF EXISTS TopTenPrograms
GO
CREATE VIEW TopTenPrograms AS
	  SELECT p.programName AS 'Program Name', 
	  p.programYear AS 'Year of Program', 
	  r.programRank AS 'Rank of Program'
	  FROM [InsightHarbor.Rank] r 
	  INNER JOIN [InsightHarbor.Program] p
	  ON p.programID = r.programID
	  WHERE programRank < 10  
GO 
SELECT *
FROM TopTenPrograms
ORDER BY 'Rank of Program'


-- 12. Who are the employers of the Smith School of Business?
GO
DROP VIEW IF EXISTS EmployersOfSmith
GO
CREATE VIEW EmployersOfSmith AS
	SELECT a.alumniEmployer AS 'Employer Company', COUNT(a.alumniID) AS 'Number of Alumni'
	FROM [InsightHarbor.Alumni] a
	GROUP BY a.alumniEmployer  
GO
SELECT * 
FROM EmployersOfSmith
ORDER BY 'Number of Alumni' DESC

-- 13. What is the tuition fee for the courses offered in Fall 2023?
GO
DROP VIEW IF EXISTS TuitionFeesFall2023
GO
CREATE VIEW TuitionFeesFall2023 AS
	SELECT p.programName AS 'Program Name', p.programType AS 'Type of Program', 
		30*p.programOutStateTuition AS 'Tuition Fees for out-state students',
		30*p.programInStateTuition AS 'Tuition Fees for in-state students'
	FROM [InsightHarbor.Program] p
	WHERE p.programYear = 'Fall 2023'
GO
SELECT * 
FROM TuitionFeesFall2023