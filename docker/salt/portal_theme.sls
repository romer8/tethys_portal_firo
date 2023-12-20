{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set STATIC_ROOT = salt['environ.get']('STATIC_ROOT') %}

Move_Custom_Theme_Files_to_Static_Root:
  cmd.run:
    - name: mv /tmp/custom_theme {{ STATIC_ROOT }}
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/custom_theme_setup_complete" ];"

Apply_Custom_Theme:
  cmd.run:
    - name: >
        tethys site
        --site-title "FIRO Tethys Portal"
        --brand-text "FIRO Tethys Portal"
        --apps-library-title "Tools"
        --primary-color "#01200F"
        --secondary-color "#358600"
        --background-color "#ffffff"
        --brand-image "/custom_theme/images/leaf-logo.png"
        --favicon "/custom_theme/images/favicon.ico"
        --copyright "Copyright © 2023 Aquaveo"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/custom_theme_setup_complete" ];"

Flag_Custom_Theme_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/custom_theme_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/custom_theme_setup_complete" ];"