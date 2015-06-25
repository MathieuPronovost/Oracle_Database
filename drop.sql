--
-- Script de nettoyage
-- Auteurs
-- Code permanent: JOUG08108901
-- Code permanent: PROM18118300
--
SPOOL resultats/drop.res

SET ECHO ON

--TRIGGERS

DROP TRIGGER Employe_NaissanceDateValide;
DROP TRIGGER Employe_FonctionService;
DROP TRIGGER Surveillance_UneZoneParJour;
DROP TRIGGER Surveillance_UneZoneParJour2;
DROP TRIGGER Surveillance_PasMemeLotDeSuite;
DROP TRIGGER Surveillance_PasMemeLotDeSuit2;
DROP TRIGGER Choix_LimiteAffinite;
DROP TRIGGER Lotissement_Ins_NumSuccessifs;
DROP TRIGGER Lotissement_Upd_NumSuccessifs;
DROP TRIGGER Individu_ExclusEspeceIndividu;
DROP TRIGGER Individu_ExclusEspeceIndividu2;
DROP TRIGGER Individu_DecesDateValide;
DROP TRIGGER Individu_DecesDateValide2;
DROP TRIGGER Individu_ParentsNaissValide;
DROP TRIGGER Individu_ParentsMemeEspece;
DROP TRIGGER Individu_MereSiPere;
DROP TRIGGER Individu_MereSiPere2;
DROP TRIGGER Individu_EnfantsPasParents;
DROP TRIGGER Individu_ParentPasParent;
DROP TRIGGER Individu_UnLotParEspece;
DROP TRIGGER Individu_UnLotParEspece2;
DROP TRIGGER Surveillant_EmployeSurveillant;
DROP TRIGGER Employe_EmployeSurveillant;
DROP TRIGGER ChefDeZone_EmployeChefDeZone;
DROP TRIGGER Employe_EmployeChefDeZone;

-- CONSTRAINTS
ALTER TABLE Salaire DROP CONSTRAINTS FKSalaire
/

ALTER TABLE Salaire DROP CONSTRAINTS FKSalaire2
/

ALTER TABLE ChefDeZone DROP CONSTRAINTS FKChefDeZone
/

ALTER TABLE ChefDeZone DROP CONSTRAINTS FKChefDeZone2
/

ALTER TABLE Choix DROP CONSTRAINTS FKChoix
/

ALTER TABLE Choix DROP CONSTRAINTS FKChoix2
/

ALTER TABLE Surveillance DROP CONSTRAINTS FKSurveillance
/

ALTER TABLE Surveillance DROP CONSTRAINTS FKSurveillance2
/

ALTER TABLE Lotissement DROP CONSTRAINTS FKLotissement
/

ALTER TABLE Individu DROP CONSTRAINTS FKIndividu
/

ALTER TABLE Individu DROP CONSTRAINTS FKIndividu2
/

ALTER TABLE Individu DROP CONSTRAINTS FKIndividu3
/

ALTER TABLE Individu DROP CONSTRAINTS FKIndividu4
/

ALTER TABLE Mesures DROP CONSTRAINTS FKMesures
/

-- TABLES
DROP TABLE Salaire
/

DROP TABLE Mois
/

DROP TABLE ChefDeZone
/

DROP TABLE Zone
/

DROP TABLE Choix
/

DROP TABLE Surveillant
/

DROP TABLE Surveillance
/

DROP TABLE Lotissement
/

DROP TABLE Individu
/

DROP TABLE Mesures
/

DROP TABLE Espece
/

DROP TABLE Employe
/

SET ECHO OFF

SPOOL OFF
