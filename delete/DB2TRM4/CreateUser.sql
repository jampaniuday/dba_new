CREATE USER ^uName IDENTIFIED BY ^uPWD 
	default tablespace tr_data
	temporary tablespace temp;

Grant connect, resource to ^uName;
Grant create any synonym, Create database link to ^uName;
