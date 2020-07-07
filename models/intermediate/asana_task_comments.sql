with comments as (
    
    select *
    from {{ ref('asana_task_story') }}
    where comment_content is not null
    order by target_task_id, created_at asc

),

task_conversation as (

    {% set commented_at =  'comments.created_at'|string %}

    select
        target_task_id as task_id,
        -- creates a chronologically ordered conversation about the task
        {{ string_agg( "concat( created_at, '  -  ', created_by_name, ':  ', comment_content)" , "''\n") }} as conversation,

        count(*) as number_of_comments,
        count(distinct created_by_user_id) as number_of_authors 

    from comments        
    group by 1
)

select * from task_conversation
