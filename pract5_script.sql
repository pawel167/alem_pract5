-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION postgres;

-- DROP SEQUENCE public.film_id_seq;

CREATE SEQUENCE public.film_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.film_id_seq1;

CREATE SEQUENCE public.film_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.hall_id_seq;

CREATE SEQUENCE public.hall_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.hall_id_seq1;

CREATE SEQUENCE public.hall_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.hall_row_id_hall_seq;

CREATE SEQUENCE public.hall_row_id_hall_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.hall_row_id_hall_seq1;

CREATE SEQUENCE public.hall_row_id_hall_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.screening_id_seq;

CREATE SEQUENCE public.screening_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.screening_id_seq1;

CREATE SEQUENCE public.screening_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.tickets_id_screening_seq;

CREATE SEQUENCE public.tickets_id_screening_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.tickets_id_screening_seq1;

CREATE SEQUENCE public.tickets_id_screening_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.film definition

-- Drop table

-- DROP TABLE public.film;

CREATE TABLE public.film (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description varchar(2000) NOT NULL,
	CONSTRAINT film_pkey PRIMARY KEY (id)
);


-- public.hall definition

-- Drop table

-- DROP TABLE public.hall;

CREATE TABLE public.hall (
	id serial4 NOT NULL,
	"name" varchar(100) NOT NULL,
	CONSTRAINT hall_pkey PRIMARY KEY (id)
);


-- public.hall_row definition

-- Drop table

-- DROP TABLE public.hall_row;

CREATE TABLE public.hall_row (
	id_hall serial4 NOT NULL,
	"_number" int2 NOT NULL,
	capacity int2 NOT NULL,
	CONSTRAINT hall_row_pkey PRIMARY KEY (id_hall, _number),
	CONSTRAINT hall_row_id_hall_fkey FOREIGN KEY (id_hall) REFERENCES public.hall(id)
);


-- public.screening definition

-- Drop table

-- DROP TABLE public.screening;

CREATE TABLE public.screening (
	id serial4 NOT NULL,
	hall_id int4 NOT NULL,
	film_id int4 NOT NULL,
	"time" timestamp NOT NULL,
	CONSTRAINT screening_pkey PRIMARY KEY (id),
	CONSTRAINT screening_film_id_fkey FOREIGN KEY (film_id) REFERENCES public.film(id),
	CONSTRAINT screening_hall_id_fkey FOREIGN KEY (hall_id) REFERENCES public.hall(id)
);


-- public.tickets definition

-- Drop table

-- DROP TABLE public.tickets;

CREATE TABLE public.tickets (
	id_screening serial4 NOT NULL,
	"row" int2 NOT NULL,
	seat int2 NOT NULL,
	"cost" int4 NOT NULL,
	CONSTRAINT tickets_pkey PRIMARY KEY (id_screening, "row", seat),
	CONSTRAINT tickets_id_screening_fkey FOREIGN KEY (id_screening) REFERENCES public.screening(id)
);


-- public.film_prokat source

CREATE OR REPLACE VIEW public.film_prokat
AS SELECT film.name AS "название фильма"
   FROM screening
     JOIN film ON film.id = screening.film_id
     JOIN hall ON hall.id = screening.hall_id
  WHERE film.name::text = 'дюна'::text;


-- public.public_rasp_in_hall source

CREATE OR REPLACE VIEW public.public_rasp_in_hall
AS SELECT film.name AS "название фильма",
    hall.name AS "название зала",
    screening."time" AS "время сеанса"
   FROM screening
     JOIN film ON film.id = screening.film_id
     JOIN hall ON hall.id = screening.hall_id
  WHERE screening.hall_id = 2;


-- public.rasp_film source

CREATE MATERIALIZED VIEW public.rasp_film
TABLESPACE pg_default
AS SELECT film.name AS "название фильма"
   FROM screening
     JOIN film ON film.id = screening.film_id
  WHERE screening."time" > '2021-01-01 11:00:00'::timestamp without time zone
WITH DATA;
