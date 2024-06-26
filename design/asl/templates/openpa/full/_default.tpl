{ezpagedata_set( 'has_container', true() )}

<div class="container">
    <div class="row">
        <div class="col-12">
            <div class="cmp-heading pb-3 pb-lg-4">
                <div class="row">
                    <div class="col-lg-8">
                        <h1 class="title-xxxlarge" data-element="service-title">{$node.name|wash()}</h1>
                        {include uri='design:openpa/full/parts/main_attributes.tpl'}
                    </div>
                    <div class="col-lg-3 mt-5 mt-lg-0 text-end">
                        {include uri='design:openpa/full/parts/actions.tpl'}
                    </div>
                </div>
            </div>
        </div>
        {if $node|has_attribute('image')|not()}
            <hr class="d-none d-lg-block mt-2">
        {/if}
    </div>
</div>

{if $node|has_attribute('image')}
    {include uri='design:openpa/full/parts/main_image.tpl'}
{/if}

<section class="container">
    {include uri='design:openpa/full/parts/attributes_alt.tpl' object=$node.object}
</section>

{if $node.children_count}
<div class="section section-muted section-inset-shadow p-4 pt-5">
    {node_view_gui content_node=$node view=children view_parameters=$view_parameters}
</div>
{/if}

{if $openpa['content_tree_related'].full.exclude|not()}
    {include uri='design:openpa/full/parts/related.tpl' object=$node.object}
{/if}