/* ---
SELECT
    empno,
    ename,
    job,
    mgr,
    hiredate,
    sal,
    comm,
    deptno
FROM
    scott.emp e order by e.sal desc --offset 1 rows  fetch next 5 rows only
    offset 0 rows fetch next 2 rows with ties;
    */
----
create or replace function scott.topnsal(p_n number) return  number is 
   l_sum number(10,2);
begin
-- tanfolyamra készítet KL
 SELECT  SUM(sal) into l_sum from(
  SELECT * FROM  scott.emp e order by e.sal desc 
  offset 0 rows  fetch next p_n rows only );
  return l_sum;
End topnsal;
/
select scott.topnsal(3) FROM DUAL;

create or replace procedure scott.topnsal_caller is
begin
 dbms_output.put_line(scott.topnsal(10));
end topnsal_caller;
/
begin
   scott.topnsal_caller;
end;
---
select * from all_objects where owner ='SCOTT' and OBJECT_TYPE in ('FUNCTION', 'PROCEDURE')
---
alter procedure scott.topnsal_caller compile;
---
alter session set plsql_warnings='ENABLE:ALL';
---
select * from all_plsql_object_settings where owner ='SCOTT'
---
select * from all_identifiers where owner ='SCOTT'
--  
select * from all_statements where owner ='SCOTT'
---
show errors
show 
select * from all_users
select user from dual
select * from all_views where view_name like 'ALL%' order by 2
   

select * from ALL_ARGUMENTS
select * from ALL_CATALOG
select * from ALL_CONSTRAINTS
select * from ALL_HIERARCHIES
select * from SYS.SQLTXL$
 
















-----