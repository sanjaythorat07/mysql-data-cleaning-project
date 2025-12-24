use world_layout;

SELECT * 
FROM layoffs;

#DATA Cleaning
#1 Remove Duplicates
#2 Standardize Data
#3 NULL Values 
#4 Remove Any columns

create table layoffs_staging
like layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;


SELECT * ,
row_number() over(
partition by company,industry,date,country,funds_raised_millions,total_laid_off, percentage_laid_off,`date`) AS row_num
FROM layoffs_staging;

with duplicate_cte as
(
SELECT * ,
row_number() over(
partition by company,location,date,country,funds_raised_millions,industry,total_laid_off, percentage_laid_off,`date`) AS row_num
FROM layoffs_staging
)
select *
from duplicate_cte
where row_num >1 ;

select *
from layoffs_staging
where company ='Casper';


# standardizing data

select company , (trim(company))
from layoffs_staging;


SELECT @@sql_safe_updates;


SET SQL_SAFE_UPDATES = 0;


update layoffs_staging
set company = trim(company);

select distinct country, trim(trailing '.' from country)
from layoffs_staging;

update layoffs_staging
set country = trim(trailing '.' from country)
where country like 'United States%';

select `date`
from layoffs_staging;

update layoffs_staging
set `date` = str_to_date(`date`,'%m/%d/%Y');


ALTER table layoffs_staging
modify column `date` DATE;

select *
from layoffs_staging
where total_laid_off is null
and total_laid_off is null ;


select *
from layoffs_staging

