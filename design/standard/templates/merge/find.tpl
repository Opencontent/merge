<h1>
    Stai visualizzando i possibili duplicati del seguente oggetto:
    {if $field}
    <br /><small>Ricerca per {$field}</small>
    {/if}
</h1>    
<form name="MergeFind" action={'merge/select'|ezurl()} method="POST">
<table class="list">
    <tr>
        <th>Nodo</th>
        <th>Oggetto</th>
        <th>Nome</th>
        <th>Pubblicato</th>
        <th>Creatore</th>        
    </tr>
    <tr>
        <td><span title="{$current_object.main_node.path_with_names}">{$current_object.main_node_id}</span></td>
        <td><span title="{$current_object.remote_id}">{$current_object.id}</span></td>
        <input type="hidden" name="SelectedNodeIDArray[]" value="{$current_object.main_node_id}" />
        <td><a data-object="{$current_object.id}" href={$current_object.main_node.url_alias|ezurl()}>{$current_object.name}</a></td>            
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
        <td><a data-object="{$item.object.id}" href={$item.url_alias|ezurl()}>{$item.name}</a></td>        
        <td>{$item.object.published|l10n('shortdate')}</td>
        <td><span title="{$item.object.current.creator.name}">{$item.object.owner.name}</span> </td>
    </tr>    
    {/foreach}
</table>

<input type="hidden" name="BrowseActionName" value="MergeObjects" />
<a href="/" class="btn btn-danger pull-left">Annulla</a>
<input type="submit" class="button defaultbutton pull-right" value="Prosegui" />

{else}
<p>La ricerca non ha prodotto possibili duplicati</p>
{/if}


</form>

<div id="modal" class="modal fade" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body">
                <div class="clearfix">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div id="view" class="clearfix"></div>
            </div>
        </div>
    </div>
</div>

{ezscript_load(array(
    'ezjsc::jquery',
    'ezjsc::jqueryUI',
    'ezjsc::jqueryio',
    'bootstrap.min.js',
    'handlebars.min.js',
    'moment-with-locales.min.js',
    'bootstrap-datetimepicker.min.js',
    'jquery.fileupload.js',
    'jquery.fileupload-process.js',
    'jquery.fileupload-ui.js',
    'alpaca.js',
    'leaflet/leaflet.0.7.2.js',
    'leaflet/Control.Geocoder.js',
    'leaflet/Control.Loading.js',
    'leaflet/Leaflet.MakiMarkers.js',
    'leaflet/leaflet.activearea.js',
    'leaflet/leaflet.markercluster.js',
    'jquery.price_format.min.js',
    'jquery.opendatabrowse.js',
    'fields/OpenStreetMap.js',
    'fields/RelationBrowse.js',
    'fields/LocationBrowse.js',
    'jquery.opendataform.js'
))}
<script type="text/javascript" src={'javascript/tinymce/tinymce.min.js'|ezdesign()} charset="utf-8"></script>
{ezcss_load(array(        
    'alpaca.min.css',
    'leaflet/leaflet.0.7.2.css',
    'leaflet/Control.Loading.css',
    'leaflet/MarkerCluster.css',
    'leaflet/MarkerCluster.Default.css',
    'bootstrap-datetimepicker.min.css',
    'jquery.fileupload.css',
    'alpaca-custom.css'
))}
{literal}
<script type="text/javascript">
    $(document).ready(function () {
        $.opendataFormSetup({
            onBeforeCreate: function(){$('#modal').modal('show')},
            onSuccess: function(data){$('#modal').modal('hide');}
        });
        $('[data-object]').on('click', function (e) {            
            $('#view').opendataFormView({object: $(this).data('object')});
            e.preventDefault();
        });
    });
</script>
{/literal}
