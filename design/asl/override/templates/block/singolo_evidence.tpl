{if count($block.valid_nodes)|gt(0)}
    {def $valid_node = $block.valid_nodes[0]}
    {def $openpa = object_handler($valid_node)}

    {def $has_image = false()}
    {foreach class_extra_parameters($valid_node.object.class_identifier, 'table_view').main_image as $identifier}
        {if $valid_node|has_attribute($identifier)}
            {set $has_image = true()}
            {break}
        {/if}
    {/foreach}

    <div class="bg-dark position-relative overflow-hidden">
        {if $has_image}
            <div class="d-none d-lg-block position-absolute h-100 w-100"
                    {include name="bg" uri='design:atoms/background-image.tpl' node=$valid_node options="right: 0;background-position: center center;background-repeat: no-repeat;background-size: cover;min-height:200px;opacity:.2"}>
            </div>
        {/if}
        <div class="container py-3">
            <div class="row position-relative">
                <div class="col">
                    <div class="py-4 px-2">
                        <h2 class="h4 mt-0 mb-2 text-center">
                            <a href="{$openpa.content_link.full_link}" title="Link a {$valid_node.name|wash()}" class="text-white text-decoration-none font-weight-bold">
                                {$valid_node.name|wash()}
                            </a>
                        </h2>
                        <div class="text-white lead text-center">
                            {include uri='design:openpa/full/parts/main_attributes.tpl' node=$valid_node}
                            {if and(is_set($block.custom_attributes.show_all_text), $block.custom_attributes.show_all_text|ne(''))}
                                <a class="btn btn-light" href="{$openpa.content_link.full_link}">{$block.custom_attributes.show_all_text|wash()}</a>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {undef $valid_node $openpa $has_image}
{/if}