#!/bin/bash

## URL ENDPOINT DA API PARA RECEBER MÉTRICAS
# Informar o endereço da sua api em docker para executar este script
ENDPOINT="http://api:8080/<meu-endpoint-para-metricas>/"

## Curl to API ##
# DESCRIPTION: Faz uma chamada de API passando as informações de metricas
# ARGUMENTS:
# - ${1} -> Metric Name
# - ${2} -> APP Name
# - ${3} -> Value
function sendCurl() {
    curl -X POST "${ENDPOINT}" -H 'Content-Type: application/json' -d "{\"metricName\":\"${1}\",\"appName\":\"${2}\",\"value\":${3}}"
}

### START PROGRAM ###
while true;
do
    sendCurl "response_time" "ms-system-01" ${RANDOM:0:3}
    sendCurl "error_rate_percentile" "ms-system-01" ${RANDOM:0:2}
    sendCurl "throughput" "ms-system-01" ${RANDOM:0:5}

    sendCurl "response_time" "ms-system-02" ${RANDOM:0:3}
    sendCurl "error_rate_percentile" "ms-system-02" ${RANDOM:0:2}
    sendCurl "throughput" "ms-system-02" ${RANDOM:0:5}

    sendCurl "response_time" "ms-system-03" ${RANDOM:0:3}
    sendCurl "error_rate_percentile" "ms-system-03" ${RANDOM:0:2}
    sendCurl "throughput" "ms-system-03" ${RANDOM:0:5}

    sendCurl "response_time" "ms-system-04" ${RANDOM:0:3}
    sendCurl "error_rate_percentile" "ms-system-04" ${RANDOM:0:2}
    sendCurl "throughput" "ms-system-04" ${RANDOM:0:5}

    sendCurl "response_time" "ms-system-05" ${RANDOM:0:3}
    sendCurl "error_rate_percentile" "ms-system-05" ${RANDOM:0:2}
    sendCurl "throughput" "ms-system-05" ${RANDOM:0:5}
    
    sleep 30
done
