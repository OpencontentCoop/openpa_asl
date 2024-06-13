{set_defaults(hash(
    'show_icon', true(),
    'show_category', false(),
    'image_class', 'imagelargeoverlay',
    'custom_css_class', '',
    'view_variation', '',
    'hide_title', false()
))}

{def $attributes = class_extra_parameters($node.object.class_identifier, 'card_small_view')}
<div data-object_id="{$node.contentobject_id}"
     style="border-bottom:5px solid #ddd"
     class="font-sans-serif card card-teaser{if $openpa.content_icon.context_icon.node} card-teaser-image card-flex{/if} no-after rounded shadow-sm mb-0 border border-bottom-card {$node|access_style} {$custom_css_class}">
    {if $openpa.content_icon.context_icon.node}
    <div class="card-image-wrapper{if $attributes.show|contains('content_show_read_more')} with-read-more{/if}">
    {/if}
        <div class="card-body {if $openpa.content_icon.context_icon.node}p-3 {/if} {$view_variation}">
        {if $hide_title|not()}
        <h3 class="card-title text-paragraph-medium fw-normal mb-0 py-4">
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
    </div>
    {if $openpa.content_icon.context_icon.node}
        <div class="category-top mx-2 my-0 align-self-center">
            {display_icon($openpa.content_icon.icon.icon_text, 'svg', 'icon icon-lg')}
        </div>
    </div>
    {/if}
    {if or($attributes.show|contains('content_show_read_more'), $attributes.enabled|not())}
        <a data-element="{$openpa.data_element.value|wash()}" class="read-more{if $openpa.content_icon.context_icon.node} ps-3 position-absolute bottom-0 mb-3{/if}" href="{$openpa.content_link.full_link}" title="{'Go to content'|i18n('bootstrapitalia')} {$node.name|wash()}">
            <span class="text">{'Further details'|i18n('bootstrapitalia')}</span>
            {display_icon('it-arrow-right', 'svg', 'icon ms-0', 'Read more'|i18n('bootstrapitalia'))}
        </a>
    {/if}
</div>
{undef $attributes}
{unset_defaults(array('show_icon', 'image_class', 'view_variation', 'hide_title'))}