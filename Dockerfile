FROM openjdk:8
WORKDIR /app
# COPY ./target/employee-jdbc-0.0.1-SNAPSHOT.jar employee-jdbc-0.0.1-SNAPSHOT.jar

COPY ./target-artifact/employee-*.jar employee-jdbc-0.0.1-SNAPSHOT.jar
CMD ["java","-jar","employee-jdbc-0.0.1-SNAPSHOT.jar"]



#docker image build -t employee-jdbc .
#docker container run --network employee-mysql --name employee-jdbc-container -p 8080:8080 -d employee-jdbc

#MySQL container
#docker container run --name mysqldb --network employee-mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=bootdb -d mysql:8
#docker container exec -it ae bash


#docker image build -t employee-jdbc .

# this command will run multiple containers
# docker-compose up

#docker exec -ti container_id bash
#curl --header "Content-Type: application/json"   --request POST   --data '{"empId":"232938","empName":"Shroff"}'   http://192.168.99.102:8080/insertemployee
