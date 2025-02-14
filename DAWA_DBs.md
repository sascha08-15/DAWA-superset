CREATE TABLE document_fact (
	id serial4 NOT NULL,
	"name" text NULL,
	notes text NULL,
	validity_date date NULL
);


CREATE TABLE date_dimension (
	"date" date NOT NULL,
	day_of_week varchar NULL,
	quarter varchar NULL,
    month varchar NULL,
    year varchar NULL,
	CONSTRAINT date_dimension_pk PRIMARY KEY (date)
);