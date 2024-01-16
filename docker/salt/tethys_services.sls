{% set ALLOWED_HOSTS = salt['environ.get']('ALLOWED_HOSTS') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}

{% set TETHYS_DB_HOST = salt['environ.get']('TETHYS_DB_HOST') %}
{% set TETHYS_DB_PORT = salt['environ.get']('TETHYS_DB_PORT') %}
{% set TETHYS_DB_SUPERUSER = salt['environ.get']('TETHYS_DB_SUPERUSER') %}
{% set TETHYS_DB_SUPERUSER_PASS = salt['environ.get']('TETHYS_DB_SUPERUSER_PASS') %}
{% set POSTGIS_SERVICE_NAME = 'tethys_postgis' %}
{% set POSTGIS_SERVICE_URL = TETHYS_DB_SUPERUSER + ':' + TETHYS_DB_SUPERUSER_PASS + '@' + TETHYS_DB_HOST + ':' + TETHYS_DB_PORT %}

Create_PostGIS_Database_Service:
  cmd.run:
    - name: "tethys services create persistent -n {{ POSTGIS_SERVICE_NAME }} -c {{ POSTGIS_SERVICE_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Setup_In_Memory_Channel_Layer:
  cmd.run:
    - name: "tethys settings --set CHANNEL_LAYERS.default.BACKEND channels_redis.core.RedisChannelLayer"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Set_Allowed_Hosts:
  cmd.run:
    - name: "tethys settings --set ALLOWED_HOSTS $(python -c 'from socket import gethostname, gethostbyname_ex; print(str({{ ALLOWED_HOSTS }}[1:-2].split(\", \") + list(set(gethostbyname_ex(gethostname())[2]))).replace(\" \", \"\"))')"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Update_ASGI_Supervisord_Config:
  file.rename:
    - source: {{ TETHYS_HOME }}/configs/asgi_supervisord.conf
    - name: {{ TETHYS_HOME }}/asgi_supervisord.conf
    - force: True
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Flag_Tethys_Services_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/tethys_services_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"