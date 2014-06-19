<?php

$http = eZHTTPTool::instance();
$Module = $Params['Module'];

$selectedArray = array();
$mergeNodeMaster = false;
$translationMap = array();

// Update master node
if ( $http->hasPostVariable( 'MergeNodeMaster' ) )
{
    $mergeNodeMaster = $http->postVariable( 'MergeNodeMaster' );    
}

// Get any new candidate nodes to merge
if ( $http->hasPostVariable( 'BrowseActionName' ) AND $http->postVariable( 'BrowseActionName' ) == 'MergeObjects' )
{
    if ( $http->hasPostVariable( 'SelectedNodeIDArray' ) )
    {
        $selectedArray = array_merge( $selectedArray, $http->postVariable( 'SelectedNodeIDArray' ) );
    }
}

if ( $http->hasPostVariable( 'MergeAction' ) )
{
    $masterNodeID = $http->postVariable( 'MergeNodeMaster' );
    $selectedNodes = $http->postVariable( 'SelectedNodes' );    
    $mergeTranslations = $http->hasPostVariable( 'MergeTranslation' ) ? $http->postVariable( 'MergeTranslation' ) : false;

    try
    {
        $handler = new eZMergeObjectsHandler( $masterNodeID, $selectedNodes, $mergeTranslations  );
        $handler->run();
        $Module->redirectTo( $handler->redirectUrl() );
    }
    catch( Exception $e )
    {
        $tpl->setVariable( 'error', $e->getMessage() );
    }
}

// Get a list of objects selected, and their languages
$tpl = eZTemplate::factory();
$nodeList = array();
$languageList = array();
foreach ( $selectedArray as $key => $nodeID )
{
    $node = eZFunctionHandler::execute( 'content', 'node', array( 'node_id' => $nodeID ) );
    if ( $node )
    {
        if ( empty( $mergeNodeMaster ) )
        {
            $mergeNodeMaster = $nodeID;            
        }

        $object = $node->attribute( 'object' );
        $languages = $object->attribute( 'available_languages' );
        foreach ( $languages as $language )
        {
            if ( !in_array( $language, $languageList ) )
            {
                $languageList[] = $language;
            }
        }

        foreach ( $languageList as $language )
        {
            $node = eZFunctionHandler::execute( 'content', 'node', array( 'node_id' => $nodeID, 'language_code' => $language ) );
            if ( $node && in_array( $language, $node->attribute( 'object' )->attribute( 'available_languages' ) ) )
                $nodeList[$nodeID][$language] = $node;
            // Set default values for translation map
            if ( !isset( $translationMap[$language] ) )
            {
                $translationMap[$language] = $nodeID;                
            }
        }
    }
    else
    {
         unset( $selectedArray[$key] );         
    }
}

$tpl->setVariable( 'node_list', $nodeList );
$tpl->setVariable( 'merge_node_master', $mergeNodeMaster );
$tpl->setVariable( 'translation_map', $translationMap );
$tpl->setVariable( 'language_list', $languageList );

$Result['content'] = $tpl->fetch( 'design:merge/select.tpl' );
$Result['path'] = array( array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Merge' ) ),
                         array( 'url' => false,
                                'text' => ezpI18n::tr( 'kernel/content', 'Select class' ) ) );

?>
