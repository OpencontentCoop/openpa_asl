{def $block_handler = object_handler($block)}
{def $show_all_link = cond(is_set($block.custom_attributes.show_all_link), $block.custom_attributes.show_all_link|eq(1), true(), false())}
{def $show_all_has_node = cond(is_set($block_handler.root_node), $block_handler.root_node, $block_handler.root_node.node_id|ne(ezini('NodeSettings', 'RootNode', 'content.ini')), true(), false())}
{def $show_all_node = $block_handler.root_node}

{if and($show_all_link, $show_all_has_node)}
    <div class="d-flex justify-content-end mt-4">
        <a class="text-decoration-none fw-semibold" href="{$show_all_node.url_alias|ezurl(no)}"
           {if $is_homepage|not()}data-element="{object_handler($show_all_node).data_element.value|wash()}"{/if}>
            <span class="text">
                {if and(is_set($block.custom_attributes.show_all_text), $block.custom_attributes.show_all_text|ne(''))}
                    {$block.custom_attributes.show_all_text|wash()}
                {else}
                    {'View all'|i18n('bootstrapitalia')}
                {/if}
            </span>
            {display_icon('it-arrow-right', 'svg', 'icon icon-sm icon-primary', 'Read more'|i18n('bootstrapitalia'))}
        </a>
    </div>
{/if}
{undef $block_handler $show_all_link $show_all_has_node $show_all_node}