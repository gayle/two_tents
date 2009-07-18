drop database two_tents_development;
create database two_tents_development;
drop database two_tents_test;
create database two_tents_test;
drop database two_tents_production;
create database two_tents_production;

grant all on two_tents_development.* to 'two_tents'@'localhost' identified by 'two_tents-pass';
grant all on two_tents_development.* to 'two_tents'@'%' identified by 'two_tents-pass';
grant all on two_tents_test.* to 'two_tents'@'localhost' identified by 'two_tents-pass';
grant all on two_tents_test.* to 'two_tents'@'%' identified by 'two_tents-pass';
grant all on two_tents_production.* to 'two_tents'@'localhost' identified by 'two_tents-pass';
grant all on two_tents_production.* to 'two_tents'@'%' identified by 'two_tents-pass';
