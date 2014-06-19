{def $attributes = array()}
{if ezini_hasvariable( 'Details', concat( 'Attributes_', $current_object.class_identifier ), 'merge.ini' )}
{set $attributes = ezini( 'Details', concat( 'Attributes_', $current_object.class_identifier ), 'merge.ini' )}
{/if}

<h1>Stai visualizzando i possibili duplicati del seguente oggetto:</h1>
<form name="MergeFind" action={'merge/select'|ezurl()} method="POST">
<table class="list">
    <tr>
        <th>Nodo</th>
        <th>Oggetto</th>
        <th>Nome</th>
        <th>Dettagli</th>
        <th>Pubblicato</th>
        <th>Creatore</th>        
    </tr>
    <tr>
        <td><span title="{$current_object.main_node.path_with_names}">{$current_object.main_node_id}</span></td>
        <td><span title="{$current_object.remote_id}">{$current_object.id}</span></td>
        <input type="hidden" name="SelectedNodeIDArray[]" value="{$current_object.main_node_id}" />
        <td><a href={$current_object.main_node.url_alias|ezurl()}>{$current_object.name}</a></td>
        <td>
            {foreach $current_object.data_map as $identifier => $attribute}
            {if $attributes|contains($identifier)}
                <strong>{$attribute.contentclass_attribute_name}:</strong>
                {attribute_view_gui attribute=$attribute} <br />
            {/if}
            {/foreach}
        </td>        
        <td>{$current_object.published|l10n('shortdate')}</td>
        <td><span title="{$current_object.current.creator.name}">{$current_object.owner.name}</span></td>        
    </tr>
</table>    

{if $search_result.SearchCount|gt(0)}
<h2>Seleziona un oggetto da confrontare tra i seguenti possibili duplicati</h2>
<table class="list">
    <tr>
        <th></th>
        <th>Nodo</th>
        <th>Oggetto</th>
        <th>Nome</th>
        <th>Dettagli</th>
        <th>Pubblicato</th>
        <th>Creatore</th>        
    </tr>    
    
    {def $style = 'bglight'}
    {foreach $search_result.SearchResult as $item}    
    {if $style|eq('bglight')}{set $style = 'bgdark'}{else}{set $style = 'bglight'}{/if}
    <tr class="{$style}">
        <td><input type="radio" name="SelectedNodeIDArray[]" value="{$item.node_id}" /></td>
        <td><span title="{$item.path_with_names}">{$item.main_node_id}</span></td>
        <td><span title="{$item.object.remote_id}">{$item.contentobject_id}</span></td>
        <td><a href={$item.url_alias|ezurl()}>{$item.name}</a></td>
        <td>
            {foreach $item.data_map as $identifier => $attribute}
            {if $attributes|contains($identifier)}
                <strong>{$attribute.contentclass_attribute_name}:</strong>
                {attribute_view_gui attribute=$attribute} <br />
            {/if}
            {/foreach}            
        </td>        
        <td>{$item.object.published|l10n('shortdate')}</td>
        <td><span title="{$item.object.current.creator.name}">{$item.object.owner.name}</span> </td>
    </tr>    
    {/foreach}
</table>

<input type="hidden" name="BrowseActionName" value="MergeObjects" />
<input type="submit" class="button defaultbutton" value="Prosegui" />

{else}
<p>La ricerca non ha prodotto possibili duplicati</p>
{/if}


</form>

