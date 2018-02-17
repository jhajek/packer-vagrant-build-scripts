<html>
<head><title>SQL query</title></head>
<body>


<?php

// change this endpoint to the IP of your database server
$endpoint="192.168.1.240";  // this is the public IP of the database server
$user="username"; //this is the same username that you created in the create-user-with-grants.sql file -- change this from root as root is not allowed to make remote connections at all in mysql anymore
$password="pword";  //this is the password that you entered in the create-user-with-grants.sql file after the IDENTIFIED BY string
$db-name="store"; //this is the name of the database you created in create.sql -- store if you keep the default setting 
echo "begin database";
$link = mysqli_connect($endpoint,$user,$password,$db) or die("Error "
. mysqli_error($link));

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

$link->real_query("SELECT * FROM items");
$res = $link->use_result();

echo "Result set order...\n";
while ($row = $res->fetch_assoc()) {
    echo " id = " . $row['id'] . "\n";
    echo " phone = " . $row['phone'] . "\n";
    echo " email = " . $row['email'] . "\n";
    echo " s3finishedurl = " . $row['s3finishedurl'] . "\n";
}


$link->close();

?>

</body>
</html>