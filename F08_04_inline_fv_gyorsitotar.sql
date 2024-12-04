SELECT * FROM SH.sales s;
/
CREATE OR REPLACE FUNCTION SH.unit_price(p_quantity_sold NUMBER, p_amount_sold NUMBER)
RETURN NUMBER IS
    i NUMBER; s NUMBER := 0;
BEGIN
    FOR i IN 1..100 LOOP s := s + i; END LOOP;
    RETURN p_amount_sold / p_quantity_sold;
END;
/
--FOR ciklus nélkül: 39.6s
--FOR ciklussal: 55.5s
SELECT AVG(SH.unit_price(s.quantity_sold, s.amount_sold)) FROM SH.sales s;
/
CREATE OR REPLACE FUNCTION SH.unit_price_rc(p_quantity_sold NUMBER, p_amount_sold NUMBER)
RETURN NUMBER RESULT_CACHE IS
    i NUMBER; s NUMBER := 0;
BEGIN
    FOR i IN 1..100 LOOP s := s + i; END LOOP;
    RETURN p_amount_sold / p_quantity_sold;
END;
/
--FOR ciklus nélkül: 42.6s
--FOR ciklussal: 42.4s   -> 3586x meghívta a függvényt, 918.000-3.586 alkalommal cache-bõl dolgozott
SELECT AVG(SH.unit_price_rc(s.quantity_sold, s.amount_sold)) FROM SH.sales s;
/
SELECT * FROM V$RESULT_CACHE_OBJECTS WHERE NAME LIKE '%UNIT_PRICE_RC%'; --3587 sor

SELECT DISTINCT s.quantity_sold, s.amount_sold FROM SH.sales s; --3586 sor

ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;

BEGIN
  DBMS_RESULT_CACHE.FLUSH;
END;  
/
--INLINE FOR ciklussal: 15s
--INLINE FOR ciklus nélkül: 1.3s
WITH FUNCTION unit_price_inline(p_quantity_sold NUMBER, p_amount_sold NUMBER)
RETURN NUMBER IS
    --i NUMBER; s NUMBER := 0;
BEGIN
    --FOR i IN 1..100 LOOP s := s + i; END LOOP;
    RETURN p_amount_sold / p_quantity_sold;
END;
SELECT AVG(unit_price_inline(s.quantity_sold, s.amount_sold)) FROM SH.sales s;
/
--0.8s
SELECT AVG(s.amount_sold / s.quantity_sold) FROM SH.sales s;

