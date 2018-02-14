<?php

use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\AttributeConverterLoader;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;


$tpl = eZTemplate::factory();
$http = eZHTTPTool::instance();
$Module = $Params['Module'];
$ObjectID = $Params['ObjectID'];
$Field = $Params['Field'];

$http->removeSessionVariable( 'MergeNodeSelectionList' );
$http->removeSessionVariable( 'MergeNodeMaster' );
$http->removeSessionVariable( 'MergeObjectTranslationMap' );

$object = eZContentObject::fetch( $ObjectID );
if ( !is_object( $object ) )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

$contentSearch = new ContentSearch();
$currentEnvironment = EnvironmentLoader::loadPreset('full');
$contentSearch->setEnvironment($currentEnvironment);

$language = eZLocale::currentLocaleCode();
$query = "q = '{$object->attribute( 'name' )}'";
$fieldValue = false;
if ($Field){	
	$currentContent = Content::createFromEzContentObject($object);
	foreach ($currentContent->data[$language] as $field => $value) {
		if ($field == $Field){
			list( $classIdentifier, $identifier ) = explode('/', $value['identifier']);
            $converter = AttributeConverterLoader::load(
                $classIdentifier,
                $identifier,
                $value['datatype']
            );
            $fieldValue = $converter->toCSVString($value['content']);
		}
	}
	if (is_string($fieldValue)){
		$tpl->setVariable( 'field', $Field );
		$query = "$Field = '$fieldValue'";
	}
}
$query .= " and id != '$ObjectID' and classes [{$object->attribute( 'class_identifier' )}]";
$data = $contentSearch->search($query);
$result = array(
	'SearchCount' => $data->totalCount,
	'SearchResult' => array()
);
foreach ($data->searchHits as $item) {
	$content = new Content($item);
	$result['SearchResult'][] = $content->getContentObject($language)->attribute('main_node');
}

$tpl->setVariable( 'current_object', $object );
$tpl->setVariable( 'search_result', $result );

$Result['content'] = $tpl->fetch( 'design:merge/find.tpl' );
$Result['path'] = array( array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Merge' ) ),
                         array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Find duplicates' ) ) );
