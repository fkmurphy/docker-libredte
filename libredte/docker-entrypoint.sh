#!/bin/sh
set -e 

if [ ! -f /app/ready ]; then

    until PGPASSWORD=$POSTGRES_PASSWORD psql -h postgres -U $POSTGRES_USER -c '\q'; do
        >&2 echo "Postgres is unavailable - sleep"
        sleep 5
    done

    export PGPASSWORD=$POSTGRES_PASSWORD 
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -f "/usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/Usuarios/Model/Sql/PostgreSQL/usuarios.sql"

    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -f "/usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/General/Model/Sql/moneda.sql"

    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -f "/app/website/Module/Sistema/Module/General/Model/Sql/PostgreSQL/actividad_economica.sql"

    #actividad economica
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY actividad_economica FROM '/tmp/actividad_economica.csv' delimiter ',' csv header;"
    #psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\copy /usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/General/Model/Sql/moneda.sql"

    ##Division geopolitica
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER} -f "/usr/share/sowerphp/extensions/sowerphp/app/Module/Sistema/Module/General/Module/DivisionGeopolitica/Model/Sql/PostgreSQL/division_geopolitica.sql"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY region FROM '/tmp/division_geopolitica.csv' delimiter ',' csv header;"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY provincia FROM '/tmp/provincia.csv' delimiter ',' csv header;"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY comuna FROM '/tmp/comuna.csv' delimiter ',' csv header;"



    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER} -f "/app/website/Module/Dte/Model/Sql/PostgreSQL.sql"


    mkdir -p /app/data/static/contribuyentes && chmod 775 /app/data/static/contribuyentes
    #download csv


    echo "REFERENCIA TIPO"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY dte_referencia_tipo FROM '/tmp/datos.csv' delimiter ',' csv header;"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY dte_tipo FROM '/tmp/dte_tipo.csv' delimiter ',' csv header;"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY impuesto_adicional FROM '/tmp/impuesto_adicional.csv' delimiter ',' csv header;"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "\COPY iva_no_recuperable FROM '/tmp/iva_no_recuperable.csv' delimiter ',' csv header;"

    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "INSERT INTO contribuyente VALUES (55555555, '5', 'Extranjero', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NOW());"
    psql -d${POSTGRES_DB} -h postgres -a -U${POSTGRES_USER}  -c "INSERT INTO contribuyente VALUES (66666666, '6', 'Sin razón social informada', 'Sin giro informado', NULL, NULL, NULL, 'Sin dirección informada', '13101', NULL, NOW());"

    #apk add ttf-opensans gnumeric


    touch /app/ready
fi

exec "$@"
