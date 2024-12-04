SELECT ORA_HASH(e.ename), e.ename FROM SCOTT.emp e;
/
SELECT DISTINCT o.order_mode FROM OE.orders o;
/
CREATE TABLE OE.orders_listpart
PARTITION BY LIST (order_mode) AUTOMATIC 
(   PARTITION order_mode_direct VALUES ('direct'),
    PARTITION order_mode_online VALUES ('online'))
AS SELECT * FROM OE.orders;
/
CREATE TABLE OE.orders_hashpart
PARTITION BY HASH (order_id) PARTITIONS 4
AS SELECT * FROM OE.orders;
/
CREATE TABLE SH.sales_rangepart
PARTITION BY RANGE (time_id) 
(   PARTITION sales_time_id_pre1999 VALUES LESS THAN (DATE '1999-01-01'),
    PARTITION sales_time_id_1999    VALUES LESS THAN (DATE '2000-01-01'),
    PARTITION sales_time_id_2000    VALUES LESS THAN (DATE '2001-01-01'),
    PARTITION sales_time_id_rest    VALUES LESS THAN (MAXVALUE))
AS SELECT * FROM SH.sales;
/
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS('OE', 'ORDERS_LISTPART');
    DBMS_STATS.GATHER_TABLE_STATS('OE', 'ORDERS_HASHPART');
    DBMS_STATS.GATHER_TABLE_STATS('SH', 'SALES_RANGEPART');
END;   
/
SELECT * FROM DBA_PART_TABLES WHERE OWNER IN ('OE', 'SH');
SELECT * FROM DBA_TAB_PARTITIONS WHERE TABLE_OWNER IN ('OE', 'SH');
/
SELECT * FROM SH.sales_rangepart s WHERE s.time_id = DATE '1998-01-10'; --egyetlen partícióból dolgozik (1.)
SELECT * FROM SH.sales_rangepart s WHERE s.time_id = DATE '2001-01-10'; --egyetlen partícióból dolgozik (4.)
SELECT * FROM SH.sales_rangepart s WHERE s.time_id >= DATE '1998-12-10' AND s.time_id <= DATE '1999-01-31';
--kettõ partícióból dolgozik (1-2.)
SELECT * FROM SH.sales_rangepart s WHERE EXTRACT(YEAR FROM s.time_id) = 1998; --nincs pruning, mindegyiket használja

--explicit partíció elõírás
SELECT * FROM SH.sales_rangepart PARTITION (sales_time_id_pre1999) s WHERE EXTRACT(YEAR FROM s.time_id) = 1998;
--"hibásan" megadott explicit partíció
SELECT * FROM SH.sales_rangepart PARTITION (sales_time_id_1999) s WHERE EXTRACT(YEAR FROM s.time_id) = 1998;