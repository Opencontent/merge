<?php

$http = eZHTTPTool::instance();
$Module = $Params['Module'];
$ObjectID = $Params['ObjectID'];

$http->removeSessionVariable( 'MergeNodeSelectionList' );
$http->removeSessionVariable( 'MergeNodeMaster' );
$http->removeSessionVariable( 'MergeObjectTranslationMap' );

$object = eZContentObject::fetch( $ObjectID );
if ( !is_object( $object ) )
{
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

$SearchParameters = array(
    'SearchOffset' => 0,
    'SearchLimit' => 1000,
    'Filter' => array( '-meta_id_si:' . $ObjectID ),
    'SearchContentClassID' => array( $object->attribute( 'class_identifier' ) )
);
$solrSearch = new eZSolr();

$result = $solrSearch->search( $object->attribute( 'name' ), $SearchParameters );
$tpl = eZTemplate::factory();
$tpl->setVariable( 'current_object', $object );
$tpl->setVariable( 'search_result', $result );

$Result['content'] = $tpl->fetch( 'design:merge/find.tpl' );
$Result['path'] = array( array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Merge' ) ),
                         array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Find duplicates' ) ) );
