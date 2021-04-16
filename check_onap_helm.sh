#!/bin/bash

echo "------------------------------------------------------------------------"
echo "-------------------  ONAP Check helm charts ----------------------------"
echo "------------------------------------------------------------------------"
code=0
nb_charts=$(helm ls |awk {'print $1'}|grep -v NAME |wc -l)
nb_failed_charts=0

# List Helm chart and get their status
for i in $(helm ls |awk {'print $1'}|grep -v NAME);do
    echo "Chart $i"
    status=$(helm status $i |grep STATUS:)
    echo ${status}
    if [ "${status}" != "STATUS: DEPLOYED" ]; then
        echo "Chart problem"
        helm status $i -o yaml
        code=1
        let "nb_failed_charts++"
    fi
    echo "--------------------------------------------------------------------"
done

echo "------------------------------------------------"
echo "------- ONAP Helm tests ------------------------"
echo "------------------------------------------------"
echo ">>> Nb Helm charts: ${nb_charts}"
echo ">>> Nb Failed Helm charts: ${nb_failed_charts}"
echo "------------------------------------------------"
echo "------------------------------------------------"
echo "------------------------------------------------"

exit $code
