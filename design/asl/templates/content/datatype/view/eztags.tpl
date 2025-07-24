{default show_link=false() tag_view=''}
{if $attribute.content.tag_ids|count}
<div class="d-flex flex-wrap gap-2 mt-10 mb-30 font-sans-serif">
{foreach $attribute.content.tags as $tag}
    <div class="cmp-tag">
        {if $show_link}
            <a class="chip chip-simple chip-primary text-button border-primary rounded-2" href="{concat( '/tags/view/', $tag.url )|explode('tags/view/tags/view')|implode('tags/view')|ezurl(no)}">
                <span class="chip-label lh-sm px-2">{$tag.keyword|wash}</span>
            </a>
        {else}
        <div class="chip chip-simple chip-primary text-button border-primary rounded-2">
          <span class="chip-label lh-sm px-2">{$tag.keyword|wash}</span></div>
        {/if}
    </div>
{/foreach}
</div>
{/if}
{/default}
