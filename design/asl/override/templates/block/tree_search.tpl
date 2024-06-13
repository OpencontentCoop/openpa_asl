{if $block.valid_nodes|count()}
    {def $contents_by_node = array()}
    {foreach $block.valid_nodes as $index => $valid_node}
        {def $query = ''}
        {if is_set($block.custom_attributes.user_type_node_id)}
            {set $query = concat($query, 'raw[submeta_user_types___main_node_id____si] = ', $block.custom_attributes.user_type_node_id, ' and')}
        {/if}
        {if is_set($block.custom_attributes.topic_node_id)}
            {set $query = concat($query, 'raw[submeta_topics___main_node_id____si] = ', $block.custom_attributes.topic_node_id, ' and')}
        {/if}
        {set $query = concat($query, ' subtree [', $valid_node.node_id, ']')}
        {def $count = api_search(concat($query, ' limit 1')).totalCount}
        {debug-log var=$query msg=concat($valid_node.name, ' ', $count)}
        {if $count|gt(0)}
            {set $contents_by_node = $contents_by_node|append(hash(
                'node', $valid_node,
                'query', $query,
                'count', $count
            ))}
        {/if}
        {undef $count $query}
    {/foreach}

    <div class="container py-2 mb-2">
        <div class="row">
            <div class="col-12 col-md-3">
                <ul id="edit-groups" class="affix-top nav nav-tabs nav-tabs-vertical" role="tablist" aria-orientation="vertical">
                    {foreach $contents_by_node as $index => $valid_node}
                        <li class="nav-item">
                            <a class="w-100 nav-link my-2{if $index|eq(0)} active{/if}" data-bs-toggle="tab" data-toggle="tab" data-bs-target="#subtree-{$valid_node.node.node_id}"
                               href="#subtree-{$valid_node.node.node_id}">
                                {if $valid_node.node.node_id|eq(fetch('openpa', 'homepage').node_id)}
                                    {'All'|i18n('openpa/search')}
                                {else}
                                    {$valid_node.node.name|wash()}
                                {/if}
                            </a>
                        </li>
                    {/foreach}
                </ul>
            </div>
            <div class="col-12 col-md-8 tab-content">
                {foreach $contents_by_node as $index => $valid_node}
                    <div class="attribute-edit tab-pane {if $index|eq(0)} active{/if} p-2 mt-2" id="subtree-{$valid_node.node.node_id}">
                        {include uri='design:zone/default.tpl' zones=array(hash('blocks', array(page_block(
                            '',
                            "OpendataRemoteContents",
                            "default",
                            hash(
                                "remote_url", "",
                                "query", $valid_node.query,
                                "show_grid", "1",
                                "show_map", "",
                                "show_search", "1",
                                "limit", "12",
                                "items_per_row", "1",
                                "facets", "",
                                "view_api", "latest_messages_item",
                                "color_style", "",
                                "fields", "",
                                "template", "",
                                "simple_geo_api", "0",
                                "input_search_placeholder", "",
                                "wrapper_class", ''
                            )
                        ))))}
                    </div>
                {/foreach}
            </div>
        </div>
    </div>
{/if}