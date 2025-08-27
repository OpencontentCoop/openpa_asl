<div class="form-check custom-control custom-checkbox mb-3">
    <input name="UserType[]"
           id="user_type-{$user_type.item.node_id}"
           value={$user_type.item.node_id}
           {if $checked}{if $selected|contains($user_type.item.node_id)}checked="checked"{else}data-indeterminate="1"{/if}{/if}
           class="custom-control-input"
           type="checkbox">
    <label class="custom-control-label" for="user_type-{$user_type.item.node_id}"{if $user_type.has_children} style="max-width: 80%"{/if}>
        {if $recursion|gt(0)}<small>{/if}
        {$user_type.item.name|wash()} {if is_set($user_type_facets[$user_type.item.node_id])}<small>({$user_type_facets[$user_type.item.node_id]})</small>{/if}
        {if $recursion|gt(0)}</small>{/if}
    </label>
    {if $user_type.has_children}
        <a class="float-right" aria-label="More items" href="#side-search-more-user_type-{$user_type.item.node_id}" data-toggle="collapse" data-bs-toggle="collapse" aria-expanded="{*if $checked}true{else*}false{*/if*}" aria-controls="side-search-more-user_type-{$user_type.item.node_id}">
            {display_icon('it-more-items', 'svg', 'icon icon-primary right icon-sm ml-2 ms-2')}
        </a>
    {/if}
</div>
{if $user_type.has_children}
    <div class="pl-2 ps-2 collapse{*if $checked} show{/if*}" id="side-search-more-user_type-{$user_type.item.node_id}">
        {foreach $user_type.children as $child}
            {set $recursion = $recursion|inc()}
            {include name="user_type_search_input" uri='design:parts/search/user_type_search_input.tpl' user_type=$child user_type_facets=$user_type_facets checked=cond(menu_item_tree_contains($child,$selected), true(), false()) selected=$selected recursion=$recursion}
        {/foreach}
    </div>
{/if}
