--
-- Script de creation des tables
-- Auteurs
-- Code permanent: JOUG08108901
-- Code permanent: PROM18118300
-- 
SPOOL resultats/create.res
SET ECHO ON

CREATE TABLE Employe
(
  Code           VARCHAR(3)      NOT NULL,
  NAS            INTEGER         NOT NULL,
  Adr            VARCHAR(40)     NOT NULL,
  Tel            INTEGER         NOT NULL,
  Fonction       VARCHAR2(20)    NOT NULL,
  Service        VARCHAR2(20)    NOT NULL,
  Nom            VARCHAR(20)     NOT NULL,
  Prenom         VARCHAR(20)     NOT NULL,
  NaissanceDate  DATE            NOT NULL,
  NomJeuneFille  VARCHAR(20)     NULL,
  PRIMARY KEY 	(Code),
    CHECK (NAS >= 0 AND NAS < 1000000000),
    CHECK (Tel >= 0 AND Tel < 10000000000),
	CHECK (Fonction IN ('Chef de zone', 'Surveillant', 'Secretaire', 'Comptable', 'Chef du personnel', 'Directeur', 'Veterinaire', 'Infirmiere')),
	CHECK (Service IN ('Surveillance', 'Administratif', 'Medical'))
)
/

CREATE TABLE Salaire
(
  Code           VARCHAR (3)     NOT NULL,
  Mois           INTEGER         NOT NULL,
  Salaire        DECIMAL         NOT NULL,
  PRIMARY KEY (Code, Mois),
	CHECK (Salaire >= 0)
)
/

CREATE TABLE Mois
(
  Mois           INTEGER         NOT NULL,
  PRIMARY KEY (Mois),
    CHECK (Mois > 0 AND Mois < 13)
)
/

CREATE TABLE ChefDeZone
(        
  CodeChefZone   VARCHAR (3)     NOT NULL,
  NomZone        VARCHAR(20)     NOT NULL,
  PRIMARY KEY (CodeChefZone)
)
/

CREATE TABLE Zone
(        
  Nom            VARCHAR(20)     NOT NULL,
  PRIMARY KEY (Nom)
)
/

CREATE TABLE Choix
(        
  NomZone         VARCHAR(20)     NOT NULL,
  CodeSurveillant VARCHAR (3)     NOT NULL,
  Affinite        VARCHAR(20)     NOT NULL,
  PRIMARY KEY (NomZone, CodeSurveillant),
    CHECK (Affinite IN ('favorite', 'non apprecie'))
)
/

CREATE TABLE Surveillant
(        
  CodeSurveillant VARCHAR (3)     NOT NULL,
  Taux            DECIMAL         NOT NULL,
  Grade           VARCHAR (2)     NOT NULL,
  PRIMARY KEY (CodeSurveillant),
	CHECK (Taux >= 0),
	CHECK (Grade IN ('G1', 'G2', 'G3', 'G4', 'G5'))
)
/

CREATE TABLE Surveillance
(        
  Jour            DATE            NOT NULL,
  NomZone         VARCHAR(20)     NOT NULL,
  NumLotissement  INTEGER         NOT NULL,
  Heure           INTEGER         NOT NULL,
  CodeSurveillant VARCHAR (3)     NOT NULL,
  PRIMARY KEY (Jour, NomZone, NumLotissement, Heure),
	CHECK (NumLotissement > 0),
	CHECK (Heure > 0 AND Heure < 25)
)
/

CREATE TABLE Lotissement
(        
  NomZone         VARCHAR(20)     NOT NULL,
  Numero          INTEGER         NOT NULL,
  PRIMARY KEY (NomZone, Numero),
	CHECK (Numero > 0)
)
/

CREATE TABLE Individu
(        
  Numero          INTEGER         NOT NULL,
  Nom             VARCHAR(20)     NOT NULL,
  Sang            VARCHAR (3)     NULL,
  NaissanceDate   DATE            NULL,
  DecesDate       DATE            NULL,
  NumPere         INTEGER         NULL,
  NumMere         INTEGER         NULL,
  NomEspece       VARCHAR(40)     NOT NULL,
  NomZone         VARCHAR(20)     NOT NULL,
  NumLotissement  INTEGER         NOT NULL,
  PRIMARY KEY (Numero),
	CHECK (Numero > 0),
	CHECK (NumLotissement > 0)
)
/

CREATE TABLE Mesures
(
  NumIndividu          INTEGER         NOT NULL,
  DateMesure           DATE            NOT NULL,
  Poids                INTEGER         NOT NULL,
  Taille               INTEGER         NOT NULL,
  PRIMARY KEY (NumIndividu, DateMesure),
  	CHECK (Poids > 0),
	CHECK (Taille > 0)
)
/

CREATE TABLE Espece
(
  NomEspece       VARCHAR(40)     NOT NULL,
  Nombre          INTEGER         NULL,
  PRIMARY KEY (NomEspece),
	CHECK (Nombre > 0)
)
/

ALTER TABLE Salaire ADD CONSTRAINTS FKSalaire FOREIGN KEY (Code) REFERENCES Employe (Code) ON DELETE CASCADE INITIALLY DEFERRED
/

ALTER TABLE Salaire ADD CONSTRAINTS FKSalaire2 FOREIGN KEY (Mois) REFERENCES Mois (Mois) INITIALLY DEFERRED
/

ALTER TABLE ChefDeZone ADD CONSTRAINTS FKChefDeZone FOREIGN KEY (NomZone) REFERENCES Zone (Nom) INITIALLY DEFERRED
/

ALTER TABLE ChefDeZone ADD CONSTRAINTS FKChefDeZone2 FOREIGN KEY (CodeChefZone) REFERENCES Employe (Code) INITIALLY DEFERRED
/

ALTER TABLE Choix ADD CONSTRAINTS FKChoix FOREIGN KEY (NomZone) REFERENCES Zone (Nom) ON DELETE CASCADE INITIALLY DEFERRED
/

ALTER TABLE Choix ADD CONSTRAINTS FKChoix2 FOREIGN KEY (CodeSurveillant) REFERENCES Surveillant (CodeSurveillant) INITIALLY DEFERRED
/

ALTER TABLE Surveillant ADD CONSTRAINTS FKSurveillant FOREIGN KEY (CodeSurveillant) REFERENCES Employe (Code) INITIALLY DEFERRED
/

ALTER TABLE Surveillance ADD CONSTRAINTS FKSurveillance FOREIGN KEY (CodeSurveillant) REFERENCES Surveillant (CodeSurveillant) ON DELETE CASCADE INITIALLY DEFERRED
/

ALTER TABLE Surveillance ADD CONSTRAINTS FKSurveillance2 FOREIGN KEY (NomZone, NumLotissement) REFERENCES Lotissement (NomZone, Numero) ON DELETE CASCADE INITIALLY DEFERRED
/

ALTER TABLE Lotissement ADD CONSTRAINTS FKLotissement FOREIGN KEY (NomZone) REFERENCES Zone (Nom) ON DELETE CASCADE INITIALLY DEFERRED
/

ALTER TABLE Individu ADD CONSTRAINTS FKIndividu FOREIGN KEY (NomZone, NumLotissement) REFERENCES Lotissement (NomZone, Numero) INITIALLY DEFERRED
/

ALTER TABLE Individu ADD CONSTRAINTS FKIndividu2 FOREIGN KEY (NomEspece) REFERENCES Espece (NomEspece) ON DELETE CASCADE INITIALLY DEFERRED
/

ALTER TABLE Individu ADD CONSTRAINTS FKIndividu3 FOREIGN KEY (NumPere) REFERENCES Individu (Numero) ON DELETE SET NULL INITIALLY DEFERRED
/

ALTER TABLE Individu ADD CONSTRAINTS FKIndividu4 FOREIGN KEY (NumMere) REFERENCES Individu (Numero) ON DELETE SET NULL INITIALLY DEFERRED
/

ALTER TABLE Mesures ADD CONSTRAINTS FKMesures  FOREIGN KEY (NumIndividu) REFERENCES Individu (Numero) ON DELETE CASCADE INITIALLY DEFERRED
/

SET ECHO OFF

SPOOL OFF












