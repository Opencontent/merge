<?php


use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\AttributeConverterLoader;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;

/** @var eZModule $module */
$module = $Params['Module'];
$class = $Params['Class'];
$field = $Params['Field'];
$filters = $Params['Filters'];
$duplicatesValues = array();
$error = false;

try{
	$contentSearch = new ContentSearch();
	$currentEnvironment = EnvironmentLoader::loadPreset('full');
	$contentSearch->setEnvironment($currentEnvironment);
	$language = eZLocale::currentLocaleCode();
	$query = "classes [{$class}] facets [{$field}] limit 1";
	if ($filters){
		$query .= " and {$filters}";
	}
	$data = $contentSearch->search($query);
	$facets = $data->facets;

	$duplicates = array();
	foreach ($facets[0]['data'] as $value => $count) {
		if ($count > 1 && !empty($value)){
			$duplicates[] = $value;
		}
	}

	foreach ($duplicates as $duplicate) {
		$query = "select-fields [metadata.id as id, metadata.name as name, metadata.mainNodeId as node_id] classes [{$class}] and {$field} in [{$duplicate}]";
		if ($filters){
			$query .= " and {$filters}";
		}
		$duplicatesValues[$duplicate] = $contentSearch->search($query);
	}
}catch(Exception $e){
	$error = $e->getMessage();
}

$tpl = eZTemplate::factory();
$tpl->setVariable('error', $error);
$tpl->setVariable('class', $class);
$tpl->setVariable('field', $field);
$tpl->setVariable('duplicates', $duplicatesValues);
$Result['content'] = $tpl->fetch( 'design:merge/duplicates.tpl' );
$Result['path'] = array( array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Merge' ) ),
                         array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Find duplicates' ) ) );
