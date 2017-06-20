DROP TABLE IF EXISTS household_dim;

CREATE TABLE household_dim
(
  household_id       BIGSERIAL PRIMARY KEY ,
  addressline1       VARCHAR(50)             NULL,
  addressline2       VARCHAR(50)             NULL,
  raw_city_state_zip VARCHAR(50)             NULL,
  city               VARCHAR(25)             NULL,
  state_code         VARCHAR(2)              NULL,
  zip                VARCHAR(25)             NULL,
  geom               GEOMETRY(Point, 102671) NULL,
  geocode_status     CHAR(1) DEFAULT 0,
  hashcode           BIGINT                  NOT NULL
);
CREATE UNIQUE INDEX idx_household_dim_pk
  ON household_dim (household_id);

CREATE INDEX idx_household_dim_lookup
  ON household_dim (hashcode);

CREATE INDEX household_dim_geom_idx
  ON household_dim (geom);


DROP TABLE IF EXISTS voter_dim;
CREATE TABLE voter_dim
(
  voter_id          BIGSERIAL PRIMARY KEY,
  county_voter_id   BIGINT  NULL,
  birth_year        INTEGER NULL,
  gender            CHAR(1) NULL,
  registration_date DATE    NULL,
  registration_year INTEGER NULL,
  age_registered    INTEGER NULL,
  version           INTEGER,
  date_from         TIMESTAMP,
  date_to           TIMESTAMP
);
CREATE INDEX idx_voter_dim_lookup
  ON voter_dim (county_voter_id);
CREATE INDEX idx_voter_dim_tk
  ON voter_dim (voter_id);


DROP TABLE IF EXISTS election_dim;
CREATE TABLE election_dim
(
  election_id   SERIAL PRIMARY KEY ,
  election_type VARCHAR(25),
  election_date DATE,
  election_year INTEGER
);


DROP TABLE if exists voting_fact CASCADE ;
CREATE TABLE voting_fact
(
  voting_fact_id               BIGSERIAL,
  ballot_type                  VARCHAR(25),
  ballot_date                  TIMESTAMP,
  report_date                  DATE,
  election_key                 BIGINT,
  household_id                 BIGINT REFERENCES  household_dim(household_id),
  voter_id                     INTEGER REFERENCES voter_dim(voter_id),
  polling_place_key            INTEGER REFERENCES polling_places(gid),
  days_prior_to_election       INTEGER ,
  years_registered_at_election INTEGER,
  age_at_election              INTEGER
);