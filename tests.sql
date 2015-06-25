--
-- Script de test des triggers
-- Auteurs
-- Code permanent:JOUG08108901
-- Code permanent:PROM18118300
--
SPOOL resultats/tests.res
SET LINESIZE 160
SET ECHO ON

-- Test#1: Employe_NaissanceDateValide
-- Test#1.1
INSERT INTO Employe VALUES ('JGA',123456789,'123 Rue St-Denis',5145555555,'Surveillant','Surveillance','Jourdenais','Gabriel','2015-04-17',NULL);
ROLLBACK;
-- Test#1.2
UPDATE Employe SET NaissanceDate='2015-04-17' WHERE Code='AAA';
ROLLBACK;

-- Test#2: Employe_FonctionService
-- Test#2.1
INSERT INTO Employe VALUES ('JGA',123456789,'123 Rue St-Denis',5145555555,'Secretaire','Surveillance','Jourdenais','Gabriel','1989-10-08',NULL);
INSERT INTO Employe VALUES ('HDA',987654321,'456 Rue St-Denis',5145555555,'Veterinaire','Administratif','Hamel','Daniel','1965-02-12',NULL);
INSERT INTO Employe VALUES ('JSY',678912345,'789 Rue St-Denis',5145555555,'Chef de zone','Medical','Jourdenais','Sylvie','1967-04-04',NULL);
ROLLBACK;
-- Test#2.2
UPDATE Employe SET Fonction='Chef du personnel' WHERE Code='AAA';
UPDATE Employe SET Service='Medical' WHERE Code='BBB';
ROLLBACK;

-- Test#3: Surveillance_UneZoneParJour
-- Test#3.1
INSERT INTO Surveillance VALUES ('2015-04-16','Insectes',1,14,'BBB');
ROLLBACK;
-- Test#3.2
UPDATE Surveillance SET NomZone='Insectes' WHERE CodeSurveillant='BBB' AND Jour='2015-04-17' AND NomZone='Singes' AND NumLotissement=2 AND Heure=9;
ROLLBACK;

-- Test#4: Surveillance_PasMemeLotDeSuite
-- Test#4.1
INSERT INTO Surveillance VALUES ('2015-04-16','Singes',1,7,'BBB');
INSERT INTO Surveillance VALUES ('2015-04-16','Singes',1,9,'BBB');
ROLLBACK;
-- Test#4.2
UPDATE Surveillance SET NumLotissement=2 WHERE CodeSurveillant='BBB' AND Jour='2015-04-19' AND NomZone='Insectes' AND NumLotissement=1 AND Heure=6;
UPDATE Surveillance SET Heure=10 WHERE CodeSurveillant='BBB' AND Jour='2015-04-17' AND NomZone='Singes' AND NumLotissement=1 AND Heure=11;
ROLLBACK;

-- Test#5: Choix_LimiteAffinite
-- Test#5.1
INSERT INTO Choix VALUES ('Singes','BBB','favorite');
INSERT INTO Choix VALUES ('Insectes','BBD','non apprecie');
ROLLBACK;
-- Test#5.2
UPDATE Choix SET CodeSurveillant='BBD' WHERE NomZone='Singes' AND CodeSurveillant='BBB';
UPDATE Choix SET Affinite='non appercie' WHERE NomZone='Polaire' AND CodeSurveillant='BBD';
ROLLBACK;

-- Test#6: Lotissement_Ins_NumSuccessifs
-- Test#6.1
INSERT INTO Lotissement VALUES ('Singes',6);
ROLLBACK;

-- Test#7: Lotissement_Upd_NumSuccessifs
-- Test#7.1
UPDATE Lotissement SET Numero=5 WHERE NomZone='Singes' AND Numero=1;
UPDATE Lotissement SET NomZone='Insectes' WHERE NomZone='Singes' AND Numero=4;
ROLLBACK;

-- Test#8: Individu_ExclusEspeceIndividu
-- Test#8.1
INSERT INTO Individu VALUES (6,'Tom','AB+','1989-10-08','1989-10-09',NULL,NULL,'Fourmi Rouge','Insectes',1);
ROLLBACK;
-- Test#8.2
UPDATE Individu SET NomEspece='Poisson Rouge' WHERE Numero=1;
ROLLBACK;

-- Test#9: Individu_DecesDateValide
-- Test#9.1
INSERT INTO Individu VALUES (6,'Tom','AB+','1989-10-08','1989-10-01',NULL,NULL,'Babouin','Singes',1);
ROLLBACK;
-- Test#9.2
UPDATE Individu SET NaissanceDate='2010-11-19' WHERE Numero=5;
UPDATE Individu SET DecesDate='1983-11-17' WHERE Numero=5;
ROLLBACK;

-- Test#10: Individu_ParentsNaissValide
-- Test#10.1
INSERT INTO Individu VALUES (6,'Tom','AB+','1983-11-18',NULL,1,2,'Babouin','Singes',1);
INSERT INTO Individu VALUES (7,'John','AB+','1983-11-17',NULL,1,2,'Babouin','Singes',1);
INSERT INTO Individu VALUES (8,'Rose','AB+','1994-11-19',NULL,3,4,'Babouin','Singes',1);
ROLLBACK;
-- Test#10.2
UPDATE Individu SET NumPere=4 WHERE Numero=3;
UPDATE Individu SET NaissanceDate='1983-10-08' WHERE Numero=3;
UPDATE Individu SET NumMere=2 WHERE Numero=1;
UPDATE Individu SET NaissanceDate='1984-11-18' WHERE Numero=3;
ROLLBACK;

-- Test#11: Individu_ParentsMemeEspece
-- Test#11.1
INSERT INTO Individu VALUES (6,'Tom','AB+','2007-10-08',NULL,1,2,'Tigre','Singes',1);
INSERT INTO Individu VALUES (7,'Max','AB+','2007-10-08',NULL,3,4,'Lion','Singes',1);
INSERT INTO Individu VALUES (8,'Bob','AB+','2007-10-08',NULL,3,4,'Tigre','Singes',1);
ROLLBACK;
-- Test#11.2
UPDATE Individu SET NumPere=5 WHERE Numero=3;
UPDATE Individu SET NomEspece='Lion' WHERE Numero=3;
UPDATE Individu SET NumMere=5 WHERE Numero=3;
UPDATE Individu SET NomEspece='Tigre' WHERE Numero=4;
ROLLBACK;

-- Test#12: Individu_MereSiPere
-- Test#12.1
INSERT INTO Individu VALUES (6,'Tom','AB+','2015-10-08',NULL,1,NULL,'Babouin','Singes',1);
ROLLBACK;
-- Test#12.2
UPDATE Individu SET NumMere=NULL WHERE Numero=3;
UPDATE Individu SET NumPere=1 WHERE Numero=2;
ROLLBACK;

-- Test#13: Individu_EnfantsPasParents
-- Test#13.1
INSERT INTO Individu VALUES (6,'Tom','AB+','2015-10-08',NULL,6,1,'Babouin','Singes',1);
INSERT INTO Individu VALUES (7,'Tom','AB+','2015-10-08',NULL,1,7,'Babouin','Singes',1);
ROLLBACK;
-- Test#13.2
UPDATE Individu SET NumMere=3 WHERE Numero=3;
UPDATE Individu SET NumPere=2 WHERE Numero=2;
ROLLBACK;

-- Test#14: Individu_ParentPasParent
-- Test#14.1
INSERT INTO Individu VALUES (6,'Tom','AB+','2015-10-08',NULL,1,1,'Babouin','Singes',1);
INSERT INTO Individu VALUES (7,'Tom','AB+','2015-10-08',NULL,2,2,'Babouin','Singes',1);
ROLLBACK;
-- Test#14.2
UPDATE Individu SET NumMere=1 WHERE Numero=3;
UPDATE Individu SET NumPere=2 WHERE Numero=4;
ROLLBACK;

-- Test#15: Individu_UnLotParEspece
-- Test#15.1
INSERT INTO Individu VALUES (6,'Tom','AB+','2015-10-08',NULL,NULL,NULL,'Babouin','Singes',2);
INSERT INTO Individu VALUES (7,'Tom','AB+','2015-10-08',NULL,NULL,NULL,'Babouin','Singes',2);
ROLLBACK;
-- Test#15.2
UPDATE Individu SET NumLotissement=2 WHERE Numero=1;
UPDATE Individu SET NomZone='Tropicale' WHERE Numero=4;
UPDATE Individu SET NomEspece='Babouin' WHERE Numero=5;
ROLLBACK;

-- Test#16: Surveillant_EmployeSurveillant
-- Test#16.1
INSERT INTO Surveillant VALUES('CCC', 8.5, 'G1');
ROLLBACK;
-- Test#16.2
UPDATE Surveillant SET CodeSurveillant='CCC' WHERE CodeSurveillant='BBB';
ROLLBACK;

-- Test#17: ChefDeZone_EmployeChefDeZone
-- Test#17.1
INSERT INTO ChefDeZone VALUES('CCC', 'Singes');
ROLLBACK;
-- Test#17.2
UPDATE ChefDeZone SET CodeChefZone='CCC' WHERE CodeChefZone='AAA';
ROLLBACK;

SET ECHO OFF
SET PAGESIZE 30
SPOOL OFF
