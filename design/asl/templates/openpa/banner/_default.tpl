{def $attributes = class_extra_parameters($node.object.class_identifier, 'card_small_view')}
{def $has_image = cond($node|has_attribute('image'), true(), false())}
{set_defaults(hash('attribute_index', 0, 'data_element', $openpa.data_element.value))}
<div data-object_id="{$node.contentobject_id}"
     class="h-100 font-sans-serif card card-teaser border border-light rounded shadow row p-0 align-items-stretch">

    {if $has_image}
        <div
            class="{if $attribute_index|eq(0)}order-0 order-md-2 col-12 col-md-6{else}order-2 col-4{/if} p-0">
            {attribute_view_gui
                attribute=$node|attribute('image')
                image_class=imagelargeoverlay
                inline_style="height: 100%;width: 100%;object-fit: cover;"}
        </div>
    {/if}

    <div class="card-body p-4 {if $attribute_index|eq(0)}order-1 col col-md-6{else}order-1 col-8{/if} {if $has_image}pe-3{/if}">
        <h3 class="card-title fs-4 fw-bold mb-3 lh-sm">
            <a class="text-decoration-none" href="{$openpa.content_link.full_link}" data-element="{$data_element|wash()}" data-focus-mouse="false">
                {include uri='design:openpa/card_teaser/parts/card_title.tpl'}
            </a>
            {if and($openpa.content_link.is_node_link|not(), $node.can_edit)}
            <a style="z-index: 10;right: 0;left: auto;bottom: 0" class="position-absolute p-1" href="{$node.url_alias|ezurl(no)}">
                <span class="fa-stack">
                  <i aria-hidden="true" class="fa fa-circle fa-stack-2x"></i>
                  <i aria-hidden="true" class="fa fa-wrench fa-stack-1x fa-inverse"></i>
                </span>
            </a>
            {/if}
        </h3>
        {if and($attribute_index|eq(0), $node|has_abstract())}
        <div class="card-text u-main-black">
            <p>{$node|abstract()}</p>
        </div>
        {/if}

        {if $openpa.content_icon.context_icon}
            <div class="category-top mt-5">
                <a class="read-more" href="{$openpa.content_icon.context_icon.node.url_alias|ezurl(no)}">
                    {include uri='design:openpa/card/parts/icon_label.tpl' fallback=$openpa.content_icon.context_icon.node.name|wash()}
                </a>
            </div>
        {elseif $openpa.content_icon.class_icon}
            <div class="category-top mt-5">
                <a class="read-more" href="{concat('content/search?Class[]=', $node.object.contentclass_id)|ezurl(no)}">
                    {include uri='design:openpa/card/parts/icon_label.tpl' fallback=$node.class_name}
                </a>
            </div>
        {/if}

    </div>
</div>
{unset_defaults(array('attribute_index', 'data_element'))}
{undef $attributes $has_image}