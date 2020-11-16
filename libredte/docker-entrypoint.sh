#!/bin/sh
set -e 

until PGPASSWORD=$POSTGRES_PASSWORD psql -h postgres -U $POSTGRES_USER -c '\q'; do
    >&2 echo "Postgres is unavailable - sleep"
    sleep 5
done

export PGPASSWORD=$POSTGRES_PASSWORD 
psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -f "/usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/Usuarios/Model/Sql/PostgreSQL/usuarios.sql"

psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -f "/usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/General/Model/Sql/moneda.sql"

psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -f "/app/website/Module/Sistema/Module/General/Model/Sql/PostgreSQL/actividad_economica.sql"

#psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\copy /usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/General/Model/Sql/moneda.sql"



apk add ttf-opensans gnumeric

#Actividad economica
ssconvert --export-type=Gnumeric_stf:stf_csv './website/Module/Sistema/Module/General/Model/Sql/actividad_economica.ods' fd://1 | awk -F, '{if (!a[$1]++) print}' > /tmp/actividad_economica.csv 

psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\copy actividad_economica FROM '/tmp/actividad_economica.csv' csv header"

# DivisionGeopolitica1
ssconvert --export-type=Gnumeric_stf:stf_csv '/usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/General/Module/DivisionGeopolitica/Model/Sql/division_geopolitica.ods' fd://1 | awk -F, '{if (!a[$1]++) print}' > /tmp/division_geopolitica.csv 

psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER} -c 'CREATE TABLE division_geopolitica (codigo CHAR(5) PRIMARY KEY, comuna CHAR(5), CONSTRAINT division_geopolitica_comuna_fk FOREIGN KEY(comuna) REFERENCES comuna(codigo) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE, provincia CHAR(3), CONSTRAINT division_geopolitica_provincia_fk FOREIGN KEY(provincia) REFERENCES provincia (codigo) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE)'

psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER} -f "/usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/General/Module/DivisionGeopolitica/Model/Sql/PostgreSQL/division_geopolitica.sql"

#psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\copy division_geopolitica FROM '/tmp/division_geopolitica.csv' csv header"


psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER} -f "/app/website/Module/Dte/Model/Sql/PostgreSQL.sql"

ssconvert '/app/website/Module/Dte/Model/Sql/datos.ods' /tmp/datos.csv

#psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\copy division_geopolitica FROM '/tmp/division_geopolitica.csv' csv header"

mkdir -p /app/data/static/contribuyentes && chmod 775 /app/data/static/contribuyentes

while [ true ]; do 
    sleep 10
done
>&2 echo "Postgres is available"

