/* Hausafgabe 2 von:
   Elie Mengi: 91713,
   Luka Palameta 91162,
   Mazlum Örnek 89053,
*/

CREATE TABLE Verein (
   VereinsID INT AUTO_INCREMENT PRIMARY KEY,
   Name VARCHAR(50) NOT NULL
);

CREATE TABLE Halle (
    HallenID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Ort VARCHAR(50) NOT NULL
);

CREATE TABLE Paarung (
    PaarungsID INT AUTO_INCREMENT PRIMARY KEY,
    HeimVerein INT NOT NULL,
    GastVerein INT NOT NULL,
    SpielStaette INT NOT NULL,
    SpielDatum DATE NOT NULL,
    GastTore INT NOT NULL,
    HeimTore INT NOT NULL,
    FOREIGN KEY (HeimVerein) REFERENCES Verein(VereinsID),
    FOREIGN KEY (GastVerein) REFERENCES Verein(VereinsID),
    FOREIGN KEY (SpielStaette) REFERENCES Halle(HallenID)
);

INSERT INTO Verein (Name) VALUES
       ('TuS Blaubach'),
       ('Althausener SC'),
       ('SpVgg Porz'),
       ('Rot-Weiss Oststadt'),
       ('Nordstern SV'),
       ('FSV Zentrum');

INSERT INTO Halle (Name, Ort) VALUES
             ('Sportzentrum Blaubach', 'Blaubach'),
             ('Turnzentrum Porz', 'Porz'),
             ('Nordsternstadion', 'Nordstern'),
             ('Spielpark Nordstern', 'Nordstern'),
             ('Althausenhalle 2', 'Althausen'),
             ('Kampfbahn im Zentrum', 'Zentrum'),
             ('Blaubach Haupthalle', 'Blaubach'),
             ('Oststadtarena', 'Oststadt');

INSERT INTO Paarung (HeimVerein, GastVerein, SpielStaette, SpielDatum, HeimTore, GastTore) VALUES
            (1, 2, 1, '2025-05-03', 10, 5),   -- TuS Blaubach vs Althausener SC
            (3, 4, 2, '2025-05-03', 6, 6),     -- SpVgg Porz vs Rot-Weiss Oststadt
            (5, 6, 3, '2025-05-03', 15, 9),    -- Nordstern SV vs FSV Zentrum
            (5, 4, 4, '2025-05-10', 9, 8),     -- Nordstern SV vs Rot-Weiss Oststadt
            (2, 3, 5, '2025-05-10', 0, 11),    -- Althausener SC vs SpVgg Porz
            (6, 1, 6, '2025-05-10', 5, 4),     -- FSV Zentrum vs TuS Blaubach
            (1, 5, 7, '2025-05-17', 14, 13),   -- TuS Blaubach vs Nordstern SV
            (4, 2, 8, '2025-05-17', 10, 7),    -- Rot-Weiss Oststadt vs Althausener SC
            (3, 6, 2, '2025-05-17', 10, 0),    -- SpVgg Porz vs FSV Zentrum
            (2, 5, 5, '2025-05-24', 1, 12),    -- Althausener SC vs Nordstern SV
            (6, 4, 4, '2025-05-24', 12, 3),    -- FSV Zentrum vs Rot-Weiss Oststadt
            (3, 1, 2, '2025-05-24', 4, 13);    -- SpVgg Porz vs TuS Blaubach



/*2.2*/
SELECT
    p.SpielDatum AS 'Datum',
    h.Name AS 'Heim',
    g.Name AS 'Gast',
    s.Name AS 'Austragungsort',
    CONCAT(p.HeimTore, ':', p.GastTore) AS 'Ergebnis'
FROM
    Paarung p
        JOIN
    Verein h ON p.HeimVerein = h.VereinsID
        JOIN
    Verein g ON p.GastVerein = g.VereinsID
        JOIN
    Halle s ON p.SpielStaette = s.HallenID
ORDER BY
    p.SpielDatum;

/*2.3*/
WITH VereinsSpiele AS (

    SELECT
        v.VereinsID,
        v.Name AS Verein,
        SUM(CASE WHEN p.HeimTore > p.GastTore THEN 1
            WHEN p.HeimTore = p.GastTore THEN 0.5
            ELSE 0
        END) AS Punkte,
        SUM(p.HeimTore - p.GastTore) AS Tordifferenz,
        SUM(p.HeimTore) AS Tore,
        COUNT(*) AS Spiele
    FROM Verein v
    JOIN Paarung p ON v.VereinsID = p.HeimVerein
    WHERE p.SpielDatum <= '2025-05-24'
    GROUP BY v.VereinsID, v.Name

    UNION ALL

    SELECT
        v.VereinsID,
        v.Name AS Verein,
        SUM(CASE WHEN p.GastTore > p.HeimTore THEN 1
            WHEN p.GastTore = p.HeimTore THEN 0.5
            ELSE 0
        END) AS Punkte,
        SUM(p.GastTore - p.HeimTore) AS Tordifferenz,
        SUM(p.GastTore) AS Tore,
        COUNT(*) AS Spiele
    FROM Verein v
    JOIN Paarung p ON v.VereinsID = p.GastVerein
    WHERE p.SpielDatum <= '2025-05-24'
    GROUP BY v.VereinsID, v.Name
),
Gesamt AS (
    SELECT
        Verein,
        SUM(Punkte) AS Punkte,
        SUM(Tordifferenz) AS Tordifferenz,
        SUM(Tore) AS Tore,
        SUM(Spiele) AS Spiele
    FROM VereinsSpiele
    GROUP BY Verein
)
SELECT
    RANK() OVER (ORDER BY Punkte DESC, Tordifferenz DESC) AS Platz,
    Verein,
    Punkte,
    Tordifferenz,
    ROUND(Tore/Spiele, 2) AS ToreProSpiel
FROM Gesamt
ORDER BY Punkte DESC, Tordifferenz DESC;

/*2.4*/

SELECT
    v.Name,
    ROUND(AVG(CASE WHEN v.VereinsID = p.HeimVerein THEN p.HeimTore END), 2) AS Durchschnitt_Heimtore,
    ROUND(AVG(CASE WHEN v.VereinsID = p.GastVerein THEN p.GastTore END), 2) AS Durchschnitt_Gasttore
FROM Verein v
         LEFT JOIN Paarung p ON v.VereinsID = p.HeimVerein OR v.VereinsID = p.GastVerein
GROUP BY v.Name
ORDER BY v.Name;

/*Wie ändert sich die SQL-Abfrage, wenn
nur Durchschnitte berechnet werden sollen, wenn mindestens schon zwei Ergebnisse
vorliegen? */


SELECT
    v.Name,
    ROUND(AVG(p.HeimTore), 2) AS Durchschnitt_Heimtore
FROM Verein v
         JOIN Paarung p ON v.VereinsID = p.HeimVerein
GROUP BY v.Name
HAVING COUNT(*) >= 2;


INSERT INTO Halle (Ort) VALUES
       ('Sportzentrum Blaubach'),
       ('Turnzentrum Porz'    ),
       ('Nordsternstadion'           ),
       ('Spielpark Nordstern'      ),
       ('Althausenhalle 2'         ),
       ('Kampfbahn im Zentrum'        ),
       ('Blaubach Haupthalle'       ),
       ('Oststadtarena'          );

CREATE TABLE Stadtteil (
        StadtteilID INT PRIMARY KEY,
        Name VARCHAR(50) NOT NULL
);

INSERT INTO Stadtteil (StadtteilID, Name) VALUES
    (1, 'Blaubach'),
    (2, 'Porz'),
    (3, 'Nordstern'),
    (4, 'Althausen'),
    (5, 'Zentrum'),
    (6, 'Oststadt');



CREATE TABLE Halle (
     HallenID INT PRIMARY KEY,
     Name VARCHAR(50) NOT NULL,
     StadtteilID INT,
     FOREIGN KEY (StadtteilID) REFERENCES Stadtteil(StadtteilID)
);

INSERT INTO Halle (HallenID, Name, StadtteilID) VALUES
   (1, 'Sportzentrum Blaubach', 1),
   (2, 'Turnzentrum Porz', 2),
   (3, 'Nordsternstadion', 3),
   (4, 'Spielpark Nordstern', 3),
   (5, 'Althausenhalle 2', 4),
   (6, 'Kampfbahn im Zentrum', 5),
   (7, 'Blaubach Haupthalle', 1),
   (8, 'Oststadtarena', 6);













