{def $status_tags = array()}
{if $node|has_attribute('has_service_status')}
    {foreach $node|attribute('has_service_status').content.tags as $tag}
        {set $status_tags = $status_tags|append($tag.keyword)}
    {/foreach}
{/if}
{def $is_active = cond(is_active_public_service($node), true(), false())}
<ul class="d-flex flex-wrap gap-1 my-3">
    <li>
        <div class="chip chip-simple chip-primary text-button border-primary bg-light rounded-2" href="#" data-element="service-status">
            <span class="chip-label lh-sm px-2">{if count($status_tags)}{$status_tags|implode(', ')|wash()}{else}Servizio non attivo{/if}</span>
        </div>
        {if $is_active|not()}
            {if $node|has_attribute('status_note')}
                {attribute_view_gui attribute=$node|attribute('status_note')}
            {else}
                {openpaini('AttributeHandlers', 'DefaultContent_status_note', 'Il servizio online al momento non è disponibile')}
            {/if}
        {elseif $node|has_attribute('status_note')}
            <small class="text-sm">{attribute_view_gui attribute=$node|attribute('status_note')}</small>
        {/if}

    </li>
</ul>
{undef $is_active}