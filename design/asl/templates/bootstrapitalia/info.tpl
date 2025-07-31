{ezpagedata_set( 'has_container', true() )}
{def $pagedata = openpapagedata()}

<div class="container mb-3">
    <h2 class="mb-4">Gestioni contatti e informazioni generali</h2>

    {if is_set($message)}
        <div class="message-error">
            <p>{$message}</p>
        </div>
    {/if}

    <div id="info" class="border rounded p-3" style="min-height:300px"></div>
    {literal}
        <script>
          $(document).ready(function () {
            let load = function (){
              $('#info').opendataForm({}, {
                connector: 'info',
                onSuccess: function () {
                  load();
                }
              });
            }
            load();
          });
        </script>
    {/literal}

    {if $has_access_to_hot_zone}
        {include uri="design:bootstrapitalia/info_hot_zone.tpl"}
    {/if}

</div>
{include uri='design:load_ocopendata_forms.tpl'}