CREATE OR REPLACE TYPE MultipFunc AS OBJECT
(
  multip NUMBER,

  STATIC FUNCTION ODCIAggregateInitialize(actx IN OUT MultipFunc) 
  RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateIterate(self IN OUT MultipFunc, val NUMBER)
  RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateMerge(self IN OUT MultipFunc, ctx2 IN MultipFunc) RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateTerminate(self IN MultipFunc, ReturnValue OUT NUMBER, flags IN number) RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY MultipFunc AS
STATIC FUNCTION ODCIAggregateInitialize(actx IN OUT MultipFunc)RETURN NUMBER IS BEGIN
    actx   := MultipFunc( NULL );    
    RETURN ODCIConst.Success;   --1x fut le
END;   
MEMBER FUNCTION ODCIAggregateIterate(self IN OUT MultipFunc, val NUMBER) RETURN NUMBER IS BEGIN
    IF val is NOT NULL THEN  --minden rekordra kulon lefut
      IF 
        self.multip IS NULL THEN self.multip := val;
      ELSE 
        self.multip := self.multip * val; 
      END IF;
    END IF;    
    RETURN ODCIConst.Success;
END;
MEMBER FUNCTION ODCIAggregateMerge(self IN OUT MultipFunc, ctx2 IN MultipFunc) RETURN NUMBER IS BEGIN
    IF ctx2.multip IS NOT NULL THEN 
      self.multip := NVL(self.multip * ctx2.multip, ctx2.multip);
    END IF;    
    RETURN ODCIConst.Success;
END;
MEMBER FUNCTION ODCIAggregateTerminate(self IN MultipFunc, ReturnValue OUT NUMBER, flags IN number) RETURN NUMBER IS BEGIN
    ReturnValue := self.multip;    
    RETURN ODCIConst.Success;
END; END;
/
CREATE OR REPLACE FUNCTION multiply(v NUMBER) RETURN NUMBER
AGGREGATE USING MultipFunc;
/
SELECT * FROM SCOTT.dept;
SELECT multiply(deptno), SUM(deptno), MAX(deptno) FROM SCOTT.dept;
SELECT multiply(deptno) FROM SCOTT.dept WHERE deptno < 10;
SELECT multiply(deptno) FROM SCOTT.dept WHERE deptno = 10;




