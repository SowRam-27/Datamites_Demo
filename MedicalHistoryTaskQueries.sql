select * from admissions;
select * from doctors;
select * from patients;
select * from province_names;
-- Show first name, last name, and gender of patients whose gender is 'M'--
select first_name,last_name,gender from patients where gender='M';

/*Show first name and last name of patients who do not have allergies*/
select first_name,last_name from patients where allergies is null or allergies='';

/*Show first name of patients that start with the letter 'C'*/
select first_name from patients where first_name like 'C%';

/*Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)*/
select first_name,last_name from patients where weight between 100 and 120;

/*Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'*/
update patients set allergies='' where allergies='NKA';
update patients set allergies='NKA' where allergies='' or allergies is null;

/*Show first name and last name concatenated into one column to show their full name*/
select first_name,last_name, concat(first_name,' ',last_name) as full_name from patients;

/*Show first name, last name, and the full province name of each patient*/
select first_name,last_name,province_name from patients left join province_names on patients.province_id=province_names.province_id;

/*Show how many patients have a birth_date with 2010 as the birth year*/
select count(*) from patients where birth_date like '%2010%';
                     -- (or)--
select count(*) from patients where year(birth_date)='2010';

/*Show the first_name, last_name, and height of the patient with the greatest height*/
select first_name,last_name,height from patients order by height desc limit 1;

/*Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000*/
select * from patients where patient_id in(1,45,534,879,1000);

/*Show the total number of admissions*/
select count(*) from admissions;

/* Show all the columns from admissions where the patient was admitted and discharged on the same day*/
select * from admissions where admission_date=discharge_date;

/* Show the total number of admissions for patient_id 579*/
select count(*) from admissions where patient_id=579;

/*Based on the cities that our patients live in, show unique cities that are in province_id 'NS'*/
select distinct(city) from patients where province_id='NS';
select distinct city from patients; /* Total different cities */

/* Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70 */
select first_name, last_name,birth_date from patients where height>160 and weight>70;

/*Show unique birth years from patients and order them by ascending*/
select distinct year(birth_date) as birth_year from patients order by birth_year ASC;

/* Show unique first names from the patients table which only occurs once in the list */
select distinct first_name from patients group by first_name having count(first_name)=1;
                             /* (or) */
select  first_name from patients group by  first_name having COUNT(*) = 1;

/* Show patient_id a nd first_name from patients where their first_name starts and ends with 's' and is at least 6 characters long */
select patient_id, first_name from patients where first_name like 's%s' having length(first_name)>=6; /* or */
select patient_id, first_name from patients where first_name like 's%' and first_name like '%s' and length(first_name)>=6;

/* Show patient_id, first_name, last_name from patients whose diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table */
select p.patient_id, p.first_name, p.last_name, a.diagnosis from patients as p join admissions as a on p.patient_id=a.patient_id where a.diagnosis='Dementia';

/* Display every patient's first_name. Order the list by the length of each name and then by alphabetically */
select first_name from patients order by length(first_name), first_name;

/* Show the total number of male patients and the total number of female patients in the patients table. Display the two results in the same row */
select sum(case when gender='M' then 1 else 0 end) as male_patients, sum(case when gender='F' then 1 else 0 end) as female_patients  from patients;

/*Show the total number of male patients and the total number of female patients in the patients table. Display the two results in the same row*/
select sum(case when gender='M' then 1 else 0 end) as Male_Patients,sum(case when gender='F' then 1 else 0 end) as Female_Patients from patients;

/* Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis */
select patient_id,diagnosis from admissions group by patient_id,diagnosis having count(*)>1;

/*  Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending */
select city,count(*) as total_patients from patients group by city order by total_patients DESC,city ASC;

/* Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor" */
select first_name,last_name, "Patient" as role from patients union all select first_name, last_name , "Doctor" as role from doctors;

/* Show all allergies ordered by popularity. Remove NULL values from the query */
select allergies, count(patient_id) as popularity from patients where patient_id is not null group by allergies order by popularity DESC;

/* Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date */
select first_name, last_name,birth_date from patients where year(birth_date)='1970' order by birth_date ASC;
/* or */
select first_name, last_name,birth_date from patients where year(birth_date) between '1970-01-01' and '1970-12-31' order by birth_date ASC;

/* We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower 
case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in descending order EX: SMITH,jane*/
select concat(upper(last_name),',',lower(first_name)) as full_name from patients order by lower(first_name) DESC;

/* Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000 */
select province_id,sum(height) as sum_of_height from patients group by province_id having sum(height)>=7000;

/* Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni' */
select max(weight)-min(weight) as weight_difference from patients where last_name like '%Maroni%'; /* OR */
select max(weight)-min(weight) as weight_difference from patients where last_name ='Maroni';

/* Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions */
select day(admission_date) as day_of_month,count(*) as admission_count from admissions group by day_of_month order by day_of_month DESC;

/* Show all of the patients grouped into weight groups. Show the total number of patients in each weight group. Order the list by the weight group
descending. e.g. if they weigh 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc */
select count(*) as total_patients, case when weight between 100 and 109 then '100_weight_group'
										when weight between 110 and 119 then '110_weight_group'
                                        when weight between 120 and 129 then '120_weight_group'
                                        when weight between 130 and 139 then '130_weight_group'
                                        when weight between 140 and 149 then '140_weight_group'
                                        when weight between 150 and 159 then '150_weight_group'
                                        else 'other_group' 
									end as weight_group
from patients group by weight_group order by weight_group DESC;

/* Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m).
Weight is in units kg. Height is in units cm */
select patient_id,weight,height, case when weight/((height/100)*(height/100))>30 then 1 else 0 end as isObese from patients;

/* Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first
name is 'Lisa'. Check patients, admissions, and doctors tables for required information*/
select 
	p.patient_id,
	p.first_name,
	p.last_name,
	d.specialty 
from
	patients as p 
join
    admissions as a on p.patient_id=a.patient_id 
join 
	doctors as d on a.attending_doctor_id=d.doctor_id
where 
	a.diagnosis='Epilepsy' and d.first_name='Lisa';
    
/* All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after
their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
- patient_id
- the numerical length of patient's last_name
- year of patient's birth_date */
select patient_id, concat(patient_id, length(last_name), year(birth_date)) as temp_password from  patients 
where patient_id in (select distinct patient_id from admissions);
