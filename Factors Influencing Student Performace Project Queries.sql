-- Analysis on Factors Influence Student Academic Performance 

-- Academic Performance
-- What is the average GPA based on parental education levels?
SELECT parent_inf.parental_edu, 
	ROUND(AVG(acad_perf.gpa), 2) AS average_gpa
FROM acad_performance AS acad_perf
JOIN parental_influence AS parent_inf
ON acad_perf.student_id = parent_inf.student_id
GROUP BY 1
ORDER BY 2 DESC;

-- How does weekly study time affect GPA?
SELECT ROUND(study_habits.study_time_weekly, 0) AS hours_studying_weekly, 
	ROUND(AVG(acad_perf.gpa), 2) AS average_gpa
FROM study_habits
JOIN acad_performance AS acad_perf
ON study_habits.student_id = acad_perf.student_id
GROUP BY 1
ORDER BY 1 DESC;


-- Attendance and Performance
-- Is there a correlation between absences and GPA?
SELECT absences AS num_of_absences, 
	ROUND(AVG(gpa), 2) AS average_gpa
FROM acad_performance
GROUP BY 1
ORDER BY 1;


-- Lifestyle and Activities
-- How is GPA affected if students are involved in activities?
SELECT
	(CASE WHEN activities.extracurricular = 'yes' THEN 1 ELSE 0 END + 
    CASE WHEN activities.sports = 'yes' THEN 1 ELSE 0 END + 
    CASE WHEN activities.music = 'yes' THEN 1 ELSE 0 END + 
    CASE WHEN activities.volunteering = 'yes' THEN 1 ELSE 0 END) AS activity_count,
    ROUND(AVG(acad_perf.gpa), 2) AS average_gpa
FROM activities
JOIN acad_performance AS acad_perf
ON activities.student_id = acad_perf.student_id
GROUP BY 1
ORDER BY 2 DESC;

-- Comparison of academic performance between students participating
-- in sports and volunteering.
SELECT
	CASE
		WHEN activities.sports = 'yes' THEN 'student participates in sports'
        WHEN activities.volunteering = 'yes' THEN 'student volunteers'
        WHEN activities.sports = 'yes' AND activities.volunteering = 'yes'
        THEN 'student participates in sports and volunteers'
        ELSE "student doesn't participate in sports or volunteers"
        END AS sports_and_vol_participation,
        ROUND(AVG(acad_performance.gpa), 2) AS average_gpa
FROM activities
JOIN acad_performance
ON activities.student_id = acad_performance.student_id
GROUP BY 1
ORDER BY 2 DESC;


-- Parental Influence
-- Does parental support correlate with reduced absences or higher GPA?
SELECT parental_influence.parental_supp, 
	acad_performance.absences AS num_of_absences,
    ROUND(AVG(acad_performance.gpa), 2) AS average_gpa
FROM parental_influence
JOIN acad_performance
ON parental_influence.student_id = acad_performance.student_id
GROUP BY 1, 2
HAVING parental_influence.parental_supp = 'very high' OR 
	parental_influence.parental_supp = 'high'
ORDER BY 2, 3 DESC;

-- What are the differences in GPA based on ethnicity and parental education?
SELECT students.ethnicity, parental_influence.parental_edu,
	ROUND(AVG(acad_performance.gpa), 2) AS average_gpa
FROM students
JOIN parental_influence
ON students.student_id = parental_influence.student_id
JOIN acad_performance
ON parental_influence.student_id = acad_performance.student_id
GROUP BY 1, 2
ORDER BY 3 DESC;