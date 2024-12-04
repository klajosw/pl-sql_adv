--SYS (TRAINING) felhasználóval
C:\Installs\WINDOWS.X64_193000_db_home\rdbms\admin

create table sys.plsql_trace_runs
(
  runid           number primary key,  -- unique run identifier,
                                       -- from plsql_trace_runnumber
  run_date        date,                -- start time of run
  run_owner       varchar2(31),        -- account under which run was made
  run_comment     varchar2(2047),      -- user provided comment for this run
  run_comment1    varchar2(2047),      -- additional user-supplied comment
  run_end         date,                -- termination time for this run
  run_flags       varchar2(2047),      -- flags for this run
  related_run     number,              -- for correlating client/server   
  run_system_info varchar2(2047),      -- currently unused
  spare1          varchar2(256)        -- unused
);

create table sys.plsql_trace_events
(
  runid           number references sys.plsql_trace_runs,--  run identifier
  event_seq       number,           -- unique sequence number within run
  event_time      date,             -- timestamp
  related_event   number,
  event_kind      number,
  event_unit_dblink varchar2(4000),
  event_unit_owner varchar2(31),
  event_unit      varchar2(31),     -- unit where the event happened
  event_unit_kind varchar2(31),
  event_line      number,           -- line in the unit where event happened
  event_proc_name varchar2(31),     -- if not empty, procedure where event 
                                    -- happened
  stack_depth     number,
--
-- Fields that apply to procedure calls
  proc_name       varchar2(31),     -- if not empty, name of procedure called
  proc_dblink     varchar2(4000),
  proc_owner      varchar2(31),
  proc_unit       varchar2(31),
  proc_unit_kind  varchar2(31),
  proc_line       number,
  proc_params     varchar2(2047),
--
-- Fields that apply to ICDs (Calls to PL/SQL internal routines)
  icd_index       number,         
--
-- Fields that apply to exceptions
  user_excp       number,
  excp            number,
--
-- Field for comments
--     User defined event - text supplied by user
--     SQL event          - actual SQL string
--     Others             - Description of event 
  event_comment   varchar2(2047),
----
-- Fields for bulk binds
-- ?
--
-- Fields from dbms_application_info, dbms_session, and ECID
  module          varchar2(4000),
  action          varchar2(4000),
  client_info     varchar2(4000),
  client_id       varchar2(4000),
  ecid_id         varchar2(4000),
  ecid_seq        number,
--
--
-- Fields for extended callstack and errorstack info
--  (currently set only for "Exception raised", "Exception handled" and "Trace
--  flags changed" ([5066528]) events)
--
  callstack       clob,
  errorstack      clob,
--
  primary key(runid, event_seq)
);

create sequence sys.plsql_trace_runnumber start with 1 nocache;

GRANT SELECT ON sys.plsql_trace_events TO SYSTEM;
GRANT SELECT ON sys.plsql_trace_runs TO SYSTEM;
/
--SYSTEM userrel
BEGIN
    DBMS_TRACE.SET_PLSQL_TRACE(
        DBMS_TRACE.TRACE_ALL_CALLS + 
        DBMS_TRACE.TRACE_ALL_SQL +
        DBMS_TRACE.TRACE_ALL_EXCEPTIONS +
        DBMS_TRACE.TRACE_ALL_LINES);
END;        
/
SELECT * FROM SCOTT.emp e;
SELECT * FROM SCOTT.salgrade sg;
SELECT COUNT(*) FROM SH.costs;
UPDATE OE.customers SET credit_limit = credit_limit / 2;
SELECT * FROM SCOTT.dept d;
DELETE FROM SCOTT.dept WHERE deptno = 40;
SELECT SCOTT.topnsal(10) FROM DUAL;
/
BEGIN
    SCOTT.topnsal_caller;
END;
/
BEGIN
    DBMS_TRACE.CLEAR_PLSQL_TRACE;
END;
/
SELECT * FROM sys.plsql_trace_runs;
SELECT TO_CHAR(event_time, 'YYYY.MM.DD HH24:MI:SS') FROM sys.plsql_trace_events;
SELECT * FROM sys.plsql_trace_events;

