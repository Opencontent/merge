<div class="content-view-full row">	
	<div class="content-main wide">
		<h3>Controllo duplicati <em>{$field}</em> in <em>{$class}</em></h3>
		{if $error}
			<div class="alert alert-danger">{$error|wash()}</div>		
		{elseif count($duplicates)|gt(0)}
			<table class="table table-striped">
				<tr>
					<th>Valore duplicato</th>
					<th>Contenuti</th>
					<th></th>
				</tr>
				{foreach $duplicates as $key => $values}
				<tr>
					<td>{$key}</td>
					<td>
						<ul class="list-unstyled">
						{foreach $values as $value}
							<li>#{$value.id} <a data-object="{$value.id}" href="{concat('tavolare/object/', $value.id)|ezurl(no)}"><strong>{$value.name|wash()}</strong></a></li>
						{/foreach}
						</ul>						
					</td>
					<td>
						{if count($values)|eq(2)}
						<form action="{'merge/select'|ezurl(no)}" method="POST">
							<input type="hidden" name="BrowseActionName" value="MergeObjects" />
							{foreach $values as $value}
								<input type="hidden" name="SelectedNodeIDArray[]" value="{$value.node_id}">
							{/foreach}
							<input type="submit" class="btn btn-success btn-sm" value="Unisci" />
						</form>
						{else}
						<a href="{concat('merge/find/', $values[0].id, '/', $field)|ezurl(no)}" class="btn btn-success btn-sm">Inizia procedura di unione</a>
						{/if}
					</td>
				</tr>
				{/foreach}
			</table>
		{else}
			<div class="alert alert-success">Nessun duplicato trovato</div>
		{/if}
	</div>
</div>


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
