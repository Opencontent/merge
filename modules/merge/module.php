<?php

$Module = array('name' => 'Merge');

$ViewList = array();

$ViewList['select'] = array(
    'functions' => array('select'),
    'script' => 'select.php',
    'params' => array()
);

$ViewList['find'] = array(
    'functions' => array('find'),
    'script' => 'find.php',
    'params' => array('ObjectID', 'Field')
);

$ViewList['duplicates'] = array(
    'functions' => array('find'),
    'script' => 'duplicates.php',
    'params' => array('Class', 'Field', 'Filters')
);

$FunctionList['select'] = array();
$FunctionList['find'] = array();

