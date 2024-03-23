BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE COMPETITIONS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE addresses';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ENTRIES';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE PETS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/



BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE ScoreList_varray_type';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/


BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE owner_type';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE Score_type';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE addresses';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE address_type';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/

DROP PROCEDURE INSERT_COMPETITION;
DROP PROCEDURE UPDATE_COMPETITION_LOCATION;
DROP PROCEDURE DELETE_COMPETITION;
DROP FUNCTION AVERAGE_SCORE;


PURGE RECYCLEBIN;
COLUMN object_name FORMAT A30;
COLUMN object_type FORMAT A12;

-- List all objects i
SELECT object_name, object_type FROM user_objects;


-- List all objects i

-- Object types
CREATE OR REPLACE TYPE address_type AS OBJECT (
    street VARCHAR2(255),
    city VARCHAR2(255),
    country VARCHAR2(255)
);
/


-- User-defined collection types
CREATE OR REPLACE TYPE Score_type AS OBJECT (
    Score_Value NUMBER(2),
    Position NUMBER(2),
    Result VARCHAR2(10)
);
/

CREATE TABLE ADDRESSES OF address_type;

-- Object tables

CREATE OR REPLACE TYPE owner_type AS OBJECT (
    Owner__ID NUMBER(2),
    Owner_Name VARCHAR2(255),
    Owner_Number NUMBER(12)
    
);
/

-- Varray type
CREATE TYPE ScoreList_varray_type AS VARRAY(10) OF Score_type;
/


-- Relational tables

CREATE TABLE COMPETITIONS (
    Competition_ID VARCHAR2(3),
    Competition_Name VARCHAR2(255),
    Entry_ID NUMBER(2),
    DateHeld DATE,
    Location REF address_type SCOPE IS addresses,
    CONSTRAINT pk_COMPETITION_ID PRIMARY KEY (Competition_ID)
);


CREATE TABLE PETS(
    Pet_ID NUMBER(3),
    Name VARCHAR2(255),
    Species VARCHAR2(255),
    Owners owner_type,
    CONSTRAINT pk_PET_ID PRIMARY KEY (Pet_ID)
)
;


CREATE TABLE ENTRIES (
    Entry_ID NUMBER(2),
    Pet_ID NUMBER(3),
    Scores ScoreList_varray_type,
    Result VARCHAR2(50),
    CONSTRAINT pk_Entry_ID PRIMARY KEY (Entry_ID)
);


-- Make Pet_ID in ENTRIES a foreign key that references Pet_ID in PETS
ALTER TABLE ENTRIES
ADD CONSTRAINT fk_e_pet FOREIGN KEY (Pet_ID) REFERENCES PETS(Pet_ID);

-- Make Entry_ID in COMPETITIONS a foreign key that references Entry_ID in ENTRIES
ALTER TABLE COMPETITIONS
ADD CONSTRAINT fk_c_entry FOREIGN KEY (Entry_ID) REFERENCES ENTRIES(Entry_ID);

-- Insert Address 1
INSERT INTO ADDRESSES VALUES (address_type('100 Road St', 'London', 'UK'));

-- Insert Address 2
INSERT INTO ADDRESSES VALUES (address_type('55 Elm St', 'Springfield', 'USA'));

-- Insert Address 3
INSERT INTO ADDRESSES VALUES (address_type('22 Park View', 'Manchester', 'UK'));

COMMIT;
-- INSERT INTO PETS VALUES(1, 'Buddy', 'Dog', owner_type(1, 'John', 'Doe'));

INSERT INTO PETS VALUES(1, 'Buddy', 'Dog', owner_type(1, 'John',07408699875));
INSERT INTO PETS VALUES(2, 'Mittens', 'Cat', owner_type(2, 'Jane', 07408699876));
INSERT INTO PETS VALUES(3, 'Rover', 'Dog', owner_type(3, 'Bob', 07408699877));
INSERT INTO PETS VALUES(4, 'Fluffy', 'Cat', owner_type(4, 'Sue', 07408699878));
INSERT INTO PETS VALUES(5, 'Fido', 'Dog', owner_type(5, 'Alice', 07408699879));

COMMIT;

-- INSERT INTO ENTRIES VALUES(1, 1, ScoreList_varray_type(Score_type(10,20,'Placed')), 'First Place');

INSERT INTO ENTRIES VALUES (1, 1, ScoreList_varray_type(Score_type(10,20,'Placed')), 'First Place');
INSERT INTO ENTRIES VALUES (4, 2, ScoreList_varray_type(Score_type(30,40,'Placed')), 'Second Place');
INSERT INTO ENTRIES VALUES (5, 3, ScoreList_varray_type(Score_type(50,60,'Placed')), 'Third Place');
INSERT INTO ENTRIES VALUES (6, 4, ScoreList_varray_type(Score_type(70,80,'Placed')), 'Fourth Place');
INSERT INTO ENTRIES VALUES (7, 5, ScoreList_varray_type(Score_type(90,90,'Placed')), 'Fifth Place');

COMMIT;

-- COMPETITIONS INSERTS

-- Insert Competition 1 with Location Address 1
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM1', 'Summer Games', 1, TO_DATE('2024-05-25', 'YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '100 Road St'));
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM2', 'Summer Games', 4, TO_DATE('2024-05-25', 'YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '100 Road St'));
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM3', 'Summer Games', 7, TO_DATE('2024-05-25', 'YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '100 Road St'));

COMMIT;

-- Insert Competition 2 with Location Address 2
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM4', 'Winter Festival', 1, TO_DATE('2023-12-21', 'YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '55 Elm St'));
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM5', 'Winter Festival', 4, TO_DATE('2023-12-21','YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '55 Elm St'));
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM6', 'Winter Festival', 7, TO_DATE('2023-12-21','YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '55 Elm St'));

COMMIT;

-- Insert Competition 3 with Location Address 3
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM7', 'Autumn Challenge', 1, TO_DATE('2024-10-26','YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '22 Park View'));
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM8', 'Autumn Challenge', 4, TO_DATE('2024-10-26','YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '22 Park View'));
INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
VALUES ('CM9', 'Autumn Challenge', 7, TO_DATE('2024-10-26','YYYY-MM-DD'), (SELECT REF(a) FROM ADDRESSES a WHERE street = '22 Park View'));

COMMIT;

-- PL SQL CODE

-- Calcukate the average score for a pet
CREATE OR REPLACE FUNCTION average_score (
    p_pet_id IN PETS.Pet_ID%TYPE
) RETURN NUMBER AS
    v_total NUMBER;
    v_count NUMBER;
    v_average NUMBER;
BEGIN 
    SELECT SUM(Score_Value), COUNT(Score_Value)
    INTO v_total, v_count
    FROM ENTRIES e, TABLE(e.Scores) s
    WHERE e.Pet_ID = p_pet_id;
    v_average := v_total / v_count;
    RETURN v_average;
END average_score;

/

-- Inserting  a new competition

CREATE OR REPLACE PROCEDURE insert_competition (
    p_competition_id IN COMPETITIONS.Competition_ID%TYPE,
    p_competition_name IN COMPETITIONS.Competition_Name%TYPE,
    p_entry_id IN COMPETITIONS.Entry_ID%TYPE,
    p_date_held IN COMPETITIONS.DateHeld%TYPE
) AS
BEGIN
    INSERT INTO COMPETITIONS (Competition_ID, Competition_Name, Entry_ID, DateHeld, Location)
    VALUES (p_competition_id, p_competition_name, p_entry_id, p_date_held, NULL);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END insert_competition;
/



-- Updating the location of a competition

CREATE OR REPLACE PROCEDURE update_competition_location (
    p_competition_id IN COMPETITIONS.Competition_ID%TYPE,
    p_street IN ADDRESSES.Street%TYPE
) AS
BEGIN
    UPDATE COMPETITIONS
    SET Location = (SELECT REF(a) FROM ADDRESSES a WHERE a.Street = p_street)
    WHERE Competition_ID = p_competition_id;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END update_competition_location;
/

-- Deleting a competition

CREATE OR REPLACE PROCEDURE delete_competition (
    p_competition_id IN COMPETITIONS.Competition_ID%TYPE
) AS
BEGIN
    DELETE FROM COMPETITIONS
    WHERE Competition_ID = p_competition_id;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END delete_competition;
/

/* All drops. 
DROP PROCEDURE INSERT_COMPETITION;
DROP PROCEDURE UPDATE_COMPETITION_LOCATION;
DROP PROCEDURE DELETE_COMPETITION;
DROP FUNCTION AVERAGE_SCORE;

DROP TABLE COMPETITIONS;
DROP TABLE ADDRESSES;
DROP TABLE ENTRIES;
DROP TABLE PETS;
DROP TYPE ScoreList_varray_type;
DROP TYPE owner_type;
drop TYPE score_type;
Drop table addresses;
drop type address_type;
*/
