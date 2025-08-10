Sports League Database & Analytics
Dieses Projekt ist eine vollständige SQL-Implementierung zur Verwaltung und Analyse einer Sportliga.
Es wurde so entworfen, dass es leicht auf andere Ligasysteme (Fußball, Basketball, etc.) übertragbar ist.

Features
Datenmodellierung

Tabellen für Teams, Spielstätten, Stadtteile und Begegnungen

Primär- und Fremdschlüssel für referentielle Integrität

Normalisierung der Daten für saubere Strukturen

Datenbefüllung

Realistische Beispiel-Datensätze für Teams, Hallen und Spiele

Klare Trennung zwischen Stammdaten und Spielplänen

Analytische Abfragen

Ligatabelle mit Platzierung, Punkten, Tordifferenz und Toren pro Spiel

Durchschnittliche Heim- und Auswärtstore pro Team

Spiele pro Spieltag mit Ergebnisübersicht

Flexible Filterung (z. B. nur Spiele ab einem bestimmten Datum)

Erweiterbar

Kann leicht um Spielerstatistiken, Schiedsrichter oder Playoff-Formate ergänzt werden

Beispielabfragen
1. Ligatabelle mit Punkten und Tordifferenz

sql
Kopieren
Bearbeiten
SELECT 
    t.TeamName,
    COUNT(s.SpielID) AS Spiele,
    SUM(CASE WHEN s.HeimTore > s.GastTore THEN 3
             WHEN s.HeimTore = s.GastTore THEN 1
             ELSE 0 END) AS Punkte,
    SUM(s.HeimTore) - SUM(s.GastTore) AS Tordifferenz
FROM Teams t
JOIN Spiele s ON t.TeamID = s.HeimTeamID OR t.TeamID = s.GastTeamID
GROUP BY t.TeamName
ORDER BY Punkte DESC, Tordifferenz DESC;
2. Durchschnittliche Tore pro Team

sql
Kopieren
Bearbeiten
SELECT 
    t.TeamName,
    ROUND(AVG(s.HeimTore), 2) AS Durchschnitt_Heim,
    ROUND(AVG(s.GastTore), 2) AS Durchschnitt_Auswärts
FROM Teams t
JOIN Spiele s ON t.TeamID = s.HeimTeamID OR t.TeamID = s.GastTeamID
GROUP BY t.TeamName;
Installation & Nutzung
SQL-Skript Hausaufgabe2.sql herunterladen.

In einer SQL-Umgebung (z. B. MySQL Workbench oder DBeaver) ausführen.

Tabellen und Daten werden automatisch angelegt.

Abfragen aus der README kopieren und direkt ausführen.

Technologien
Datenbank: MySQL / MariaDB (kompatibel)

Sprache: SQL (DDL & DML)

Plattform: Plattformunabhängig

