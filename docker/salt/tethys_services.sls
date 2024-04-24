{% set ALLOWED_HOSTS = salt['environ.get']('ALLOWED_HOSTS') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}
{% set ALLOWED_CIDR_RANGE = salt['environ.get']('ALLOWED_CIDR_RANGE') %}
{% set PREFIX_URL = salt['environ.get']('PREFIX_URL') %}

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
    - name: "tethys settings --set ALLOWED_HOSTS ['{{ ALLOWED_HOSTS }}']"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Set_Allowed_CIDR_Middleware:
  cmd.run:
    - name: "tethys settings --set MIDDLEWARE ['allow_cidr.middleware.AllowCIDRMiddleware']"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Set_Allowed_CIDR_Range:
  cmd.run:
    - name: "tethys settings --set ALLOWED_CIDR_NETS ['{{ ALLOWED_CIDR_RANGE }}']"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Set_Prefix_URL:
  cmd.run:
    - name: "tethys settings --set PREFIX_URL {{ PREFIX_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Update_NGINX_Static_Location:
  cmd.run:
    - name: "sed -i 's/location \\/static/location \\/{{ PREFIX_URL }}\\/static/' {{ TETHYS_HOME }}/tethys_nginx.conf"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Update_NGINX_Workspace_Location:
  cmd.run:
    - name: "sed -i 's/location \\/workspaces/location \\/{{ PREFIX_URL }}\\/workspaces/' {{ TETHYS_HOME }}/tethys_nginx.conf"
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