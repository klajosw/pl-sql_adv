SELECT * FROM OE.orders o WHERE o.order_id = 2458;
SELECT SUM(oi.quantity * oi.unit_price) FROM OE.order_items oi WHERE oi.order_id = 2458;
--78279.6

UPDATE OE.orders o
SET order_total = 
    (SELECT SUM(oi.quantity * oi.unit_price) FROM OE.order_items oi WHERE oi.order_id = o.order_id)
WHERE order_id = 2458;
/
CREATE OR REPLACE TRIGGER OE.tr_order_items_recalc
AFTER INSERT OR UPDATE OR DELETE ON OE.order_items FOR EACH ROW
BEGIN
    UPDATE OE.orders o
    SET order_total = 
        (SELECT SUM(oi.quantity * oi.unit_price) FROM OE.order_items oi WHERE oi.order_id = o.order_id)
    WHERE order_id IN (:new.order_id, :old.order_id);
END;
/
UPDATE OE.order_items SET quantity = quantity * 2 WHERE order_id = 2458;
--ORA-04091: table OE.ORDER_ITEMS is mutating, trigger/function may not see it
/*
1. Kiindulo allapot
order_id    line_item_id    quantity    unit_price
2458        1               1           10
2458        2               2           20
order_total = 50
2. For each row, elso lefutas
order_id    line_item_id    quantity    unit_price
2458        1               2           10
2458        2               2           20
order_total = 60
3. For each row, masodik lefutas
order_id    line_item_id    quantity    unit_price
2458        1               2           10
2458        2               4           20
order_total = 100
*/
DROP TRIGGER OE.tr_order_items_recalc;
/
CREATE OR REPLACE TRIGGER OE.tr_order_items_recalc2
FOR INSERT OR UPDATE OR DELETE ON OE.order_items COMPOUND TRIGGER
--közös deklarációs rész
    TYPE t_idlist IS TABLE OF NUMBER(6) INDEX BY PLS_INTEGER;
    l_idlist t_idlist;
AFTER EACH ROW IS BEGIN
    IF INSERTING OR UPDATING THEN
        l_idlist(:new.order_id) := :new.order_id;
    END IF;    
    IF DELETING OR UPDATING THEN
        l_idlist(:old.order_id) := :old.order_id;
    END IF;    
END AFTER EACH ROW;
AFTER STATEMENT IS  --lokális deklarációs rész erre a triggerre
    l_order_id NUMBER(6);
BEGIN
    l_order_id := l_idlist.FIRST;
    WHILE l_order_id IS NOT NULL LOOP
        UPDATE OE.orders o
        SET order_total = 
            (SELECT SUM(oi.quantity * oi.unit_price) FROM OE.order_items oi WHERE oi.order_id = o.order_id)
        WHERE order_id IN (l_order_id);
        l_order_id := l_idlist.NEXT(l_order_id); --adott kulcsot követõ kulcs lekérése
    END LOOP;
END AFTER STATEMENT;
END;
/



