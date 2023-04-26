/*0.//////////////////////////////////////////////////////////////.0*/

CREATE TABLE venta(
codventa NUMBER(8) PRIMARY KEY,
idvendedor NUMBER(8) NOT NULL,
unidades NUMBER(8) NOT NULL CHECK (unidades > 0)
);

CREATE INDEX idven ON venta(idvendedor);

CREATE PROCEDURE insercionDatos(x NUMBER) IS
    v venta%rowtype;
BEGIN
    FOR i IN 1..x LOOP
        v.codventa := i;
        v.idvendedor := dbms_random.value(1,x);
        v.unidades := dbms_random.value(1,x);
        INSERT INTO venta VALUES v;
    END LOOP;
    COMMIT;
END;
/

DELETE venta;
EXECUTE insercionDatos(100);

select * from venta;


/*1.//////////////////////////////////////////////////////////////.1*/

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

/*2.//////////////////////////////////////////////////////////////.2*/

CREATE VIEW visvend AS
SELECT DISTINCT idvendedor
FROM venta;

SELECT sv, COUNT(*) AS cuantos
FROM
(SELECT CASE
WHEN sumin BETWEEN 0 AND 50 THEN 1
WHEN sumin BETWEEN 51 AND 100 THEN 2
WHEN sumin BETWEEN 101 AND 150 THEN 3
ELSE 4
END AS sv
FROM (SELECT (SELECT SUM(unidades)
FROM venta v2
WHERE v2.idvendedor = v1.idvendedor) AS sumin
FROM visvend v1
)
)
GROUP BY sv;

/*3.//////////////////////////////////////////////////////////////.3*/

CREATE TABLE rango(
sv NUMBER(1) PRIMARY KEY CHECK(sv IN (1,2,3,4)),
menor NUMBER(8) NOT NULL,
mayor NUMBER(8) NOT NULL);
INSERT INTO rango VALUES(1,0,50);
INSERT INTO rango VALUES(2,51,100);
INSERT INTO rango VALUES(3,101,150);
INSERT INTO rango VALUES(4,151,99999999);

CREATE VIEW totales AS
SELECT idvendedor, SUM(unidades) AS sumi
FROM venta
GROUP BY idvendedor;

CREATE VIEW clases AS
SELECT sv
FROM totales, rango
WHERE sumi BETWEEN menor AND mayor;

SELECT sv, COUNT(*)
FROM clases
GROUP BY sv;

/*4.//////////////////////////////////////////////////////////////.4*/

CREATE VIEW visvend AS
SELECT DISTINCT idvendedor
FROM venta;

CREATE OR REPLACE FUNCTION clase(idv IN NUMBER)
RETURN NUMBER IS
sumi NUMBER(8);
clasi NUMBER(1);
BEGIN
SELECT SUM(unidades) INTO sumi
FROM venta
WHERE idvendedor = idv;
CASE WHEN sumi BETWEEN 0 AND 50 THEN clasi := 1;
WHEN sumi BETWEEN 51 AND 100 THEN clasi := 2;
WHEN sumi BETWEEN 101 AND 150 THEN clasi := 3;
ELSE clasi := 4;
END CASE;
RETURN clasi;
END;
/

SELECT clase(v.idvendedor) sv, COUNT(*) AS cuantos
FROM visvend v
GROUP BY clase(v.idvendedor);

/*5.//////////////////////////////////////////////////////////////.5*/

CREATE OR REPLACE FUNCTION clasin(sumi IN NUMBER)
RETURN NUMBER IS
clasi NUMBER(1);
BEGIN
CASE WHEN sumi BETWEEN 0 AND 50 THEN clasi := 1;
WHEN sumi BETWEEN 51 AND 100 THEN clasi := 2;
WHEN sumi BETWEEN 101 AND 150 THEN clasi := 3;
ELSE clasi := 4;
END CASE;
RETURN clasi;
END;
/

SELECT sv, COUNT(*) AS cuantos
FROM
(
SELECT DISTINCT idvendedor,
clasin(SUM(unidades) OVER (PARTITION BY idvendedor))
AS sv
FROM venta
)
GROUP BY sv;

//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////

