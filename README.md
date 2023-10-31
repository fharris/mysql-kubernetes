# mysql-kubernetes
deploy a simple mysql pod on kubernetes with persistent volumes


1. kubectl create ns mysql

2. kubectl -n mysql create secret generic mysql-db-secret --from-literal=pword=mySQLpword#2023

3. kubectl apply -f persistentvolume.yaml

4. kubectl -n mysql apply -f persistentvolumeclaim.yaml

5. kubectl -n mysql apply -f mysql-persistent-deploy.yaml

6. kubectl -n mysql expose deployment mysql-db-deployment --port=80 --target-port=3306

7. echo "CREATE DATABASE TESTING_PV;" > temp.sql ; kubectl -n mysql exec -it `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name` -- mysql -h 127.0.0.1 -u root -pmySQLpword#2023 < temp.sql ; rm temp.sql;

8. echo "SHOW DATABASES;" > temp.sql ; kubectl -n mysql exec -it `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name` -- mysql -h 127.0.0.1 -u root -pmySQLpword#2023 < temp.sql ; rm temp.sql;

9. kubectl -n mysql delete pod `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name`

10. echo "SHOW DATABASES;" > temp.sql ; kubectl -n mysql exec -it `kubectl -n mysql get --no-headers=true pods -l app=mysql-db -o custom-columns=:metadata.name` -- mysql -h 127.0.0.1 -u root -pmySQLpword#2023 < temp.sql ; rm temp.sql;

Database TESTING_PV shoud still exist after deleting the pod.

