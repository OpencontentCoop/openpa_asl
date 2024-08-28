{set_defaults(hash(
    'show_icon', true(),
    'show_category', false(),
    'image_class', 'imagelargeoverlay',
    'custom_css_class', '',
    'view_variation', '',
    'hide_title', false()
))}

{def $attributes = class_extra_parameters($node.object.class_identifier, 'card_small_view')}
{def $has_image = cond(and($attributes.show|contains('image'), $node|has_attribute('image')), true(), false())}
<div data-object_id="{$node.contentobject_id}"
     class="font-sans-serif card card-teaser{if or($has_image,$openpa.content_icon.context_icon.node)} card-teaser-image card-flex{/if} no-after rounded shadow-sm mb-0 border {$node|access_style} {$custom_css_class}">
    {if or($has_image,$openpa.content_icon.context_icon.node)}
    <div class="card-image-wrapper{if $attributes.show|contains('content_show_read_more')} with-read-more{/if}">
    {/if}
        <div class="card-body {if or($has_image,$openpa.content_icon.context_icon.node)}p-3 {/if} {$view_variation}">
        {if $hide_title|not()}
        <h3 class="card-title text-paragraph-medium fw-normal mb-0">
            {if $attributes.show|contains('content_show_read_more')|not()}
            <a class="text-decoration-none" href="{$openpa.content_link.full_link}" title="{'Go to content'|i18n('bootstrapitalia')} {$node.name|wash()}">
            {/if}
                {include uri='design:openpa/card_teaser/parts/card_title.tpl'}
            {if $attributes.show|contains('content_show_read_more')|not()}
            </a>
            {/if}
            {if and($openpa.content_link.is_node_link|not(), $node.can_edit)}
                <a href="{$node.url_alias|ezurl(no)}">
				<span class="fa-stack">
				  <i aria-hidden="true" class="fa fa-circle fa-stack-2x"></i>
				  <i aria-hidden="true" class="fa fa-wrench fa-stack-1x fa-inverse"></i>
				</span>
                </a>
            {/if}
        </h3>
        {/if}
        <div class="text-paragraph-card u-grey-light m-0"{if or($attributes.show|contains('content_show_read_more'), $attributes.enabled|not())} style="min-height:50px;padding-bottom:30px"{/if}>
            {include uri='design:openpa/card_teaser/parts/attributes.tpl'}
        </div>
    </div>
    {if $has_image}
        <div class="card-image card-image-rounded pb-5" style="width: 130px;">
            {attribute_view_gui attribute=$node|attribute('image') image_class=$image_class context='card_teaser'}

        </div>
    </div>
    {elseif $openpa.content_icon.context_icon.node}
        <div class="category-top mx-2 my-0 align-self-center">
            {display_icon($openpa.content_icon.icon.icon_text, 'svg', 'icon icon-sm')}
        </div>
    </div>
    {/if}

    {if or($attributes.show|contains('content_show_read_more'), $attributes.enabled|not())}
        <a data-element="{$openpa.data_element.value|wash()}" class="read-more{if or($has_image,$openpa.content_icon.context_icon.node)} ps-3 position-absolute bottom-0 mb-3{/if}" href="{$openpa.content_link.full_link}" title="{'Go to content'|i18n('bootstrapitalia')} {$node.name|wash()}">
            <span class="text">{'Further details'|i18n('bootstrapitalia')}</span>
            {display_icon('it-arrow-right', 'svg', 'icon ms-0', 'Read more'|i18n('bootstrapitalia'))}
        </a>
    {/if}

</div>
{undef $attributes $has_image}
{unset_defaults(array('show_icon', 'image_class', 'view_variation', 'hide_title'))}