BEGIN;

CREATE OR REPLACE FUNCTION city_center(_lat1 numeric, _lng1 numeric, _lat2 numeric, _lng2 numeric)
RETURNS point AS $$
  BEGIN
    RETURN center(box(point(_lat1, _lng1), point(_lat2, _lng2)));
  END;
$$ LANGUAGE 'plpgsql' STABLE;

CREATE OR REPLACE FUNCTION city_bounds(_lat1 numeric, _lng1 numeric, _lat2 numeric, _lng2 numeric)
RETURNS cube AS $$
  DECLARE
    _center point;
    _radius numeric;
    _earth  earth;
  BEGIN
    SELECT INTO _center city_center(_lat1, _lng1, _lat2, _lng2);
    SELECT INTO _earth  ll_to_earth((_center)[0], (_center)[1]);
    SELECT INTO _radius earth_distance(_earth, ll_to_earth(_lat1, _lng1));
    RETURN earth_box(_earth, _radius);
  END;
$$ LANGUAGE 'plpgsql' STABLE;

COMMIT;