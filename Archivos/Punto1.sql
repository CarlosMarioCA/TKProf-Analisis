/*/////////////////////EXPLAIN PLAN////////////////////////////////*/

SELECT * FROM PLAN_TABLE;
SELECT operation,options,object_name,cost FROM PLAN_TABLE;
DELETE PLAN_TABLE;

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
FROM visvend v1))
GROUP BY sv;

/*3.//////////////////////////////////////////////////////////////.3*/


SELECT sv, COUNT(*)
FROM clases
GROUP BY sv;

/*4.//////////////////////////////////////////////////////////////.4*/


SELECT clase(v.idvendedor) sv, COUNT(*) AS cuantos
FROM visvend v
GROUP BY clase(v.idvendedor);

/*5.//////////////////////////////////////////////////////////////.5*/


SELECT sv, COUNT(*) AS cuantos
FROM
(
SELECT DISTINCT idvendedor,
clasin(SUM(unidades) OVER (PARTITION BY idvendedor))
AS sv
FROM venta
)
GROUP BY sv;




