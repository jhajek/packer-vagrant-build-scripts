# change the permissions IP
# https://stackoverflow.com/questions/7616520/how-do-execute-a-sql-script-from-bash
# http://stackoverflow.com/questions/2857446/error-1130-in-mysql
# localhost install
-- Create a database
-- Using your chosen database server, create a new empty database. The default encoding must be UTF8. For example, using MySQL:
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO moodleuser@localhost IDENTIFIED BY 'letmein2';
flush privileges;

-- If using remote server uncomment this code
-- CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Create a user/password combination with appropriate permissions for the database. For example (MySQL again):
-- GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'moodleuser'@'localhost' IDENTIFIED BY 'yourpassword';
-- flush privileges;

-- Code to create a user only to be used for mysqldump with limited privilleges
-- CREATE USER 'backup'@'localhost' IDENTIFIED BY 'secret';
-- http://www.fromdual.com/privileges-of-mysql-backup-user-for-mysqldump
CREATE USER 'backup'@'localhost' IDENTIFIED BY 'CHANGEME';
GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';