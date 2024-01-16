#!/bin/bash

set -e

eval "$(jq -r '@sh "tcp_health_check_link=\(.tcp_health_check_link) region=\(.region)"')"

backend_service_name=$(gcloud compute backend-services list --filter="name~'firoportal'" --format="value(NAME)")

gcloud compute backend-services update $backend_service_name --health-checks=$tcp_health_check_link --global

external_ip=$(kubectl get ingress --field-selector metadata.name=firoportal-ingress --output json | jq -r '.items[0].status.loadBalancer.ingress[0].ip')

jq -n \
    --arg backend_service_name "$backend_service_name" \
    --arg external_ip "$external_ip" \
    '{"backend_service_name":$backend_service_name, "external_ip":$external_ip}'