create database testdb;
create user 'tester'@'%' identified by 'testpass';
grant all privileges on testdb.* to 'tester'@'%';
