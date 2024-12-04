BEGIN
    DBMS_DDL.CREATE_WRAPPED('
CREATE OR REPLACE FUNCTION SCOTT.topnsal(p_n NUMBER) RETURN NUMBER IS
    l_sum NUMBER(10,2);
BEGIN
    SELECT SUM(sal) INTO l_sum FROM 
        (   SELECT e.sal FROM SCOTT.emp e ORDER BY e.sal DESC 
            OFFSET 0 ROWS FETCH NEXT p_n ROWS ONLY );
    RETURN l_sum;            
END topnsal;');
END;
/
--obfuscated
/
Ez lett:
create or replace FUNCTION       topnsal wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
111 10b
0IZ2q0UX4oPa15KYJF60QYUf+/0wgy7Qr8usZ3SiAE6Ux0bbL9KXoafi8WcMnwyJtghId6K1
JNFTOcE8//awDR39eUYIP3q7ZB5izUk5KEzp0dbvpGhkooa2Ng23LEW0DL+Vn0+NoenGQB+x
Xgxg88h3LIN0sgrb8x4aauHX8up1m6k/eSCiKrDiWzVxpAkKf5IqQgNKctP2AD6eV60SVAnH
4evpf7VL0kYF8+68WEpyVsSJtfbTBqvFAAeJwE77zys1VA==
