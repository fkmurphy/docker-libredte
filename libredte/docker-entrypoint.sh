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





>&2 echo "Postgres is available"

