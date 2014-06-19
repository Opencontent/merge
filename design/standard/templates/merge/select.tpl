{def $used_languages = array()
     $can_merge = count( $node_list )|eq( 2 )
     $contains_class = ''
     $relation_count = 0
     $reverse_count = 0
     $attributes = array()}

{if is_set( $error )}
{$error}
{else}

<h1>Seleziona l'oggetto che desideri mantenere {if ezini( 'MergeSettings', 'LanguagesGUI', 'merge.ini' )|eq( 'enabled' )}e la relativa lingua{/if}</h1>
<ul>
    <li>Tutte le relazioni verranno fuse nell'oggetto selezionato.</li>
    <li>Tutti gli altri attributi dell'oggetto che selezioni saranno mantenuti.</li>
    <li>L'oggetto non selezionato sar&agrave; eliminato.</li>
</ul>
<form name="MergeSelection" action={'merge/select'|ezurl()} method="POST">

{if count( $node_list )|gt( 0 )}
    <table class="list">
    <tr>        
        <th>Mantieni</th>
        {if ezini( 'MergeSettings', 'LanguagesGUI', 'merge.ini' )|eq( 'enabled' )}
        {foreach $language_list as $language}
            <th><img src="{$language|flag_icon()}" width="18" height="12" alt="{$language}" title="{$language}" /></th>
        {/foreach}
        {/if}
    </tr>
    {def $style = 'bglight'}
    {foreach $node_list as $node_translations}
        {if $style|eq('bglight')}{set $style = 'bgdark'}{else}{set $style = 'bglight'}{/if}
        <tr class="{$style}">                    
            </td>
            <td>
                {foreach $node_translations as $key => $node}
                    {if $node}
                        {set $relation_count = fetch( 'content', 'related_objects_count',
                                                            hash( 'object_id', $node.contentobject_id,
                                                                'all_relations', true(),
                                                                'ignore_visibility', true() ) )
                             $reverse_count = fetch( 'content', 'reverse_related_objects_count',
                                                            hash( 'object_id', $node.contentobject_id,
                                                                'all_relations', true(),
                                                                'ignore_visibility', true() ) )}
                        <input type="radio" name="MergeNodeMaster" value="{$node.node_id}"{if $node.node_id|eq( $merge_node_master )} checked="checked"{/if} />
                        <input type="hidden" name="SelectedNodes[]" value="{$node.node_id}" />
                        <a href={$node.url_alias|ezurl()}><strong>{$node.name}</strong></a>                        
                        [{$relation_count}/{$reverse_count}]
                        {break}
                    {/if}
                {/foreach}
            </td>
            {if ezini( 'MergeSettings', 'LanguagesGUI', 'merge.ini' )|eq( 'enabled' )}
            {foreach $language_list as $key => $language}
                <td>
                    {if is_set( $node_translations.$language )}
                        <input type="radio" name="MergeTranslation[{$language}]" value="{$node_translations.$language.node_id}"{if $translation_map.$language|eq( $node_translations.$language.node_id )} checked="checked"{/if} />                        
                        <strong>{$node_translations.$language.name}</strong>
                        {if $used_languages|contains( $language )|not()}
                            {set $used_languages = $used_languages|append( $language )}
                        {/if}
                        {* Make sure all selected objects are of same class *}
                        {if $contains_class|eq( '' )}
                            {set $contains_class = $node_translations.$language.class_identifier}
                        {elseif $contains_class|ne( $node_translations.$language.class_identifier )}
                            {set $can_merge = false()}
                        {/if}
                    {/if}
                </td>
            {/foreach}
            {/if}
        </tr>
        {foreach $node_translations as $key => $node}
            {if $node}
                {def $current_object = $node.object}        
                {if ezini_hasvariable( 'Details', concat( 'Attributes_', $current_object.class_identifier ), 'merge.ini' )}
                    {set $attributes = ezini( 'Details', concat( 'Attributes_', $current_object.class_identifier ), 'merge.ini' )}
                {else}
                    {set $attributes = array()}
                {/if}
                <tr class="{$style}" style="margin:0">
                    <td colspan="3" style="padding:0">
                        <table class="list">                
                        <tr class="{$style}">                                 
                            <td style="border:none"><span title="{$current_object.main_node.path_with_names}">{$current_object.main_node_id}</span></td>
                            <td style="border:none"><span title="{$current_object.remote_id}">{$current_object.id}</span></td>                    
                            <td style="border:none"><a href={$current_object.main_node.url_alias|ezurl()}>{$current_object.name}</a></td>
                            <td style="border:none">                                     
                                {foreach $current_object.data_map as $identifier => $attribute}
                                {if $attributes|contains($identifier)}
                                    <strong>{$attribute.contentclass_attribute_name}:</strong>
                                    {attribute_view_gui attribute=$attribute} <br />
                                {/if}
                                {/foreach}
                            </td>                    
                            <td style="border:none">{$current_object.published|l10n('shortdate')}</td>
                            <td style="border:none">{$current_object.owner.name}</td>                            
                        </tr>
                        </table>
                    </td>
                </tr>
                {undef $current_object}
            {/if}
        {/foreach}
    {/foreach}
    </table>

{/if}

<input type="submit" class="button defaultbutton" name="MergeAction" value="Unisci"{if $can_merge|not()} disabled="disabled"{/if} />

</form>
{/if}