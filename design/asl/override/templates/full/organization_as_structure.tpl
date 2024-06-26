{def $openpa = object_handler($node)}
{if $openpa.control_cache.no_cache}
    {set-block scope=root variable=cache_ttl}0{/set-block}
{/if}


{def $parent = $node.parent}
{def $parent_openpa = object_handler($parent)}
{if and($parent_openpa.content_tag_menu.has_tag_menu, $node|has_attribute('type'))}
    {foreach $node|attribute('type').content.tags as $tag}
        {if $tag.parent.keyword|eq('Struttura')} {*TODO usare remote_id*}
            {def $keyword = $tag.keyword|wash()}
            {ezpagedata_set( 'current_content_tagged_keyword', $keyword )}
            {ezpagedata_set( 'current_content_tagged_keyword_url', concat($parent.url_alias, '/(view)/', $keyword|urlencode()))}
            {undef $keyword}
            {break}
        {/if}
    {/foreach}
{/if}

{include uri='design:openpa/full/oragnization_as_structure.tpl'}

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