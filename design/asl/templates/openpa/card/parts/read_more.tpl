{def $show_date = cond(
    and(
        or(
            class_extra_parameters($node.object.class_identifier, 'table_view').show|contains('content_show_published'),
            class_extra_parameters($node.object.class_identifier, 'table_view').in_overview|contains('content_show_published'),
            class_extra_parameters($node.object.class_identifier, 'table_view').in_overview|contains('published')
        ),
        $node.object.published|gt(0)
    ), true(), false())}
{if $openpa.content_icon.context_icon}
        <a class="read-more" href="{$openpa.content_icon.context_icon.node.url_alias|ezurl(no)}" style="width: 87%;  justify-content: space-between;">
            <span class="d-none d-sm-inline">{include uri='design:openpa/card/parts/icon_label.tpl' fallback=$openpa.content_icon.context_icon.node.name|wash()}</span>
            {if $show_date}
                <span class="font-monospace text-lowercase text-500">{$node.object.published|datetime(custom, '%j %F %Y')}</span>
            {/if}
        </a>
{elseif $openpa.content_icon.class_icon}
        <a class="read-more" href="{concat('content/search?Class[]=', $node.object.contentclass_id)|ezurl(no)}" style="width: 87%;  justify-content: space-between;">
            <span class="d-none d-sm-inline">{include uri='design:openpa/card/parts/icon_label.tpl' fallback=$node.class_name}</span>
            {if $show_date}
                <span class="font-monospace text-lowercase text-500">{$node.object.published|datetime(custom, '%j %F %Y')}</span>
            {/if}
        </a>
{/if}