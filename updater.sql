DECLARE
TYPE client IS TABLE OF crd_person%ROWTYPE;

client_t client;

CURSOR cur
IS
SELECT *
FROM crd_person
WHERE residentstate IS NULL
FETCH FIRST 100000 ROWS ONLY;
BEGIN
FOR i IN 1 .. 14
LOOP
OPEN cur;

FETCH cur BULK COLLECT INTO client_t;

FORALL i IN client_t.FIRST .. client_t.LAST
UPDATE crd_person t
SET t.residentstate = 'BAKU'
WHERE t.FIID = client_t (i).FIID AND t.id = client_t (i).id;

COMMIT;

CLOSE cur;

DBMS_APPLICATION_INFO.set_client_info (i);
END LOOP;
END;
