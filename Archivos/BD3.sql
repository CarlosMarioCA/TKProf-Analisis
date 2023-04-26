/*Ejemplo Pacho*/
DROP TABLE emp;
DROP TABLE dep;

CREATE TABLE dep(
   depno NUMBER(3) PRIMARY KEY,
   dnom VARCHAR2(20));
   
CREATE TABLE emp(
   ced NUMBER(8) PRIMARY KEY,
   enom VARCHAR2(10), 
   depno NUMBER(3) REFERENCES dep);

INSERT INTO dep VALUES(1,'Admin');
INSERT INTO dep VALUES(2,'Pintura');
INSERT INTO dep VALUES(3,'Lavado');

INSERT INTO emp VALUES(101,'Lisa',1);
INSERT INTO emp VALUES(201,'Kirsty',1);
INSERT INTO emp VALUES(304,'Bjork',3);

DELETE plan_table;

EXPLAIN PLAN 
SET STATEMENT_ID = 'P1' FOR
SELECT *
FROM dep, emp
WHERE emp.depno = dep.depno;

select * from plan_table;

SELECT LPAD(' ', 2*LEVEL) || OPERATION || ' ' 
       || OPTIONS || ' ' || OBJECT_NAME
       AS query_plan
FROM PLAN_TABLE
WHERE STATEMENT_ID = 'P1'
CONNECT BY PRIOR ID = PARENT_ID
START WITH ID = 0;

    SELECT * 
    FROM table(DBMS_XPLAN.DISPLAY);
    
//////////////////////////////////////////////////////////////

EXPLAIN PLAN FOR
SELECT sv, COUNT(*) AS cuantos
FROM(SELECT CASE
WHEN SUM(unidades) BETWEEN 0 AND 50 THEN 1
WHEN SUM(unidades) BETWEEN 51 AND 100 THEN 2
WHEN SUM(unidades) BETWEEN 101 AND 150 THEN 3
ELSE 4
END AS sv
FROM venta
GROUP BY idvendedor
)
GROUP BY sv;

delete plan_table;
select * from plan_table;
COMMIT;

//////////////////////////////////////////////////////////////

/*Permisos de Sesi�n*/
CONN SYS AS SYSDBA;
GRANT ALTER SESSION TO SAM;
ALTER SESSION SET TIMED_STATISTICS=TRUE;
SET AUTOTRACE ON;


             
//////////////////////////////////////////////////////////////

/*////////////////////////////////TKPROF///////////////////////////////////////*/

delete venta;
EXECUTE insercionDatos(100000)
/*1.Credenciales*/
ALTER SESSION SET TIMED_STATISTICS=TRUE;
ALTER SESSION SET SQL_TRACE = TRUE;

SELECT spid FROM sys.v_$process
WHERE addr = (SELECT paddr FROM sys.v_$session
              WHERE audsid = USERENV('sessionid')
             );
             
C:\oraclexe\app\oracle\diag\rdbms\xe\xe\trace
tkprof xe_ora_1284.trc C:\Users\usuario\Desktop\TKPROF\10000Datos.txt
