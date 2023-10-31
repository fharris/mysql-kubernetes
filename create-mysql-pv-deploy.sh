# Deploy a simple mysql pod on kubernetes with persistent volumes

kubectl create ns mysql

kubectl -n mysql create secret generic mysql-db-secret --from-literal=pword=mySQLpword#2023

kubectl apply -f mysql-kubernetes/persistentvolume.yaml

kubectl -n mysql apply -f mysql-kubernetes/persistentvolumeclaim.yaml

kubectl -n mysql apply -f mysql-kubernetes/mysql-persistent-deploy.yaml


kubectl -n mysql expose deployment mysql-db-deployment --port=80 --target-port=3306

echo "sleeping for 10 seconds..."
sleep 10

echo "CREATE DATABASE TESTING_PV;" > temp.sql ; kubectl -n mysql exec -it `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name` -- mysql -h 127.0.0.1 -u root -pmySQLpword#2023 < temp.sql ; rm temp.sql;

echo "SHOW DATABASES;" > temp.sql ; kubectl -n mysql exec -it `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name` -- mysql -h 127.0.0.1 -u root -pmySQLpword#2023 < temp.sql ; rm temp.sql;

echo "deleting pod" `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name`
kubectl -n mysql delete pod `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name`

echo "SHOW DATABASES;" > temp.sql ; kubectl -n mysql exec -it `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name` -- mysql -h 127.0.0.1 -u root -pmySQLpword#2023 < temp.sql | grep -in "TESTING_PV" ; rm temp.sql;

## Database TESTING_PV shoud still exist after deleting the pod.
