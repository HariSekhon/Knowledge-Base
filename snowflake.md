# Snowflake

## SnowPipe

```sql
--use role snowpipe_role;
use database demo_db;

create or replace stage demo_db.public.snowstage
    url='s3://snowflake-oregon/'
    credentials = (AWS_KEY_ID = '...' AWS_SECRET_KEY = '...' );
show stages;

list @snowstage;

-- Create target table for JSON data
create or replace table public.twitter(json variant);
show tables;

-- Create a pipe to ingest JSON data
create or replace pipe public.snowpipe auto_ingest=true as
    copy into public.twitter
    from @public.snowstage
    file_format = (type = 'JSON');

-- Create a pipe to ingest JSON data
create or replace pipe public.snowpipe2 auto_ingest=true as
    copy into public.twitter
    from @public.snowstage/twitter
    file_format = (type = 'JSON');

show pipes;
show pipes;

--Check COPY_HISTORY
select *
from table(information_schema.copy_history(table_name=>'twitter', start_time=> dateadd(hours, -1, current_timestamp())));

select count(*) from  public.twitter;


select
to_date(json:created_at) date_id,
json:user:name::string user_name,
coalesce(json:extended_tweet:full_text::string, json:text::string) tweet
from public.twitter;

--S3 > COPY INTO TARGET, THEN delete to remove duplicates


-- REQUIRMENT: Top Hashtags
SELECT
--to_date(json:created_at) date_id,
--substring(json:created_at::string, 12,5) time_id,
a.value:text::string hashtag,
count(*)
FROM tweets,
lateral flatten( input => json:entities:hashtags ) a
GROUP BY 1
ORDER BY 2 desc
;
```
