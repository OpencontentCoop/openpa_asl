{set_defaults(hash('show_icon', false(), 'image_class', 'imagelargeoverlay', 'view_variation', ''))}

{if class_extra_parameters($node.object.class_identifier, 'line_view').show|contains('show_icon')}
    {set $show_icon = true()}
{/if}

{def $has_image = false()}
{foreach class_extra_parameters($node.object.class_identifier, 'table_view').main_image as $identifier}
    {if and($node|has_attribute($identifier), or($node|attribute($identifier).data_type_string|eq('ezimage'), $identifier|eq('image')))}
        {set $has_image = true()}
        {break}
    {/if}
{/foreach}
{def $has_video = false()}
{if and($view_variation|ne('big'), class_extra_parameters($node.object.class_identifier, 'line_view').show|contains('disable_video')|not())}
    {def $oembed = false()}
    {if $node|has_attribute('video')}
        {set $has_video = $node|attribute('video').content}
    {elseif $node|has_attribute('has_video')}
        {set $has_video = $node|attribute('has_video').content}
    {/if}
    {if $has_video}
        {set $oembed = get_oembed_object($has_video)}
        {if is_array($oembed)|not()}
            {set $has_video = false()}
        {/if}
    {/if}
{/if}

{def $has_media = false()}
{if or($has_image, $has_video)}
    {set $has_media = true()}
{/if}

{include uri='design:openpa/card/parts/card_wrapper_open.tpl'}

    {include uri='design:openpa/card/parts/image.tpl'}

    <div class="col-{if $has_media}8{else}12{/if} order-1 order-md-2">
        <div class="card-body pb-5 font-sans-serif">

                {include uri='design:openpa/card/parts/category.tpl'}

                {if $view_variation|eq('alt')}
                    <h3 class="card-title">
                        <a data-element="{$openpa.data_element.value|wash()}" class="text-decoration-none lh-sm" href="{$openpa.content_link.full_link}">{$node.data_map.given_name.content|wash()} {$node.data_map.family_name.content|wash()}</a>
                        {include uri='design:parts/card_title_suffix.tpl'}
                    </h3>
                {else}
                    <h3 class="card-title{if and($has_media|not(), $view_variation|eq('big')|not())} big-heading{/if}">
                        <a data-element="{$openpa.data_element.value|wash()}" class="text-decoration-none" href="{$openpa.content_link.full_link}">{$node.data_map.given_name.content|wash()} {$node.data_map.family_name.content|wash()}</a>
                        {include uri='design:parts/card_title_suffix.tpl'}
                    </h3>
                {/if}

                {def $attributes = class_extra_parameters($node.object.class_identifier, 'card_small_view')}
                {include uri='design:openpa/card_teaser/parts/attributes.tpl'}
                {undef $attributes}

        </div>
    </div>

{include uri='design:openpa/card/parts/card_wrapper_close.tpl'}

{undef $has_image $has_video}

{unset_defaults(array('show_icon', 'image_class', 'view_variation'))}
