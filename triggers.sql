--
-- Script de creation des triggers
-- Auteurs
-- Code permanent:JOUG08108901
-- Code permanent:PROM18118300
--
SPOOL resultats/triggers.res
SET ECHO ON

CREATE TRIGGER Employe_NaissanceDateValide
BEFORE INSERT OR UPDATE OF NaissanceDate ON Employe
FOR EACH ROW
BEGIN

IF CURRENT_DATE-:NEW.NaissanceDate<16
THEN
raise_application_error (-20000,'Employe '||TO_CHAR(:NEW.Code)||': a moins de 16 ans');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Employe_FonctionService
BEFORE INSERT OR UPDATE OF Fonction,Service ON Employe
FOR EACH ROW
BEGIN

IF (:NEW.Service='Surveillance' AND :NEW.Fonction NOT IN ('Chef de zone','Surveillant'))
OR (:NEW.Service='Medical' AND :NEW.Fonction NOT IN ('Veterinaire','Infirmiere'))
OR (:NEW.Service='Administratif' AND :NEW.Fonction NOT IN ('Secretaire','Directeur','Chef du personnel','Comptable'))
THEN
raise_application_error (-20000,'Employe '||TO_CHAR(:NEW.Code)||': sa fonction ne correspond pas a son service');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Surveillance_UneZoneParJour
BEFORE INSERT ON Surveillance
FOR EACH ROW
DECLARE rows_count INTEGER;
BEGIN

SELECT COUNT(*) INTO rows_count FROM Surveillance WHERE CodeSurveillant=:NEW.CodeSurveillant AND Jour=:NEW.Jour AND NomZone<>:NEW.NomZone AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Surveillance '||TO_CHAR(:NEW.Jour)||' '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.NumLotissement) 
||' '||TO_CHAR(:NEW.Heure)||' '||TO_CHAR(:NEW.CodeSurveillant)||q'!: le surveillant surveille plus d'une zone dans la meme journee!');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Surveillance_UneZoneParJour2
AFTER UPDATE OF CodeSurveillant,NomZone,Jour ON Surveillance
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Surveillance WHERE CodeSurveillant=:NEW.CodeSurveillant AND Jour=:NEW.Jour AND NomZone<>:NEW.NomZone AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Surveillance '||TO_CHAR(:NEW.Jour)||' '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.NumLotissement) 
||' '||TO_CHAR(:NEW.Heure)||' '||TO_CHAR(:NEW.CodeSurveillant)||q'!: le surveillant surveille plus d'une zone dans la meme journee!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Surveillance '||TO_CHAR(:NEW.Jour)||' '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.NumLotissement) 
||' '||TO_CHAR(:NEW.Heure)||' '||TO_CHAR(:NEW.CodeSurveillant)||q'!: le surveillant surveille plus d'une zone dans la meme journee!');
END;
/
SHOW ERRORS;

CREATE TRIGGER Surveillance_PasMemeLotDeSuite
BEFORE INSERT ON Surveillance
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Surveillance WHERE CodeSurveillant=:NEW.CodeSurveillant AND Jour=:NEW.Jour AND NomZone=:NEW.NomZone 
AND NumLotissement=:NEW.NumLotissement AND ABS(Heure-:NEW.Heure)=1 AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Surveillance '||TO_CHAR(:NEW.Jour)||' '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.NumLotissement) 
||' '||TO_CHAR(:NEW.Heure)||' '||TO_CHAR(:NEW.CodeSurveillant)||q'!: le lotissement est surveille consecutivement par le meme surveillant!');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Surveillance_PasMemeLotDeSuit2
AFTER UPDATE ON Surveillance
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Surveillance WHERE CodeSurveillant=:NEW.CodeSurveillant AND Jour=:NEW.Jour AND NomZone=:NEW.NomZone 
AND NumLotissement=:NEW.NumLotissement AND ABS(Heure-:NEW.Heure)=1 AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Surveillance '||TO_CHAR(:NEW.Jour)||' '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.NumLotissement) 
||' '||TO_CHAR(:NEW.Heure)||' '||TO_CHAR(:NEW.CodeSurveillant)||q'!: le lotissement est surveille consecutivement par le meme surveillant!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Surveillance '||TO_CHAR(:NEW.Jour)||' '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.NumLotissement) 
||' '||TO_CHAR(:NEW.Heure)||' '||TO_CHAR(:NEW.CodeSurveillant)||q'!: le lotissement est surveille consecutivement par le meme surveillant!');
END;
/
SHOW ERRORS;


CREATE TRIGGER Choix_LimiteAffinite
BEFORE INSERT OR UPDATE OF CodeSurveillant,Affinite ON Choix
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Choix WHERE CodeSurveillant=:NEW.CodeSurveillant AND Affinite=:NEW.Affinite;
IF rows_count=3
THEN
raise_application_error (-20000,'Choix '||TO_CHAR(:NEW.CodeSurveillant)||' '||TO_CHAR(:NEW.NomZone)||': le surveillant a plus de 3 zones '||TO_CHAR(:NEW.Affinite)||'s');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Choix '||TO_CHAR(:NEW.CodeSurveillant)||' '||TO_CHAR(:NEW.NomZone)||': le surveillant a plus de 3 zones '||TO_CHAR(:NEW.Affinite)||'s');
END;
/
SHOW ERRORS;

CREATE TRIGGER Lotissement_Ins_NumSuccessifs
BEFORE INSERT ON Lotissement
FOR EACH ROW
DECLARE rows_count INTEGER;
BEGIN

SELECT COUNT(*) INTO rows_count FROM Lotissement WHERE NomZone=:NEW.NomZone;
IF :NEW.Numero>rows_count+1
THEN
raise_application_error (-20000,'Lotissement '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.Numero)||q'!: le numero de lotissement n'est pas successif (entre 1 et le nombre de lotissement d'une zone)!');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Lotissement_Upd_NumSuccessifs
BEFORE UPDATE OF Numero,NomZone ON Lotissement
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Lotissement WHERE NomZone=:NEW.NomZone;
IF :NEW.Numero>rows_count+1
THEN
raise_application_error (-20000,'Lotissement '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.Numero)||q'!: le numero de lotissement n'est pas successif (entre 1 et le nombre de lotissement d'une zone)!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Lotissement '||TO_CHAR(:NEW.NomZone)||' '||TO_CHAR(:NEW.Numero)||q'!: le numero de lotissement n'est pas successif (entre 1 et le nombre de lotissement d'une zone)!');
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_ExclusEspeceIndividu
BEFORE INSERT ON Individu
FOR EACH ROW
DECLARE rows_count INTEGER;
BEGIN

SELECT COUNT(*) INTO rows_count FROM Espece WHERE NomEspece=:NEW.NomEspece AND Nombre>0 AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Espece '||TO_CHAR(:NEW.NomEspece)||':a un nombre definit mais est associe a des individus');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_ExclusEspeceIndividu2
AFTER UPDATE OF NomEspece ON Individu
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Espece WHERE NomEspece=:NEW.NomEspece AND Nombre>0 AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Espece '||TO_CHAR(:NEW.NomEspece)||':a un nombre definit mais est associe a des individus');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Espece '||TO_CHAR(:NEW.NomEspece)||':a un nombre definit mais est associe a des individus');
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_DecesDateValide
BEFORE INSERT ON Individu
FOR EACH ROW
BEGIN

IF :NEW.NaissanceDate>:NEW.DecesDate
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||':sa date de naissance est superieur a sa date de deces');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_DecesDateValide2
AFTER UPDATE OF NaissanceDate,DecesDate ON Individu
FOR EACH ROW
BEGIN

IF :NEW.NaissanceDate>:NEW.DecesDate
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||':sa date de naissance est superieur a sa date de deces');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_ParentsNaissValide
BEFORE INSERT ON Individu
FOR EACH ROW
DECLARE rows_count1 INTEGER;
rows_count2 INTEGER;
rows_count3 INTEGER;
rows_count4 INTEGER;
BEGIN

SELECT COUNT(*) INTO rows_count1 FROM Individu WHERE Numero=:NEW.NumPere AND :NEW.NaissanceDate<NaissanceDate AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count2 FROM Individu WHERE Numero=:NEW.NumPere AND DecesDate<>NULL AND DecesDate<:NEW.NaissanceDate AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count3 FROM Individu WHERE Numero=:NEW.NumMere AND :NEW.NaissanceDate<NaissanceDate AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count4 FROM Individu WHERE Numero=:NEW.NumMere AND DecesDate<>NULL AND DecesDate<:NEW.NaissanceDate AND ROWNUM=1;
IF rows_count1=1 OR rows_count2=1 OR rows_count3=1 OR rows_count4=1
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||q'!:n'a pas une date de naissance valide par rapport a ses parents!');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_ParentsNaissValide2
AFTER UPDATE OF NumPere,NumMere,NaissanceDate ON Individu
FOR EACH ROW
DECLARE rows_count1 INTEGER;
rows_count2 INTEGER;
rows_count3 INTEGER;
rows_count4 INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count1 FROM Individu WHERE Numero=:NEW.NumPere AND :NEW.NaissanceDate<NaissanceDate AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count2 FROM Individu WHERE Numero=:NEW.NumPere AND DecesDate<>NULL AND DecesDate<:NEW.NaissanceDate AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count3 FROM Individu WHERE Numero=:NEW.NumMere AND :NEW.NaissanceDate<NaissanceDate AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count4 FROM Individu WHERE Numero=:NEW.NumMere AND DecesDate<>NULL AND DecesDate<:NEW.NaissanceDate AND ROWNUM=1;
IF rows_count1=1 OR rows_count2=1 OR rows_count3=1 OR rows_count4=1
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||q'!:n'a pas une date de naissance valide par rapport a ses parents!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||q'!:n'a pas une date de naissance valide par rapport a ses parents!');
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_ParentsMemeEspece
BEFORE INSERT ON Individu
FOR EACH ROW
DECLARE rows_count1 INTEGER;
rows_count2 INTEGER;
BEGIN

SELECT COUNT(*) INTO rows_count1 FROM Individu WHERE Numero=:NEW.NumPere AND NomEspece<>:NEW.NomEspece AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count2 FROM Individu WHERE Numero=:NEW.NumMere AND NomEspece<>:NEW.NomEspece AND ROWNUM=1;
IF rows_count1=1 OR rows_count2=1
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||q'!:n'a pas une espece valide par rapport a ses parents!');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_ParentsMemeEspece2
AFTER UPDATE OF NomEspece,NumPere,NumMere ON Individu
FOR EACH ROW
DECLARE rows_count1 INTEGER;
rows_count2 INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count1 FROM Individu WHERE Numero=:NEW.NumPere AND NomEspece<>:NEW.NomEspece AND ROWNUM=1;
SELECT COUNT(*) INTO rows_count2 FROM Individu WHERE Numero=:NEW.NumMere AND NomEspece<>:NEW.NomEspece AND ROWNUM=1;
IF rows_count1=1 OR rows_count2=1
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||q'!:n'a pas une espece valide par rapport a ses parents!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)||q'!:n'a pas une espece valide par rapport a ses parents!');
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_MereSiPere
BEFORE INSERT ON Individu
FOR EACH ROW
DECLARE rows_count INTEGER;
BEGIN

SELECT COUNT(*) INTO rows_count FROM Individu WHERE Numero=:NEW.NumMere AND ROWNUM=1;
IF :NEW.NumPere>0 AND rows_count=0
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| ': a un pere mais pas de mere');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_MereSiPere2
AFTER UPDATE OF NumPere,NumMere ON Individu
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Individu WHERE Numero=:NEW.NumMere AND ROWNUM=1;
IF :NEW.NumPere>0 AND rows_count=0
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| ': a un pere mais pas de mere');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| ': a un pere mais pas de mere');
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_EnfantsPasParents
BEFORE INSERT OR UPDATE OF NumPere,NumMere ON Individu
FOR EACH ROW
BEGIN

IF :NEW.Numero=:NEW.NumPere OR :NEW.Numero=:NEW.NumMere
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| ': est le meme individu que ses parents');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_ParentPasParent
BEFORE INSERT OR UPDATE OF NumPere,NumMere ON Individu
FOR EACH ROW
BEGIN

IF :NEW.NumPere=:NEW.NumMere
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| ': ses parents sont le meme individu');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_UnLotParEspece
BEFORE INSERT ON Individu
FOR EACH ROW
DECLARE rows_count INTEGER;
BEGIN

SELECT COUNT(*) INTO rows_count FROM Individu WHERE (NomEspece=:NEW.NomEspece AND NomZone<>:NEW.NomZone) OR (NomEspece=:NEW.NomEspece AND NumLotissement<>:NEW.NumLotissement) AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| q'!: n'est pas dans la meme zone ou lotissement que les autres membres de son espece!');
END IF;
END;
/
SHOW ERRORS;

CREATE TRIGGER Individu_UnLotParEspece2
AFTER UPDATE OF NumLotissement,NomZone,NomEspece ON Individu
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Individu WHERE (NomEspece=:NEW.NomEspece AND NomZone<>:NEW.NomZone) OR (NomEspece=:NEW.NomEspece AND NumLotissement<>:NEW.NumLotissement) AND ROWNUM=1;
IF rows_count=1
THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| q'!: n'est pas dans la meme zone ou lotissement que les autres membres de son espece!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Individu '||TO_CHAR(:NEW.Numero)|| q'!: n'est pas dans la meme zone ou lotissement que les autres membres de son espece!');
END;
/
SHOW ERRORS;

CREATE TRIGGER Surveillant_EmployeSurveillant
BEFORE INSERT OR UPDATE OF CodeSurveillant ON Surveillant
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Employe WHERE Code=:NEW.CodeSurveillant AND Fonction='Surveillant' AND ROWNUM=1;
IF rows_count=0
THEN
raise_application_error (-20000,'Surveillant '||TO_CHAR(:NEW.CodeSurveillant)|| q'!: n'est pas un employe de fonction Surveillant!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'Surveillant '||TO_CHAR(:NEW.CodeSurveillant)|| q'!: n'est pas un employe de fonction Surveillant!');
END;
/
SHOW ERRORS;

CREATE TRIGGER ChefDeZone_EmployeChefDeZone
BEFORE INSERT OR UPDATE OF CodeChefZone ON ChefDeZone
FOR EACH ROW
DECLARE rows_count INTEGER;
MUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MUT,-4091);
BEGIN

SELECT COUNT(*) INTO rows_count FROM Employe WHERE Code=:NEW.CodeChefZone AND Fonction='Chef de zone' AND ROWNUM=1;
IF rows_count=0
THEN
raise_application_error (-20000,'ChefDeZone '||TO_CHAR(:NEW.CodeChefZone)|| q'!: n'est pas un employe de fonction Chef de zone!');
END IF;
EXCEPTION
WHEN MUT THEN
raise_application_error (-20000,'ChefDeZone '||TO_CHAR(:NEW.CodeChefZone)|| q'!: n'est pas un employe de fonction Chef de zone!');
END;
/
SHOW ERRORS;

SET ECHO OFF
SPOOL OFF