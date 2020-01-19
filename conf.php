<?php
// Modified by L0C4LH34RTZ - INDOXPLOIT.OR.ID
// DONT CHANGE COPYRIGHT OR I'LL ENCRYPT THIS
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require('vendor/autoload.php');

$one = explode("|", $argv[1])[0];
$two  = explode("|", $argv[1])[1];
$three = explode("|", $argv[1])[2];
$four = explode("|", $argv[1])[3];

$mail = new PHPMailer(true);

// Settings
$mail->IsSMTP();
$mail->CharSet = 'UTF-8';

$mail->Host       = $one; // SMTP server example
$mail->SMTPDebug  = 3;                     // enables SMTP debug information (for testing)
$mail->SMTPAuth   = true;                  // enable SMTP authentication
$mail->Port       = (int) $two;                    // set the SMTP port for the GMAIL server
$mail->Username   = $three; // SMTP account username example
$mail->Password   = $four;        // SMTP account password example

$mail->setFrom('noreply@kipkipfun.com'); // Set From Mail
$mail->addAddress('abdiprawiran@yahoo.com'); // Put your email here

// Content
$mail->isHTML(true);                                  // Set email format to HTML
$mail->Subject = '=== ZeroByte.ID ===';
$mail->Body    = '<h2>ZeroByte.ID SMTP Checker</h2><br/>==============================<br/>Going to Inbox ? Or this is shit SMTP ?<br/>';
$mail->AltBody = '';

$mail->send();
?>
