{def $openpa = object_handler($node)}
{if $openpa.control_cache.no_cache}
    {set-block scope=root variable=cache_ttl}0{/set-block}
{/if}

{ezpagedata_set( 'has_container', true() )}
{ezpagedata_set( 'has_sidemenu', false() )}

<div class="container">
    <div class="row">
        <div class="col-12 col-lg-10">
            <div class="cmp-hero">
                <section class="it-hero-wrapper bg-white align-items-start">
                    <div class="it-hero-text-wrapper pt-0 ps-0 pb-4{if $node|has_attribute('image')|not()} pb-lg-60{/if}">
                        <h1 class="text-black hero-title" data-element="page-name">
                            {$node.name|wash()}
                        </h1>
                        <div class="hero-text">
                            {include uri='design:openpa/full/parts/main_attributes.tpl'}
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>

{if $node|has_attribute('layout')}
    {attribute_view_gui attribute=$node|attribute('layout')}
{else}
    {include uri='design:zone/default.tpl' zones=array(hash('blocks', array(page_block(
        "",
        "OpendataRemoteContents",
        "default",
        hash(
            "remote_url", "",
            "query", concat("classes [public_person] and subtree [", $node.node_id, "]"),
            "show_grid", "1",
            "show_map", "1",
            "show_search", "1",
            "limit", "4",
            "items_per_row", "2",
            "facets", concat('Users'|i18n('design/admin/setup/session'), ':user_types.name,', 'Topics'i18n('bootstrapitalia'), ':topics.name'),
            "view_api", "card",
            "context_api", $node.node_id,
            "color_style", "bg-100",
            "fields", "",
            "template", "",
            "simple_geo_api", "1",
            "input_search_placeholder", ""
            )
        )
    )))}
{/if}

{if and($openpa.content_tools.editor_tools, module_params().function_name|ne('versionview'))}
    {include uri=$openpa.content_tools.template}
{/if}

{def $homepage = fetch('openpa', 'homepage')}
{if $homepage.node_id|eq($node.node_id)}
    {ezpagedata_set('is_homepage', true())}
{/if}
{if and(openpaini('GeneralSettings','Valuation', 1), $node.class_identifier|ne('valuation'))}
    {ezpagedata_set('show_valuation', true())}
{/if}
{ezpagedata_set('opengraph', $openpa.opengraph.generate_data)}

{def $easyontology = class_extra_parameters($node.object.class_identifier, 'easyontology')}
{if and($easyontology, $easyontology.enabled, $easyontology.easyontology|ne(''))}
    {def $jsonld = $node.contentobject_id|easyontology_to_json($easyontology.easyontology)}
    {if $jsonld}<script data-element="metatag" type="application/ld+json">{$jsonld}</script>{/if}
{/if}

{if $node.object.state_identifier_array|contains('opencity_lock/locked')}
    {ezpagedata_set('is_opencity_locked', true())}
{/if}

{undef $openpa}