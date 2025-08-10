select * from  pan_numbers_dataset

--  Identify and handle missing data:
select * from pan_numbers_dataset
where pan_number is not null

-- Check for duplicates:
select distinct pan_number from pan_numbers_dataset

-- Handle leading/trailing spaces: 
select * from pan_numbers_dataset
where  pan_number = trim(pan_number)

-- Correct letter case: 
select * from pan_numbers_dataset
where pan_number = upper(pan_number)


-- Cleaned Pan_Number

select distinct upper(trim(pan_number)) as pan_number
from pan_numbers_dataset
where pan_number is not null
and trim(pan_number) != ''


-- function to check if adjacent characters are the same 

create or replace function fn_check_adjacent_characters (p_str text)
returns boolean
language plpgsql
as $$
begin
    for i in 1 .. (length(p_str) -1)
	loop
	    if substring(p_str, i, 1) = substring(p_str, 1+1, i)
		then
		    return true;  -- the characters are adjacent
		end if;
	end loop;
	return false;  -- non of the character adjacent to each other were the same
end;
$$


select fn_check_adjacent_characters('HEEST')



-- fuction to check if sequencial characters are used

create or replace function fn_check_sequencial_characters (p_str text)
returns boolean
language plpgsql
as $$
begin
    for i in 1 .. (length(p_str) -1)
	loop
	    if ascii(substring(p_str, i+1, 1)) - ascii(substring(p_str, i, 1)) != 1
		then
		    return false;  -- string doesn't form the sequence
		end if;
	end loop;
	return true;  -- the string is forming sequence	    
end;
$$

select fn_check_sequencial_characters('ABGDE')


-- Regular expression to validate tehe pattern or structure of Pan Numbers - AGDXV7248H 

select * from pan_numbers_dataset
where pan_number ~'^[A-Z]{5}[0-9]{4}[A-Z]$'


-- Valid and invalid PAN categorization
create or replace view vw_valid_invalid_pans
as 
with cte_cleaned_pan as
    (select distinct upper(trim(pan_number)) as pan_number
    from pan_numbers_dataset
    where pan_number is not null
    and trim(pan_number) != ''),

	cte_valid_pan as
	(
    select * from cte_cleaned_pan
	where fn_check_adjacent_characters(pan_number) = false
	and fn_check_sequencial_characters(substring(pan_number, 1,5)) = false
	and fn_check_sequencial_characters(substring(pan_number, 1,4)) = false
	and pan_number ~'^[A-Z]{5}[0-9]{4}[A-Z]$'
	)

select cln.pan_number,
case when vld.pan_number is not null 
         then 'Valid PAN'
		 else 'Invalid PAN' 
end as status
from cte_cleaned_pan as cln
left join cte_valid_pan as vld on vld.pan_number = cln.pan_number


-- Summary report

with cte as (
    select 
        (select count(*) from pan_numbers_dataset) as total_processed_records,
	    count(*) filter (where status = 'Valid PAN') as total_valid_pans,
	    count(*) filter (where status = 'Invalid PAN') as total_invalid_pans
    from vw_valid_invalid_pans)

select 
total_processed_records,
total_valid_pans,
total_invalid_pans,
(total_processed_records - (total_valid_pans + total_invalid_pans)) as  missing_incomplete_pans
from cte
