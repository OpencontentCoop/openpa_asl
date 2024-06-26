{def $node_list = array()}

{if $attribute.has_content}
    {foreach $attribute.content.relation_list as $relation_item}
        {if $relation_item.in_trash|not()}
            {def $relation_node = fetch(content, node, hash(node_id, $relation_item.node_id))}
            {if $relation_node.can_read}
                {set $node_list = $node_list|append($relation_node)}
            {/if}
        {/if}
    {/foreach}
    {foreach $node_list as $index => $child}
        {if $child.data_map.step_intro.has_content}
            <div class="richtext-wrapper lora">{attribute_view_gui attribute=$child.data_map.step_intro}</div>
        {/if}
        {attribute_view_gui attribute=$child.data_map.steps}
    {/foreach}
{/if}

{undef $node_list}